cimport _parasail as _lib


cdef class Cigar:

    cdef _lib.parasail_cigar_ *pointer
