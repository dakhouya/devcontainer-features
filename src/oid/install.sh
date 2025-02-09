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

install_cmake() {
    # Minimum required version
    REQUIRED_VERSION="3.22.1"
    TARGET_VERSION="3.31.5"
    CMAKE_URL="https://cmake.org/files/v3.31/cmake-${TARGET_VERSION}-linux-x86_64.tar.gz"
    INSTALL_DIR="/opt/cmake-${TARGET_VERSION}-linux-x86_64"

    # Check if cmake is installed
    if command -v cmake &>/dev/null; then
        INSTALLED_VERSION=$(cmake --version | head -n1 | awk '{print $3}')
        echo "CMake version $INSTALLED_VERSION detected."

        # Compare versions
        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$INSTALLED_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            echo "CMake version $INSTALLED_VERSION is sufficient."
            return 0
        else
            echo "CMake version $INSTALLED_VERSION is too old. Updating..."
        fi
    else
        echo "CMake is not installed. Installing..."
    fi

    # Download and install CMake
    curl -sSL "$CMAKE_URL" | tar -xzC /opt
    ln -sf "$INSTALL_DIR/bin/"* /usr/local/bin

    echo "CMake $TARGET_VERSION installed successfully."
}


install_qt() {
    pip3 install --upgrade pip
    pip3 install --user aqtinstall
    aqt install-qt linux desktop 5.15.2 --archives icu qtbase -O ${QT_INSTALL_PATH}
}

install_oid() {
    local oid_src="/tmp/oid-src"
    git clone  --depth 1 --branch ${OID_VERSION} https://github.com/OpenImageDebugger/OpenImageDebugger.git "${oid_src}"
    cd "${oid_src}"
    git submodule update --init

    cmake -S . -B build -DCMAKE_INSTALL_PREFIX="${OID_INSTALL_PATH}" -DQt5_DIR=${QT_INSTALL_PATH}/5.15.2/gcc_64/lib/cmake/Qt5
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
check_packages curl \
  git \
  gzip \
  build-essential \
  libpython3-dev \
  python3-dev \
  python3-pip \
  libx11-xcb-dev \
  libglu1-mesa-dev \
  libglib2.0-dev \
  libfontconfig1 \
  libxrender-dev \
  libxkbcommon-x11-0 \
  libdbus-1-3

install_cmake
install_qt
install_oid
install_debugger_init
