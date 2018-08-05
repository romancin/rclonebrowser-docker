#!/bin/sh

set -u # Treat unset variables as an error.

trap "exit" TERM QUIT INT
trap "kill_rclonebrowser" EXIT

log() {
    echo "[rclonebrowsersupervisor] $*"
}

getpid_rclonebrowser() {
    PID=UNSET
    if [ -f /config/rclonebrowser.pid ]; then
        PID="$(cat /config/rclonebrowser.pid)"
        # Make sure the saved PID is still running and is associated to
        # RcloneBrowser.
        if [ ! -f /proc/$PID/cmdline ] || ! cat /proc/$PID/cmdline | grep -qw "rclone"; then
            PID=UNSET
        fi
    fi
    if [ "$PID" = "UNSET" ]; then
        PID="$(ps -o pid,args | grep -w "rclone" | grep -vw grep | tr -s ' ' | cut -d' ' -f2)"
    fi
    echo "${PID:-UNSET}"
}

is_rclonebrowser_running() {
    [ "$(getpid_rclonebrowser)" != "UNSET" ]
}

start_rclonebrowser() {
        dbus-uuidgen 
        export TERMINAL=xterm
	/usr/bin/rclone-browser > /config/logs/output.log 2>&1 & 
}

kill_rclonebrowser() {
    PID="$(getpid_rclonebrowser)"
    if [ "$PID" != "UNSET" ]; then
        log "Terminating RcloneBrowser..."
        kill $PID
        wait $PID
    fi
}

if ! is_rclonebrowser_running; then
    log "RcloneBrowser not started yet.  Proceeding..."
    start_rclonebrowser
fi

RCLONEBROWSER_NOT_RUNNING=0
while [ "$RCLONEBROWSER_NOT_RUNNING" -lt 5 ]
do
    if is_rclonebrowser_running; then
        RCLONEBROWSER_NOT_RUNNING=0
    else
        RCLONEBROWSER_NOT_RUNNING="$(expr $RCLONEBROWSER_NOT_RUNNING + 1)"
    fi
    sleep 1
done

log "RcloneBrowser no longer running.  Exiting..."
