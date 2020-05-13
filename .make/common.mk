.DEFAULT_GOAL := help
HELP          ?= LifeSensor Makefile

VARIABLES     += MAKEFILE
HELP_MAKEFILE := Makefile options

VARIABLES_MAKEFILE += DEPENDS
HELP_DEPENDS       ?= dependencies that should be run prior to this Makefile

VARIABLES_MAKEFILE += DOCKER
HELP_DOCKER        := docker image to use for 'docker'/'docker-*' targets

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
	make -C $1 $4
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

define TEMPLATE_DEPEND_DOCKER_TARGET
.phony: $2
$2:
	make -C $1 $3
$3:$2
endef

$(foreach \
	SUBDIR, \
	$(DEPENDS), \
	$(foreach \
		TARGET, \
		$(TARGETS_common), \
		$(eval $(call TEMPLATE_DEPEND_DOCKER_TARGET,$(SUBDIR),docker-$(SUBDIR)-$(TARGET),docker-$(TARGET))) \
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
ifdef DOCKER
TARGETS     += docker
HELP_docker := enter docker container
docker:
	$(MAKE) -C $(shell git rev-parse --show-toplevel)/docker/$(DOCKER) run \
	WORKDIR=$(shell pwd) \
	MOUNT=$(shell git rev-parse --show-toplevel)
else
docker: ;
endif

TARGETS       += docker-*
HELP_docker-* := execute '*' in docker container

ifdef DOCKER
docker-%:
	$(MAKE) -C $(shell git rev-parse --show-toplevel)/docker/$(DOCKER) run \
	WORKDIR=$(shell pwd) \
	MOUNT=$(shell git rev-parse --show-toplevel) \
	EXEC="make -C $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))) $(@:docker-%=%) DEPENDS="
else
docker-%: %;
endif

TARGETS := $(TARGETS_common) $(TARGETS)
include $(shell git rev-parse --show-toplevel)/.make/help.mk