#!/usr/bin/env bash
set -ex

# Portable in-place sed for both GNU (Linux) and BSD (macOS) sed.
# `-i.bak` (suffix attached) is accepted by both; the backups are removed afterwards.
sed_inplace() {
    local expr="$1"
    shift
    sed -i.bak -e "$expr" "$@"
    for f in "$@"; do
        rm -f "$f.bak"
    done
}

npx dts2hx \
    cross-fetch \
    telegraf \
    twilio \
    @types/js-cookie \
    moment \
    copy-to-clipboard \
    fastify \
    @types/accepts \
    aws-serverless-fastify \
    google-auth-library \
    abort-controller \
    @types/promise-retry \
    ajv \
    node-ical \
    axios \
    @splidejs/splide \
    @splidejs/react-splide \
    maplibre-gl gl-matrix potpack \
    pmtiles \
    --noLibWrap \
    --useSystemHaxe \
    --output lib/dts2hx

sed_inplace 's/axios.index.AxiosRequestConfig<Dynamic>/axios.AxiosRequestConfig/g' \
    lib/dts2hx/NodeIcal.hx \
    lib/dts2hx/node_ical/*.hx

sed_inplace 's/react\.ReactElement<Dynamic, ts\.AnyOf3<String, (props:Dynamic) -> Null<react\.ReactElement<Dynamic, Dynamic>>, { }>>/Dynamic/g' \
    lib/dts2hx/splidejs/react_splide/SplideProps.hx

sed_inplace 's/react\.[A-Za-z0-9]*/Dynamic/g' \
    lib/dts2hx/splidejs/react_splide/SplideProps.hx
