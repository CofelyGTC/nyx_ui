#/bin/bash
docker build -t julianfickers/nyx_ui:v$1 .
docker push julianfickers/nyx_ui:v$1
echo -en "\007"