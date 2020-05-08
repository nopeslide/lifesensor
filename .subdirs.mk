HELP := Run Makefiles located in subdirectories.

VARIABLE += SUBDIRS
HELP_SUBDIRS := directories to run make in
SUBDIRS := $(shell dirname $(wildcard */Makefile) 2>/dev/null)

TARGET_default ?= all
TARGET_all     ?= build

define TARGET_TEMPLATE
.phony: $1-$2
TARGET_$1 += $1-$2
HELP_$1-$2 := run make -C $2 $1
$1-$2:
	make -C $2 $1
endef

$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,build,$(SUBDIR))))
$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,test,$(SUBDIR))))
$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,check,$(SUBDIR))))
$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,setup,$(SUBDIR))))
$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,clean,$(SUBDIR))))
$(foreach SUBDIR, $(SUBDIRS), $(eval $(call TARGET_TEMPLATE,distclean,$(SUBDIR))))

include $(shell git rev-parse --show-toplevel)/.common.mk