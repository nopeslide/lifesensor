### DOCKER IMAGE OPTIONS ###
NAME    := template
FROM    := base

### DOCKER IMAGE ARGUMENTS ###
ARGS     += FOO
HELP_FOO := modifies something
FOO      := default_value

ARGS     += BAR
HELP_BAR := modifies something else
BAR      := default_value

### DOCKER BUILD OPTIONS ###
TAG     := latest
BUILD   := #empty

### DOCKER RUN OPTIONS ###
RUN     := #empty
VOLUMES := #empty
WORKDIR := $(shell pwd)
ENVS    := #empty
EXEC    := #empty
MOUNT   := $(shell pwd)

include ../.docker.mk