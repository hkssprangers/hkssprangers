FROM mcr.microsoft.com/vscode/devcontainers/base:0-bionic

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
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Configure apt and install packages
RUN sed -i 's/archive\.ubuntu\.com/ftp.ubuntu-tw.net\/ubuntu/g' /etc/apt/sources.list
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
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs=12.* \
    && add-apt-repository ppa:git-core/ppa \
    && apt-get install -y git \
    && apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.5/ubuntu bionic main' \
    && apt-get install -y mariadb-server \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get install -y terraform terraform-ls \
    && echo "complete -C /usr/bin/terraform terraform" >> /etc/bash.bashrc \
    && npm install -g yarn \
    && yarn global add lix --prefix /usr/local \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install flyway
RUN cd / \
    && wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/7.1.1/flyway-commandline-7.1.1-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-7.1.1/flyway /usr/local/bin \
    && chmod a+x /usr/local/bin/flyway

# Install yq
RUN wget https://github.com/mikefarah/yq/releases/download/v4.7.0/yq_linux_amd64.tar.gz -O - | tar xz && mv yq_linux_amd64 /usr/bin/yq

WORKDIR /workspace
ENV YARN_CACHE_FOLDER=/yarn
ENV HAXESHIM_ROOT=/haxe
COPY workspace/package.json workspace/yarn.lock /workspace/
RUN yarn
COPY workspace /workspace/
RUN mkdir -p "$HAXESHIM_ROOT" && lix download
RUN yarn dts2hx
VOLUME /workspace/node_modules /workspace/lib/dts2hx

# Expose pip installed binaries
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access 
# to the Docker socket. The script will also execute CMD as needed.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
