#!/bin/bash

__dir=$(dirname $(realpath $0))

container=retos
image=retos

if [[ -z $@ ]]; then
    cmd=$image
    name="--name=$container"

    podman rm -i $container
else
    cmd="-it $image $@"
fi

podman run --rm \
    --env-file $__dir/../environment \
    --network slirp4netns:allow_host_loopback=true \
    $name \
    $cmd
