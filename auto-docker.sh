#/bin/bash
VERSION="4.1.28"
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"