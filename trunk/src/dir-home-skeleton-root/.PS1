##
#   if [ -f ~/.PS1 ] ; then source ~/.PS1 ; fi
#

#######################################################################################
#  color chart:
#  Black       0;30     Dark Gray     1;30      Blue        0;34     Light Blue    1;34
#  Red         0;31     Light Red     1;31      Purple      0;35     Light Purple  1;35
#  Green       0;32     Light Green   1;32      Cyan        0;36     Light Cyan    1;36
#  Brown       0;33     Yellow        1;33      Light Gray  0;37     White         1;37
#  No color    0
#red='\e[0;31m'
#RED='\e[1;31m'
#blue='\e[0;34m'
#BLUE='\e[1;34m'
#cyan='\e[0;36m'
#CYAN='\e[1;36m'
#green='\e[0;32m'
#GREEN='\e[1;32m'
#yellow='\e[0;33m'
#YELLOW='\e[1;33m'
#NC='\e[0m'
#######################################################################################

#PS1='${debian_chroot:+($debian_chroot)}\[\033[0;37m\]\u@\[\033[01;32m\]\h\[\033[01;00m\]: \W\[\033[00m\] \[\033[01;32m\]\$\[\033[01;00m\] '
#PS1="\[\e[01;34m\]┌─[\[\e[0m\u\e[01;34m\]]──[\[\e[40;01;37m\]${HOSTNAME%%.*}\[\e[0;01;34m\]]: \[\e[0m\]\W\[\e[01;34m\] |\[\e[01;34m\]\n\[\e[01;34m\]└──\[\e[01;34m\] \[\e[0m\]"
#PS1="\[\e[01;34m\]__[\[\e[0m\u\e[01;34m\]]__[\[\e[40;01;37m\]${HOSTNAME%%.*}\[\e[0;01;34m\]]: \[\e[0m\]\W\[\e[01;34m\] |\[\e[01;34m\]\n\[\e[01;34m\]\__\[\e[01;34m\] \[\e[0m\]"

#PS1="\[\e[01;34m\]__[\[\e[0m\u\e[01;34m\]]__[\[\e[40;01;37m\]${HOSTNAME%%.*}\[\e[0;01;34m\]]: \[\e[0m\]\W\[\e[01;34m\] |\[\e[01;34m\]\n\[\e[01;34m\]\$(bash /home/.opt/get-git-info.sh)\__\[\e[01;34m\] \[\e[0m\]"

_ps1_main_color_code=31

#PS1="\[\e[01;${_ps1_main_color_code}m\] ╭──┤\[\e[1;${_ps1_main_color_code}m\u\e[01;${_ps1_main_color_code}m\]├─┤\[\e[44;1;37m\]\h\[\e[0;01;${_ps1_main_color_code}m\]├────○\n╭┴──○\n╰─┤\[\e[0m\]\w\[\e[01;${_ps1_main_color_code}m\]├─○ \[\e[0m\]"
#PS1="\[\e[01;${_ps1_main_color_code}m\] ╭──┤ \[\e[0;0;37m\u\e[0;01;30m\]@\[\e[01;1;${_ps1_main_color_code}m\]\h\[\e[0;01;${_ps1_main_color_code}m\] ├────○\n╭┴──○\n╰─┤ \[\e[0m\]\w\[\e[01;${_ps1_main_color_code}m\] ├─○ \[\e[0m\]"
PS1="\[\e[01;${_ps1_main_color_code}m\]╭───┤ \[\e[0;0;37m\u\e[0;01;30m\]@\[\e[01;1;${_ps1_main_color_code}m\]\h\[\e[0;01;${_ps1_main_color_code}m\] ├────○\n╰─┤ \[\e[0m\]\W\[\e[01;${_ps1_main_color_code}m\] ├─○ \[\e[0m\]"
