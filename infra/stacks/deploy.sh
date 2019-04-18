#!/usr/bin/env bash
set -e

stack=$1

stacks=( "docker" "proxy" "portainer" "swarmpit" "visualizer" "jenkins" )

if [ -z $stack ]; then
    echo '>>> stack not defined use: deploy.sh <stack>'
    echo ">>> options to deploy: ${stacks[@]}"
    exit 1
fi

#load env
export $(egrep -v '^#' .env | xargs)

if [ "$stack" != 'all' ]; then
    # single deploy
    echo ">>> stack: $stack"
    docker stack deploy \
        --with-registry-auth \
        --compose-file $stack/stack.yml \
        $stack

    exit 0
fi

echo ">>> stacks to deploy: ${stacks[@]}"
for name in "${stacks[@]}"; do
    echo ">>> stack: $name"
    docker stack deploy \
        --with-registry-auth \
        --compose-file $name/stack.yml \
        $name
done
