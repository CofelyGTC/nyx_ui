#/bin/bash
sed -i "s/version:.*\",/version: \"v$1\",/" ./src/store/store.js
docker build -t engiecofely/nyx_ui:v$1 .
docker push engiecofely/nyx_ui:v$1
echo -en "\007"