#####
# Ambiente 1.0
# Ubuntu as Base Image (Node Packages)
######
FROM ubuntu:16.10

# Repository/Image Maintainer
MAINTAINER Joao Lemgruber <jclemgruber@gmail.com>

ENV NODEJS_VERSION=setup_7.x

# Install Node 7.x, some utils and cleanup
RUN echo "---> Updating Repository and Installing Utils" && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl \
    wget \
    vim \
    sudo && \
    echo "---> Enabling Node Repository" && \
    curl -sL https://deb.nodesource.com/${NODEJS_VERSION} | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Adds a new user that will match most users environments (id 1000)
# Make sure project directory exists and it's owned by the recently
# created user, also, adds that user to the sudoers file
RUN adduser --disabled-password --gecos "" node-user && \
    mkdir -p /var/www/app && \
    chown -R node-user:node-user /var/www && \
    echo "node-user  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers

# tini to trap signals and allow cancelling execution of cli commands
ADD https://github.com/krallin/tini/releases/download/v0.10.0/tini /tini
RUN chmod +x /tini

# Define the running user
USER node-user

# Define some NPM jailed environment variables
ENV NPM_PACKAGES="/home/node-user/.npm-packages" \
    NODE_PATH="/home/node-user/.npm-packages/lib/node_modules" \
    MANPATH="/home/node-user/.npm-packages/share/man:/usr/share/man" \
    PREFIX='/home/node-user/.local' \
    PATH="/home/node-user/.local/bin:/home/node-user/.npm-packages/bin:/home/node-user/.yarn/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# NPM config for setting the prefix as well
RUN mkdir -p $NPM_PACKAGES && \
    npm config set prefix $NPM_PACKAGES

# Installing Yarn
RUN echo 'Installing Yarn' && \
    curl -o- -L https://yarnpkg.com/install.sh | bash

# Application directory
WORKDIR "/var/www/app"

# Entrypoint
ENTRYPOINT ["/tini", "--"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]