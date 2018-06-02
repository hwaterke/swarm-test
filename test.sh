#!/usr/bin/env bash

set -e

# ======================================================================
echo "Create network for inter container communication"
# ======================================================================
docker-machine ssh master-foo <<EOF
  docker network create --driver overlay backend
EOF

# Result
# docker network ls
# NETWORK ID          NAME                DRIVER              SCOPE
# tw5y9n0wil6t        backend             overlay             swarm
# xcro2tcryvw5        ingress             overlay             swarm

# ======================================================================
echo "Start the docker swarm visu"
# ======================================================================
docker-machine ssh master-foo <<EOF
  docker service create \
    --name=viz \
    --publish=8090:8080/tcp \
    --constraint=node.role==manager \
    --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    dockersamples/visualizer
EOF

# After some time, we can open the visu. On fish:
# open http://(docker-machine ip master-foo):8080

# ======================================================================
echo "Build the nginx"
# ======================================================================
docker-machine scp -r ./nginx master-foo:~
docker-machine ssh master-foo <<EOF
  cd nginx
  docker build -t nginx-color .
EOF

# ======================================================================
echo "Deploying a service"
# ======================================================================

docker service create --name color --publish 3000:3000 --replicas 4 hwaterke/color:1
docker service create --name color --network backend --replicas 4 hwaterke/color:1
docker service create --name nginx-color -p 80:80 --network backend --replicas 1 nginx-color

# Scale color
docker service scale color=2
docker service update --image hwaterke/color:2 color_color
docker service update --rollback color

# Inside a container call another service on the network
dig color # Will return the ip address of the load balancer!
dig tasks.color # Will return all the ip addresses of all the containers
watch -d -n 1 curl color:3000/inspect






# traefik commands

# From https://dddpaul.github.io/blog/2016/11/07/traefik-on-docker-swarm/

# From https://stackoverflow.com/questions/45409922/traefik-how-to-redirect-using-only-docker-compose-yml/45446901#45446901
# command:
#   --web
#   --docker
#   --docker.domain=docker.localhost
#   --logLevel=DEBUG
#   --entryPoints='Name:https Address::443 TLS'
#   --entryPoints='Name:http Address::80'
#   --acme.entrypoint=https
#   --acme=true
#   --acme.domains="${BASE_URL}, ${ADMIN_URL}"
#   --acme.email="${MAIL_ADDRESS}"
#   --acme.ondemand=true acme.onhostrule=true
#   --acme.storage=/certs/acme.json
