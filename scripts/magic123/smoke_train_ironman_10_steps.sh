#!/usr/bin/env bash
set -euo pipefail

GPU_NO="${1:-0}"
WORKSPACE="${2:-out/smoke-ironman-10-steps}"

export CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-12.9}"
export PATH="$CUDA_HOME/bin:$PATH"
export TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-8.9}"
export CUDA_VISIBLE_DEVICES="$GPU_NO"

python scripts/check_cuda_build_env.py

python main.py -O \
  --text "A high-resolution DSLR image of a full body ironman" \
  --sd_version 1.5 \
  --image data/demo/a-full-body-ironman/rgba.png \
  --workspace "$WORKSPACE" \
  --optim adam \
  --iters 10 \
  --guidance SD zero123 \
  --lambda_guidance 1.0 40 \
  --guidance_scale 100 5 \
  --latent_iter_ratio 0 \
  --normal_iter_ratio 0.2 \
  --t_range 0.2 0.6 \
  --bg_radius -1 \
  --save_mesh

echo "Smoke-test results saved to: $WORKSPACE"
