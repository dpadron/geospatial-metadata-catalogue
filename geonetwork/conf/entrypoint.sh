#!/bin/bash
set -e

if [ "$1" = 'catalina.sh' ]; then

	mkdir -p "$DATA_DIR"

	#Set geonetwork data dir
	export CATALINA_OPTS="$CATALINA_OPTS -Dgeonetwork.dir=$DATA_DIR"
fi

#
# Setup Elasticsearch & Kibana from docker-compose file environment
[ "$ES_URL" != "" ] && sed -i "s#es.host=localhost#es.host=${ES_HOST}#" $CATALINA_HOME/webapps/ROOT/WEB-INF/data/config.properties
[ "$ES_USERNAME" != "" ] && sed -i "s#es.username=#es.username=${ES_USERNAME}#" $CATALINA_HOME/webapps/ROOT/WEB-INF/data/config.properties
[ "$ES_PASSWORD" != "" ] && sed -i "s#es.password=#es.password=${ES_PASSWORD}#" $CATALINA_HOME/webapps/ROOT/WEB-INF/data/config.properties
# Kibana
[ "$KB_URL" != "" ] && sed -i "s#kb.url=#kb.url=${KB_URL}#" $CATALINA_HOME/webapps/ROOT/WEB-INF/data/config.properties

exec "$@"