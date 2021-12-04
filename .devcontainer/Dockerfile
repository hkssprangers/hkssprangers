FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

ARG INSTALL_ZSH="false"
ARG UPGRADE_PACKAGES="true"
ARG ENABLE_NONROOT_DOCKER="true"
ARG USE_MOBY="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access 
# to the Docker socket. The script will also execute CMD as needed.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git and needed tools are installed
    && apt-get install -y \
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
        webp \
    && echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc \
    # Install a more recent git
    && add-apt-repository ppa:git-core/ppa \
    && apt-get install -y git \
    # Install node
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs=14.* \
    # Install mysql-client
    && apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.5/ubuntu focal main' \
    && apt-get install -y mariadb-server \
    # Install terraform
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get install -y terraform=1.0.11 terraform-ls \
    && echo "complete -C /usr/bin/terraform terraform" >> /etc/bash.bashrc \
    # Install yarn
    && npm install -g yarn \
    && yarn global add lix --prefix /usr/local \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Config direnv
COPY --chown=$USER_UID:$USER_GID direnv.toml /home/$USERNAME/.config/direnv/config.toml

# Install flyway
ARG FLYWAY_VERSION=8.1.0
RUN cd / \
    && wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin \
    && chmod a+x /usr/local/bin/flyway

# install skeema
RUN curl -fsSL -o skeema_amd64.deb https://github.com/skeema/skeema/releases/download/v1.6.0/skeema_amd64.deb \
    && apt-get install -y ./skeema_amd64.deb \
    && rm ./skeema_amd64.deb

# Install earthly
RUN curl -fsSL https://github.com/earthly/earthly/releases/download/v0.6.1/earthly-linux-amd64 -o /usr/local/bin/earthly \
    && chmod +x /usr/local/bin/earthly
RUN earthly bootstrap --no-buildkit --with-autocomplete

# Install planetscale cli
ARG PSCALE_VERSION=0.85.0
RUN curl -fsSL https://github.com/planetscale/cli/releases/download/v${PSCALE_VERSION}/pscale_${PSCALE_VERSION}_linux_amd64.deb -o pscale.deb \
    && apt-get -y install --no-install-recommends ./pscale.deb \
    && rm ./pscale.deb
    
ENV YARN_CACHE_FOLDER=/yarn
RUN mkdir -m 777 "$YARN_CACHE_FOLDER"
ENV HAXESHIM_ROOT=/haxe
RUN mkdir -m 777 "$HAXESHIM_ROOT"
RUN mkdir -m 777 "/workspace"
USER $USERNAME
WORKDIR /workspace
COPY workspace/.haxerc /workspace/
RUN lix install haxe "$(jq -r ".version" .haxerc)"
COPY workspace/*.hxml /workspace/
COPY workspace/haxe_libraries /workspace/haxe_libraries
RUN lix download
COPY workspace/package.json workspace/yarn.lock workspace/gen-externs.sh /workspace/
RUN yarn
VOLUME /workspace/node_modules
RUN yarn dts2hx
VOLUME /workspace/lib/dts2hx
USER root

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
