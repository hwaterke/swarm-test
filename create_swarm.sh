#!/usr/bin/env bash
set -e
source ./config.sh

# Grab ip of first manager
MANAGER_IP=$(docker-machine ip ${MANAGER_MACHINE_NAME}1)
echo "Manager IP: $MANAGER_IP"

# Init a new Swarm
echo "Initializing Swarm on ${MANAGER_MACHINE_NAME}1"
eval $(docker-machine env --shell bash ${MANAGER_MACHINE_NAME}1)
docker swarm init --advertise-addr $MANAGER_IP

# Collect tokens to join the Swarm
TOKEN_MANAGER=$(docker swarm join-token -q manager)
TOKEN_WORKER=$(docker swarm join-token -q worker)

# Make all other managers join the Swarm
for ((i=2; i<=$MANAGER_COUNT; i++)); do
  echo "Manager joining swarm: $MANAGER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $MANAGER_MACHINE_NAME$i)
  docker swarm join --token $TOKEN_MANAGER $MANAGER_IP:2377
done

# Make all workers join the Swarm
for ((i=1; i<=$WORKER_COUNT; i++)); do
  echo "Worker joining swarm: $WORKER_MACHINE_NAME$i"
  eval $(docker-machine env --shell bash $WORKER_MACHINE_NAME$i)
  docker swarm join --token $TOKEN_WORKER $MANAGER_IP:2377
done
