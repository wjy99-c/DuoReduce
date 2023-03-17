# MLIR-s-benchmark
MLIR's benchmark. We use these programs as input to test compilers and improve the debuggability of compilers

A task list can be found [here](TODO.md).

## ONNX-MLIR based Toy Compilation Pass

### Build
1. Install dependencies:
```bash
sudo apt-get update
sudo apt-get install protobuf-compiler libprotobuf-dev binutils cmake \
  ninja-build liblzma-dev libz-dev pkg-config autoconf libtool clang lld
```
1. Clone submodule: `git submodule update --init --recursive`
1. Clone LLVM/MLIR:
```
cd onnx-mlir
git clone -n https://github.com/llvm/llvm-project.git
cd llvm-project && git checkout 21f4b84c456b471cc52016cf360e14d45f7f2960 && cd ..
```
1. Build LLVM/MLIR:
```bash
./compile_mlir.sh configure
./compile_mlir.sh build
```
```
1. Build `libprotobuf-mutator`:
```bash
./onnx-mlir/compile_libprotobuf_mutator.sh
```
1. Build onnx-mlir and toy compiler:
```
./compile_onnxmlir.sh configure
./compile_onnxmlir.sh build
```

### Usage
TODO
