cimport _parasail as _lib

cdef class Matrix:
    cdef _lib.parasail_matrix* pointer
