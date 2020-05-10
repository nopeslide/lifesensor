HELP := Build docker image & run docker container

COMMIT := $(shell git rev-list --all --abbrev-commit -1 -- $(realpath $(firstword $(MAKEFILE_LIST))))
ifndef COMMIT
COMMIT := unknown
$(warning COMMIT OF $(realpath $(firstword $(MAKEFILE_LIST))) UNDEFINED!)
endif

VERSION := $(shell basename $$(dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
ifndef VERSION
VERSION := unknown
$(warning VERSION OF $(realpath $(firstword $(MAKEFILE_LIST))) UNDEFINED!)
endif

NAME := $(shell basename $$(dirname $$(dirname $(realpath $(firstword $(MAKEFILE_LIST))))))
ifndef NAME
NAME := unknown
$(error NAME OF $(realpath $(firstword $(MAKEFILE_LIST))) UNDEFINED!)
endif

VARIABLE_TOPIC        += DOCKER
VARIABLE_TOPIC_DOCKER := docker image options

DOCKER += IMAGE
IMAGE  := lifesensor/$(NAME)

DOCKER    += FROM
HELP_FROM := dependency of this image

VARIABLE_TOPIC      += ARGS
VARIABLE_TOPIC_ARGS := docker image arguments

VARIABLE_TOPIC              += DOCKER_BUILD
VARIABLE_TOPIC_DOCKER_BUILD := docker build options

DOCKER_BUILD += BUILD
HELP_BUILD   := additional docker build options

VARIABLE_TOPIC            += DOCKER_RUN
VARIABLE_TOPIC_DOCKER_RUN := docker run options

DOCKER_RUN   += RUN
HELP_RUN     := additional docker run options

DOCKER_RUN   += VOLUMES
HELP_VOLUMES := volumes to mount inside container

DOCKER_RUN   += WORKDIR
HELP_WORKDIR := where to start in docker volume

DOCKER_RUN   += ENVS
HELP_ENVS    := additional environment variables to set

DOCKER_RUN   += EXEC
HELP_EXEC    := additional environment variables to set
ifndef EXEC
EXEC         := /bin/bash
endif

DOCKER_RUN   += MOUNT
HELP_MOUNT   := what directory to mount into the container

TARGET_default := all
TARGET_all     := build run

.phony: build-from
TARGET_build    += build-from
HELP_build-from := build image dependency
build-from:
ifdef FROM
	make -C ../../$(FROM) build
endif

.phony: build-image
TARGET_build     += build-image
HELP_build-image := build docker image '$(IMAGE):$(VERSION)'
build-image: build-from
	docker build \
		$(foreach ARG,$(ARGS),--build-arg=$(ARG)=$($(ARG)) ) \
		$(BUILD) \
		-t "$(IMAGE)/$(VERSION):$(COMMIT)" \
		.
	docker image tag "$(IMAGE)/$(VERSION):$(COMMIT)" "$(IMAGE)/$(VERSION):latest"

.phony: run
TARGET   += run
HELP_run := run docker image '$(IMAGE):$(VERSION)'
run: build
	docker run \
		--rm \
		-ti \
		$(foreach VOLUME, $(VOLUMES),-v "$(VOLUME)" ) \
		$(foreach ENV, $(ENVS),-e "$(ENV)" ) \
		$(if $(WORKDIR), -w "$(WORKDIR)") \
		--hostname $(NAME) \
		$(if $(MOUNT), -v $(abspath $(MOUNT)):$(abspath $(MOUNT)):rw) \
		$(RUN) \
		"$(IMAGE):$(VERSION)" \
		$(EXEC)

.phony: clean-volume
TARGET_clean      += clean-volume
HELP_clean-volume := delete docker volumes
clean-volume:
	$(foreach \
		VOLUME, \
		$(shell echo "$(VOLUMES)"| tr ' ' '\n' | grep -o '^[^/][^:]*'), \
		docker volume rm -f $(VOLUME); \
	)

.phony: distclean-image
TARGET_distclean     += distclean-image
HELP_distclean-image := delete docker image
distclean-image:
	docker image rm -f $(IMAGE):$(VERSION)
	docker image rm -f $(IMAGE):$(COMMIT)

include $(shell git rev-parse --show-toplevel)/.common.mk