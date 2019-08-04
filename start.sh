#!/bin/bash

if [ "${CGRATES_CONFIG}" = "SESSION" ]; then

	#copy the session config
	cp /opt/cgrates-cfg-files/cgrates-session.json /etc/cgrates/cgrates.json

	#Get ordinal of statefulset pod and add a - in front. If no number then just leave blank
	ORDINAL=${CGRATES_NAME##*-}

	re='^[0-9]+$'
	if  ! [[ $ORDINAL =~ $re ]]; then
	        ORDINAL=""
	else
	        ORDINAL="-$ORDINAL"
	fi

        #Update kamailio evapi values in cgrates.json
	sed -i 's/CGRATES_KAMAILIO_ENABLED/'"$CGRATES_KAMAILIO_ENABLED"'/g' /etc/cgrates/cgrates.json
	sed -i 's/CGRATES_KAMAILIO_ADDRESS/'"$KAMAILIO_NAME""$ORDINAL""$KAMAILIO_SUFFIX"':'"$KAMAILIO_EVAPI_PORT"'/g' /etc/cgrates/cgrates.json

        #Update RALS values for remote raters in cgrates.json
        sed -i 's/CGRATES_SESSION_ENABLED/'"$CGRATES_SESSION_ENABLED"'/g' /etc/cgrates/cgrates.json
	if [ -z "$CGRATES_CONNS" ];  then
	        sed -i 's/CGRATES_CONNS/{"address": "127.0.0.1:2012", "transport": "*json"},/g' /etc/cgrates/cgrates.json

	else
		sed -i 's/CGRATES_CONNS/'"$CGRATES_CONNS"'/g' /etc/cgrates/cgrates.json
	fi

elif [ "${CGRATES_CONFIG}" = "RAL" ]; then

        #copy the session config
        cp /opt/cgrates-cfg-files/cgrates-ral.json /etc/cgrates/cgrates.json

fi

#Update db values in cgrates.json
sed -i 's/MONGO_HOST/'"$MONGO_HOST"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_DATADB/'"$MONGO_DATADB"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_STORDB/'"$MONGO_STORDB"'/g' /etc/cgrates/cgrates.json

#Update logger values in cgrates.json
sed -i 's/CGRATES_LOG_LEVEL/'"$CGRATES_LOG_LEVEL"'/g' /etc/cgrates/cgrates.json
sed -i 's/CGRATES_LOGGER/'"$CGRATES_LOGGER"'/g' /etc/cgrates/cgrates.json



#cat the cgrates.json file to screen (for debug)
#cat /etc/cgrates/cgrates.json

#Set versions (if first time launch) 
/usr/bin/cgr-migrator -exec=*set_versions -config_path=/etc/cgrates

#Start cgr-engine 
/usr/bin/cgr-engine -config_path=/etc/cgrates
