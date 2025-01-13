#/bin/bash
VERSION="3.27.8"
sed -i '' -e "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js #For MACOS
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js  #For Windows
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"