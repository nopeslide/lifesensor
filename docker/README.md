# Docker

This directory contains Dockerfiles for the containers used in this project.

---
## List of images
- [base](./base/README.md)
  - base image for all other images
- [idf](./idf/README.md)
  - idf framework for the esp32 firmware
- [qemu](./qemu/README.md)
  - qemu for the xtensa architecture to simulate esp32

---
## Makefile
<!-- LIST OF MANDATORY MAKEFILE TARGETS -->
- `make help`
  - show Makefile options
- `make all`
  - build all images
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
please copy and modify the [Template](./.template/README.md)

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

- *Docker images* of the LifeSensor project should have a dedicated directory here.
- *Docker images* can be based on each other (see [base](./base/README.md) image).
- *Docker images* may compete for the same functionality.
  - Different [*parts*](../parts/README.md) may use different *docker images*
- *Docker images* should follow the directory scheme defined by the [*template image*](./.template/README.md)
  - *Docker images* may contain any additional files & directories
