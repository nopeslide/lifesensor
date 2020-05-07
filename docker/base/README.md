# Docker image base

<!-- SHORT DESCRIPTION OF YOUR DOCKER IMAGE -->
This is the base image of all other images.

## Features
<!-- PLEASE LIST THE FEATURES OF YOUR IMAGE FOR A QUICK REFERENCE -->
- installs `sudo`
- creates user `developer`
- adds `developer` to sudoers

## Arguments
<!-- PLEASE LIST THE BUILD ARGUMENTS OF YOUR IMAGE FOR A QUICK REFERENCE -->
- `UID`
  - sets uid of `developer`
- `GID`
  - sets gid of `developer`

<!-- DO NOT FORGET TO MODIFY DOCKERFILE & MAKEFILE! -->
See the [Dockerfile](./Dockerfile) or [Makefile](./Makefile) for more information