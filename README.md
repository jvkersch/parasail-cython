# Cython bindings for the parasail sequence alignment library

[![Build Status](https://travis-ci.org/jvkersch/parasail-cython.svg?branch=master)](https://travis-ci.org/jvkersch/parasail-cython)

This library provides Cython bindings for the
[parasail](https://github.com/jeffdaily/parasail) sequence alignment
library.

This is very much work in progress: check out the "helping out" section below
for a selection of tasks if you're interested in helping out. Open tasks range
from exposing more of the API to streamling the build/install process, so
there's something for everybody!

## Installation from source

You'll need to install [parasail](https://github.com/jeffdaily/parasail)
according to the instructions provided with the library. Then, set the
`PARASAIL_LIB` and `PARASAIL_INCLUDE` variables to point to the parasail
install location. For example:

```bash
export PARASAIL_LIB=/usr/local/parasail/lib
export PARASAIL_INCLUDE=/usr/local/parasail/include
```

Once that is done, install parasail-cython via
```
pip install cython numpy
pip install git+https://github.com/jvkersch/parasail-cython
```

## Using the library

The api is designed to match the api of the excellently-documented
[parasail-python](https://github.com/jeffdaily/parasail-python) as closely as
possible.

An example session:

```python
>>> import cyparasail as parasail
>>> result = parasail.parasail_nw_trace("QQEGIL", "QQQERGII", 10, 1, parasail.pam10)
>>> result.cigar.decode
'3X2D3X'
>>> result = parasail.parasail_nw_stats("QQEGIL", "QQQERGII", 10, 1, parasail.pam10)
>>> result.matches
4
>>> result.score
18
```

## Helping out/reporting bugs/commenting

The library is currently under heavy development, and all help is welcome. Have
a look at the [issue
tracker](https://github.com/jvkersch/parasail-cython/issues) on GitHub for more
information. Open issues range from exposing more of the api to streamlining
the build process.

If you find a problem with this library, have a feature request, or want to
discuss the library, please also open an issue.

## Citations

Please consider citing the original paper for [parasail](https://github.com/jeffdaily/parasail/):

Daily, Jeff. (2016). Parasail: SIMD C library for global, semi-global, and
local pairwise sequence alignments. *BMC Bioinformatics*, 17(1),
1-11. doi:10.1186/s12859-016-0930-z

http://dx.doi.org/10.1186/s12859-016-0930-z

## License

This code is licensed under the [3-part BSD license](COPYING).
