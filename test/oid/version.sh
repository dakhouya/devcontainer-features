#!/bin/bash

# Test the version option
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# No way to check version after installation so we only ensure the oid script is available
check "oid initialisation script is available" ls -lah /opt/OpenImageDebugger/oid.py

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
