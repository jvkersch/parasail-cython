cimport _parasail as _lib


def parasail_version():
    cdef int major, minor, patch
    _lib.parasail_version(&major, &minor, &patch)
    return (major, minor, patch)
