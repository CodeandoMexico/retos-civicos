#!/bin/bash

__dir=$(dirname $(realpath $0))

podman run -it --rm \
    --name retos-postgres \
    --env-file $__dir/../environment \
    docker.io/postgres:14
