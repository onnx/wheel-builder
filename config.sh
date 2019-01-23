#!/bin/bash
function build_wheel {
    build_libs
    export ONNX_ML=1
    time ONNX_NAMESPACE=ONNX_REL_1_4 build_bdist_wheel $@
}

function build_libs {
    local wkdir_path="$(pwd)"
    export NUMCORES=`grep -c ^processor /proc/cpuinfo`
    if [ ! -n "$NUMCORES" ]; then
      export NUMCORES=`sysctl -n hw.ncpu`
    fi
    echo Using $NUMCORES cores

    if [ -z "$IS_OSX" ]; then
        APT_INSTALL_CMD='yum -y install'
        # Install protobuf
        pb_dir="./cache/pb"
        PB_VERSION=2.6.1
        mkdir -p "$pb_dir"
        curl -L -O https://github.com/google/protobuf/releases/download/v${PB_VERSION}/protobuf-${PB_VERSION}.tar.gz
        tar -xzf protobuf-${PB_VERSION}.tar.gz -C "$pb_dir" --strip-components 1
        activate_ccache
        ccache -z
        cd ${pb_dir} && ./configure && make -j${NUMCORES} && make check && make install && ldconfig 2>&1 || true
        ccache -s
        export PATH="/usr/lib/ccache:$PATH"
    else
        brew install ccache protobuf
        export PATH="/usr/local/opt/ccache/libexec:$PATH"
        echo PATH: $PATH
        pip install pytest-runner
    fi

    cd ${wkdir_path}

    if [ -z "$IS_OSX" ]; then
       cmake_dir="${wkdir_path}/cmake"
       mkdir -p "$cmake_dir"
       curl -L -O https://cmake.org/files/v3.1/cmake-3.1.2.tar.gz
       tar -xzf cmake-3.1.2.tar.gz -C "$cmake_dir" --strip-components 1
       cd ${cmake_dir} && ls ${cmake_dir}
       ./configure --prefix=${cmake_dir}/build
       make -j${NUMCORES} && make install
       ${cmake_dir}/build/bin/cmake -version
       export PATH="${cmake_dir}/build/bin:$PATH"
    fi

    cd ${wkdir_path}
    pip install protobuf numpy
}

function run_tests {
    cd ..
    local wkdir_path="$(pwd)"
    echo Running tests at root path: ${wkdir_path}
    cd ${wkdir_path}/onnx
    pip install tornado==4.5.3
    pip install pytest-cov nbval
    pytest
}