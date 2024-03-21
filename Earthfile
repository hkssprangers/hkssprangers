VERSION 0.8
FROM mcr.microsoft.com/vscode/devcontainers/base:0-jammy
ARG --global DEVCONTAINER_IMAGE_NAME_DEFAULT=ghcr.io/hkssprangers/hkssprangers_devcontainer
ARG --global MAIN_BRANCH=master

ARG --global USERNAME=vscode
ARG --global USER_UID=1000
ARG --global USER_GID=$USER_UID

ARG --global WORKDIR=/workspace
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$WORKDIR"
WORKDIR "$WORKDIR"

devcontainer-base:
    ENV HAXESHIM_ROOT=/haxe
    RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$HAXESHIM_ROOT"

    # Maunally install docker-compose to avoid the following error:
    # pip seemed to fail to build package: PyYAML<6,>=3.10
    COPY +docker-compose/docker-compose /usr/local/bin/

    # Avoid warnings by switching to noninteractive
    ENV DEBIAN_FRONTEND=noninteractive

    ARG INSTALL_ZSH="false"
    ARG UPGRADE_PACKAGES="true"
    ARG ENABLE_NONROOT_DOCKER="true"
    ARG USE_MOBY="false"
    COPY .devcontainer/library-scripts/common-debian.sh .devcontainer/library-scripts/docker-debian.sh /tmp/library-scripts/
    RUN apt-get update \
        && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
        && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
        # Clean up
        && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

    SAVE IMAGE --cache-hint --cache-from="ghcr.io/hkssprangers/hkssprangers_cache:$MAIN_BRANCH"

    # https://github.com/nodesource/distributions#installation-instructions
    RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    ARG NODE_MAJOR=16
    RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

    # Configure apt and install packages
    RUN apt-get update \
        && apt-get install -qqy --no-install-recommends apt-utils dialog 2>&1 \
        && apt-get install -qqy --no-install-recommends \
            iproute2 \
            procps \
            sudo \
            bash-completion \
            build-essential \
            curl \
            wget \
            python3 \
            python3-pip \
            software-properties-common \
            libnss3-tools \
            direnv \
            tzdata \
            imagemagick \
            librsvg2-bin \
            webp \
            # tilemaker deps
            liblua5.1-0 \
            liblua5.1-0-dev \
            osmosis \
            # install docker engine for using `WITH DOCKER`
            docker-ce \
            # install node
            nodejs=${NODE_MAJOR}.* \
        # Install postgresql-client
        # https://www.postgresql.org/download/linux/ubuntu/
        && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
        && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
        && apt-get update \
        && apt-get -y install postgresql-client-13 \
        # Install haxe
        && add-apt-repository ppa:haxe/haxe4.2 -y \
        && apt-get update \
        && apt-get install -qqy --no-install-recommends \
            haxe=1:4.2.* \
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*

    # Switch back to dialog for any ad-hoc use of apt-get
    ENV DEBIAN_FRONTEND=

    RUN npm config --global set update-notifier false
    RUN npm config set prefix /usr/local
    RUN npm install -g lix

    SAVE IMAGE --cache-hint --cache-from="ghcr.io/hkssprangers/hkssprangers_cache:$MAIN_BRANCH"

devcontainer-library-scripts:
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-debian.sh
    SAVE ARTIFACT --keep-ts *.sh AS LOCAL .devcontainer/library-scripts/

docker-compose:
    ARG TARGETARCH
    ARG VERSION=2.25.0 # https://github.com/docker/compose/releases/
    RUN curl -fsSL https://github.com/docker/compose/releases/download/v${VERSION}/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose \
        && chmod +x /usr/local/bin/docker-compose
    SAVE ARTIFACT /usr/local/bin/docker-compose

# Usage:
# COPY +tfenv/tfenv /tfenv
# RUN ln -s /tfenv/bin/* /usr/local/bin
tfenv:
    RUN git clone --depth 1 https://github.com/tfutils/tfenv.git /tfenv
    SAVE ARTIFACT /tfenv

# Usage:
# COPY +terraform-ls/terraform-ls /usr/local/bin/
terraform-ls:
    ARG TARGETARCH
    ARG VERSION=0.30.3
    RUN curl -fsSL -o terraform-ls.zip "https://releases.hashicorp.com/terraform-ls/${VERSION}/terraform-ls_${VERSION}_linux_${TARGETARCH}.zip" \
        && unzip -qq terraform-ls.zip \
        && mv ./terraform-ls /usr/local/bin/ \
        && rm terraform-ls.zip
    SAVE ARTIFACT /usr/local/bin/terraform-ls

terraform:
    FROM +tfenv
    RUN ln -s /tfenv/bin/* /usr/local/bin
    ARG --required TERRAFORM_VERSION
    RUN tfenv install "$TERRAFORM_VERSION"
    RUN tfenv use "$TERRAFORM_VERSION"

# Usage:
# COPY +earthly/earthly /usr/local/bin/
# RUN earthly bootstrap --no-buildkit --with-autocomplete
earthly:
    ARG TARGETARCH
    ARG VERSION=0.8.4 # https://github.com/earthly/earthly/releases
    RUN curl -fsSL "https://github.com/earthly/earthly/releases/download/v${VERSION}/earthly-linux-${TARGETARCH}" -o /usr/local/bin/earthly \
        && chmod +x /usr/local/bin/earthly
    SAVE ARTIFACT /usr/local/bin/earthly

dbmate:
    ARG TARGETARCH
    RUN curl -fsSL "https://github.com/amacneil/dbmate/releases/download/v1.14.0/dbmate-linux-${TARGETARCH}" -o /usr/local/bin/dbmate \
        && chmod +x /usr/local/bin/dbmate
    SAVE ARTIFACT /usr/local/bin/dbmate

# Usage:
# RUN /aws/install
awscli:
    RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "/tmp/awscliv2.zip" \
        && unzip -qq /tmp/awscliv2.zip -d / \
        && rm /tmp/awscliv2.zip
    SAVE ARTIFACT /aws

# Usage:
# COPY +rclone/rclone /usr/local/bin/
# COPY +rclone/bash_completion /etc/bash_completion.d/rclone
rclone:
    ARG TARGETARCH
    ARG VERSION=1.61.1
    RUN curl -fsSL "https://downloads.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-${TARGETARCH}.zip" -o rclone.zip \
        && unzip -qq rclone.zip \
        && rm rclone.zip
    RUN rclone-*/rclone completion bash > bash_completion
    SAVE ARTIFACT rclone-*/rclone
    SAVE ARTIFACT bash_completion

github-src:
    ARG --required REPO
    ARG --required COMMIT
    ARG DIR=/src
    WORKDIR $DIR
    RUN curl -fsSL "https://github.com/${REPO}/archive/${COMMIT}.tar.gz" | tar xz --strip-components=1 -C "$DIR"
    SAVE ARTIFACT "$DIR"

osmium-tool:
    FROM debian:bullseye
    RUN apt-get update -qqy && \
        apt-get install -qqy --no-install-recommends \
            osmium-tool \
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*
    RUN osmium --version
    WORKDIR "$WORKDIR"

tilemaker:
    FROM +devcontainer-base
    RUN apt-get update -qqy && \
        apt-get install -qqy --no-install-recommends \
            build-essential \
            libprotobuf-dev \
            libsqlite3-dev \
            protobuf-compiler \
            shapelib \
            libshp-dev \
            libboost-program-options-dev \
            libboost-filesystem-dev \
            libboost-system-dev \
            libboost-iostreams-dev \
            rapidjson-dev \
            cmake \
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*
    ARG TM_COMMIT=3c4fdb8db99b210796ebe576e2b1c3665bc9f8ea
    COPY (+github-src/src --REPO=systemed/tilemaker --COMMIT="$TM_COMMIT") /tilemaker
    WORKDIR /tilemaker/build
    RUN cmake -DTILEMAKER_BUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ ..
    RUN cmake --build .
    RUN strip tilemaker
    RUN mv tilemaker /usr/local/bin/
    WORKDIR /tilemaker
    SAVE ARTIFACT /usr/local/bin/tilemaker
    SAVE ARTIFACT resources/config-openmaptiles.json config.json
    SAVE ARTIFACT resources/process-openmaptiles.lua process.lua

pmtiles:
    ARG VERSION=1.7.0
    WORKDIR /tmp
    RUN curl -fsSL "https://github.com/protomaps/go-pmtiles/releases/download/v${VERSION}/go-pmtiles_${VERSION}_Linux_x86_64.tar.gz" | tar xz
    SAVE ARTIFACT pmtiles

china.osm.pbf:
    FROM openmaptiles/openmaptiles-tools:7.0.0
    RUN download-osm geofabrik china
    RUN ls -lah
    SAVE ARTIFACT china-latest.osm.pbf china.osm.pbf

china.osm.pbf-check:
    FROM +osmium-tool
    COPY +china.osm.pbf/china.osm.pbf .
    RUN osmium check-refs china.osm.pbf

ssp.osm.pbf:
    COPY +china.osm.pbf/china.osm.pbf .
    RUN osmosis --read-pbf china.osm.pbf --bounding-box top=22.347 left=114.1307 bottom=22.3111 right=114.198 completeWays=yes --write-pbf ssp.osm.pbf
    RUN ls -lah
    SAVE ARTIFACT ssp.osm.pbf AS LOCAL ./static/tiles/

ssp.osm.pbf-check:
    FROM +osmium-tool
    COPY +ssp.osm.pbf/ssp.osm.pbf .
    RUN osmium check-refs ssp.osm.pbf

ssp.osm.pbf-bbox:
    FROM +osmium-tool
    COPY +ssp.osm.pbf/ssp.osm.pbf .
    RUN osmium fileinfo -e -g data.bbox ssp.osm.pbf

ssp.mbtiles:
    COPY +tilemaker/tilemaker /usr/local/bin/
    COPY +tilemaker/config.json +tilemaker/process.lua /usr/local/share/tilemaker
    COPY +ssp.osm.pbf/ssp.osm.pbf .
    RUN tilemaker \
        --config /usr/local/share/tilemaker/config.json \
        --process /usr/local/share/tilemaker/process.lua \
        --input ssp.osm.pbf \
        --bbox 114.08885,22.2856527,114.2475128,22.4311088 \
        --output ssp.mbtiles \
        --skip-integrity
    RUN ls -lah
    SAVE ARTIFACT --keep-ts ssp.mbtiles AS LOCAL ./static/tiles/

ssp.pmtiles:
    COPY +pmtiles/pmtiles /usr/local/bin/
    COPY +ssp.mbtiles/ssp.mbtiles .
    RUN pmtiles convert ssp.mbtiles ssp.pmtiles
    RUN pmtiles show ssp.pmtiles
    SAVE ARTIFACT --keep-ts ssp.pmtiles AS LOCAL ./static/tiles/

ssp.pmtiles-current:
    RUN curl -fsSL https://ssprangers.com/tiles/ssp.pmtiles -o ssp.pmtiles
    SAVE ARTIFACT --keep-ts ssp.pmtiles AS LOCAL ./static/tiles/

ssp.mbtiles-server:
    FROM debian:bullseye
    RUN apt-get update -qqy && \
        apt-get install -qqy --no-install-recommends \
            build-essential \
            sqlite3 \
            libsqlite3-dev \
            ruby \
            ruby-dev \
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*
    ARG TM_COMMIT=763200664db2319079e97cc8134c41deffb41f0d
    COPY (+github-src/src --REPO=systemed/tilemaker --COMMIT="$TM_COMMIT") /tilemaker
    WORKDIR /tilemaker/server
    RUN gem install sqlite3 cgi glug rack
    COPY +ssp.mbtiles/ssp.mbtiles .
    ENV RACK_ENV=production
    EXPOSE 8080
    CMD ["ruby", "server.rb", "ssp.mbtiles"]
    SAVE IMAGE ssp.mbtiles-server:latest

ssp.mbtiles-serve:
    LOCALLY
    WITH DOCKER --load ssp.mbtiles-server:latest=+ssp.mbtiles-server
        RUN docker run \
            --rm \
            -p 8080:8080 \
            ssp.mbtiles-server:latest
    END

nginx-serve:
    LOCALLY
    WITH DOCKER
        RUN docker run \
            --rm \
            -p 8080:80 \
            nginx
    END

lix-download:
    FROM +devcontainer-base
    USER $USERNAME
    COPY haxe_libraries haxe_libraries
    COPY .haxerc .
    RUN mkdir -p "$HAXESHIM_ROOT/versions/$(jq -r .version .haxerc)"
    RUN ln -s /usr/bin/haxe "$HAXESHIM_ROOT/versions/$(jq -r .version .haxerc)/haxe"
    RUN ln -s /usr/bin/haxelib "$HAXESHIM_ROOT/versions/$(jq -r .version .haxerc)/haxelib"
    RUN ln -s /usr/share/haxe/std "$HAXESHIM_ROOT/versions/$(jq -r .version .haxerc)/std"
    RUN lix download
    SAVE ARTIFACT "$HAXESHIM_ROOT"
    SAVE IMAGE --cache-hint

node-modules-prod:
    FROM +devcontainer-base
    COPY .haxerc package.json package-lock.json .
    COPY +lix-download/haxe "$HAXESHIM_ROOT"
    RUN npm install --only=production
    SAVE ARTIFACT node_modules
    SAVE IMAGE --cache-hint

node-modules-dev:
    FROM +node-modules-prod
    RUN npm install
    SAVE ARTIFACT node_modules
    SAVE IMAGE --cache-hint

dts2hx-externs:
    FROM +node-modules-dev
    COPY gen-externs.sh .
    RUN sh gen-externs.sh
    SAVE ARTIFACT lib/dts2hx
    SAVE IMAGE --cache-hint

devcontainer:
    FROM +devcontainer-base

    # tfenv
    COPY +tfenv/tfenv /tfenv
    RUN ln -s /tfenv/bin/* /usr/local/bin/
    COPY --chown=$USER_UID:$USER_GID terraform/.terraform-version "/home/$USERNAME/"
    RUN tfenv install "$(cat /home/$USERNAME/.terraform-version)"
    RUN tfenv use "$(cat /home/$USERNAME/.terraform-version)"
    COPY +terraform-ls/terraform-ls /usr/local/bin/

    # Install earthly
    COPY +earthly/earthly /usr/local/bin/
    RUN earthly bootstrap --no-buildkit --with-autocomplete

    # Install flyway
    ARG FLYWAY_VERSION=8.1.0
    RUN cd / \
        && curl -fsSL https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar xz && sudo ln -s `pwd`/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin \
        && chmod a+x /usr/local/bin/flyway

    # install skeema
    ARG TARGETARCH
    RUN curl -fsSL -o skeema.deb https://github.com/skeema/skeema/releases/download/v1.7.0/skeema_${TARGETARCH}.deb \
        && apt-get install -y ./skeema.deb \
        && rm ./skeema.deb

    # AWS cli
    COPY +awscli/aws /aws
    RUN /aws/install

    COPY +dbmate/dbmate /usr/local/bin/

    COPY +rclone/rclone /usr/local/bin/
    COPY +rclone/bash_completion /etc/bash_completion.d/rclone

    COPY +tilemaker/tilemaker /usr/local/bin/
    COPY +tilemaker/config.json +tilemaker/process.lua /usr/local/share/tilemaker/

    COPY +pmtiles/pmtiles /usr/local/bin/

    USER $USERNAME

    # Config direnv
    COPY --chown=$USER_UID:$USER_GID .devcontainer/direnv.toml /home/$USERNAME/.config/direnv/config.toml

    # Config bash
    RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc \
        && echo 'complete -C terraform terraform' >> ~/.bashrc

    COPY --chown=$USER_UID:$USER_GID +lix-download/haxe "$HAXESHIM_ROOT"
    COPY --chown=$USER_UID:$USER_GID +node-modules-dev/node_modules node_modules
    VOLUME /workspace/node_modules
    COPY --chown=$USER_UID:$USER_GID +dts2hx-externs/dts2hx lib/dts2hx
    VOLUME /workspace/lib/dts2hx
    COPY --chown=$USER_UID:$USER_GID +ssp.pmtiles-current/ssp.pmtiles static/tiles/ssp.pmtiles
    VOLUME /workspace/static/tiles
    COPY --chown=$USER_UID:$USER_GID +mapfonts/font static/font
    VOLUME /workspace/static/font

    USER root

    ARG EARTHLY_GIT_HASH
    ENV GIT_SHA="$EARTHLY_GIT_HASH"
    ARG IMAGE_NAME="$DEVCONTAINER_IMAGE_NAME_DEFAULT"
    ARG IMAGE_TAG="$MAIN_BRANCH"
    ARG IMAGE_CACHE="$IMAGE_NAME:$IMAGE_TAG"
    SAVE IMAGE \
        --cache-from="$DEVCONTAINER_IMAGE_NAME_DEFAULT:$MAIN_BRANCH" \
        --cache-from="$IMAGE_CACHE" \
        --push "$IMAGE_NAME:$IMAGE_TAG"

ci-images:
    ARG EARTHLY_GIT_BRANCH
    RUN echo "$EARTHLY_GIT_BRANCH" | sed 's/[^A-Za-z0-9\-\.]/_/g' | tee image_tag
    RUN echo "$DEVCONTAINER_IMAGE_NAME_DEFAULT:$(cat image_tag)" | tee image_cache
    BUILD +devcontainer \ 
        --IMAGE_CACHE="$(cat image_cache)" \
        --IMAGE_TAG="$(cat image_tag)"

tailwind:
    FROM +devcontainer
    COPY package.json tailwind.config.js .
    COPY src src
    RUN NODE_ENV=production npm run tailwind
    SAVE ARTIFACT static/css/tailwind.css

style-css:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc processCss.hxml .
    COPY +static-assets/static.json .
    RUN haxe -D production processCss.hxml
    SAVE ARTIFACT --keep-ts static/css/style.css AS LOCAL static/css/style.css

serviceWorker-js:
    FROM +devcontainer
    USER $USERNAME
    COPY lib/workbox lib/workbox
    COPY haxe_libraries haxe_libraries
    COPY src src
    COPY .haxerc serviceWorker.hxml esbuild.inject.js .
    RUN haxe  -D production serviceWorker.hxml
    RUN node -c serviceWorker.bundled.js
    SAVE ARTIFACT --keep-ts serviceWorker.bundled.js AS LOCAL serviceWorker.bundled.js

browser-js:
    FROM +devcontainer
    USER $USERNAME
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc browser.hxml esbuild.inject.js holidays.json lunarCalendar.json .
    COPY +static-assets/static.json .
    RUN haxe -D production browser.hxml
    RUN node -c static/browser.bundled.js
    SAVE ARTIFACT --keep-ts static/browser.bundled.js AS LOCAL static/browser.bundled.js

server:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY \
        +browser-js/browser.bundled.js \
        static
    COPY \
        +serviceWorker-js/serviceWorker.bundled.js \
        .
    COPY \
        +tailwind/tailwind.css \
        +style-css/style.css \
        static/css
    COPY src src
    COPY .haxerc server.hxml holidays.json lunarCalendar.json package-lock.json .
    COPY +static/static.json .
    RUN haxe -D production server.hxml
    RUN node -c index.js
    SAVE ARTIFACT --keep-ts index.js AS LOCAL index.js
    SAVE ARTIFACT --keep-ts static.json AS LOCAL static.json

mapfonts:
    WORKDIR /tmp
    ARG COMMIT=d5cb92205b731ccde6b901e6387229e1a991317e
    RUN curl -fsSL "https://github.com/maplibre/demotiles/archive/$COMMIT.tar.gz" | tar xz --strip-components=1
    SAVE ARTIFACT --keep-ts "font/Open Sans Regular,Arial Unicode MS Regular" "font/Open Sans Regular,Arial Unicode MS Regular"

static-assets:
    FROM +devcontainer
    COPY static static
    RUN rm -rf static/css
    COPY haxe_libraries haxe_libraries
    COPY src src
    COPY .haxerc staticResource.hxml .
    RUN haxe staticResource.hxml
    SAVE ARTIFACT staticOut static
    SAVE ARTIFACT --keep-ts static.json AS LOCAL static.json

static:
    FROM +static-assets
    COPY \
        +browser-js/browser.bundled.js \
        static
    COPY \
        +tailwind/tailwind.css \
        +style-css/style.css \
        static/css
    RUN haxe staticResource.hxml
    SAVE ARTIFACT --keep-ts staticOut static
    SAVE ARTIFACT --keep-ts static.json AS LOCAL static.json

cronjobs.js:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc cronjobs.hxml holidays.json lunarCalendar.json .
    RUN haxe cronjobs.hxml
    RUN node -c cronjobs.js
    SAVE ARTIFACT cronjobs.js

commands.js:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc commands.hxml holidays.json lunarCalendar.json .
    RUN haxe commands.hxml
    RUN node -c commands.js
    SAVE ARTIFACT commands.js

test:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY test test
    COPY .haxerc test.hxml holidays.json lunarCalendar.json .
    RUN haxe test.hxml

deploy-static:
    FROM +devcontainer
    COPY .devcontainer/rclone/rclone.conf /root/.config/rclone/rclone.conf
    COPY --keep-ts +static/static static
    RUN --no-cache \
        --mount=type=secret,id=+secrets/envrc,target=.envrc \
        . ./.envrc \
        && rclone copy static s3:hkssprangers-static \
            --header-upload 'Cache-Control: public, max-age=31536000, immutable'
    COPY +static/static.json .
    SAVE ARTIFACT static.json

deploy:
    FROM +devcontainer
    USER $USERNAME
    COPY --chown=$USER_UID:$USER_GID \
        +deploy-static/static.json \
        +server/index.js \
        +cronjobs.js/cronjobs.js \
        +serviceWorker-js/serviceWorker.bundled.js \
        .
    COPY --chown=$USER_UID:$USER_GID \
        serverless.yml package.json package-lock.json holidays.json lunarCalendar.json deliveryLocations.json \
        .
    ARG --required DEPLOY_STAGE
    ENV DEPLOY_STAGE="$DEPLOY_STAGE"
    ARG --required SERVER_HOST
    ENV SERVER_HOST="$SERVER_HOST"
    RUN --no-cache \
        --mount=type=secret,id=+secrets/envrc,target=.envrc \
        . ./.envrc \
        && npx serverless deploy --stage "${DEPLOY_STAGE}" \
        && node index.js setTgWebhook

check-terraform:
    FROM +devcontainer
    COPY terraform terraform
    WORKDIR terraform
    ENV TF_INPUT=0
    ENV TF_IN_AUTOMATION=1
    ARG TF_LOCK_TIMEOUT=0s
    RUN --no-cache \
        --mount=type=secret,id=+secrets/envrc,target=.envrc \
        . ./.envrc \
        && terraform init \
        && terraform plan -detailed-exitcode -lock-timeout="$TF_LOCK_TIMEOUT"

check-database-schema:
    FROM +devcontainer
    COPY dev/initdb/schema.sql committed.sql
    COPY +db-dump-schema/schema.sql live.sql
    RUN diff committed.sql live.sql

pre-deploy-check:
    ARG TF_LOCK_TIMEOUT=0s
    BUILD +check-terraform --TF_LOCK_TIMEOUT="$TF_LOCK_TIMEOUT"
    BUILD +check-database-schema

post-deploy-test:
    RUN --no-cache date +%s | tee timestamp
    ARG --required SERVER_HOST
    RUN curl -fsSL "https://$SERVER_HOST?cache_invalidator=$(cat timestamp)" -o /dev/null
    RUN curl -fsSL "https://$SERVER_HOST/login?cache_invalidator=$(cat timestamp)" -o /dev/null

db-dump-schema:
    FROM +devcontainer
    RUN --no-cache \
        --mount=type=secret,id=+secrets/envrc,target=.envrc \
        . ./.envrc \
        && psql -d "$DATABASE_URL" -c "SHOW CREATE ALL TABLES" -q -A -t -o schema.sql
    SAVE ARTIFACT --keep-ts schema.sql AS LOCAL dev/initdb/schema.sql

db-backup:
    FROM +devcontainer
    ARG S3_BUCKET=hkssprangers-dbbackup
    ARG S3_PATH=dbbackup
    RUN --no-cache \
        --mount=type=secret,id=+secrets/envrc,target=.envrc \
        . ./.envrc \
        && psql -d "$DATABASE_URL" -c "BACKUP INTO 's3://${S3_BUCKET}/${S3_PATH}?AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}&AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' AS OF SYSTEM TIME '-10s';"
