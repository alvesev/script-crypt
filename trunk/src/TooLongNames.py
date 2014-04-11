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


eCryptFSFileNameMaxRecommendedLength = 143

aboutText='''
Utility to evaluate file names length and print name if any one is greater than threshold. There is default threshold value %s. 
''' % eCryptFSFileNameMaxRecommendedLength


import argparse
import os
import sys


def main():
    args = evaluateCliArgs(argparse.ArgumentParser(description=aboutText))
    
    if args.maxLength: wantedMaxLength = int(args.maxLength)
    else: wantedMaxLength = eCryptFSFileNameMaxRecommendedLength
    dirTop = args.dirTop

    
    dirTop = expandPath(dirTop)
    for dirRoot, subDirs, files in os.walk(dirTop):
        for subName in subDirs + files:
            if isTooLong(subName, wantedMaxLength):
                printOut(os.path.join(dirRoot, subName))


def evaluateCliArgs(parser):
    parser.add_argument('-d', '--dir', dest='dirTop', required=True,
                        help="Top level dir to be used while names search.")
    parser.add_argument('-m', '--max', dest='maxLength', type=int,
                            help="Threshold value to be compared with a file name length.")
    args = parser.parse_args()
    return args


def expandPath(path):
    path = os.path.expanduser(path)
    path = os.path.abspath(path)
    return path

def isTooLong(string, wantedMaxLength):
    length = len(string)
    if (length > wantedMaxLength): return True
    else: return False

def printOut(string):
    try:
        string = string.encode('utf-8', errors='backslashreplace').decode('utf-8')
        sys.stdout.write(string + '\n')
    except:
        raise Exception("Failed with printing of file/dir name obtained for parent directory '%s'. Is the sub-name have deprecated symbols???"
                            % os.path.dirname(string))
    

if __name__ == "__main__": main()
