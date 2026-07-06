import os
import sys
from setuptools import setup
from torch.utils.cpp_extension import BuildExtension

_src_path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(_src_path))
from setup_cuda_ext import make_cuda_extension

setup(
    name='freqencoder', # package name, import this to use python API
    ext_modules=[
        make_cuda_extension(
            name='_freqencoder', # extension name, import this to use CUDA API
            sources=[os.path.join(_src_path, 'src', f) for f in [
                'freqencoder.cu',
                'bindings.cpp',
            ]],
            nvcc_extra_flags=['-use_fast_math']
        ),
    ],
    cmdclass={
        'build_ext': BuildExtension,
    }
)
