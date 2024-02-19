# Devcontainer-features
Collection of devcontainer features

## Contents

oid - Add link to documentation

### Run tests

Example to run tests for a specific feature
```bash
devcontainer features test \
               --features <feature e.g. oid>   \
               --remote-user root \
               --skip-scenarios   \ # Only tun test.sh
               --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
               <devcontainer-feature-path>
```
