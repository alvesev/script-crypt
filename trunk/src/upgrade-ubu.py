#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  upgrade-ubu.py
#
#  Copyright 2013-2018 Alex Vesev <alvesev@gmail.com>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.


import os
import argparse
import logging
from logging.handlers import RotatingFileHandler
import traceback


# # #
 # #
# #
 #
#


file_log = os.path.expanduser(os.path.join(
                    "~/.logs/" + os.path.basename(__file__) + ".log"))
size_log = 1*1024*1024


# # #
 # #
# #
 #
#


if not os.path.isdir(os.path.dirname(file_log)):
    os.mkdir(os.path.dirname(file_log))
log_str_frmt = "%(asctime)s:pid=%(process)d:" \
               + "%(filename)s:%(lineno)s: %(message)s"
level = logging.INFO
logging.basicConfig(format=log_str_frmt, level="INFO")
lform = logging.Formatter(log_str_frmt)
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


def getCLIArgs():
    mainHelpText = "No documentation has been created."
    parser = argparse.ArgumentParser(description=mainHelpText)
    parser.add_argument('--download-only',
                        dest='doUpgrade',
                        default=True,
                        action='store_false',
                        required=False)
    args = parser.parse_args()
    return args


def unHoldPacks(debPacksNames):
    if debPacksNames:
        exec_shell_cmd("sudo apt-mark unhold" \
                       + " {}".format(" ".join(debPacksNames)))


def putOnHold(debPacksNames):
    if debPacksNames:
        exec_shell_cmd("sudo apt-mark hold" \
                       + " {}".format(" ".join(debPacksNames)))


def downloadAll(explicitInstallPacks=()):
    exec_shell_cmd("sudo apt-get update")
    exec_shell_cmd("sudo apt-get --yes --download-only upgrade")
    if explicitInstallPacks:
        exec_shell_cmd("sudo apt-get" \
                       + " --yes --download-only install"
                       + " {}".format(" ".join(explicitInstallPacks)))


def upgradeFromDownloaded(explicitInstallPacks=()):
    exec_shell_cmd("sudo apt-get upgrade")
    if explicitInstallPacks:
        exec_shell_cmd("sudo apt-get install" \
                       + " {}".format(" ".join(explicitInstallPacks)))


def exec_shell_cmd(shell_cmd):
    assert isinstance(shell_cmd, str)
    shell_true = 0
    err_msg = "SHELL COMMAND FAILED OR HAS BEEN INTERRUPTED."
    l.info("Launching shell command: {}".format(shell_cmd))
    assert shell_true == os.system(shell_cmd), err_msg


# # #
 # #
# #
 #
#


def main():

    cliArgs = getCLIArgs()

    explicitInstall=({"set":       "Linux_kernels",
                      "deb_names": ("linux-generic",
                                    "linux-headers-generic",
                                    "linux-image-generic")},)  # YAML conf file content. Packages to be installed explicitly.

    notHolded = ({"set": "firefox",
                "deb_names": ()},)  # YAML conf file content. Packages to remove from Apt hold.

    holdPackages = (
                    {"set": "firefox",
                    "deb_names": ("firefox", "firefox-locale-en")},)  # YAML conf file content. Packages to put on Apt hold.


    explicitNames = [y for x in explicitInstall for y in x["deb_names"]]
    unHoldHeapNames = [y for x in notHolded for y in x["deb_names"]]
    holdHeapNames = [y for x in holdPackages for y in x["deb_names"]]

    l.info("\n\nUNHOLD AND HOLD MOVEMENTS"
           + " - INCLUDE AND EXCLUDE CERTAIN PACKS.\n")

    unHoldPacks(unHoldHeapNames)
    putOnHold(holdHeapNames)

    l.info("\n\nDOWNLOAD STAGE.\n")

    downloadAll(explicitInstallPacks=explicitNames)

    if cliArgs.doUpgrade:
        l.info("\n\nINSTALL STAGE.\n")
        upgradeFromDownloaded(explicitInstallPacks=explicitNames)
    else:
        l.info("\n\nINSTALL SKIPPED BECAUSE OF EXPLICIT REQUEST"
               + " VIA CLI ARGUMENTS.\n")


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        l.error("Had error.\n".format(traceback.format_exc(e)))
        exit(1)
    l.info("Job done.\n")
