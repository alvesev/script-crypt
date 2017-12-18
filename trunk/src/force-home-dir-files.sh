#!/bin/bash

#
#  Copyright 2007-2017 Alex Vesev
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


PS4="+:\${0}:${LINENO}: "
set -x
set -e

declare -r dir_home_skeleton="/home/.opt/conf/templates/user-person"

read -p "WILL OVEWRITE SETTINGS IN HOME DIRECTORY !!!"

if [ "$EUID" == "0" ] && [ "${1}" != "--force-if-root" ] ; then
    set +x
    echo "Detected launch on behalf of root. Do nothing."
    exit 1
fi

while read path ; do
    cp --recursive "${path}" "${HOME}"
done <<< "$( find "${dir_home_skeleton}" -mindepth 1 -maxdepth 1 )"

