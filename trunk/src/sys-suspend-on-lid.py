#!/usr/bin/python3

#
#  Copyright 2017-2022 Alex Vesev
#
#  This file is part of Script Crypt.
#
#  Script Crypt is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Script Crypt is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Script Crypt. If not, see <http://www.gnu.org/licenses/>.
#
##


import inspect, os
this_directory = os.path.dirname(inspect.getabsfile(lambda: 0))

file_conf_pool = (
                    os.path.join(this_directory, "sys-suspend-on-lid.yaml"),
                    "/etc/sys-suspend-on-lid.yaml"
                    )
conf_default = {  # Default configuration.
    "actions": {
        "on_close": (
            "wmctrl -k on",
            # "xscreensaver -command -lock",
            # "sudo /usr/sbin/pm-suspend",
            "/bin/systemctl suspend --ignore-inhibitors"
        )
    }
}


import getpass

import yaml
import logging
from logging.handlers import RotatingFileHandler
from time import sleep
from os import system, walk
import sys
#import fcntl
import re


# # #
 # #
# #
 #
#


def get_log_file_name():
    user = getpass.getuser()
    if user == "root":
        log_filename = "/var/log/sys-suspend-on-lid.log"
    else:
        log_filename = os.path.join("/tmp",
                                    user + "-" + "sys-suspend-on-lid.log")
    return log_filename

file_log = get_log_file_name()
size_log = 1*1024*1024

format = "%(asctime)s:pid=%(process)d:%(filename)s:%(lineno)s: %(message)s"
if "--debug" in sys.argv:
    level = logging.DEBUG
else:
    level = logging.INFO
logging.basicConfig(format=format, level="INFO")
lform = logging.Formatter(format)
flh = RotatingFileHandler(file_log, maxBytes=size_log, backupCount=2)
l = logging.getLogger('root')

flh.setFormatter(lform)
flh.setLevel(level)
l.addHandler(flh)
l.setLevel(level)


# # #
 # #
# #
 #
#


def get_conf():
    conf = {}
    try:
        for f in file_conf_pool:
            if os.path.exists(f):
                l.info("Configuration file '{}'.".format(f))
                with open(f, "r") as fh:
                    conf = yaml.safe_load(fh)
                break
    except Exception as e:
        l.error(e)
    if not conf:
        l.warning("No configuration file loaded, using defaults."
                  " Configuration file names are:\n"
                  "{}".format("\n".join(file_conf_pool)))
        conf = conf_default
    return conf


def validate(lid_state_yaml):
    for exe_file in ("/usr/bin/sudo",
                     "/usr/bin/xscreensaver-command",
                     "/usr/bin/wmctrl",
                     "/bin/systemctl"):
        if not which(exe_file):
            l.error("Executable '{}'"
                    "not found in PATH or at all.".format(exe_file))
            exit(1)

    if not os.path.exists(lid_state_yaml):
        l.error("Lid state information source"
                + " '{}' not found at start.".format(lid_state_yaml))


def get_lid_state_file():

    dir_lid_kfs = "/proc/acpi/button/lid/"
    lid_state_yaml = ""

    is_found = False
    while not lid_state_yaml:
        for root, subDirs, files in walk(dir_lid_kfs):
            for d in subDirs:
                lid_state_yaml = os.path.join(dir_lid_kfs, d, "state")
                if bool(re.fullmatch(r"LID\d+", d)) \
                        and os.path.exists(lid_state_yaml):
                    is_found = True
                    break
            if is_found:
                break
        if lid_state_yaml:
            break
        else:
            l.error(f"Lid state file is not found in '{dir_lid_kfs}'.")
            sleep(900)

    return lid_state_yaml


def get_lid_state_file():
    dir_lid_kfs = "/proc/acpi/button/lid/"
    re_lid_name   = re.compile(r"^LID\d*$")
    wait_time = 900

    while True:
        # iterate directly over the entries of the lid directory
        for entry in os.scandir(dir_lid_kfs):
            if entry.is_dir() and re_lid_name.fullmatch(entry.name):
                state_path = os.path.join(entry.path, "state")
                if os.path.exists(state_path):
                    return state_path

        l.error(f"Lid state file is not found in '{dir_lid_kfs}'."
                f" Sleeping for '{wait_time}'")
        sleep(wait_time)


def which(program):
    import os
    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None

def fork_child_and_exit_parent():
    '''
        Exit if this is a parent. Child will be adopted by
        process with PID=1. Each launch leaves it's child
        running in "background".
    '''
    if os.fork():
        sys.exit()


def process_lid(conf, lid_state_yaml):

    l.info("Starting lid state watching."
           + " Using flag from '{}'.".format(lid_state_yaml)
           + " Log file is '{}'.".format(file_log))

    is_after_sleep = False

    while True:
        if is_after_sleep:
            is_after_sleep = False
            sleep(5)
        if os.path.exists(lid_state_yaml):
            with open(lid_state_yaml, "r") as fh:
                lid_conf = yaml.safe_load(fh)
            if lid_conf["state"] == "open":
                sleep(1)
            elif lid_conf["state"] == "closed":
                l.info("Lid has been {}.".format(lid_conf["state"]))
                try:
                    for cmd in conf['actions']['on_close']:
                        cmd = str(cmd)
                        l.debug("Executing command: {}".format(cmd))
                        fb = system(cmd)
                        if fb != 0:
                            l.error("Got error exit code '{}'".format(fb) +
                                    " from '{}'.".format(cmd))
                except Exception as e:
                    l.error("Fail during going to sleep mode.")
                    l.error(e)
                is_after_sleep = True
            else:
                l.error("Unknown lid state '{}'.".format(lid_conf["state"]))
        else:
            sleep(120)


# # #
 # #
# #
 #
#


if __name__ == "__main__":

    lid_state_yaml = get_lid_state_file()

    validate(lid_state_yaml)

    conf = get_conf()


    if "--debug" not in sys.argv:
        fork_child_and_exit_parent()

    process_lid(conf, lid_state_yaml)
