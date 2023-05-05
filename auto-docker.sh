#/bin/bash
docker build -t engiecofely/nyx_ui:v$1 .
docker push engiecofely/nyx_ui:v$1
echo -en "\007"