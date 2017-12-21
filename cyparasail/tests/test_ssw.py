import unittest

import numpy.testing as nptest

import cyparasail as parasail


class TestSSW(unittest.TestCase):

    def test_basic_ssw(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"

        res = parasail.ssw(s1, s2, 10, 1, parasail.pam10)

        self.assertEqual(res.score1, 32)
        self.assertEqual(res.ref_begin1, 1)
        self.assertEqual(res.ref_end1, 6)
        self.assertEqual(res.read_begin1, 0)
        self.assertEqual(res.read_end1, 4)
        self.assertEqual(res.cigarLen, 3)
        nptest.assert_array_equal(res.cigar, [55, 18, 39])
