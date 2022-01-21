set -ex

npx dts2hx \
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
    --noLibWrap \
    --useSystemHaxe \
    --output lib/dts2hx

sed -i 's/axios.index.AxiosRequestConfig<Dynamic>/axios.AxiosRequestConfig/g' \
    lib/dts2hx/NodeIcal.hx \
    lib/dts2hx/node_ical/*.hx
