#!/bin/bash

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


PS4="CMD:\${0}:\${LINENO}:pid=\${$}: "
set -x
set -e

declare -r packageName="script-crypt"

echo "INFO:${0}:${LINENO}: Building the package."
fakeroot dpkg-buildpackage -b -us -uc # XXX - GPG sign?

echo "INFO:${0}:${LINENO}: Moving the package and other files into current directory."
mv --force "../${packageName}_"*"_"*".changes" "."
mv --force "../${packageName}_"*"_"*".deb" "."

echo "INFO:${0}:${LINENO}: Going to perform cleanup."
make clean
rm -rf ./debian/${packageName}/
rm -rf ./debian/${packageName}.substvars
rm -rf ./debian/stamp-makefile-build
rm -rf ./debian/stamp-makefile-install

set +x
echo -ne "\n\n"
echo "INFO:${0}:${LINENO}: You may see the packages's list of files via 'dpkg -c ${packageName}_*.deb'".
