#!/usr/bin/env bash

set -ex
yarn
yarn tailwind
yarn dts2hx
