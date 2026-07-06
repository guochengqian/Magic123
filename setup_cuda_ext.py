import glob
import os
import platform
import shutil
import subprocess


DEFAULT_CUDA_ARCH_LIST = "8.9;8.6;8.0;7.5;7.0"


def configure_cuda_extension_build():
    os.environ.setdefault("TORCH_CUDA_ARCH_LIST", DEFAULT_CUDA_ARCH_LIST)
    if os.name == "nt":
        _configure_windows_msvc()


def make_cuda_extension(name, sources, nvcc_extra_flags=None):
    configure_cuda_extension_build()

    from torch.utils.cpp_extension import CUDAExtension

    c_flags = _cxx_flags()
    nvcc_flags = [
        "-O3",
        "-std=c++17",
        "-U__CUDA_NO_HALF_OPERATORS__",
        "-U__CUDA_NO_HALF_CONVERSIONS__",
        "-U__CUDA_NO_HALF2_OPERATORS__",
    ]
    if nvcc_extra_flags:
        nvcc_flags.extend(nvcc_extra_flags)

    return CUDAExtension(
        name=name,
        sources=sources,
        extra_compile_args={
            "cxx": c_flags,
            "nvcc": nvcc_flags,
        },
    )


def _cxx_flags():
    if os.name == "nt":
        return ["/O2", "/std:c++17"]
    return ["-O3", "-std=c++17"]


def _configure_windows_msvc():
    if shutil.which("cl.exe"):
        return

    cl_path = _find_cl_path()
    if cl_path:
        os.environ["PATH"] += os.pathsep + cl_path
        return

    raise RuntimeError(
        "Could not locate cl.exe. Install the Desktop development with C++ "
        "workload from Visual Studio Build Tools, then run this from a "
        "Developer PowerShell or Developer Command Prompt."
    )


def _find_cl_path():
    candidates = []
    vswhere = os.path.join(
        os.environ.get("ProgramFiles(x86)", r"C:\Program Files (x86)"),
        "Microsoft Visual Studio",
        "Installer",
        "vswhere.exe",
    )
    if os.path.exists(vswhere):
        try:
            output = subprocess.check_output(
                [
                    vswhere,
                    "-latest",
                    "-products",
                    "*",
                    "-requires",
                    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
                    "-property",
                    "installationPath",
                ],
                text=True,
            ).strip()
        except (OSError, subprocess.CalledProcessError):
            output = ""
        if output:
            candidates.extend(
                glob.glob(
                    os.path.join(output, "VC", "Tools", "MSVC", "*", "bin", "Hostx64", "x64")
                )
            )

    for program_files in [os.environ.get("ProgramFiles(x86)"), os.environ.get("ProgramFiles")]:
        if not program_files:
            continue
        candidates.extend(
            glob.glob(
                os.path.join(
                    program_files,
                    "Microsoft Visual Studio",
                    "*",
                    "*",
                    "VC",
                    "Tools",
                    "MSVC",
                    "*",
                    "bin",
                    "Hostx64",
                    "x64",
                )
            )
        )

    candidates = sorted(set(candidates), reverse=True)
    return candidates[0] if candidates else None


def build_environment_summary():
    return {
        "platform": platform.platform(),
        "cuda_home": os.environ.get("CUDA_HOME") or os.environ.get("CUDA_PATH"),
        "torch_cuda_arch_list": os.environ.get("TORCH_CUDA_ARCH_LIST", DEFAULT_CUDA_ARCH_LIST),
        "nvcc": shutil.which("nvcc"),
        "cl": shutil.which("cl.exe") if os.name == "nt" else None,
    }
