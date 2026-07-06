
#!/usr/bin/env bash
set -euo pipefail

# For KAUST cluster, uncomment the matching modules.
# module load cuda/11.7.0
# module load gcc/7.5.0
# module load eigen

# for aws ubuntu.  install eigen
#sudo apt update && sudo apt upgrade
#sudo apt install git wget libeigen3-dev -y

# 4090/4090 Ti: 8.9; A100: 8.0; 3090: 8.6; V100: 7.0; 2080 Ti: 7.5.
export CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-12.9}"
export PATH="$CUDA_HOME/bin:$PATH"
export TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-8.9;8.6;8.0;7.5;7.0}"

# use python venv
python3 -m venv venv_magic123
source venv_magic123/bin/activate

# use conda
# conda create -n magic123 python=3.10 ipython -y
# conda activate magic123

python -m pip install --upgrade pip setuptools wheel
pip3 install torch torchvision
pip3 install -r requirements.txt
bash scripts/install_ext.sh
