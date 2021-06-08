#!/bin/bash

if [ "${CGRATES_CONFIG}" = "SESSION" ]; then

	#copy the session config
	cp /opt/cgrates-cfg-files/cgrates-session.json /etc/cgrates/cgrates.json

        #Update kamailio evapi values in cgrates.json
	sed -i 's/CGRATES_KAMAILIO_ENABLED/'"$CGRATES_KAMAILIO_ENABLED"'/g' /etc/cgrates/cgrates.json
	sed -i 's/CGRATES_KAMAILIO_EVAPI_HOST/'"$CGRATES_KAMAILIO_EVAPI_HOST"'/g' /etc/cgrates/cgrates.json
	sed -i 's/CGRATES_KAMAILIO_EVAPI_PORT/'"$CGRATES_KAMAILIO_EVAPI_PORT"'/g' /etc/cgrates/cgrates.json

  #Update RALS values for remote raters in cgrates.json
	sed -i 's/CGRATES_DISPATCHER_ENABLED/'"$CGRATES_DISPATCHER_ENABLED"'/g' /etc/cgrates/cgrates.json
	sed -i 's/CGRATES_SESSION_ENABLED/'"$CGRATES_SESSION_ENABLED"'/g' /etc/cgrates/cgrates.json

elif [ "${CGRATES_CONFIG}" = "DISPATCHER" ]; then

	#copy the session config
	cp /opt/cgrates-cfg-files/cgrates-disptacher.json /etc/cgrates/cgrates.json

  #Update RALS values for remote raters in cgrates.json
	sed -i 's/CGRATES_DISPATCHER_ENABLED/'"$CGRATES_DISPATCHER_ENABLED"'/g' /etc/cgrates/cgrates.json
	sed -i 's/CGRATES_SESSION_ENABLED/'"$CGRATES_SESSION_ENABLED"'/g' /etc/cgrates/cgrates.json

elif [ "${CGRATES_CONFIG}" = "RAL" ]; then

	#copy the ral config
  cp /opt/cgrates-cfg-files/cgrates-ral.json /etc/cgrates/cgrates.json

elif [ "${CGRATES_CONFIG}" = "API" ]; then

	#copy the ral config
  cp /opt/cgrates-cfg-files/cgrates-api.json /etc/cgrates/cgrates.json

fi

#Update core networking for connectivity in cgrates.json
sed -i 's/CGRATES_NAME/'"$CGRATES_NAME"'/g' /etc/cgrates/cgrates.json
sed -i 's/CGRATES_CONN_STRATEGY/'"$CGRATES_CONN_STRATEGY"'/g' /etc/cgrates/cgrates.json

#Update db values in cgrates.json
sed -i 's/MONGO_HOST/'"$MONGO_HOST"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_PORT/'"$MONGO_PORT"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_DATADB/'"$MONGO_DATADB"'/g' /etc/cgrates/cgrates.json
sed -i 's/MONGO_STORDB/'"$MONGO_STORDB"'/g' /etc/cgrates/cgrates.json

#Update logger values in cgrates.json
sed -i 's/CGRATES_LOG_LEVEL/'"$CGRATES_LOG_LEVEL"'/g' /etc/cgrates/cgrates.json
sed -i 's/CGRATES_LOGGER/'"$CGRATES_LOGGER"'/g' /etc/cgrates/cgrates.json

if [ -z "$CGRATES_CONNS" ];  then
				sed -i 's/CGRATES_CONNS/{"address": "127.0.0.1:2012", "transport": "*json"},/g' /etc/cgrates/cgrates.json

else
	sed -i 's/CGRATES_CONNS/'"$CGRATES_CONNS"'/g' /etc/cgrates/cgrates.json
fi



#cat the cgrates.json file to screen (for debug)
cat /etc/cgrates/cgrates.json

#Set versions (if first time launch)
/usr/bin/cgr-migrator -exec=*set_versions -config_path=/etc/cgrates

#Start cgr-engine
/usr/bin/cgr-engine -config_path=/etc/cgrates
