cdef extern from "parasail.h":
    struct parasail_result_t:
        pass

    void parasail_version(int *major, int *minor, int *patch)
