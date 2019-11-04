CURRENT_ABSOLUTE_PATH=$(shell pwd)
CURRENT_DIR_IN_LOWER_CASE=$(shell echo $(notdir $(shell pwd)) | tr A-Z a-z)
ARGS=$(filter-out $@, $(MAKECMDGOALS))
PROJECT_NAME=dockerized-php-project-template
COMPOSER_CONTAINER_NAME=${PROJECT_NAME}_composer-sidecar
NETWORK=${PROJECT_NAME}_network

.DEFAULT_GOAL=help
.PHONY: enter up-build composer kv-force kv up down all migrate intoken help env rm enter clean network

%:
	@:

network:
	docker network inspect ${NETWORK} >> /dev/null || \
		docker network create --driver bridge ${NETWORK}

clean:
	docker volume rm -f \
		$(CURRENT_DIR_IN_LOWER_CASE)_consul \
		$(CURRENT_DIR_IN_LOWER_CASE)_mysql

rm:
	docker rm -f $(shell docker-compose ps -q ${ARGS})

stop:
	docker-compose stop ${ARGS}

enter:
	docker-compose exec ${ARGS} sh

composer:
	docker image history ${COMPOSER_CONTAINER_NAME} >> /dev/null || \
		docker build ./docker/services/composer-sidecar -t ${COMPOSER_CONTAINER_NAME}

	docker run -it -v ${CURRENT_ABSOLUTE_PATH}/codebase:/app ${COMPOSER_CONTAINER_NAME} composer --working-dir=/app install

kv:
	docker run \
		-it \
		--network=${NETWORK} \
		-v ${CURRENT_ABSOLUTE_PATH}/consul-kv-seeder.sh:/home/consul-kv-seeder.sh \
		-v ${CURRENT_ABSOLUTE_PATH}/consul-kv.json:/home/consul-kv.json \
		consul \
		/bin/sh /home/consul-kv-seeder.sh --file=/home/consul-kv.json


kv-force:
	docker run \
		-it \
		--network=${NETWORK} \
		-v ${CURRENT_ABSOLUTE_PATH}/consul-kv-seeder.sh:/home/consul-kv-seeder.sh \
		-v ${CURRENT_ABSOLUTE_PATH}/consul-kv.json:/home/consul-kv.json \
		consul \
		/bin/sh /home/consul-kv-seeder.sh --force --file=/home/consul-kv.json

up:
	docker-compose up -d
	sleep 5
	echo "Done"

up-build:
	docker-compose up -d --build
	sleep 5
	echo "Done"

down:
	docker-compose down

help:
	echo "Hello world"
