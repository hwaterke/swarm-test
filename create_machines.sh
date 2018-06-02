#!/usr/bin/env bash
set -e
source ./config.sh

for ((i=1; i<=$MANAGER_COUNT; i++)); do
  echo "Creating Swarm manager: $MANAGER_MACHINE_NAME$i"
  docker-machine create $MANAGER_MACHINE_NAME$i >/dev/null
done

for ((i=1; i<=$WORKER_COUNT; i++)); do
  echo "Creating Swarm worker: $WORKER_MACHINE_NAME$i"
  docker-machine create $WORKER_MACHINE_NAME$i >/dev/null
done
