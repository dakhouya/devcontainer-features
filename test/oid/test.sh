#!/bin/bash
set -e

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
check "oid exist" ls -lah /opt/OpenImageDebugger
check "oid initialisation script is available" ls -lah /opt/OpenImageDebugger/oid.py
check "validate lldb hook is available" grep -q "command script import /path/to/OpenImageDebugger/oid.py" ${HOME}/.lldbinit
check "validate gdb hook is available" grep -q "source /path/to/OpenImageDebugger/oid.py" ${HOME}/.gdbinit

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults