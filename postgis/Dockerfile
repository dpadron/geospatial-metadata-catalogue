FROM mdillon/postgis:11-alpine

#TODO : 
# - Fix database creation by automating command : su postgres -c postgis.sh
#  - Automate postgis & useful extensions deployment

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends \
#       postgresql-11-pgrouting \
#       osm2pgrouting

COPY ./initdb-entrypoint.sh /docker-entrypoint-initdb.d/postgis.sh