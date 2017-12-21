def B(s):
    return s.encode('latin-1')


def D(b):
    return b.decode('latin-1')


def isstr(s):  # python 3 only
    return isinstance(s, str)
