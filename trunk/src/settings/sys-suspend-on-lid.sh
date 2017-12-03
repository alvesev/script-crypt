#!/bin/bash
#

#
#  Copyright 2017 Alex Vesev
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


### BEGIN INIT INFO
# Provides:        sys-suspend-on-lid
# Default-Start:   2 3 4 5
# Default-Stop:    1
# Short-Description: Suspend on lid close action.
### END INIT INFO

case $1 in
    start)
        if [ -n "$( /bin/bash "${0}" status )" ] ; then
            /bin/bash "${0}" status
            echo "Already running. Do nothing."
            exit 0
        fi
        nohup "/usr/bin/sys-suspend-on-lid" 1>/dev/null 2>/dev/null &
        if [ -n "$( /bin/bash "${0}" status )" ] ; then
            exit 0
        else
            exit 1
        fi
    ;;
    stop)
        if [ -n "$( /bin/bash "${0}" status )" ] ; then
            kill -9 $( bash "${0}" status | awk '{print $1}' )
        fi
        if [ -z "$( /bin/bash "${0}" status )" ] ; then
            exit 0
        else
            exit 1
        fi
    ;;
    restart|force-reload|try-restart|reload)
        /bin/bash "${0}" stop
        /bin/bash "${0}" start
    ;;
    status)
        ps aux | grep "/usr/bin/sys-suspend-on-lid" | awk '{print $2 " " $11 " " $12}' | grep -v grep
        exit 0
    ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
    ;;
esac
