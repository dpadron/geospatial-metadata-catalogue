# Set default no argument goal to help
.DEFAULT_GOAL := help

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Allow a custom docker-compose project name, if the following variable is set (no spaces)
DC_PROJECT?=metadata-catalogue
ifeq ($(strip $(DC_PROJECT)),)
  override DC_PROJECT:=$(notdir $(shell pwd))
  DOCKER_COMPOSE:= docker-compose
else
  DOCKER_COMPOSE:= docker-compose --project-name $(DC_PROJECT)
endif

# Every command is a PHONY, to avoid file naming confliction -> strengh comes from good habits!
.PHONY: help
help:
	@echo "=============================================================================="
	@echo " Geospatial Metadata Catalogue complete SDI  https://github.com/elasticlabs/geospatial-metadata-catalogue "
	@echo " "
	@echo "Hints for developers:"
	@echo "  make proxy-up               # Initialize front proxy entrypoint"
	@echo "  make up                     # With working proxy, brings up the SDI"
	@echo "  make build                  # Build Geonetwork and Geoserver images"
	@echo "  make logs                   # Follows whole SDI logs (Geoserver, Geonetwork, PostGIS, Client app)"
	@echo "  make down                   # Brings the SDI down. "
	@echo "  make cleanup                # Complete hard cleanup of images, containers, networks, volumes & data of the SDI"
	@echo "  make reset                  # Soft reboot of the whole SDI"
	@echo "  make update                 # Update the whole stack"
	@echo "  make hard-reset             # All configuration except data and databases is deleted, then rebuilt"
	@echo "  make disaster-recovery      # Saves volumes to ../YYYYMMdd_SDI_Voumes then erases all containers and persistent volumes involved in the SDI, ultimately recreating a fresh one"
	@echo "=============================================================================="

.PHONY: proxy-up
proxy-up:
	$(DOCKER_COMPOSE) up --f docker-compose.proxy.yml -d --build portainer --remove-orphans

.PHONY: up
up:
	$(DOCKER_COMPOSE) up --f docker-compose.yml -d geonetwork geoserver --remove-orphans

.PHONY: build
build:
	$(DOCKER_COMPOSE) --f docker-compose.yml build geonetwork
	$(DOCKER_COMPOSE) --f docker-compose.yml build geoserver

.PHONY: pull
pull: 
	$(DOCKER_COMPOSE) --f docker-compose.yml pull

.PHONY: logs
logs:
	$(DOCKER_COMPOSE) --f docker-compose.yml logs --follow

.PHONY: down
down:
	$(DOCKER_COMPOSE) --f docker-compose.yml down

.PHONY: cleanup
cleanup:
	$(DOCKER_COMPOSE) --f docker-compose.yml stop
	# 1st : kill all stopped containers
	docker kill $(docker ps -q)
	# 2nd : clean up all containers & images, without deleting static volumes (e.g. geoserver catalog)
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)
	docker system prune -a

.PHONY: cleanup-volumes
cleanup-volumes:
	# Delete all hosted persistent data available in volumes
	docker volume rm -f $(DC_PROJECT)_geonetwork-base
	docker volume rm -f $(DC_PROJECT)_geoserver-exts
	docker volume rm -f $(DC_PROJECT)_geoserver-data
	# Remove all dangling docker volumes
	docker volume rm $(shell docker volume ls -qf dangling=true)

.PHONY: update
update: pull up wait
	docker image prune

.PHONY: reset
reset: down up wait

.PHONY: hard-reset
hard-reset: cleanup build up wait

.PHONY: disaster-recovery
disaster-recovery: cleanup cleanup-volumes pull build up wait

.PHONY: wait
wait: 
	sleep 5