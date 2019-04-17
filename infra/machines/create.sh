
set -e

create() {
    if [ -z $DIGITALOCEAN_TOKEN ]; then
        echo 'digitalocean token not set'
        exit 12
    fi

    name=$1

#--digitalocean-monitoring # no for coreOs

    docker-machine $MACHINE_DEBUG create \
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
        --digitalocean-private-networking \
        $name
}

#load env
export $(egrep -v '^#' .env | xargs)

# vars
DELAY=60

# leader information
LEADER_IP=
LEADER_WORKER_TOKEN=
LEADER_MANAGER_TOKEN=

echo ">>> create managers:"
for n in $(seq 1 $MANAGER_NODES); do
    name="$ENVIRONMENT-manager-$(printf '%02d' $n)"
    create $name

    echo ">>> sleep ${DELAY}s"
    sleep $DELAY

    ip=docker-machine ip $name
    echo ">>> created node $name ip=$ip"

    # define LEADER
    if [ -z $LEADER_IP ]; then
        echo ">>> node $name init swarm node"
        docker-machine ssh $name "docker swarm init --advertise-addr $ip"

        LEADER_IP=$ip
        LEADER_WORKER_TOKEN="$(docker-machine ssh $name docker swarm join-token worker -q)"
        LEADER_MANAGER_TOKEN="$(docker-machine ssh $name docker swarm join-token manager -q)"

        continue
    fi

    echo ">>> $name join as manager on swarm cluster"
    docker-machine ssh $name "docker swarm join --token $LEADER_MANAGER_TOKEN $LEADER_IP:2377"
done

echo ">>> create workers:"
for n in $(seq 1 $WORKER_NODES); do
    name="$ENVIRONMENT-worker-$(printf '%02d' $n)"
    create $name

    echo ">>> sleep ${DELAY}s"
    sleep $DELAY

    ip=docker-machine ip $name
    echo ">>> created node $name ip=$ip"

    echo ">>> $name join as worker on swarm cluster"
    docker-machine ssh $name "docker swarm join --token $LEADER_MANAGER_TOKEN $LEADER_IP:2377"
done
