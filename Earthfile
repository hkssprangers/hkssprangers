VERSION 0.6
FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal
ARG DEVCONTAINER_IMAGE_NAME_DEFAULT=ghcr.io/hkssprangers/hkssprangers_devcontainer
ARG MAIN_BRANCH=master

ARG TARGETARCH

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG WORKDIR=/workspace
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$WORKDIR"
WORKDIR "$WORKDIR"

ENV HAXESHIM_ROOT=/haxe
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$HAXESHIM_ROOT"

ARG NODE_VERSION=16

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

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access 
# to the Docker socket. The script will also execute CMD as needed.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

SAVE IMAGE --cache-hint

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
    && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -qqy --no-install-recommends nodejs=${NODE_VERSION}.* \
    # Install postgresql-client
    # https://www.postgresql.org/download/linux/ubuntu/
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && apt-get update \
    && apt-get -y install postgresql-client-13 \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

RUN npm config --global set update-notifier false
RUN npm config set prefix /usr/local
RUN npm install -g lix

SAVE IMAGE --cache-hint

devcontainer-library-scripts:
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-debian.sh
    SAVE ARTIFACT --keep-ts *.sh AS LOCAL .devcontainer/library-scripts/

# Usage:
# COPY +tfenv/tfenv /tfenv
# RUN ln -s /tfenv/bin/* /usr/local/bin
tfenv:
    RUN git clone --depth 1 https://github.com/tfutils/tfenv.git /tfenv
    SAVE ARTIFACT /tfenv

# Usage:
# COPY +terraform-ls/terraform-ls /usr/local/bin/
terraform-ls:
    ARG TERRAFORM_LS_VERSION=0.25.1
    RUN curl -fsSL -o terraform-ls.zip https://github.com/hashicorp/terraform-ls/releases/download/v${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_linux_${TARGETARCH}.zip \
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
    RUN curl -fsSL https://github.com/earthly/earthly/releases/download/v0.6.29/earthly-linux-${TARGETARCH} -o /usr/local/bin/earthly \
        && chmod +x /usr/local/bin/earthly
    SAVE ARTIFACT /usr/local/bin/earthly

dbmate:
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
    ARG TM_COMMIT=763200664db2319079e97cc8134c41deffb41f0d
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
    RUN pip3 install pmtiles==1.3.0

china.osm.pbf:
    FROM openmaptiles/openmaptiles-tools:6.1.4
    RUN download-osm geofabrik china
    RUN ls -lah
    SAVE ARTIFACT china-latest.osm.pbf china.osm.pbf

china.osm.pbf-check:
    FROM +osmium-tool
    COPY +china.osm.pbf/china.osm.pbf .
    RUN osmium check-refs china.osm.pbf

hk.osm.pbf:
    FROM openmaptiles/openmaptiles-tools:6.1.4
    RUN download-osm osmfr asia/china/hong_kong
    RUN ls -lah
    SAVE ARTIFACT hong_kong-latest.osm.pbf hk.osm.pbf

ssp.osm.pbf:
    COPY +hk.osm.pbf/hk.osm.pbf .
    RUN osmosis --read-pbf hk.osm.pbf --bounding-box top=22.347 left=114.1307 bottom=22.3111 right=114.198 completeWays=yes --write-pbf ssp.osm.pbf
    RUN ls -lah
    SAVE ARTIFACT ssp.osm.pbf

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
    COPY +tilemaker/config.json /usr/local/share/tilemaker/config.json
    COPY +tilemaker/process.lua /usr/local/share/tilemaker/process.lua
    COPY +ssp.osm.pbf/ssp.osm.pbf .
    RUN tilemaker \
        --config /usr/local/share/tilemaker/config.json \
        --process /usr/local/share/tilemaker/process.lua \
        --input ssp.osm.pbf \
        --bbox 114.08885,22.2856527,114.2475128,22.4311088 \
        --output ssp.mbtiles
    RUN ls -lah
    SAVE ARTIFACT ssp.mbtiles AS LOCAL ./static/

ssp.pmtiles:
    FROM +pmtiles
    COPY +ssp.mbtiles/ssp.mbtiles .
    RUN pmtiles-convert ssp.mbtiles ssp.pmtiles
    RUN pmtiles-show ssp.pmtiles
    SAVE ARTIFACT ssp.pmtiles AS LOCAL ./static/

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
    USER $USERNAME
    COPY haxe_libraries haxe_libraries
    COPY .haxerc .
    RUN lix download
    SAVE ARTIFACT "$HAXESHIM_ROOT"
    SAVE IMAGE --cache-hint

node-modules-prod:
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
    RUN curl -fsSL -o skeema_amd64.deb https://github.com/skeema/skeema/releases/download/v1.7.0/skeema_${TARGETARCH}.deb \
        && apt-get install -y ./skeema_amd64.deb \
        && rm ./skeema_amd64.deb

    # AWS cli
    COPY +awscli/aws /aws
    RUN /aws/install

    COPY +dbmate/dbmate /usr/local/bin/

    COPY +tilemaker/tilemaker /usr/local/bin/
    COPY +tilemaker/config.json /usr/local/share/tilemaker/config.json
    COPY +tilemaker/process.lua /usr/local/share/tilemaker/process.lua

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
    COPY --chown=$USER_UID:$USER_GID +ssp.pmtiles/ssp.pmtiles static/tiles/ssp.pmtiles
    VOLUME /workspace/static/tiles

    USER root

    ARG GIT_SHA
    ENV GIT_SHA="$GIT_SHA"
    ARG IMAGE_NAME="$DEVCONTAINER_IMAGE_NAME_DEFAULT"
    ARG IMAGE_TAG="$MAIN_BRANCH"
    ARG IMAGE_CACHE="$IMAGE_NAME:$IMAGE_TAG"
    SAVE IMAGE --cache-from="$IMAGE_CACHE" --push "$IMAGE_NAME:$IMAGE_TAG"

ci-images:
    ARG --required GIT_REF_NAME
    ARG --required GIT_SHA
    RUN echo "$GIT_REF_NAME" | sed 's/[^A-Za-z0-9\-\.]/_/g' | tee image_tag
    RUN echo "$DEVCONTAINER_IMAGE_NAME_DEFAULT:$(cat image_tag)" | tee image_cache
    BUILD +devcontainer \ 
        --IMAGE_CACHE="$(cat image_cache)" \
        --IMAGE_TAG="$(cat image_tag)" \
        --GIT_SHA="$GIT_SHA"

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
    RUN haxe processCss.hxml
    SAVE ARTIFACT static/css/style.css

serviceWorker-js:
    FROM +devcontainer
    USER $USERNAME
    COPY lib/workbox lib/workbox
    COPY haxe_libraries haxe_libraries
    COPY src src
    COPY .haxerc serviceWorker.hxml esbuild.inject.js .
    RUN mkdir -p static
    RUN haxe serviceWorker.hxml
    SAVE ARTIFACT static/serviceWorker.bundled.js

browser-js:
    FROM +devcontainer
    USER $USERNAME
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc browser.hxml esbuild.inject.js holidays.json .
    COPY +serviceWorker-js/serviceWorker.bundled.js static/serviceWorker.bundled.js
    RUN haxe browser.hxml
    SAVE ARTIFACT static/browser.bundled.js

server:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY +browser-js/browser.bundled.js static/browser.bundled.js
    COPY +serviceWorker-js/serviceWorker.bundled.js static/serviceWorker.bundled.js
    COPY +tailwind/tailwind.css static/css/tailwind.css
    COPY +style-css/style.css static/css/style.css
    COPY src src
    COPY .haxerc server.hxml holidays.json package-lock.json .
    RUN haxe server.hxml
    SAVE ARTIFACT index.js
    SAVE ARTIFACT static/images

holidays.json:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY src src
    COPY .haxerc holidays.hxml package-lock.json .
    RUN echo '{}' > holidays.json
    RUN haxe holidays.hxml
    RUN node holidays.js
    SAVE ARTIFACT holidays.json AS LOCAL holidays.json

importGoogleForm-js:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc importGoogleForm.hxml holidays.json .
    RUN haxe importGoogleForm.hxml
    SAVE ARTIFACT importGoogleForm.js

test:
    FROM +devcontainer
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY test test
    COPY .haxerc test.hxml holidays.json .
    RUN haxe test.hxml

deploy:
    FROM +devcontainer
    USER $USERNAME
    COPY --chown=$USER_UID:$USER_GID static static
    COPY --chown=$USER_UID:$USER_GID +browser-js/browser.bundled.js static/browser.bundled.js
    COPY --chown=$USER_UID:$USER_GID +serviceWorker-js/serviceWorker.bundled.js static/serviceWorker.bundled.js
    COPY --chown=$USER_UID:$USER_GID +tailwind/tailwind.css static/css/tailwind.css
    COPY --chown=$USER_UID:$USER_GID +style-css/style.css static/css/style.css
    COPY --chown=$USER_UID:$USER_GID +server/index.js index.js
    COPY --chown=$USER_UID:$USER_GID +server/images static/images
    COPY --chown=$USER_UID:$USER_GID +importGoogleForm-js/importGoogleForm.js importGoogleForm.js
    COPY --chown=$USER_UID:$USER_GID serverless.yml package.json package-lock.json holidays.json .
    ARG --required DEPLOY_STAGE
    ENV DEPLOY_STAGE="$DEPLOY_STAGE"
    ARG --required SERVER_HOST
    ENV SERVER_HOST="$SERVER_HOST"
    RUN --no-cache \
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
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
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
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
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
        . ./.envrc \
        && psql -d "$DATABASE_URL" -c "SHOW CREATE ALL TABLES" -q -A -t -o schema.sql
    SAVE ARTIFACT --keep-ts schema.sql AS LOCAL dev/initdb/schema.sql

db-backup:
    FROM +devcontainer
    ARG S3_BUCKET=hkssprangers-dbbackup
    ARG S3_PATH=dbbackup
    RUN --no-cache \
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
        . ./.envrc \
        && psql -d "$DATABASE_URL" -c "BACKUP INTO 's3://${S3_BUCKET}/${S3_PATH}?AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}&AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' AS OF SYSTEM TIME '-10s';"
