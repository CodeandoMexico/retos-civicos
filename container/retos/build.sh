#!/bin/bash

__dir=$(dirname $(realpath $0))

podman build -t retos $__dir/../../
