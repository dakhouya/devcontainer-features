#!/usr/bin/env bash
set -e

# Checks if packages are installed and installs them if not
check_packages() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    apt-get update -y
    apt-get -y install --no-install-recommends "$@"
  fi
}

# Install qt
install_qt() {
    pip3 install --upgrade pip
    pip3 install aqtinstall
    aqt install-qt linux desktop 5.12.8 -O /opt/Qt
}

# Install depot_tools
install_oid() {
    local oid_src="/tmp/oid-src"
    local oid_install="/opt/oid"
    git clone https://github.com/OpenImageDebugger/OpenImageDebugger.git "${oid_src}"
    cd "${oid_src}"
    git submodule init
    git submodule update

    cmake -S . -B build -DCMAKE_INSTALL_PREFIX="${oid_install}" -DQt5_DIR=/opt/Qt/5.12.8/gcc_64/lib/cmake/Qt5
    cmake --build build --config Release --target install -j
    rm -rf "${oid_src}"
}

# Install dependencies
check_packages git \
  build-essential \
  libpython3-dev \
  python3-dev \
  python3-pip \
  cmake \
  libqt5opengl5-dev

install_qt
install_oid
