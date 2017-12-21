from setuptools import find_packages

from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

import numpy


PARASAIL_INCLUDE = "/Users/jvankerschaver/src/parasail"
PARASAIL_LIB = "/Users/jvankerschaver/src/parasail/build"


def extension(name, sources):
    return Extension(
        name, sources,
        include_dirs=[PARASAIL_INCLUDE, numpy.get_include()],
        library_dirs=[PARASAIL_LIB],
        extra_link_args=["-Wl,-rpath,{}".format(PARASAIL_LIB)],
        runtime_library_dirs=[PARASAIL_LIB],
        libraries=['parasail'])


extensions = [
    extension('cyparasail._parasail_base', ["cyparasail/_parasail_base.pyx"]),
    extension('cyparasail._parasail_ssw', ["cyparasail/_parasail_ssw.pyx"]),
]

setup(
    name="parasail-cython",
    packages=find_packages(),
    ext_modules=cythonize(extensions),
)
