#!/bin/bash

#Update db_host in cgrates.json
sed -i 's/MONGO_HOST/'"$MONGO_HOST"'/g' /etc/cgrates/cgrates.json

#cat the log file to screen
#cat /etc/cgrates/cgrates.json

#Start cgr-engine with log to stdout and debug level based on env variable
/usr/bin/cgr-engine -config_path=/etc/cgrates -logger=*stdout -log_level=$CGRATES_LOG_LEVEL
