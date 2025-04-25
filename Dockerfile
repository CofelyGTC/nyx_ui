FROM node:16.19.0-slim AS base
ARG VERSION

FROM base AS builder
ENV VERSION=${VERSION}
WORKDIR /etc/opt
RUN apt-get update && apt-get upgrade -y
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
