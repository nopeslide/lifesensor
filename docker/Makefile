VARIABLE += IMAGES
HELP_IMAGES := docker images
IMAGES := $(shell dirname $(wildcard */Makefile))

.phony: build
TARGET     += build
ALL        += build
DEFAULT    += build
HELP_build := build all docker images
build: $(IMAGES:%=build-%)

define IMAGE_BUILD
.phony: build-$1
TARGET_build += build-$1
HELP_build-$1 := build docker image '$1'
build-$1:
	make -C $1 build
endef

define IMAGE_CLEAN
.phony: clean-$1
CLEAN += clean-$1
HELP_clean-$1 := clean docker image '$1'
clean-$1:
	make -C $1 clean
endef

define IMAGE_DISTCLEAN
.phony: distclean-$1
DISTCLEAN += distclean-$1
HELP_distclean-$1 := distclean docker image '$1'
distclean-$1:
	make -C $1 distclean
endef

$(foreach IMAGE, $(IMAGES), $(eval $(call IMAGE_BUILD,$(IMAGE))))
$(foreach IMAGE, $(IMAGES), $(eval $(call IMAGE_CLEAN,$(IMAGE))))
$(foreach IMAGE, $(IMAGES), $(eval $(call IMAGE_DISTCLEAN,$(IMAGE))))

include $(shell git rev-parse --show-toplevel)/.common.mk