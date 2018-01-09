cimport _parasail as _lib

cdef class Result:
    cdef _lib.parasail_result *pointer
    cdef char *query
    cdef size_t len_query
    cdef char *ref
    cdef size_t len_ref
    cdef _lib.parasail_matrix *matrix
