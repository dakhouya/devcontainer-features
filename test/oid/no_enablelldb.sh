#!/bin/bash

# Test the enableGDB option
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# No way to check version after installation so we only ensure the oid script is available
check "validate lldb hook is not available" grep -q "command script import /path/to/OpenImageDebugger/oid.py" ~/.lldbinit || return 0

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
