ARG VERSION=19

FROM node:${VERSION}
LABEL maintainer="kaduhiro <github@kaduhiro.com>"

RUN apt-get update \
    && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y tini

RUN apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER node

ENTRYPOINT ["/usr/bin/tini", "--"]
