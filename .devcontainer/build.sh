#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TAG="hkssprangers/hkssprangers_devcontainer_workspace:$(date +%Y%m%d%H%M%S)"

docker build --pull -t "$TAG" "$DIR"

yq eval ".services.workspace.image = \"$TAG\"" "$DIR/.devcontainer/docker-compose.yml" -i
yq eval ".jobs.build.container = \"$TAG\"" "$DIR/.github/workflows/ci.yml" -i
