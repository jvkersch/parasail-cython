cimport _parasail as _lib
from matrix cimport Matrix
from result cimport Result


cdef class Profile:
    cdef _lib.parasail_profile_t *profile
    cdef _lib.parasail_pfunction_t *align_func

    cdef Matrix matrix
    cdef char *query

    def __cinit__(self, str query, Matrix matrix, str method,
                  str vector="striped",
                  int bitlength=16,
                  bint stats=False):

        cdef str py_name
        cdef char *name
        cdef _lib.parasail_pcreator_t *pcreator

        py_name = _create_profile_name(method, vector, bitlength, stats)
        py_bytes_name = py_name.encode()
        name = py_bytes_name

        pcreator = _lib.parasail_lookup_pcreator(name)
        if pcreator == NULL:
            raise ValueError("No profile with name {!r}".format(name))

        py_query = query.encode()
        self.query = py_query
        self.matrix = matrix

        self.profile = pcreator(self.query, len(self.query), matrix.pointer)
        if self.profile == NULL:
            raise RuntimeError("Profile is NULL")

        self.align_func = _lib.parasail_lookup_pfunction(name)
        if self.align_func == NULL:
            raise RuntimeError("Align function is NULL ({})".format(name))

    def __dealloc__(self):
        if self.profile != NULL:
            _lib.parasail_profile_free(self.profile)
            self.profile = NULL

    def align(self, str seq, int open, int gap):
        cdef _lib.parasail_result *pointer

        py_seq = seq.encode()
        pointer = self.align_func(self.profile, py_seq, len(py_seq), open, gap)
        return self._make_result(pointer, py_seq)

    cdef object _make_result(self, _lib.parasail_result *pointer, char* seq):
        cdef Result res = Result(
            self.query, len(self.query), seq, len(seq), self.matrix
        )
        res.pointer = pointer
        return res


cdef str _create_profile_name(method, vector, bitlength, stats):
    return "parasail_{}{}_{}_profile_{}".format(
        method,
        "_stats" if stats else "",
        vector,
        bitlength
    )
