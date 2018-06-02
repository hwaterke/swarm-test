#!/usr/bin/env bash
set -e
source ./config.sh

# Make all workers leave the Swarm
for ((i=1; i<=$WORKER_COUNT; i++)); do
  echo "Worker leaving swarm: $WORKER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $WORKER_MACHINE_NAME$i)
  docker swarm leave
done

# Make all other managers join the Swarm
for ((i=1; i<=$MANAGER_COUNT; i++)); do
  echo "Manager leaving swarm: $MANAGER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $MANAGER_MACHINE_NAME$i)
  docker swarm leave --force
done
