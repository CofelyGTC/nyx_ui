#/bin/bash
# sed -i "s/version: \"v[0-9.]*\",/version: \"$VERSION\",/" /src/store/store.js
docker build -t engiecofely/nyx_ui:v$1 .
docker push engiecofely/nyx_ui:v$1
echo -en "\007"