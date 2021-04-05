#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TAG="hkssprangers/hkssprangers_devcontainer_workspace:$(date +%Y%m%d%H%M%S)"

docker build -t "$TAG" "$DIR"
