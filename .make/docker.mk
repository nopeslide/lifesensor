HELP := LifeSensor docker image & container

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

VARIABLES         += DOCKER_IMAGE
HELP_DOCKER_IMAGE := docker image options

VARIABLES_DOCKER_IMAGE += IMAGE
HELP_IMAGE             := name of the docker image
IMAGE                  := lifesensor/$(NAME)/$(VERSION)

VARIABLES_DOCKER_IMAGE += TAG
HELP_TAG               := tag of the docker image
TAG                    ?= latest


VARIABLES         += DOCKER_BUILD
HELP_DOCKER_BUILD := docker build options

VARIABLES_DOCKER_BUILD += $(ARGS)

VARIABLES_DOCKER_BUILD += BUILD
HELP_BUILD             := additional docker build options
BUILD                  ?= #empty

VARIABLES       += DOCKER_RUN
HELP_DOCKER_RUN := docker run options

VARIABLES_DOCKER_RUN += RUN
HELP_RUN             := additional docker run options
RUN                  ?= #empty

VARIABLES_DOCKER_RUN += VOLUMES
HELP_VOLUMES         := volumes to mount inside container
VOLUMES              ?= #empty

VARIABLES_DOCKER_RUN += WORKDIR
HELP_WORKDIR         := where to start in docker volume
WORKDIR              ?= #empty

VARIABLES_DOCKER_RUN += ENVS
HELP_ENVS            := additional environment variables to set
ENVS                 ?= #empty

VARIABLES_DOCKER_RUN += EXEC
HELP_EXEC            := additional environment variables to set
EXEC                 ?= /bin/bash


VARIABLES_DOCKER_RUN += MOUNT
HELP_MOUNT           := what directory to mount into the container
MOUNT                ?= #empty

.phony: build-image
TARGETS_build    += build-image
HELP_build-image := build docker image '$(IMAGE):$(TAG)'
build-image:
	docker build \
		$(foreach ARG,$(ARGS),--build-arg=$(ARG)=$($(ARG)) ) \
		$(BUILD) \
		-t "$(IMAGE):$(COMMIT)" \
		.
	docker image tag "$(IMAGE):$(COMMIT)" "$(IMAGE):$(TAG)"

.phony: run
TARGETS  += run
HELP_run := run docker image '$(IMAGE):$(TAG)'
run: build
	docker run --rm -ti --hostname $(NAME) \
		$(foreach VOLUME, $(VOLUMES),-v "$(VOLUME)" ) \
		$(foreach ENV, $(ENVS),-e "$(ENV)" ) \
		$(if $(WORKDIR),-w "$(WORKDIR)") \
		$(if $(MOUNT),-v $(abspath $(MOUNT)):$(abspath $(MOUNT)):rw) \
		$(RUN) \
		"$(IMAGE):$(TAG)" \
		$(EXEC)

.phony: clean-volume
TARGETS_clean     += clean-volume
HELP_clean-volume := delete docker volumes
clean-volume:
	$(foreach \
		VOLUME, \
		$(shell echo "$(VOLUMES)"| tr ' ' '\n' | grep -o '^[^/][^:]*'), \
		docker volume rm -f $(VOLUMES); \
	)

.phony: distclean-image
TARGETS_distclean    += distclean-image
HELP_distclean-image := delete docker image
distclean-image:
	docker image rm -f $(IMAGE):$(COMMIT)
	docker image rm -f $(IMAGE):$(TAG)

include $(shell git rev-parse --show-toplevel)/.make/common.mk