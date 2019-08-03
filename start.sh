#!/bin/bash

#Get ordinal of statefulset pod and add a - in front. If no number then just leave blank
ORDINAL=${CGRATES_NAME##*-}

re='^[0-9]+$'
if  ! [[ $ORDINAL =~ $re ]] ; then
        ORDINAL=""
else
        ORDINAL="-$ORDINAL"
fi

#Update db values in cgrates.json
sed -i 's/MONGO_HOST/'"$MONGO_HOST"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_DATADB/'"$MONGO_DATADB"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_STORDB/'"$MONGO_STORDB"'/g' /etc/cgrates/cgrates.json
sed -i 's/CGRATES_KAMAILIO_ENABLED/'"$CGRATES_KAMAILIO_ENABLED"'/g' /etc/cgrates/cgrates.json
sed -i 's/CGRATES_KAMAILIO_ADDRESS/'"$KAMAILIO_NAME""$ORDINAL""$KAMAILIO_SUFFIX"':'"$KAMAILIO_PORT"'/g' /etc/cgrates/cgrates.json

#cat the log file to screen
#cat /etc/cgrates/cgrates.json

#Set versions (if first time launch) 
/usr/bin/cgr-migrator -exec=*set_versions -config_path=/etc/cgrates

#Start cgr-engine with log to stdout and debug level based on env variable
/usr/bin/cgr-engine -config_path=/etc/cgrates -logger=*stdout -log_level=$CGRATES_LOG_LEVEL
