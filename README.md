# geospatial-metadata-catalogue
Docker based composition of a geospatial metadata catalogue solution including OGC services harvesting capabilities

#### Preparation :
* Install very useful tools: `# yum install git nano make htop elinks wget tshark nano tree`
* Avoid `sudo`issues by adding your current username to the `docker` group: `# sudo groupadd docker && sudo usermod -aG docker <usename> && sudo systemctl restart docker`
* Avoid docker-compose issues with sudo by adding `/usr/local/lib`to the PATH `secure_path variable`
* Install the [latest version of docker-compose](https://docs.docker.com/compose/install/)

#### Repository clone & application build
* Clone this repository and go to the `geospatial-metadata-portal` directory.
* Build the application using `sudo make build && sudo make proxy-up && sudo make wait && sudo make up`

#### Basic administration commands
* `make proxy-up`               # Initialize front proxy entrypoint
* `make up`                     # With working proxy, brings up the SDI
* `make build`                  # Build Geonetwork and Geoserver images
* `make logs`                   # Follows whole SDI logs (Geoserver, Geonetwork, PostGIS, Client app)
* `make down`                   # Brings the SDI down. 
* `make cleanup`                # Complete hard cleanup of images, containers, networks, volumes & data of the SDI
* `make reset`                  # Soft reboot of the whole SDI
* `make update`                 # Update the whole stack
* `make hard-reset`             # All configuration except data and databases is deleted, then rebuilt
* `make disaster-recovery`      # Saves volumes to ../YYYYMMdd_SDI_Voumes then erases all containers and persistent volumes involved in the SDI, ultimately recreating a fresh one