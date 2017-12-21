cdef extern from "parasail.h":
    struct parasail_result:
        pass

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

    # Lookup substitution matrix by name.
    parasail_matrix* parasail_matrix_lookup(const char *matrixname)

    # Deallocate substitution matrix.
    void parasail_matrix_free(parasail_matrix *matrix)

    # Copy any matrix into wriㅠteable matrix.
    parasail_matrix* parasail_matrix_copy(const parasail_matrix *original)

    # Modify a user matrix.
    void parasail_matrix_set_value(parasail_matrix *matrix, int row, int col, int value)

    struct parasail_result_ssw:
        pass
    
    parasail_result_ssw* parasail_ssw(
        const char * const restrict s1, const int s1Len,
        const char * const restrict s2, const int s2Len,
        const int open, const int gap,
        const parasail_matrix* matrix)
