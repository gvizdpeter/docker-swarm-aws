#!/bin/sh

set -eu

AWS_SHARED_VOLUME_MOUNTPOINT=$1

(docker network ls | grep traefik-public) || (docker network create --driver overlay --attachable --subnet 10.10.0.0/16 traefik-public)
mkdir -m 777 -p "${AWS_SHARED_VOLUME_MOUNTPOINT}/traefik"
mkdir -m 777 -p "${AWS_SHARED_VOLUME_MOUNTPOINT}/portainer"
