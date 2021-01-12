#!/usr/bin/env bash

set -ex

lix download

mkdir -p node_modules
sudo chmod a+rwx node_modules
yarn --network-concurrency 1 # https://github.com/yarnpkg/yarn/issues/6312
npx dts2hx telegraf @types/js-cookie moment copy-to-clipboard fastify @types/accepts aws-serverless-fastify google-auth-library abort-controller @types/promise-retry --noLibWrap --output lib/dts2hx

pip3 install docx2txt
