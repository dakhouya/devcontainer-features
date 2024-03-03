# Devcontainer-features
Collection of devcontainer features

## Available devcontainer features

[oid](src/oid/README.md)

### Supported distributions
- ubuntu:focal
- ubuntu:jammy

### Run tests
Example to run tests for a specific feature
```bash
# oid tests without scenarios
devcontainer features test --features oid --skip-scenarios --base-image mcr.microsoft.com/devcontainers/base:ubuntu $PWD
# oid tests with scenarios
devcontainer features test --features oid --base-image mcr.microsoft.com/devcontainers/base:ubuntu $PWD
```
