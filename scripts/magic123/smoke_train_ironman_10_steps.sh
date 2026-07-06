#!/usr/bin/env bash
set -euo pipefail

GPU_NO="${1:-0}"
WORKSPACE="${2:-out/smoke-ironman-10-steps}"

export CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-12.9}"
export PATH="$CUDA_HOME/bin:$PATH"
export CUDA_VISIBLE_DEVICES="$GPU_NO"

# Auto-detect the GPU compute capability so the CUDA extensions target this card.
# 4090/4090 Ti report 8.9; RTX 5090 (Blackwell) reports 12.0. Override by exporting
# TORCH_CUDA_ARCH_LIST before calling this script.
if [ -z "${TORCH_CUDA_ARCH_LIST:-}" ]; then
  DETECTED_CC="$(nvidia-smi --id="$GPU_NO" --query-gpu=compute_cap --format=csv,noheader 2>/dev/null | head -n1 | tr -d '[:space:]')"
  export TORCH_CUDA_ARCH_LIST="${DETECTED_CC:-8.9}"
fi

python scripts/check_cuda_build_env.py

# runwayml/stable-diffusion-v1-5 was removed from the Hugging Face Hub; use the
# maintained community mirror. Override with HF_KEY to point elsewhere.
HF_KEY="${HF_KEY:-stable-diffusion-v1-5/stable-diffusion-v1-5}"

python main.py -O \
  --text "A high-resolution DSLR image of a full body ironman" \
  --sd_version 1.5 \
  --hf_key "$HF_KEY" \
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
