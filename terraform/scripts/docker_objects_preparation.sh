#!/bin/sh

set -eu

AWS_SHARED_VOLUME_MOUNTPOINT=$1
ACTION=$2

if [ $ACTION = "create" ]; then
    (docker network ls | grep traefik-public) || (docker network create --driver overlay --attachable --subnet 10.10.0.0/16 traefik-public)
    mkdir -m 777 -p "${AWS_SHARED_VOLUME_MOUNTPOINT}/traefik"
    mkdir -m 777 -p "${AWS_SHARED_VOLUME_MOUNTPOINT}/portainer"
elif [ $ACTION = "destroy" ]; then
    docker network rm traefik-public
    rm -rf "${AWS_SHARED_VOLUME_MOUNTPOINT}/traefik"
    rm -rf "${AWS_SHARED_VOLUME_MOUNTPOINT}/portainer"
fi
