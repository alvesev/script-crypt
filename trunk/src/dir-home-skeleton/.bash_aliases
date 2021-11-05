####     Open ~/.bashrc and ensure the following lines are uncommented:
####
####     # Alias definitions.
####     # You may want to put all your additions into a separate file like
####     # ~/.bash_aliases, instead of adding them here directly.
####     # See /usr/share/doc/bash-doc/examples in the bash-doc package.
####
####     if [ -f ~/.bash_aliases ]; then
####         . ~/.bash_aliases
####     fi



alias get-tag-time="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )' "
alias get-tag-time-full="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )-%S.%N' "
alias get-tag-time-sec="date '+%Y-%m-%d-%H%M$( date '+%z' | sed -e 's#-#m#g;s#+#p#g' )-%S' "

while read fName ; do
    source "${fName}"
done <<< "$( find ~ -maxdepth 1 -type f \( -name ".bash_aliases_*" -not -iname "*.swp" \) )"
