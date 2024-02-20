#!/usr/bin/env bash
set -e

# Input options
OID_VERSION="${VERSION:-"main"}"
OID_ENABLE_GDB="${ENABLEGDB:-"true"}"
OID_ENABLE_LLDB="${ENABLELLDB:-"true"}"

# Devcontainer environment variable
REMOTE_USER="${_REMOTE_USER}"
REMOTE_USER_HOME="${_REMOTE_USER_HOME}"

# Constant
QT_INSTALL_PATH="/opt/Qt"
OID_INSTALL_PATH="/opt"

# Checks if packages are installed and installs them if not
check_packages() {
  export DEBIAN_FRONTEND=noninteractive
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    apt-get update -y
    apt-get -y install --no-install-recommends "$@"
  fi
}

# Install qt
install_qt() {
    pip3 install --upgrade pip
    pip3 install aqtinstall
    aqt install-qt linux desktop 5.12.8 -O ${QT_INSTALL_PATH}
}

# Install depot_tools
install_oid() {
    local oid_src="/tmp/oid-src"
    git clone  --depth 1 --branch ${OID_VERSION} https://github.com/OpenImageDebugger/OpenImageDebugger.git "${oid_src}"
    cd "${oid_src}"
    git submodule update --init

    cmake -S . -B build -DCMAKE_INSTALL_PREFIX="${OID_INSTALL_PATH}" -DQt5_DIR=${QT_INSTALL_PATH}/5.12.8/gcc_64/lib/cmake/Qt5
    cmake --build build --config Release --target install -j
    rm -rf "${oid_src}"
}

install_debugger_init() {
    if [ "${OID_ENABLE_GDB}" = "true" ]; then
        echo "source ${OID_INSTALL_PATH}/OpenImageDebugger/oid.py" >> ${REMOTE_USER_HOME}/.gdbinit
        chown ${REMOTE_USER}:${REMOTE_USER} ${REMOTE_USER_HOME}/.gdbinit
    fi

    if [ "${OID_ENABLE_LLDB}" = "true" ]; then
        echo "command script import ${OID_INSTALL_PATH}/OpenImageDebugger/oid.py" >> ${REMOTE_USER_HOME}/.lldbinit
        chown ${REMOTE_USER}:${REMOTE_USER} ${REMOTE_USER_HOME}/.lldbinit
    fi
}

# Install dependencies
check_packages git \
  build-essential \
  libpython3-dev \
  python3-dev \
  python3-pip \
  cmake \
  libx11-xcb-dev \
  libglu1-mesa-dev \
  libglib2.0-dev \
  libfontconfig1 \
  libxrender-dev \
  libxkbcommon-x11-0 \
  libdbus-1-3

install_qt
install_oid
install_debugger_init
