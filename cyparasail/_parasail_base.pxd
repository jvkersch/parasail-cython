cimport _parasail as _lib

cdef class Matrix:
    cdef _lib.parasail_matrix* pointer

cdef class SSWResult:
    cdef _lib.parasail_result_ssw *pointer
