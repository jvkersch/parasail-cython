cimport _parasail as _lib


cdef class Result:

    def __dealloc__(self):
        if self.pointer != NULL:
            _lib.parasail_result_free(self.pointer)
        self.pointer = NULL
