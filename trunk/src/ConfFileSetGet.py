#!/usr/bin/python3


#
#  Copyright 2007-2014 Alex Vesev
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


import argparse
import configparser

aboutText = '''
Utility for setting up a value for an option in a configuration file, or - get a value. Configuration file syntax intended to be 'ini'.
'''

knownActionNames = ('set', 'get')

parser = argparse.ArgumentParser(description=aboutText)
parser.add_argument('-a', '--action', dest='action', required=True,
                        help="Action to be performed - set or get.")
parser.add_argument('-f', '--file', dest='fileName', required=True,
                        help="Configuration file name to be processed.")
parser.add_argument('-c', '--section', dest='section', required=True,
                        help="Configuration section to be processed.")
parser.add_argument('-k', '--key', dest='field', required=True,
                        help="Configuration option name from the section to be processed.")
parser.add_argument('-v', '--value', dest='value',
                        help="Configuration option value to be set.")
args = parser.parse_args()


def main():
    validatePrelaunch()
    configInstance = configparser.ConfigParser()
    configInstance.read(args.fileName)
    if args.action == 'set':
        setValue(configInstance, args.section, args.field, args.value)
        saveConfToFile(configInstance, args.fileName)
    if args.action == 'get':
        print(getValue(configInstance, args.section, args.field), end='')


# # #
# # #
# # #


def setValue(conf, section, field, value):
    conf[section] = {field: value}


def getValue(conf, section, field):
    if isConfHaveWanted(conf, section, field): return conf[section][field]
    else: return ""
    

def isConfHaveWanted(conf, section, field):
    return conf.has_option(section, field)


def saveConfToFile(conf, fileName):
    try:
        with open(fileName, 'w') as fh:
            conf.write(fh)
    except:
        raise Exception("Failed to save configuration file '%s'." % fileName)
    
    
def validatePrelaunch():
    if args.action not in knownActionNames:
        raise Exception("Action name '%s' is not valid." % args.action)
    
    if args.action == set and not args.value:
        args.value = ""


# # #
# # #
# # #


if __name__ == '__main__': main()

