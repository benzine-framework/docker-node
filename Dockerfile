FROM marshall:build AS nodejs

LABEL maintainer="Matthew Baggett <matthew@baggett.me>" \
      org.label-schema.vcs-url="https://github.com/benzine-framework/docker-node" \
      org.opencontainers.image.source="https://github.com/benzine-framework/docker-node"

ARG NODE_VERSION
ARG YARN_VERSION
ARG PATH="/app/node_modules/.bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN nvm list
RUN nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION} \
RUN apt-get -qq update && \
    apt-get -yqq install --no-install-recommends \
        npm \
        && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/dpkg/status.old /var/cache/debconf/templates.dat /var/log/dpkg.log /var/log/lastlog /var/log/apt/*.log
RUN npm install -g yarn@${YARN_VERSION}

# Healthcheck is nonsensical for this container.
HEALTHCHECK NONE

# Back to userland
USER node

FROM nodejs AS nodejs-compiler

# Install dependencies
USER root
RUN apt-get -qq update && \
    apt-get -yqq install --no-install-recommends \
        python \
        build-essential \
        && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/dpkg/status.old /var/cache/debconf/templates.dat /var/log/dpkg.log /var/log/lastlog /var/log/apt/*.log

# Healthcheck is nonsensical for this container.
HEALTHCHECK NONE

# Back to userland
USER node
