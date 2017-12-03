#!/bin/bash
#

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
