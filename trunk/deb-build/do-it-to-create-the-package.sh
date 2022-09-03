#!/bin/bash

#
#  Copyright 2007-2022 Alex Vesev
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
set -xeu

declare -r packageName="script-crypt"

declare -r dir_this="$( dirname "${0}" )"

declare -r dir_artifacts="$( cd "${dir_this}" ; echo -n "$(pwd)/../../artifacts" )"
if [ ! -d "${dir_artifacts}" ] ; then
    mkdir -p "${dir_artifacts}"
fi

pushd "${dir_this}"

echo "INFO:${0}:${LINENO}: Building the package."
fakeroot dpkg-buildpackage -b -us -uc # XXX - GPG sign?

pushd ..
while read f_name ; do
    if [ -n "${f_name}" ] && [ ! -f "${f_name}.md5" ] ; then
        md5sum "$( basename "${f_name}" )" > "${f_name}.md5"
    fi
done <<< "$( find . -maxdepth 1 -iname "*.deb" )"
popd

if [ "$( pwd )" != "${dir_artifacts}" ] ; then
    echo "INFO:${0}:${LINENO}: Moving the package and other files into '${dir_artifacts}'."
    mv --force "../${packageName}_"*"_"*".changes" "${dir_artifacts}"
    mv --force "../${packageName}_"*"_"*".buildinfo" "${dir_artifacts}"
    mv --force "../${packageName}_"*"_"*".deb" "${dir_artifacts}"
    mv --force "../${packageName}_"*"_"*".md5" "${dir_artifacts}"
fi

echo "INFO:${0}:${LINENO}: Going to perform cleanup."
make clean
rm -rf ./debian/${packageName}/
rm -rf ./debian/${packageName}.substvars
rm -rf ./debian/stamp-makefile-build
rm -rf ./debian/stamp-makefile-install

set +x
echo -ne "\n\n"
echo "INFO:${0}:${LINENO}: You may see the packages's list of files via 'dpkg -c ${packageName}_*.deb'".
