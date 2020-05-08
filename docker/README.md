# Docker

This directory contains Dockerfiles for the containers used in this project.

---
## List of images
- [base](./base/)
  - base image for all other images
- [idf](./idf/)
  - idf framework for the esp32 firmware
- [qemu](./qemu/)
  - qemu for the xtensa architecture to simulate esp32

---
## Makefile
<!-- LIST OF MAKEFILE TARGETS -->
- `make help`
  - show Makefile options
- `make build`
  - build all images
- `make clean`
  - delete all volumes
- `make distclean`
  - delete all images

---
## Building a single image
1. change into the directory of the image
2. run `make build`
   - you may specify additional options, see `make help` for more information

or
1. run `make build-<IMAGE>`, where `<IMAGE>` is the image you want to build

---
## Run a container
1. change into the directory of the image
2. run `make run`
   - you may specify additional options, see `make help` for more information
   - you may specify `EXEC` to run a single command
     - i.e. `make run EXEC='echo hello world'`

---
## Adding new images
- If you want to add a new image,
please copy and modify the [Template](./.template/)

---
## Structure

```
.
├── <image name>   : mandatory unique name of the image
│   ├── README.md  : mandatory general description of the image
│   ├── Dockerfile : mandatory Dockerfile to build the image
│   ├── Makefile   : mandatory Makefile to work with the image
│   └── ...
│
├── <image name>
│   └── ...
└── ...
```

---
## Rules
- *Docker images* of the LifeSensor project should have a dedicated directory here.
- *Docker images* can be based on each other (see [base](./base/) image).
- *Docker images* may compete for the same functionality.
  - Different [*parts*](../parts/) may use different *docker images*
- *Docker images* should follow the directory scheme defined by the [*template image*](./.template/)
  - *Docker images* may contain any additional files & directories
