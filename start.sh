#/bin/bash
export CLIENT=cofely

while true;
        do
        echo 'Starting NYX UI'
        cd /etc/opt/
        node ./app.js
        sleep 5
        done
