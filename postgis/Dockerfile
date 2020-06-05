FROM mdillon/postgis:11-alpine

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql-10-pgrouting \
       osm2pgrouting

COPY ./initdb-entrypoint.sh /docker-entrypoint-initdb.d/postgis.sh
ENTRYPOINT [ "/bin/sh", "/docker-entrypoint-initdb.d/postgis.sh"]