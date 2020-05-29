# geospatial-metadata-catalogue
Docker based composition of a geospatial metadata catalogue solution including OGC services harvesting capabilities

#### Preparation :
* Install very useful tools: `# yum install git nano make htop elinks wget tshark nano tree`
* Avoid `sudo`issues by adding your current username to the `wheel` group: `# usermod -aG wheel <usename>`
* Avoid docker-compose issues with sudo by adding `/usr/local/lib`to the PATH `secure_path variable`
* Install the [latest version of docker-compose](https://docs.docker.com/compose/install/)

