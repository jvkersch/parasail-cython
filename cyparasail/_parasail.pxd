cimport numpy as cnp


cdef extern from "parasail.h":

    struct parasail_result_extra_stats_tables:
        # DP table of scores
        int *score_table
        # DP table of exact match counts
        int *matches_table
        # DP table of similar substitution counts
        int *similar_table
        # DP table of lengths
        int *length_table

    struct parasail_result_extra_stats_rowcols:
        # last row of DP table of scores
        int *score_row
        # last row of DP table of exact match counts
        int *matches_row
        # last row of DP table of similar substitution counts
        int *similar_row
        # last row of DP table of lengths
        int *length_row
        # last col of DP table of scores
        int *score_col
        # last col of DP table of exact match counts
        int *matches_col
        # last col of DP table of similar substitution counts
        int *similar_col
        # last col of DP table of lengths
        int *length_col

    union parasail_result_extra_stats_union:
        void *extra
        parasail_result_extra_stats_tables *tables;
        parasail_result_extra_stats_rowcols *rowcols;

    struct parasail_result_extra_stats:
        # number of exactly matching characters in the alignment
        int matches
        # number of similar characters (positive substitutions) ibn the alignment
        int similar
        # length of the alignment
        int length
        # data
        parasail_result_extra_stats_union un

    struct parasail_result_extra_tables:
        pass

    struct parasail_result_extra_rowcols:
        pass

    struct parasail_result_extra_trace:
        pass

    union parasail_results_extra:
        void *extra
        parasail_result_extra_stats *stats
        parasail_result_extra_tables *tables
        parasail_result_extra_rowcols *rowcols
        parasail_result_extra_trace *trace

    struct parasail_result:
        # alignment score
        int score
        # end position of query sequence
        int end_query
        # end position of reference sequence
        int end_ref
        # bit field for various flags
        int flag

        # union of pointers to extra result data based on the flag
        parasail_results_extra un

    struct parasail_matrix:
        const char* name
        const int* matrix
        const int* mapper
        int size
        int max
        int min
        int* user_matrix

    # Run-time API version detection
    void parasail_version(int *major, int *minor, int *patch)

    # Deallocate result.
    void parasail_result_free(parasail_result *result)

    # Lookup substitution matrix by name.
    parasail_matrix* parasail_matrix_lookup(const char *matrixname)

    # Deallocate substitution matrix.
    void parasail_matrix_free(parasail_matrix *matrix)

    # Copy any matrix into writeable matrix.
    parasail_matrix* parasail_matrix_copy(const parasail_matrix *original)

    # Modify a user matrix.
    void parasail_matrix_set_value(parasail_matrix *matrix, int row, int col, int value)

    struct parasail_result_ssw:
        cnp.uint16_t score1
        cnp.int32_t ref_begin1
        cnp.int32_t ref_end1
        cnp.int32_t read_begin1
        cnp.int32_t read_end1
        cnp.uint32_t *cigar
        cnp.int32_t cigarLen

    parasail_result_ssw* parasail_ssw(
        const char * const s1, const int s1Len,
        const char * const s2, const int s2Len,
        const int open, const int gap,
        const parasail_matrix* matrix)

    void parasail_result_ssw_free(parasail_result_ssw *result)

    # The following functions help access result attributes.
    int parasail_result_is_saturated(const parasail_result * const result)
    int parasail_result_is_stats(const parasail_result * const result)
    int parasail_result_is_stats_table(const parasail_result * const result)
    int parasail_result_is_table(const parasail_result * const result)
    int parasail_result_is_rowcol(const parasail_result * const result)

    int parasail_result_get_matches(const parasail_result * const result)
    int parasail_result_get_similar(const parasail_result * const result)
    int parasail_result_get_length(const parasail_result * const result)

    int* parasail_result_get_score_table(const parasail_result * const result)
    int* parasail_result_get_matches_table(const parasail_result * const result)
    int* parasail_result_get_similar_table(const parasail_result * const result)
    int* parasail_result_get_length_table(const parasail_result * const result)
    int* parasail_result_get_score_row(const parasail_result * const result)
    int* parasail_result_get_matches_row(const parasail_result * const result)
    int* parasail_result_get_similar_row(const parasail_result * const result)
    int* parasail_result_get_length_row(const parasail_result * const result)
    int* parasail_result_get_score_col(const parasail_result * const result)
    int* parasail_result_get_matches_col(const parasail_result * const result)
    int* parasail_result_get_similar_col(const parasail_result * const result)
    int* parasail_result_get_length_col(const parasail_result * const result)
