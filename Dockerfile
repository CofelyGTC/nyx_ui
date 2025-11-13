FROM node:16.19.0-slim AS base
ARG VERSION

FROM base AS builder
WORKDIR /etc/opt

# Correction des sources Debian obsolètes + update
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
    && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN npm i express
COPY . /etc/build
WORKDIR /etc/build

RUN npm i
RUN npm run build

FROM builder
ENV VERSION=${VERSION}
RUN mv ./dist /etc/opt/nyx_ui
COPY ./start.sh /etc/opt/start.sh
COPY ./app.js /etc/opt/app.js
RUN rm -d -r /etc/build
CMD ["/etc/opt/start.sh"]
