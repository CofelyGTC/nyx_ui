#/bin/bash
VERSION="4.1.32"
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"


### VERSION HISTORY ###

#   4.1.29  EBU Fix Multiple Deletion emplacement, add custom url icon
#   4.1.30  EBU Fix timerange for Grafana
#   4.1.31  EBU Fix custom url icon for all icon
#   4.1.32  EBU Fix unique color