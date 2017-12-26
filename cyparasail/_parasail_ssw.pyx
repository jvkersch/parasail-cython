cimport numpy as cnp
cimport _parasail as _lib

import numpy as np

from _parasail_base cimport Matrix

from .util import B


cdef class SSWResult:
    cdef _lib.parasail_result_ssw *pointer

    def __dealloc__(self):
        if self.pointer != NULL:
            _lib.parasail_result_ssw_free(self.pointer)
        self.pointer = NULL

    @property
    def score1(self):
        return self.pointer.score1

    @property
    def ref_begin1(self):
        return self.pointer.ref_begin1

    @property
    def ref_end1(self):
        return self.pointer.ref_end1

    @property
    def read_begin1(self):
        return self.pointer.read_begin1

    @property
    def read_end1(self):
        return self.pointer.read_end1

    @property
    def cigar(self):
        cdef cnp.int32_t s = self.pointer.cigarLen
        cdef cnp.uint32_t[::1] data = <cnp.uint32_t[:s:1]>self.pointer.cigar
        return np.array(data, order='C')

    @property
    def cigarLen(self):
        return self.pointer.cigarLen


def ssw(s1, s2, open_, extend, matrix):
    # TODO check matrix input argument

    cdef _lib.parasail_result_ssw *result
    cdef SSWResult wrapped_result = SSWResult()

    result = _lib.parasail_ssw(
        B(s1), len(s1), B(s2), len(s2), open_, extend,
        (<Matrix>matrix).pointer
    )
    if result != NULL:
        wrapped_result.pointer = result
        return wrapped_result
