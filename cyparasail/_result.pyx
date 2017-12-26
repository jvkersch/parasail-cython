cimport _parasail as _lib
from _cigar cimport Cigar

import numpy as np

cdef _make_1d_array(int* data, size_t length):
    cdef int[::1] data_view = <int[:length:1]>(data)
    return np.asarray(data_view, order='C')


cdef _make_2d_array(int* data, size_t rows, size_t cols):
    cdef int[::1] data_view = <int[:rows * cols:1]>(data)
    return np.asarray(data_view, order='C').reshape(rows, cols)


cdef class Result:

    def __init__(self, char * query, size_t len_query, char * ref, size_t len_ref,
                 matrix=None):

        self.len_query = len_query
        self.len_ref = len_ref
        self.query = query
        self.ref = ref
        self.matrix = NULL  # matrix

    def __dealloc__(self):
        if self.pointer != NULL:
            _lib.parasail_result_free(self.pointer)
        self.pointer = NULL

    @property
    def saturated(self):
        return _lib.parasail_result_is_saturated(self.pointer) != 0

    @property
    def score(self):
        return self.pointer.score

    @property
    def matches(self):
        if 0 == _lib.parasail_result_is_stats(self.pointer):
            raise AttributeError("'Result' object has no stats")
        return _lib.parasail_result_get_matches(self.pointer)

    @property
    def similar(self):
        if 0 == _lib.parasail_result_is_stats(self.pointer):
            raise AttributeError("'Result' object has no stats")
        return _lib.parasail_result_get_similar(self.pointer)

    @property
    def length(self):
        if 0 == _lib.parasail_result_is_stats(self.pointer):
            raise AttributeError("'Result' object has no stats")
        return _lib.parasail_result_get_length(self.pointer)

    @property
    def end_query(self):
        return self.pointer.end_query

    @property
    def end_ref(self):
        return self.pointer.end_ref

    @property
    def score_table(self):
        if (0 == _lib.parasail_result_is_table(self.pointer) and
            0 == _lib.parasail_result_is_stats_table(self.pointer)):
            raise AttributeError("'Result' object has no score table")
        return _make_2d_array(
            _lib.parasail_result_get_score_table(self.pointer),
            self.len_query, self.len_ref
        )

    @property
    def matches_table(self):
        if 0 == _lib.parasail_result_is_stats_table(self.pointer):
            raise AttributeError("'Result' object has no stats table")
        return _make_2d_array(
            _lib.parasail_result_get_matches_table(self.pointer),
            self.len_query, self.len_ref
        )

    @property
    def similar_table(self):
        if 0 == _lib.parasail_result_is_stats_table(self.pointer):
            raise AttributeError("'Result' object has no stats tables")
        return _make_2d_array(
            _lib.parasail_result_get_similar_table(self.pointer),
            self.len_query, self.len_ref
        )

    @property
    def length_table(self):
        if 0 == _lib.parasail_result_is_stats_table(self.pointer):
            raise AttributeError("'Result' object has no stats tables")
        return _make_2d_array(
            _lib.parasail_result_get_length_table(self.pointer),
            self.len_query, self.len_ref
        )

    @property
    def score_row(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_score_row(self.pointer),
            self.len_ref
        )

    @property
    def matches_row(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_matches_row(self.pointer),
            self.len_ref
        )

    @property
    def similar_row(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_similar_row(self.pointer),
            self.len_ref
        )

    @property
    def length_row(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_length_row(self.pointer),
            self.len_ref
        )

    @property
    def score_col(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_score_col(self.pointer),
            self.len_query
        )

    @property
    def matches_col(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_matches_col(self.pointer),
            self.len_query
        )

    @property
    def similar_col(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_similar_col(self.pointer),
            self.len_query
        )

    @property
    def length_col(self):
        if 0 == _lib.parasail_result_is_rowcol(self.pointer):
            raise AttributeError("'Result' object has no row/col arrays")
        return _make_1d_array(
            _lib.parasail_result_get_length_col(self.pointer),
            self.len_query
        )

    @property
    def cigar(self):
        cdef Cigar c
        if 0 == _lib.parasail_result_is_trace(self.pointer):
            raise AttributeError("'Result' object has no traceback")
        c = Cigar()
        c.pointer = _lib.parasail_result_get_cigar(self.pointer, self.query,
                                                   self.len_query, self.ref,
                                                   self.len_ref, self.matrix)
        return c
