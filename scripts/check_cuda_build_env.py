import json
import os
import shutil
import subprocess
import sys
import sysconfig


def run(command):
    try:
        return subprocess.check_output(command, text=True, stderr=subprocess.STDOUT).strip()
    except (OSError, subprocess.CalledProcessError) as exc:
        return str(exc)


def main():
    summary = {
        "python": sys.version,
        "python_include": sysconfig.get_paths().get("include"),
        "python_h": None,
        "cuda_home": os.environ.get("CUDA_HOME") or os.environ.get("CUDA_PATH"),
        "torch_cuda_arch_list": os.environ.get("TORCH_CUDA_ARCH_LIST"),
        "nvcc": shutil.which("nvcc"),
        "nvidia_smi": shutil.which("nvidia-smi"),
    }
    include_dir = summary["python_include"]
    if include_dir:
        python_h = os.path.join(include_dir, "Python.h")
        summary["python_h"] = python_h if os.path.exists(python_h) else None
    summary["nvcc_version"] = run(["nvcc", "--version"]) if summary["nvcc"] else None
    summary["nvidia_smi_output"] = run(["nvidia-smi"]) if summary["nvidia_smi"] else None

    try:
        import torch

        summary["torch_version"] = torch.__version__
        summary["torch_cuda"] = torch.version.cuda
        summary["cuda_available"] = torch.cuda.is_available()
        summary["cuda_device_name"] = torch.cuda.get_device_name(0) if torch.cuda.is_available() else None
    except Exception as exc:
        summary["torch_error"] = repr(exc)

    print(json.dumps(summary, indent=2))
    if not summary.get("python_h"):
        return 4
    if not summary.get("nvcc"):
        return 2
    if summary.get("cuda_available") is False:
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
