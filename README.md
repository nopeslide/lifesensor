# LifeSensor Project - health devices for all

<div style="text-align: center"><img src=./docs/lifesensor_logo.png></div>

The [*LifeSensor*](https://lifesensor.org) project is an open-source, modular, low-cost bio sensing platform.

- This project is a collection of [*parts*](./parts/) and [*products*](./products/).
- [*Parts*](./parts/) are components that provide a set of features.
- [*Products*](./products/) are [*LifeSensor*](https://lifesensor.org) devices consisting of [*parts*](./parts/).
- [*Parts*](./parts/) are subjects to requirements and constraints imposed by [*products*](./products/) and other [*parts*](./parts/).

---
## Directories

### [docker/](./docker/)
- Docker images used by this project
- Every used toolchain exists as docker image

### [docs/](./docs/)
- Documents regarding the whole project

### [parts/](./parts/)
- [*LifeSensor*](https://lifesensor.org) components used to build [*products*](./products/)

### [products/](./products/)
- [*LifeSensor*](https://lifesensor.org) devices consisting of [*parts*](./parts/)

---
## Makefile
<!-- LIST OF MAKEFILE TARGETS -->
- `make help`
  - show Makefile options
- `make all`
  - build & test all components
- `make build`
  - build all components
- `make test`
  - test all components
- `make clean`
  - clean all components
- `make distclean`
  - distclean all components

---
## Contributing
Please see
[CONTRIBUTING.md](./CONTRIBUTING.md)
for more information on how to contribute.

---
## License
Please see
[LICENSE.md](./LICENSE.md)
for more information on the used licenses.