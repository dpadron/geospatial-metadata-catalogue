Dockerized PGAdmin4, built on top of [PGAdmin official image](https://hub.docker.com/r/dpage/pgadmin4/)

## Features & tweaks
* Automates configuration of default user login information + password file
* Anticipates automated user creation and generates the `pgpassfile` password file
* Automates SDI server configuration file

## Configuration 
You can customize this deployemnt using the following `Dockerfile` variables :
| Variables | Details |
|---|---|
| `PGADMIN_DEFAULT_EMAIL` | Customize user login email address |
| `PGADMIN_DEFAULT_USER` | =`PGADMIN_DEFAULT_EMAIL` without special characters. User directory used for the `pgpassfile` pasword file generation.  |
| `PGADMIN_DEFAULT_PASSWORD` | Set to `SuperSecret` by default; Modify it before deployment |
| `POSTGRES_DB` | Set to `geoserver` by default; Think twice before modifying this value, since it's linked to PostGIS configuration |