#!/bin/bash

if egrep "^XRDP_SESSION=" <<< "$(set)" \
        && [ "$XRDP_SESSION" == "1" ]
then
    echo "$( date '+%Y-%m-%d-%H%M-%S.%N_%z' | tr -d '\n' ):INFO:${0}:${LINENO}: XRDP session is going to be started." >> "${HOME}/.xinitrc.log"
    export BROWSER=browser-current
    export DE=openbox
    exec ssh-agent dbus-launch openbox-session
else
    echo "$( date '+%Y-%m-%d-%H%M-%S.%N_%z' | tr -d '\n' ):INFO:${0}:${LINENO}: X session is going to be started." >> "${HOME}/.xinitrc.log"
    exec ssh-agent dbus-launch openbox-session
fi

exit 0
