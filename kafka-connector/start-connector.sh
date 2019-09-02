#!/usr/bin/env bash

tag="[docker-entrypoint.sh]"

function info {
    echo "$tag (INFO): $1"
}

function warn {
    echo "$tag (WARN): $1"
}

function error {
    echo "$tag (ERROR): $1"
}

echo ""

info "Starting ..."

CONNECT_PID=0

handleSignal(){
    info 'Stopping ...'
    if [ $CONNECT_PID -ne 0 ]; then
        kill -s TERM "$CONNECT_PID"
        wait "$CONNECT_PID"
    fi
    info 'Stopped'
    exit
}

trap "handleSignal" SIGHUP SIGINT SIGTERM
$CONNECT_BIN $CONNECT_CFG &
CONNECT_PID=$!
# build connectors
info 'build connectors in post-connector.sh'
while true
do
    sleep 2
    # #use curl judge connector online
    # netstat -tupln | grep 8083 | grep LISTEN > /dev/null
    # listen_on=$?
    listen_on=$(curl -s -o /dev/null -w %{http_code} http://kafka-connector:8083/connectors)
    info "current conector status: ${listen_on}"
    if [ $listen_on -eq 200 ];
    then
        info "start create connectors"
        ./post-connector.sh
        break
    else
        info "wait for connector build"
    fi
done

wait $CONNECT_PID

