import unittest

import numpy.testing as nptest

import cyparasail as parasail
from cyparasail.align import align


class TestCigar(unittest.TestCase):

    def test_cigar(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1, matrix=parasail.pam10, method='nw',
                    trace=True)
        cigar = res.cigar

        nptest.assert_array_equal(cigar.seq, [39, 24, 34, 39, 24])
        self.assertEqual(cigar.len, 5)
        self.assertEqual(cigar.beg_query, 0)
        self.assertEqual(cigar.beg_ref, 0)
        self.assertEqual(cigar.decode, '2=1X2D2=1X')
