HELP := LifeSensor project

TARGET_all += build
TARGET_all += test

include $(shell git rev-parse --show-toplevel)/.subdirs.mk