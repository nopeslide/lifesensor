# Docker

This directory contains Dockerfiles for the containers used in this project.

## Images
- [base](./base/README.md)
  - base image for all other images
- [idf](./idf/README.md)
  - idf framework for the esp32 firmware

## Building all images
1. run `make build`

## Building a single image
1. change into the directory of the image
2. run `make build`
   - you may specify additional options, see `make help` for more information

or
1. run `make build-<IMAGE>`, where `<IMAGE>` is the image you want to build

## Run a container
1. change into the directory of the image
2. run `make run`
   - you may specify additional options, see `make help` for more information
   - you may specify `EXEC` to run a single command
     - i.e. `make run EXEC='echo hello world'`

## Adding new images
- If you want to add a new image,
please copy and modify the [Template](./.template/README.md)

