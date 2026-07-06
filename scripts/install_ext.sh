#!/usr/bin/env bash
set -euo pipefail

# 4090/4090 Ti: 8.9; A100: 8.0; 3090: 8.6; V100: 7.0; 2080 Ti: 7.5.
export TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-8.9;8.6;8.0;7.5;7.0}"
export CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-12.9}"
export PATH="$CUDA_HOME/bin:$PATH"

python -m pip install --no-build-isolation ./raymarching
python -m pip install --no-build-isolation ./shencoder
python -m pip install --no-build-isolation ./freqencoder
python -m pip install --no-build-isolation ./gridencoder
