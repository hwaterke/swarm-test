#!/usr/bin/env bash
set -e
source ./config.sh

command=$@

# Run command on all managers
for ((i=1; i<=$MANAGER_COUNT; i++)); do
  echo "$MANAGER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $MANAGER_MACHINE_NAME$i)
  eval $command
done

# Run command on all workers
for ((i=1; i<=$WORKER_COUNT; i++)); do
  echo "$WORKER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $WORKER_MACHINE_NAME$i)
  eval $command
done
