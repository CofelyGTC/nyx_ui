#/bin/bash
VERSION="4.1.29"
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"


### VERSION HISTORY ###

# 4.1.29    EBU     Fix Multiple Deletion emplacement, add custom url icon, fix 50% time range for grafana