### DOCKER IMAGE DEPENDENCY ###
FROM    := base/v1

### DOCKER IMAGE ARGUMENTS ###
ARGS              += QEMU_VERSION
HELP_QEMU_VERSION := qemu version to use
QEMU_VERSION      := esp-develop

### DOCKER BUILD OPTIONS ###
TAG     := latest
BUILD   := #empty

### DOCKER RUN OPTIONS ###
RUN     := #empty
VOLUMES := qemu/esp-develop/home:/home/developer:rw
WORKDIR := $(shell pwd)
ENVS    := #empty
EXEC    := #empty
MOUNT   := $(shell pwd)

include $(shell git rev-parse --show-toplevel)/.docker.mk