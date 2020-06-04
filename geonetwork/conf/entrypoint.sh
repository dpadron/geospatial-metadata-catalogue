#!/bin/bash
set -e

if [ "$1" = 'catalina.sh' ]; then

	mkdir -p "$DATA_DIR"

	#Set geonetwork data dir
	export CATALINA_OPTS="$CATALINA_OPTS -Dgeonetwork.dir=$DATA_DIR"
fi

#
# Setup Elasticsearch & Kibana from docker-compose file environment
if [ "$ES_URL" != "" ]
	
	sed -i "s#es.url=#es.url=${ES_HOST}#" ${INSTALL_DIR}/WEB-INF/config.properties
	# User and password, if set in elasticsearch & compose file
	[ "$ES_USERNAME" != "" ] && sed -i "s#es.username=#es.username=${ES_USERNAME}#" ${INSTALL_DIR}/WEB-INF/config.properties
	[ "$ES_PASSWORD" != "" ] && sed -i "s#es.password=#es.password=${ES_PASSWORD}#" ${INSTALL_DIR}/WEB-INF/config.properties
fi

# Kibana
[ "$KB_URL" != "" ] && sed -i "s#kb.url=#kb.url=${KB_URL}#" ${INSTALL_DIR}/WEB-INF/config.properties

exec "$@"