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

set -e

if [[ -z "$CONNECT_BOOTSTRAP_SERVERS" ]]; then
    error "EMPTY ENV 'CONNECT_BOOTSTRAP_SERVERS'"; exit 1
fi

if [[ -z "$CONNECT_REST_ADVERTISED_HOST_NAME" ]]; then
    warn "EMPTY ENV 'CONNECT_REST_ADVERTISED_HOST_NAME'"; unset $CONNECT_REST_ADVERTISED_HOST_NAME
fi

if [[ -z "$CONNECT_REST_ADVERTISED_PORT" ]]; then
    warn "EMPTY ENV 'CONNECT_REST_ADVERTISED_PORT'"; unset $CONNECT_REST_ADVERTISED_PORT
fi

if [[ -z "$CONNECT_GROUP_ID" ]]; then
    warn "EMPTY ENV 'CONNECT_GROUP_ID'"; unset $CONNECT_GROUP_ID
fi

# extend class path for custom connectors
export CLASSPATH=${CLASSPATH}:${KAFKA_HOME}/connectors/*

# Configure properties, replace default with ENV-list
for VAR in `env`
do
    if [[ $VAR =~ ^CONNECT_ && ! $VAR =~ ^CONNECT_CFG && ! $VAR =~ ^CONNECT_BIN ]]; then
        connect_name=`echo "$VAR" | sed -r "s/CONNECT_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
        env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
        if egrep -q "(^|^#)($connect_name)=" $CONNECT_CFG; then
            sed -r -i "s@(^|^#)($connect_name)=(.*)@\2=${!env_var}@g" $CONNECT_CFG
        else
            echo "connect config ${CONNECT_CFG}"
            echo "$connect_name=${!env_var}" >> ${CONNECT_CFG}
        fi
    fi
done

exec "$@"

