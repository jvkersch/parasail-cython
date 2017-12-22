cimport _parasail as _lib

cdef class Result:
    cdef _lib.parasail_result *pointer
