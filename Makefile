.ONESHELL:

include .env.local
include .env

# --------------------------------------------------
# node
# --------------------------------------------------
dev:
	$(DOCKER_COMPOSE) exec $(SERVICE) yarn dev
deploy:
	$(DOCKER_COMPOSE) exec $(SERVICE) yarn build

.PHONY: dev deploy

src/%.ts:
	$(MAKE) ts-node/$@
ts-node/%:
	$(DOCKER_COMPOSE) exec $(SERVICE) sh -c 'dotenv -e .env.local -- ts-node -r tsconfig-paths/register --files $*'

.PHONY: src/%.ts ts-node/%

# --------------------------------------------------
# lima
# --------------------------------------------------
lima:
	find deployments -name docker-compose.yml | xargs sed -i -e 's/#\s*\(.*\/lima\/.*\)$$/\1/g'
	touch yarn-error.log yarn.lock
	mkdir -p node_modules
	chmod -R a+w yarn-error.log yarn.lock node_modules
	if [ ! -L dist ] && uname -n | grep lima; then
		mkdir -p dist/js
		chmod -R a+w dist dist/js
		mv dist /tmp/lima/dist
		ln -fns /tmp/lima/dist dist
	fi

.PHONY: lima

# --------------------------------------------------
# docker
# --------------------------------------------------
build: build/$(SERVICE)
build/%: # build or rebuild a image
	$(DOCKER_COMPOSE) build $*

run: run/$(SERVICE)
run/%: # run a one-off command on a container
	$(DOCKER_COMPOSE) run --rm $* sh -c 'bash || sh'

exec: exec/$(SERVICE)
exec/%: # run a command in a running container
	$(DOCKER_COMPOSE) exec $* sh -c 'bash || sh'

up: # create and start containers, networks, and volumes
	$(DOCKER_COMPOSE) up -d
up/%: # create and start a container
	$(DOCKER_COMPOSE) up -d $*

down: # stop and remove containers, networks, images, and volumes
	$(DOCKER_COMPOSE) down
down/%: # stop and remove a container
	$(DOCKER_COMPOSE) rm -fsv $*

logs: # view output from containers
	$(DOCKER_COMPOSE) logs -f

log: log/$(SERVICE)
log/%: # view output from a container
	$(DOCKER_COMPOSE) logs -f $*

.PHONY: build build/% run run/% up up/% exec exec/% down down/% logs log log/%

help: # list available targets and some
	@len=$$(awk -F':' 'BEGIN {m = 0;} /^[^\s]+:/ {gsub(/%/, "<service>", $$1); l = length($$1); if(l > m) m = l;} END {print m;}' $(MAKEFILE_LIST)) && \
	printf \
		"%s%s\n\n%s\n%s\n\n%s\n%s\n" \
		"usage:" \
		"$$(printf " make <\033[1mtarget\033[0m>")" \
		"services:" \
		"$$($(DOCKER_COMPOSE) config --services | awk '{ $$1 == "$(SERVICE)" ? x = "* " : x = ""; } { printf("  \033[1m%s%s\033[0m\n", x, $$1); }')" \
		"targets:" \
		"$$(awk -F':' '/^\S+:/ {gsub(/%/, "<service>", $$1); gsub(/^[^#]+/, "", $$2); gsub(/^[# ]+/, "", $$2); if ($$2) printf "  \033[1m%-'$$len's\033[0m  %s\n", $$1, $$2;}' $(MAKEFILE_LIST))"

clean: # remove cache files from the working directory

.PHONY: help clean

