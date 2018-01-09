from libc.stdlib cimport free
cimport numpy as cnp
cimport _parasail as _lib

import numpy

from .util import D


cdef _make_nd_array(cnp.uint32_t* data, shape, dtype=None):
    if len(shape) == 1:
        return _make_1d_array(data, shape[0], dtype)
    elif len(shape) == 2:
        return _make_2d_array(data, shape[0], shape[1], dtype)
    else:
        return None


cdef _make_1d_array(cnp.uint32_t* data, size_t length, dtype):
    cdef cnp.uint32_t[::1] data_view = <cnp.uint32_t[:length:1]>(data)
    return numpy.asarray(data_view, order='C')  #.astype(dtype)


cdef _make_2d_array(cnp.uint32_t* data, size_t rows, size_t cols, dtype):
    cdef cnp.uint32_t[::1] data_view = <cnp.uint32_t[:rows * cols:1]>(data)
    return numpy.asarray(data_view, order='C').reshape(rows, cols) #.astype(dtype)


cdef class Cigar:

    def __dealloc__(self):
        if self.pointer != NULL:
            _lib.parasail_cigar_free(self.pointer)
        self.pointer = NULL

    @property
    def seq(self):
        return _make_nd_array(
            self.pointer.seq,
            (self.pointer.len,),
            numpy.uint32)

    @property
    def len(self):
        return self.pointer.len

    @property
    def beg_query(self):
        return self.pointer.beg_query

    @property
    def beg_ref(self):
        return self.pointer.beg_ref

    @property
    def decode(self):
        # this allocates a char array, and we must free it
        cdef char *s =  _lib.parasail_cigar_decode(self.pointer)
        cdef bytes b
        try:
            return D(<bytes>s)
        finally:
            free(s)
            # FIXME: parasail_free not exposed?
            # _lib.parasail_free(s)

    @staticmethod
    def decode_op(cigar_int):
        return _lib.parasail_cigar_decode_op(cigar_int)

    @staticmethod
    def decode_len(cigar_int):
        return _lib.parasail_cigar_decode_len(cigar_int)
