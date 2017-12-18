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

PS4="CMD:\${0}:pid=\${$}: "
set -x
set -e

declare -r this_dir="$( dirname "$( readlink -f "${0}" )" )"

declare -r DIR_ORIGIN="${1:-${this_dir}/../src}"
declare -r DIR_BASE_INSTALL="${2:-/opt/script-crypt}"  # Not in use until need it.
declare -r DESTDIR="${3}"

declare -r CHROOT="${DESTDIR}"

declare -r dir_home_skeleton="/home/.opt/conf/templates/user-person"


test -d "${CHROOT}/usr/bin/"       || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/usr/bin/"
test -d "${CHROOT}/etc/profile.d/" || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/etc/profile.d/"
test -d "${CHROOT}/etc/init.d/"    || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/etc/init.d/"
test -d "${CHROOT}/etc/rc3.d/"     || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/etc/rc3.d/"
test -d "${CHROOT}/home/.opt/"     || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/home/.opt/"
test -d "${CHROOT}/home/.opt/mc"   || install --directory --owner=root --group=root --mode=755 --verbose   "${CHROOT}/home/.opt/mc"
test -d "${CHROOT}/${dir_home_skeleton}"     || install --directory --owner=root --group=root --mode=755 --verbose "${CHROOT}/${dir_home_skeleton}"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/ConfFileSetGet.py"                "${CHROOT}/usr/bin/conf-file-get-set"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/TooLongNames.py"                  "${CHROOT}/usr/bin/too-long-names"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/rename-APK-by-versions.sh"        "${CHROOT}/usr/bin/rename-apk-by-versions"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/upgrade-ubu.py"                   "${CHROOT}/usr/bin/upgrade-ubu"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/if-speed"                         "${CHROOT}/usr/bin/if-speed"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/sys-suspend-on-lid.py"            "${CHROOT}/usr/bin/sys-suspend-on-lid"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/force-home-dir-files.sh"          "${CHROOT}/usr/bin/force-home-dir-files"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/encrypt-for-emailing"             "${CHROOT}/usr/bin/encrypt-for-emailing"
install --owner=root --group=root --mode=644 --verbose "${DIR_ORIGIN}/settings/custom-exec-path.sh"     "${CHROOT}/etc/profile.d/custom-exec-path.sh"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/settings/sys-suspend-on-lid.sh"   "${CHROOT}/etc/init.d/sys-suspend-on-lid"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/mc-wrapper-root-custom"           "${CHROOT}/usr/bin/mc-wrapper-root-custom"
install --owner=root --group=root --mode=755 --verbose "${DIR_ORIGIN}/mc-wrapper-user-custom"           "${CHROOT}/usr/bin/mc-wrapper-user-custom"

ln -s "/etc/init.d/sys-suspend-on-lid" "${CHROOT}/etc/rc3.d/S07sys-suspend-on-lid"

while read path ; do
    cp --recursive "${path}" "${CHROOT}/${dir_home_skeleton}"
done <<< "$( find "${DIR_ORIGIN}/dir-home-skeleton" -mindepth 1 -maxdepth 1 )"

while read path ; do
    cp --recursive "${path}" "${CHROOT}/home/.opt/mc"
done <<< "$( find "${DIR_ORIGIN}/mc-additionals" -mindepth 1 -maxdepth 1 )"
