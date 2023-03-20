#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
cd "$ROOT_DIR"

cd onnx-mlir/build
cmake --build .
