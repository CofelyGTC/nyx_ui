FROM node:16.19.0-slim as base

FROM base as builder
WORKDIR /etc/opt
RUN apt-get update && apt-get upgrade -y
RUN npm i express
COPY . /etc/build
WORKDIR /etc/build

RUN npm i
RUN npm run build

FROM builder
ARG VERSION
ENV VERSION=${VERSION}
RUN mv ./dist /etc/opt/nyx_ui
COPY ./src/store/store.js /etc/store/store.js
COPY ./start.sh /etc/opt/start.sh
COPY ./app.js /etc/opt/app.js
RUN rm -d -r /etc/build
CMD /etc/opt/start.sh
