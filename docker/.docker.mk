ifndef NAME
$(error No image name specified! (NAME))
endif

VARIABLE_TOPICS += DOCKER
VARIABLE_TOPIC_DOCKER := DOCKER IMAGE OPTIONS

DOCKER       += IMAGE
HELP_IMAGE   := docker name of image
ifndef IMAGE
IMAGE        := lifesensor/$(NAME)
endif

DOCKER       += FROM
HELP_FROM    := dependency of this image

DOCKER       += VERSION
HELP_VERSION := version of image
ifndef VERSION
VERSION      := $(shell git rev-list --all --abbrev-commit -1 -- $(realpath $(firstword $(MAKEFILE_LIST))))
endif
ifndef VERSION
VERSION      := latest
endif

VARIABLE_TOPICS += ARGS
VARIABLE_TOPIC_ARGS := DOCKER IMAGE ARGUMENTS

VARIABLE_TOPICS += DOCKER_BUILD
VARIABLE_TOPIC_DOCKER_BUILD := DOCKER BUILD OPTIONS

DOCKER_BUILD += TAG
HELP_TAG     := additional version tag to set when building image

DOCKER_BUILD += BUILD
HELP_BUILD   := additional docker build options

VARIABLE_TOPICS += DOCKER_RUN
VARIABLE_TOPIC_DOCKER_RUN := DOCKER RUN OPTIONS

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

.phony: from
TARGET    += from
ALL       += from
DEFAULT   += from
HELP_from := build image dependency
from:
ifdef FROM
	make -C ../$(FROM) build
endif

.phony: build
TARGET     += build
ALL        += build
DEFAULT    += build
HELP_build := build docker image '$(IMAGE):$(VERSION)'
build: from
	docker build \
		$(foreach ARG,$(ARGS),--build-arg=$(ARG)=$($(ARG)) ) \
		$(BUILD) \
		-t "$(IMAGE):$(VERSION)" \
		.
ifdef TAG
	docker image tag "$(IMAGE):$(VERSION)" "$(IMAGE):$(TAG)"
endif

.phony: run
TARGET   += run
ALL      += run
DEFAULT  += run
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
CLEAN             += clean-volume
HELP_clean-volume := delete docker volumes
clean-volume:
	$(foreach \
		VOLUME, \
		$(shell echo "$(VOLUMES)"| tr ' ' '\n' | grep -o '^[^/][^:]*'), \
		docker volume rm -f $(VOLUME); \
	)

.phony: distclean-image
DISTCLEAN            += distclean-image
HELP_distclean-image := delete docker image
distclean-image:
	docker image rm -f $(IMAGE):$(VERSION)
	docker image rm -f $(IMAGE):$(TAG)

include $(shell git rev-parse --show-toplevel)/.common.mk