.DEFAULT_GOAL := help
HELP          ?= LifeSensor Makefile

VARIABLES     += MAKEFILE
HELP_MAKEFILE := Makefile options

VARIABLES_MAKEFILE += DEPENDS
HELP_DEPENDS       ?= dependencies that should be run prior to this Makefile

VARIABLES_MAKEFILE += DOCKER
HELP_DOCKER        := run inside docker
DOCKER             ?= 0
export DOCKER
VARIABLES_MAKEFILE += DOCKER_IMAGE
HELP_DOCKER_IMAGE  := docker image to use for targets

TARGETS_common += all
TARGETS_common += build
TARGETS_common += test
TARGETS_common += check
TARGETS_common += setup
TARGETS_common += clean
TARGETS_common += distclean

define TEMPLATE_DEPEND_TARGET
.phony: $3
TARGETS_$2 := $3 $(TARGETS_$2)
HELP_$3 := run 'make -C $1 $4'
$3:
	$(MAKE) -C $1 $4
endef

$(foreach \
	SUBDIR, \
	$(DEPENDS), \
	$(foreach \
		TARGET, \
		$(TARGETS_common), \
		$(eval $(call TEMPLATE_DEPEND_TARGET,$(SUBDIR),$(TARGET),$(TARGET)-$(SUBDIR),$(TARGET))) \
	) \
)

define TEMPLATE_COMMON_TARGET
.PHONY: $1
$1: $(TARGETS_$1)
HELP_$1  ?= run all $1 jobs
endef

TARGETS_distclean := clean $(TARGETS_distclean)
HELP_all := run common jobs
$(foreach \
	TARGET, \
	$(TARGETS_common), \
	$(eval $(call TEMPLATE_COMMON_TARGET,$(TARGET))) \
)

.PHONY: docker
ifdef DOCKER_IMAGE
TARGETS     += docker
HELP_docker := enter docker container
docker:
	$(MAKE) -C $(shell git rev-parse --show-toplevel)/docker/$(DOCKER_IMAGE) run \
	WORKDIR=$(shell pwd) \
	MOUNT=$(shell git rev-parse --show-toplevel)
else
docker: ;
endif

ifeq ($(DOCKER),1)
ifdef DOCKER_IMAGE
unexport DOCKER
$(MAKECMDGOALS):
	$(MAKE) -C $(shell git rev-parse --show-toplevel)/docker/$(DOCKER_IMAGE) run \
	WORKDIR=$(shell pwd) \
	MOUNT=$(shell git rev-parse --show-toplevel) \
	EXEC="make -C $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))) $@ DEPENDS="
endif
endif

TARGETS := $(TARGETS_common) $(TARGETS)
include $(shell git rev-parse --show-toplevel)/.make/help.mk