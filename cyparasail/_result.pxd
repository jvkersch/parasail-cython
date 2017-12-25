cimport _parasail as _lib

cdef class Result:
    cdef _lib.parasail_result *pointer
    cdef size_t len_query
    cdef size_t len_ref
