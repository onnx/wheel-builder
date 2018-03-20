#!/bin/bash

script_path=$(python -c "import os; import sys; print(os.path.realpath(sys.argv[1]))" "${BASH_SOURCE[0]}")
source "${script_path%/*}/setup.sh"

onnx_dir="$PWD"

# onnx tests
BASE=$(basename $onnx_dir)
if [ "$BASE" != "onnx" ]; then
    cd "${onnx_dir}/onnx"
fi
pip install pytest-cov nbval
pytest