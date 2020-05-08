HELP := Build docker image & run docker container

ifndef NAME
$(error No image name specified! (NAME))
endif

VARIABLE_TOPIC        += DOCKER
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

VARIABLE_TOPIC      += ARGS
VARIABLE_TOPIC_ARGS := DOCKER IMAGE ARGUMENTS

VARIABLE_TOPIC              += DOCKER_BUILD
VARIABLE_TOPIC_DOCKER_BUILD := DOCKER BUILD OPTIONS

DOCKER_BUILD += TAG
HELP_TAG     := additional version tag to set when building image

DOCKER_BUILD += BUILD
HELP_BUILD   := additional docker build options

VARIABLE_TOPIC            += DOCKER_RUN
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

TARGET_default := all
TARGET_all     := build run

.phony: build-from
TARGET_build    += build-from
HELP_build-from := build image dependency
build-from:
ifdef FROM
	make -C ../$(FROM) build
endif

.phony: build-image
TARGET_build     += build-image
HELP_build-image := build docker image '$(IMAGE):$(VERSION)'
build-image: build-from
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
	docker image rm -f $(IMAGE):$(TAG)

include $(shell git rev-parse --show-toplevel)/.common.mk