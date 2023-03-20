#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
cd "$ROOT_DIR"

echo "Creating Python environment..."
python3 -m venv onnx_env
source onnx_env/bin/activate
pip install onnx protobuf==3.20.2
pythonLocation=$(realpath "onnx_env")

echo "Cloning protobuf..."
git clone https://github.com/protocolbuffers/protobuf.git
pushd protobuf
    git checkout v3.20.2
    git submodule update --init --recursive
    mkdir build_install
    PROTOBUF_PREFIX=$(realpath build_install)
    mkdir build_source
    pushd build_source
        echo "Building protobuf..."
        cmake ../cmake \
            -Dprotobuf_BUILD_SHARED_LIBS=OFF \
            -DCMAKE_INSTALL_PREFIX="${PROTOBUF_PREFIX}/usr" \
            -DCMAKE_INSTALL_SYSCONFDIR="${PROTOBUF_PREFIX}/etc" \
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
            -Dprotobuf_BUILD_TESTS=OFF \
            -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
        make install
    popd
popd

# clone and compile onnx-mlir and its third_party submodules
echo "Initializing submodules..."
git submodule update --init --recursive
pushd onnx-mlir
    echo "Cloning MLIR..."
    git clone -n https://github.com/llvm/llvm-project.git
    pushd llvm-project
        git checkout 21f4b84c456b471cc52016cf360e14d45f7f2960
        mkdir build
        pushd build
            echo "Building MLIR..."
            cmake -G Ninja ../llvm \
               -DLLVM_ENABLE_PROJECTS=mlir \
               -DLLVM_TARGETS_TO_BUILD="host" \
               -DCMAKE_BUILD_TYPE=Release \
               -DLLVM_ENABLE_ASSERTIONS=ON \
               -DLLVM_ENABLE_RTTI=ON \
               -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON
            cmake --build .
            MLIR_DIR=$(realpath "lib/cmake/mlir")
        popd
    popd
    mkdir build
    pushd build
        echo "Building ONNX-MLIR..."
        cmake -G Ninja \
            -DProtobuf_PROTOC_EXECUTABLE="${PROTOBUF_PREFIX}/usr/bin/protoc" \
            -DProtobuf_INCLUDE_DIR="${PROTOBUF_PREFIX}/usr/include" \
            -DPython3_ROOT_DIR="$pythonLocation" \
            -DMLIR_DIR="$MLIR_DIR" \
            -DCMAKE_C_COMPILER=clang \
            -DCMAKE_CXX_COMPILER=clang++ \
            -DCMAKE_BUILD_TYPE=Debug \
            ..
        cmake --build .
    popd
popd


