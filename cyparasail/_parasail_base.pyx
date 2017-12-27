cimport numpy as cnp
cimport _parasail as _lib

import numpy as np

from .util import B, D, isstr


def parasail_version():
    cdef int major, minor, patch
    _lib.parasail_version(&major, &minor, &patch)
    return (major, minor, patch)


# TODO can we get by with classmethod?
cdef class PointerWrapper:
    cdef _lib.parasail_matrix* pointer


cdef class Matrix:

    def __dealloc__(self):
        if self.pointer != NULL and self.pointer.user_matrix:
            _lib.parasail_matrix_free(self.pointer)
        self.pointer = NULL

    def __cinit__(self, pointer_or_string):  # can we tighten this to str only?
        cdef _lib.parasail_matrix* pointer = NULL

        if isstr(pointer_or_string):
            pointer = _lib.parasail_matrix_lookup(B(pointer_or_string))
            if pointer == NULL:
                raise NotImplementedError()
        elif isinstance(pointer_or_string, PointerWrapper):
            pointer = (<PointerWrapper>pointer_or_string).pointer
        else:
            raise TypeError("Invalid input type {!r}".format(type(pointer_or_string)))
        self.pointer = pointer

    @property
    def name(self):
        return D(self.pointer.name)

    @property
    def matrix(self):
        cdef int s = self.pointer.size
        cdef int[::1] data = <int[:s*s:1]>self.pointer.matrix

        return np.array(data, order='C').reshape(s, s)

    @property
    def size(self):
        return self.pointer.size

    @property
    def min(self):
        return self.pointer.min

    @property
    def max(self):
        return self.pointer.max

    def set_value(self, row, col, value):
        _lib.parasail_matrix_set_value(self.pointer, row, col, value)

    def copy(self):
        cdef PointerWrapper wrap = PointerWrapper()
        wrap.pointer = _lib.parasail_matrix_copy(self.pointer)
        return Matrix(wrap)

    def __setitem__(self, key, value):
        if type(key) is list or type(key) is tuple:
            if len(key) < 2:
                raise IndexError('too few keys in setitem')
            if len(key) > 2:
                raise IndexError('too many keys in setitem')
            if isinstance(key[0], slice) and isinstance(key[1], slice):
                for r in range(key[0].start, key[0].stop, key[0].step or 1):
                    for c in range(key[1].start, key[1].stop, key[1].step or 1):
                        _lib.parasail_matrix_set_value(self.pointer, r, c, value)
            elif isinstance(key[0], slice):
                for r in range(key[0].start, key[0].stop, key[0].step or 1):
                    _lib.parasail_matrix_set_value(self.pointer, r, key[1], value)

            elif isinstance(key[1], slice):
                for c in range(key[1].start, key[1].stop, key[1].step or 1):
                    _lib.parasail_matrix_set_value(self.pointer, key[0], c, value)
            else:
                _lib.parasail_matrix_set_value(self.pointer, key[0], key[1], value)
        elif isinstance(key, slice):
            for r in range(key[0].start, key[0].stop, key[0].step or 1):
                for c in range(self.size):
                    _lib.parasail_matrix_set_value(self.pointer, r, c, value)
        else:
            # assume int, do what numpy does
            for c in range(self.size):
                _lib.parasail_matrix_set_value(self.pointer, key, c, value)



def matrix_create(alphabet, match, mismatch):
    cdef Matrix m = Matrix()
    m.pointer = _lib.parasail_matrix_create(B(alphabet), match, mismatch)
    return m
