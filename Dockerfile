FROM node:16.19.0-slim as base

FROM base as builder
COPY . /etc/build
WORKDIR /etc/build
RUN npm i express
RUN npm i
RUN npm run build

FROM builder
RUN mv ./dist /etc/opt/nyx_ui
COPY ./start.sh /etc/opt/start.sh
COPY ./app.js /etc/opt/app.js
RUN rm -d -r /etc/build
CMD /etc/opt/start.sh
