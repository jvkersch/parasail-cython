cimport _parasail as _lib
from matrix cimport Matrix
from result cimport Result


cdef class Aligner:
    cdef _lib.parasail_function_t *align_func
    cdef Matrix matrix

    def __cinit__(self,
                  Matrix matrix,
                  str method, 
                  str vector="striped",
                  int bitlength=16,
                  bint stats=False,
                  bint table=False,
                  bint trace=False,
                  bint rowcol=False):

        cdef str name

        if trace:
            name = _create_align_name_trace(method, vector, bitlength)
        else:
            name = _create_align_name(
                method, vector, bitlength, stats, table, rowcol
            )
        self.align_func = _lib.parasail_lookup_function(name.encode())
        if self.align_func == NULL:
            raise ValueError("No align function {!r}".format(name))

        self.matrix = matrix
        
    def align(self, str s1, str s2, int open, int gap):
        cdef Result res
        cdef _lib.parasail_result *pointer
        bytes_s1 = s1.encode()
        bytes_s2 = s2.encode()
        pointer = self.align_func(bytes_s1, len(bytes_s1),
                                  bytes_s2, len(bytes_s2),
                                  open, gap, self.matrix.pointer)
        res = Result(
            s1.encode(),
            len(s1.encode()),
            s2.encode(),
            len(s2.encode()),
            self.matrix
        )
        res.pointer = pointer
        return res


def align(str s1, str s2, int open, int gap,
          Matrix matrix,
          str method, 
          str vector="striped",
          int bitlength=16,
          bint stats=False,
          bint table=False,
          bint trace=False,
          bint rowcol=False):

    cdef Aligner aln = Aligner(
        matrix, method, vector, bitlength, stats, table, trace, rowcol
    )
    return aln.align(s1, s2, open, gap)


# TODO does not help with choosing reference implementation.

cdef str _create_align_name(method, vector, bitlength, stats, table, rowcol):
    return "parasail_{}{}{}{}_{}_{}".format(
        method,
        "_stats" if stats else "",
        "_table" if table else "",
        "_rowcol" if rowcol else "",
        vector,
        bitlength
    )

cdef str _create_align_name_trace(method, vector, bitlength):
    return "parasail_{}_trace_{}_{}".format(
        method,
        vector,
        bitlength
    )
