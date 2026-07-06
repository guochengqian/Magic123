import os
import sys
from setuptools import setup
from torch.utils.cpp_extension import BuildExtension

_src_path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(_src_path))
from setup_cuda_ext import make_cuda_extension

'''
Usage:

python setup.py build_ext --inplace # build extensions locally, do not install (only can be used from the parent directory)

python setup.py install # build extensions and install (copy) to PATH.
pip install . # ditto but better (e.g., dependency & metadata handling)

python setup.py develop # build extensions and install (symbolic) to PATH.
pip install -e . # ditto but better (e.g., dependency & metadata handling)

'''
setup(
    name='raymarching', # package name, import this to use python API
    ext_modules=[
        make_cuda_extension(
            name='_raymarching', # extension name, import this to use CUDA API
            sources=[os.path.join(_src_path, 'src', f) for f in [
                'raymarching.cu',
                'bindings.cpp',
            ]]
        ),
    ],
    cmdclass={
        'build_ext': BuildExtension,
    }
)
