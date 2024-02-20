# Devcontainer-features
Collection of devcontainer features

## Contents

[oid](src/oid/README.md)

### Run tests

Example to run tests for a specific feature
```bash
# oid tests without scenarios
devcontainer devcontainer features test --features oid --skip-scenarios --base-image mcr.microsoft.com/devcontainers/base:ubuntu $PWD
# oid tests with scenarios
devcontainer devcontainer features test --features oid --base-image mcr.microsoft.com/devcontainers/base:ubuntu $PWD
```
