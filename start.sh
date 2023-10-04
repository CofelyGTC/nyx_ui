#/bin/bash
export CLIENT=cofely

cp /etc/store/store.js /etc/build/store.js

while true;
        do
        echo 'Starting NYX UI'
        cd /etc/opt/
        node ./app.js
        sleep 5
        done
