#!/usr/bin/env bash

set -ex

lix download

mkdir -p node_modules
sudo chmod a+rwx node_modules
yarn
npx dts2hx telegraf @types/js-cookie --noLibWrap --output lib/dts2hx
