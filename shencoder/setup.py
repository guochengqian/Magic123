import os
import sys
from setuptools import setup
from torch.utils.cpp_extension import BuildExtension

_src_path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(_src_path))
from setup_cuda_ext import make_cuda_extension

setup(
    name='shencoder', # package name, import this to use python API
    ext_modules=[
        make_cuda_extension(
            name='_shencoder', # extension name, import this to use CUDA API
            sources=[os.path.join(_src_path, 'src', f) for f in [
                'shencoder.cu',
                'bindings.cpp',
            ]]
        ),
    ],
    cmdclass={
        'build_ext': BuildExtension,
    }
)
