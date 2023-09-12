#/bin/bash
VERSION="4.1.39"
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"


### VERSION HISTORY ###

#   4.1.29  EBU Fix Multiple Deletion emplacement, add custom url icon
#   4.1.30  EBU Fix timerange for Grafana
#   4.1.31  EBU Fix custom url icon for all icon
#   4.1.32  EBU Fix unique color
#   4.1.35  EBU Fix Grafana param url
#   4.1.36  EBU Fix Grafana default time
#   4.1.38  EBU Add Optiboard Editor: add default view 
#   4.1.39  EBU Add Optiboard Editor: add default view MULTIPLE