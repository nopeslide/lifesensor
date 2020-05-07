### DOCKER IMAGE OPTIONS ###
NAME    := qemu
FROM    := idf

### DOCKER IMAGE ARGUMENTS ###
ARGS              += QEMU_VERSION
HELP_QEMU_VERSION := qemu version to use
QEMU_VERSION      := esp-develop

### DOCKER BUILD OPTIONS ###
TAG     := latest
BUILD   := #empty

### DOCKER RUN OPTIONS ###
RUN     := #empty
VOLUMES := qemu-home:/home/developer:rw
WORKDIR := $(shell pwd)
ENVS    := #empty
EXEC    := #empty
MOUNT   := $(shell pwd)

include ../.docker.mk