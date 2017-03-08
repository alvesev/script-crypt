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


PS4="+:$( basename "${0}" ):\${LINENO}: "
set -x
set -e


declare -r wrkDir="${1}"
test -d "${wrkDir}"

declare packFileMask="*.apk"
declare -r dirOutput="output_$( date '+%Y-%m-%d-%H%M-%S' )"


# # #
# # #
# # #


function getMetaDataAll {
    local -r apkFName="${1}"
    set -e
    test -f "${apkFName}"
    aapt dump --values badging "${apkFName}"
}

function getVersionsAndTechName {
    local -r apkFName="${1}"
    set -e
    test -f "${apkFName}"
    getMetaDataAll "${apkFName}" | egrep "^package:" | tr -d '\n' | sed 's/^package\: //g'
}


function getHumanName {
    local -r apkFName="${1}"
    set -e
    test -f "${apkFName}"
    getMetaDataAll "${apkFName}" \
        | egrep "^application-label:" \
            || true

}


function normaliseText {
    local -r inText="${1}"

    echo "${inText}" \
        | tr -d '\n' \
        | sed "s/^application-label\://g" \
        | sed "s/^'//;s/'$//;s/ /_/g" \
        | sed "s/[\'\"]/_/g;s/\s/_/g" \
        | iconv -t koi8-r | catdoc -d us-ascii -s koi8-r \
        | tr -cd '[[:alnum:]]._-'
}


function genMD5InDir {
    local -r dir="${1}"
    test -d "${dir}"

    pushd "$(pwd)"
    cd "${dir}"
    while read fName ; do
        md5sum -b "${fName#\./}" > "${fName%\.[aA][pP][kK]}.MD5"
    done <<< "$( find . -maxdepth 1 -type f -iname "*.apk" )"
    popd
}


# # #
# # #
# # #


cd "${wrkDir}"
mkdir -p "${dirOutput}"
while read apkFName ; do
    dirContainer="$( dirname "${apkFName}" )"

    versionAndTechNameInfo="$( getVersionsAndTechName "${apkFName}" )"
    test -n "${versionAndTechNameInfo}"
    eval "${versionAndTechNameInfo}"
    versionName="$( sed 's#[[:space:]]#_#g;s#/#_#g' <<< "${versionName}" )"

    humanName="$( getHumanName "${apkFName}" )"
    if [ -z "${humanName}" ] ; then
        humanName="NoName"
    fi
    humanName="$( normaliseText "${humanName}" )"
    test -n "${humanName}"


    if [ -n "${humanName}" ] ; then
        newNamePrefix="${humanName}_${versionName}_${versionCode}_${name}"
    else
        newNamePrefix="$( sed 's/\.[aA][pP][kK]$//g' "${apkFName}" )"
    fi

    apkCommentFile="${newNamePrefix}_COMMENT.txt"
    apkFileNameNew="${newNamePrefix}.apk"

    cp "${apkFName}" "${dirOutput}/${apkFileNameNew}"

    echo "$( getHumanName "${apkFName}" )" > "${dirOutput}/${apkCommentFile}"
    echo "${versionAndTechNameInfo}" >> "${dirOutput}/${apkCommentFile}"

done <<< "$( find -maxdepth 1 -type f -name "${packFileMask}" )"

genMD5InDir "${dirOutput}"

echo "Job done."
