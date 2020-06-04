#!/bin/bash
set -e

function create_postgis_user_and_database() {
	local db=$1
	echo "  Creating user and database '$db'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $db;
		ALTER USER $db with encrypted password '$POSTGIS_DATABASE_PASSWORD';
	    CREATE DATABASE $db;
	    GRANT ALL PRIVILEGES ON DATABASE $db TO $db;
EOSQL
}

function create_postgis_user_and_geodatabase() {
	local geodb=$1
	echo "  Creating user and database '$geodb'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $geodb;
		ALTER USER $geodb with encrypted password '$POSTGIS_GEODATABASE_PASSWORD';
	    CREATE DATABASE $geodb;
	    GRANT ALL PRIVILEGES ON DATABASE $geodb TO $geodb;
EOSQL
}

function update_geodatabase_with_postgis() {
	local postgis_data=$1
	echo "  Updating geodatabase '$postgis_data' with extension"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$postgis_data" <<-EOSQL
		CREATE EXTENSION postgis;
EOSQL
}

if [ -n "$POSTGIS_DATABASE" ]; then
	echo "PostGIS database creation requested: $POSTGIS_DATABASE"
	create_postgis_user_and_database $POSTGIS_DATABASE
	echo "PostGIS database created"
fi

if [ -n "$POSTGIS_GEODATABASE" ]; then
	echo "PostGIS geodatabase creation requested: $POSTGIS_GEODATABASE"
	create_postgis_user_and_geodatabase $POSTGIS_GEODATABASE
	update_geodatabase_with_postgis $POSTGIS_GEODATABASE
	echo "PostGIS geodatabase created"
fi