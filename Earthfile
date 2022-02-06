VERSION 0.6
FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal
ARG DEVCONTAINER_IMAGE_NAME_DEFAULT=ghcr.io/hkssprangers/hkssprangers_devcontainer
ARG MAIN_BRANCH=master

ARG --required TARGETARCH

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG WORKDIR=/workspace
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$WORKDIR"
WORKDIR "$WORKDIR"

ENV YARN_CACHE_FOLDER=/yarn
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$YARN_CACHE_FOLDER"
ENV HAXESHIM_ROOT=/haxe
RUN install -d -m 0755 -o "$USER_UID" -g "$USER_UID" "$HAXESHIM_ROOT"

ARG NODE_VERSION=16

devcontainer-library-scripts:
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh
    RUN curl -fsSLO https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-debian.sh
    SAVE ARTIFACT --keep-ts *.sh AS LOCAL .devcontainer/library-scripts/

# https://github.com/docker-library/mysql/blob/master/8.0/Dockerfile.debian
mysql-public-key:
    ARG KEY=859BE8D7C586F538430B19C2467B942D3A79BD29
    RUN gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$KEY"
    RUN gpg --batch --armor --export "$KEY" > mysql-public-key
    SAVE ARTIFACT --keep-ts mysql-public-key AS LOCAL .devcontainer/mysql-public-key

# Usage:
# COPY +tfenv/tfenv /tfenv
# RUN ln -s /tfenv/bin/* /usr/local/bin
tfenv:
    FROM +devcontainer-base
    RUN git clone --depth 1 https://github.com/tfutils/tfenv.git /tfenv
    SAVE ARTIFACT /tfenv

# Usage:
# COPY +terraform-ls/terraform-ls /usr/local/bin/
terraform-ls:
    ARG --required TARGETARCH
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
    FROM +devcontainer-base
    ARG --required TARGETARCH
    RUN curl -fsSL https://github.com/earthly/earthly/releases/download/v0.6.6/earthly-linux-${TARGETARCH} -o /usr/local/bin/earthly \
        && chmod +x /usr/local/bin/earthly
    SAVE ARTIFACT /usr/local/bin/earthly

devcontainer-base:
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

    COPY .devcontainer/mysql-public-key /tmp/mysql-public-key
    RUN apt-key add /tmp/mysql-public-key

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
            # install docker engine for using `WITH DOCKER`
            docker-ce \
        # install node
        && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
        && apt-get install -qqy --no-install-recommends nodejs=${NODE_VERSION}.* \
        # Install yarn
        && npm install -g yarn \
        && yarn global add lix --prefix /usr/local \
        # Install mysql-client
        # https://github.com/docker-library/mysql/blob/master/8.0/Dockerfile.debian
        && echo 'deb http://repo.mysql.com/apt/ubuntu/ focal mysql-8.0' > /etc/apt/sources.list.d/mysql.list \
        && apt-get update \
        && apt-get -y install mysql-client=8.0.* \
        #
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*

    # Switch back to dialog for any ad-hoc use of apt-get
    ENV DEBIAN_FRONTEND=

lix-download:
    FROM +devcontainer-base
    USER $USERNAME
    WORKDIR /workspace
    COPY haxe_libraries haxe_libraries
    COPY .haxerc .
    RUN lix download
    SAVE ARTIFACT "$HAXESHIM_ROOT"

node-modules-prod:
    FROM +devcontainer-base
    COPY .haxerc package.json yarn.lock .
    COPY +lix-download/haxe "$HAXESHIM_ROOT"
    RUN yarn --production
    SAVE ARTIFACT node_modules

node-modules-dev:
    FROM +node-modules-prod
    RUN yarn
    SAVE ARTIFACT node_modules

dts2hx-externs:
    FROM +node-modules-dev
    COPY gen-externs.sh .
    RUN yarn dts2hx
    SAVE ARTIFACT lib/dts2hx

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
        && wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin \
        && chmod a+x /usr/local/bin/flyway

    # install skeema
    RUN curl -fsSL -o skeema_amd64.deb https://github.com/skeema/skeema/releases/download/v1.6.0/skeema_amd64.deb \
        && apt-get install -y ./skeema_amd64.deb \
        && rm ./skeema_amd64.deb
    
    # Install planetscale cli
    ARG PSCALE_VERSION=0.85.0
    RUN curl -fsSL https://github.com/planetscale/cli/releases/download/v${PSCALE_VERSION}/pscale_${PSCALE_VERSION}_linux_amd64.deb -o pscale.deb \
        && apt-get -y install --no-install-recommends ./pscale.deb \
        && rm ./pscale.deb

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
    BUILD +devcontainer \ 
        --IMAGE_CACHE="$DEVCONTAINER_IMAGE_NAME_DEFAULT:$GIT_REF_NAME" \
        --IMAGE_TAG="$GIT_REF_NAME" \
        --GIT_SHA="$GIT_SHA"

tailwind:
    FROM +devcontainer
    COPY package.json tailwind.config.js .
    COPY src src
    RUN NODE_ENV=production yarn tailwind
    SAVE ARTIFACT static/css/tailwind.css

style-css:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc processCss.hxml .
    RUN haxe processCss.hxml
    SAVE ARTIFACT static/css/style.css

serviceWorker-js:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY lib/workbox lib/workbox
    COPY haxe_libraries haxe_libraries
    COPY src src
    COPY .haxerc serviceWorker.hxml babel.config.json .
    RUN mkdir static
    RUN haxe serviceWorker.hxml
    RUN npx browserify serviceWorker.js --transform [ babelify --global ] -g [ envify --NODE_ENV production ] -g uglifyify | npx terser --compress --mangle > static/serviceWorker.bundled.js
    SAVE ARTIFACT static/serviceWorker.bundled.js

browser-js:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc browser.hxml babel.config.json holidays.json .
    RUN haxe browser.hxml
    RUN npx browserify browser.js -g [ envify --NODE_ENV production ] -g uglifyify | npx terser --compress --mangle > static/browser.bundled.js
    SAVE ARTIFACT static/browser.bundled.js

server:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY +browser-js/browser.bundled.js static/browser.bundled.js
    COPY +serviceWorker-js/serviceWorker.bundled.js static/serviceWorker.bundled.js
    COPY +tailwind/tailwind.css static/css/tailwind.css
    COPY +style-css/style.css static/css/style.css
    COPY src src
    COPY .haxerc server.hxml babel.config.json holidays.json .
    RUN haxe server.hxml
    SAVE ARTIFACT index.js
    SAVE ARTIFACT static/images

importGoogleForm-js:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY .haxerc importGoogleForm.hxml holidays.json .
    RUN haxe importGoogleForm.hxml
    SAVE ARTIFACT importGoogleForm.js

test:
    FROM +devcontainer
    COPY lib/hxnodelibs lib/hxnodelibs
    COPY haxe_libraries haxe_libraries
    COPY static static
    COPY src src
    COPY test test
    COPY .haxerc test.hxml holidays.json .
    RUN haxe test.hxml

deploy:
    FROM +devcontainer
    COPY static static
    COPY +browser-js/browser.bundled.js static/browser.bundled.js
    COPY +serviceWorker-js/serviceWorker.bundled.js static/serviceWorker.bundled.js
    COPY +tailwind/tailwind.css static/css/tailwind.css
    COPY +style-css/style.css static/css/style.css
    COPY +server/index.js index.js
    COPY +server/images static/images
    COPY holidays.json .
    ARG --required DEPLOY_STAGE
    RUN --no-cache \
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
        . ./.envrc \
        && npx serverless deploy --stage "${DEPLOY_STAGE}" \
        && node index.js setTgWebhook

pre-deploy-check:
    FROM +devcontainer
    COPY terraform terraform
    WORKDIR terraform
    ENV TF_INPUT=0
    ENV TF_IN_AUTOMATION=1
    RUN --no-cache \
        --mount=type=secret,id=+secrets/.envrc,target=.envrc \
        . ./.envrc \
        && terraform init \
        && terraform plan -detailed-exitcode
