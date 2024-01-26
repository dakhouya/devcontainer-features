#!/usr/bin/env bash
set -e

# Checks if packages are installed and installs them if not
check_packages() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    apt-get update -y
    apt-get -y install --no-install-recommends "$@"
  fi
}

# Install depot_tools
install() {
    local oid_src="/tmp/oid-src"
    local oid_install="/opt/oid"
    git clone https://github.com/dakhouya/OpenImageDebugger.git -b bugfix/fix-qt-build-error "${oid_src}"
    cd "${oid_src}"
    git submodule init
    git submodule update

    cmake -S . -B build -DCMAKE_INSTALL_PREFIX="${oid_install}"
    cmake --build build --config Release --target install -j
    rm -rf "${oid_src}"
}

# Install dependencies
check_packages git build-essential libpython3-dev python3-dev cmake qtbase5-dev libqt5opengl5-dev

install
