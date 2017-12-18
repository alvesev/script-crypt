#!/bin/bash
export BROWSER=firefox
export DE=openbox
exec ssh-agent dbus-launch openbox-session
