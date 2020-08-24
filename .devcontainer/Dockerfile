FROM ubuntu:18.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git and needed tools are installed
    && apt-get install -y dumb-init iproute2 procps sudo bash-completion build-essential curl python3 software-properties-common libnss3-tools \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs=12.* \
    && add-apt-repository ppa:haxe/haxe4.1 \
    && apt-get install -y haxe=1:4.1* \
    && add-apt-repository ppa:git-core/ppa \
    && apt-get install -y git \
    && apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.rackspace.com/mariadb/repo/10.5/ubuntu bionic main' \
    && apt-get install -y mariadb-server \
    && npm install -g yarn \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to use
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
