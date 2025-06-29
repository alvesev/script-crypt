#
#  Copyright 2007-2025 Alex Vesev
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

#
#   Open ~/.bashrc and ensure the following lines are uncommented:
#
#       # Alias definitions.
#       # You may want to put all your additions into a separate file like
#       # ~/.bash_aliases, instead of adding them here directly.
#       # See /usr/share/doc/bash-doc/examples in the bash-doc package.
#
#     if [ -f ~/.bash_aliases ]; then
#         . ~/.bash_aliases
#     fi
#
##

alias get-tag-time="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )' "
alias get-tag-time-full="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )-%S.%N' "
alias get-tag-time-sec="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )-%S' "

while read fName ; do
    source "${fName}"
done <<< "$( find ~ -maxdepth 1 -type f \( -name ".bash_aliases_*" -not -iname "*.swp" \) )"
