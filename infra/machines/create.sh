#!/usr/bin/env bash

set -e

create() {
    if [ -z $DIGITALOCEAN_TOKEN ]; then
        echo 'digitalocean token not set'
        exit 12
    fi

    name=$1

    if docker-machine status $name > /dev/null 2>&1; then
        echo '>>> machine already exists'
        return 0
    fi

    docker-machine create \
        --driver digitalocean \
        --digitalocean-access-token $DIGITALOCEAN_TOKEN \
        --digitalocean-image $MACHINE_IMAGE \
        --digitalocean-region $MACHINE_REGION \
        --digitalocean-size $MACHINE_SIZE \
        --digitalocean-ssh-port $MACHINE_SSH_PORT \
        --digitalocean-ssh-user $MACHINE_SSH_USER \
        --digitalocean-ssh-key-path $MACHINE_SSH_KEYPATH \
        --digitalocean-ssh-key-fingerprint $MACHINE_SSH_KEYFP \
        --digitalocean-ipv6 \
        $name

    return $?
}

#load env
export $(egrep -v '^#' .env | xargs)

# leader information
LEADER_IP=
LEADER_WORKER_TOKEN=
LEADER_MANAGER_TOKEN=

echo ">>> create managers:"
for n in $(seq 1 $MANAGER_NODES); do
    name="$ENVIRONMENT-manager-$(printf '%02d' $n)"

    create $name
    echo ">>> created node $name"

    # define LEADER
    if [ -z "$LEADER_IP" ]; then
        ip="$(docker-machine ip $name)"
        
        echo ">>> Public IP: $ip"

        echo ">>> node $name init swarm node"
        docker-machine ssh $name "docker swarm init --advertise-addr $ip || exit 0"

        echo ">>> node $name defined as LEADER"
        LEADER_IP=$ip
        LEADER_MANAGER_TOKEN="$(docker-machine ssh $name docker swarm join-token manager -q)"
        LEADER_WORKER_TOKEN="$(docker-machine ssh $name docker swarm join-token worker -q)"

        echo ">>> Leader IP: $LEADER_IP"
        echo ">>> Leader Token Manager: $LEADER_MANAGER_TOKEN"
        echo ">>> Leader Token Worker: $LEADER_WORKER_TOKEN"

        continue
    fi

    echo ">>> $name join as manager on swarm cluster"
    docker-machine ssh $name "docker swarm join --token $LEADER_MANAGER_TOKEN $LEADER_IP:2377 || exit 0"
done

echo ''
echo ">>> create workers:"
for n in $(seq 1 $WORKER_NODES); do
    name="$ENVIRONMENT-worker-$(printf '%02d' $n)"

    create $name
    echo ">>> created node $name"

    echo ">>> $name join as worker on swarm cluster"
    docker-machine ssh $name "docker swarm join --token $LEADER_WORKER_TOKEN $LEADER_IP:2377 || exit 0"
done
