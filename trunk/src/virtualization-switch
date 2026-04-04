#!/bin/bash
#
#  Copyright 2026 Alex Vesev
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
#  along with Script Crypt. If not, see <https://www.gnu.org/licenses/>.
#
##


PS4="+:$(hostname -f):\${0}:\${LINENO}: "
set -eu -o pipefail

if [ "${#}" -lt 1 ] || [ "${*}" != "${*/--help/}" ] ; then
    cat "${0}" | egrep "([[:space:]]|\|)[\-]{1,2}[a-zA-Z0-9_\-]{1,})"
    exit 1
fi

if [[ "${*}" =~ (^|[[:space:]])(-v|--verbose)([[:space:]]|$) ]] ; then
    set -x
    opt_verbose="--verbose"
fi

declare -r  dir_this="$( dirname "${0}" )"
declare -ri shell_val_true=0
declare -ri shell_val_false=1

declare -ra svc_libvirt=(
                        libvirtd
                        virtlogd
                        virtlockd
                        )
declare -ra mod_kvm=(
                    "$( if lscpu | grep --quiet -E 'Vendor[[:space:]]{1,}ID:[[:space:]]{1,}.*Intel.*' ; then echo kvm_intel ; fi )"
                    "$( if lscpu | grep --quiet -E 'Vendor[[:space:]]{1,}ID:[[:space:]]{1,}.*AMD.*' ; then echo kvm_amd ; fi )"
                    kvm
                    )
declare -ra svc_vbox=(
                    virtualbox.service
                    )
declare -ra mod_vbox=(
                    #vboxpci
                    #vboxnetadp
                    #vboxnetflt
                    vboxdrv
                    )

###
##
#

function is_loaded {
    local -r mod_name="${1}"
    if lsmod | grep --quiet "${mod_name}" ; then
        return ${shell_val_true}
    else
        return ${shell_val_false}
    fi
}

function unload_libvirt {
    for s in "${svc_libvirt[@]}" ; do
        sudo systemctl stop "${s}"
    done
    for m in "${mod_kvm[@]}" ; do
        if is_loaded "${m}" ; then
            sudo modprobe -r "${m}"
        fi
    done
}

function load_libvirt {
    for m in "${mod_kvm[@]}" ; do
        if [ -n "${m}" ] && ! is_loaded "${m}" ; then
            sudo modprobe "${m}"
        fi
    done
    for s in "${svc_libvirt[@]}" ; do
        sudo systemctl start "${s}"
    done
}

function unload_vbox {
    for s in "${svc_vbox[@]}" ; do
        sudo systemctl stop "${s}"
    done
    for m in "${mod_vbox[@]}" ; do
        if is_loaded "${m}" ; then
            sudo modprobe -r "${m}"
        fi
    done
}

function load_vbox {
    for m in "${mod_vbox[@]}" ; do
        if ! is_loaded "${m}" ; then
            sudo modprobe "${m}"
        fi
    done
    for s in "${svc_vbox[@]}" ; do
        sudo systemctl start "${s}"
    done
}

###
##
#

case "${1}" in
    --to-vbox)
        unload_libvirt
        load_vbox
        ;;
    --to-libvirt)
        unload_vbox
        load_libvirt
        ;;
    *)
        set -x
        echo "ERROR:${0}:${LINENO}: Unknown CLI option '{}'." >&2
        exit 1
esac

set +x
echo "INFO:${0}:${LINENO}: Job done." >&2
echo "" >&2
