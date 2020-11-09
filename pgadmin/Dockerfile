FROM dpage/pgadmin4:latest
LABEL maintainer="Elasticlabs <contact@elasticlabs.co>"

#ENV \
    # PGAdmin basics
#    PGADMIN_DEFAULT_EMAIL=contact@elasticlabs.co \
    # {PGADMIN_DEFAULT_EMAIL} without special characters
    #PGADMIN_DEFAULT_USER=contact_elasticlabs.co \
#    PGADMIN_DEFAULT_PASSWORD=SuperSecret \
    # PostGIS database
#    POSTGRES_DB=geoserver

# >> Passfile creation
RUN mkdir -m 700 /var/lib/pgadmin/storage/${PGADMIN_DEFAULT_USERSPACE} \
  # Replace with appropriate values
  && echo "pgadmin:5432:geoserver:geoserver:geoserver" > /tmp/pgpassfile \
  && chown pgadmin:pgadmin /tmp/pgpassfile \
  && mv /tmp/pgpassfile /var/lib/pgadmin/storage/${PGADMIN_DEFAULT_USERSPACE}/ \
  && chmod 600 /var/lib/pgadmin/storage/${PGADMIN_DEFAULT_USERSPACE}/pgpassfile

# >> Configuration file creation
# Create 'servers.json' configuration file
USER root
RUN echo -e $'{ \n\
    "Servers": { \n\
        "1": { \n\
            "Name": "Elasticlabs SDI", \n\
            "Group": "Servers", \n\
            "Host": "postgis", \n\
            "Port": 5432, \n\
            "MaintenanceDB": "geoserver", \n\
            "Username": "geoserver", \n\
            "SSLMode": "prefer", \n\
            "PassFile": "/pgpassfile" \n\
        } \n\
    } \n\
}' > /pgadmin4/servers.json
