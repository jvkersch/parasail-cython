import os

from setuptools import find_packages

from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

import numpy


PARASAIL_INCLUDE = os.environ.get('PARASAIL_INCLUDE', '/usr/local/include')
PARASAIL_LIB = os.environ.get('PARASAIL_LIB', '/usr/local/lib')


def extension(name, sources):
    return Extension(
        name, sources,
        include_dirs=[PARASAIL_INCLUDE, numpy.get_include()],
        library_dirs=[PARASAIL_LIB],
        extra_link_args=["-Wl,-rpath,{}".format(PARASAIL_LIB)],
        runtime_library_dirs=[PARASAIL_LIB],
        libraries=['parasail'])


extensions = [
    extension('cyparasail.align', ["cyparasail/align.pyx"]),
    extension('cyparasail.cigar', ["cyparasail/cigar.pyx"]),
    extension('cyparasail.matrix', ["cyparasail/matrix.pyx"]),
    extension('cyparasail.profile', ["cyparasail/profile.pyx"]),
    extension('cyparasail.result', ["cyparasail/result.pyx"]),
    extension('cyparasail.support', ["cyparasail/support.pyx"]),
    extension('cyparasail.ssw', ["cyparasail/ssw.pyx"]),
]

setup(
    name="parasail-cython",
    version="0.0.1",
    packages=find_packages(),
    ext_modules=cythonize(extensions),
)
