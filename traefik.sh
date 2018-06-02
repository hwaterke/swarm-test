#!/usr/bin/env bash
set -e
source ./config.sh

eval $(docker-machine env --shell bash ${MANAGER_MACHINE_NAME}1)

docker network create --driver overlay traefik
docker stack deploy -c viz.yml viz
docker stack deploy -c traefik.yml traefik
docker stack deploy -c color.yml color
