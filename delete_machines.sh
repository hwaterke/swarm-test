#!/usr/bin/env bash
set -e
source ./config.sh

for ((i=1; i<=$MANAGER_COUNT; i++)); do
  echo "Deleting Swarm manager: $MANAGER_MACHINE_NAME$i"
  docker-machine rm -y $MANAGER_MACHINE_NAME$i >/dev/null
done

for ((i=1; i<=$WORKER_COUNT; i++)); do
  echo "Deleting Swarm worker: $WORKER_MACHINE_NAME$i"
  docker-machine rm -y $WORKER_MACHINE_NAME$i >/dev/null
done
