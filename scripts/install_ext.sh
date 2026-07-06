#!/usr/bin/env bash
set -euo pipefail

# RTX 5090 (Blackwell): 12.0; 4090/4090 Ti: 8.9; A100: 8.0; 3090: 8.6; V100: 7.0; 2080 Ti: 7.5.
# Auto-detect the installed GPU's compute capability; override by exporting TORCH_CUDA_ARCH_LIST.
export CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-12.9}"
export PATH="$CUDA_HOME/bin:$PATH"
if [ -z "${TORCH_CUDA_ARCH_LIST:-}" ]; then
  DETECTED_CC="$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader 2>/dev/null | head -n1 | tr -d '[:space:]')"
  export TORCH_CUDA_ARCH_LIST="${DETECTED_CC:-8.9;8.6;8.0;7.5;7.0}"
fi
echo "[install_ext] building for TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}"

# CUDA 12.9's nvcc supports GCC up to 14. If the default compiler is newer (e.g. GCC 15),
# fall back to gcc-14/g++-14 when available so the host-compiler check passes.
if [ -z "${CC:-}" ] && command -v gcc >/dev/null 2>&1; then
  GCC_MAJOR="$(gcc -dumpversion | cut -d. -f1)"
  if [ "${GCC_MAJOR:-0}" -ge 15 ] && command -v gcc-14 >/dev/null 2>&1; then
    export CC=gcc-14 CXX=g++-14
    echo "[install_ext] default gcc is ${GCC_MAJOR}; using gcc-14/g++-14 for CUDA 12.9"
  fi
fi

python -m pip install --no-build-isolation ./raymarching
python -m pip install --no-build-isolation ./shencoder
python -m pip install --no-build-isolation ./freqencoder
python -m pip install --no-build-isolation ./gridencoder
