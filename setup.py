from setuptools import find_packages

from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize


PARASAIL_INCLUDE = "/Users/jvankerschaver/src/parasail"
PARASAIL_LIB = "/Users/jvankerschaver/src/parasail/build"

extensions = [
    Extension('cyparasail._parasail_base', ["cyparasail/_parasail_base.pyx"],
              include_dirs=[PARASAIL_INCLUDE],
              library_dirs=[PARASAIL_LIB],
              runtime_library_dirs=[PARASAIL_LIB],
              libraries=['parasail'])
]

setup(
    name="parasail-cython",
    packages=find_packages(),
    ext_modules=cythonize(extensions),
)
