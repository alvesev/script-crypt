#!/usr/bin/python3

#
#  Copyright 2017 Alex Vesev
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


import yaml
import logging
from logging.handlers import RotatingFileHandler
from time import sleep
import os
from os import system
import sys
import fcntl
import logging


# # #
 # #
# #
 #
#


file_log = "/var/log/sys-suspend-on-lid.log"
size_log = 1*1024*1024
lid_state_yaml = "/proc/acpi/button/lid/LID/state"
lid_closed_action_script = "/home/.opt/sys-suspend"


# # #
 # #
# #
 #
#

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

# # #
 # #
# #
 #
#


format = "%(asctime)s:pid=%(process)d:%(filename)s:%(lineno)s: %(message)s"
level = logging.INFO
logging.basicConfig(format=format, level="INFO")
lform = logging.Formatter(format)
flh = RotatingFileHandler(file_log, maxBytes=size_log, backupCount=2)
l = logging.getLogger('root')

flh.setFormatter(lform)
flh.setLevel(level)
l.addHandler(flh)
l.setLevel(level)

l.info("Starting lid state watching. Using flag from '{}'. Log file is '{}'.".format(lid_state_yaml, file_log))
if not which(lid_closed_action_script):
    l.error("Suspend action executable '{}' not found in PATH or at all.".format(lid_closed_action_script))
    exit(1)

if os.fork():
    sys.exit()

is_after_sleep = False

while True:
    if is_after_sleep:
        is_after_sleep = False
        sleep(5)
    with open(lid_state_yaml, "r") as fh:
        lid_conf = yaml.load(fh)
    if lid_conf["state"] == "open":
        sleep(1)
    elif lid_conf["state"] == "closed":
        l.info("Lid has been {}. Trigerring '{}'.".format(lid_conf["state"], lid_closed_action_script))
        system("sudo '{}' 2>>'{}' 1>>'{}'".format(lid_closed_action_script, file_log, file_log))
        is_after_sleep = True
    else:
        l.error("Unknown lid state '{}'.".format(lid_conf["state"]))

