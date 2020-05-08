<!-- Docker image <TITLE> -->
# Docker image idf

<!-- SHORT DESCRIPTION -->
This is the idf image used to build the esp32 firmware.

---
## Features
<!-- LIST OF FEATURES -->
- installs [idf](https://github.com/espressif/esp-idf) & dependencies

---
## Makefile
<!-- LIST OF MAKEFILE TARGETS -->
- `make help`
  - show Makefile options
- `make all`
  - build image & run container
- `make build`
  - build image
- `make run`
  - run container
- `make clean`
  - delete volumes
- `make distclean`
  - delete image

----
## Image arguments
<!-- LIST OF BUILD ARGUMENTS -->
- `IDF_VERSION`
  - idf version to use

---
See the [Dockerfile](./Dockerfile) or [Makefile](./Makefile) for more information