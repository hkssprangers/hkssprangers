#!/usr/bin/env bash

set -ex

haxelib newrepo
haxelib install all --always

sudo chmod a+rwx node_modules
yarn
npx dts2hx telegraf --noLibWrap --output lib/dts2hx
