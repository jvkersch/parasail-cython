import unittest

import numpy as np
import numpy.testing as nptest

import cyparasail as parasail
from cyparasail.align import align


class TestResult(unittest.TestCase):

    def test_assert_nostats(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1, matrix=parasail.pam10, method='nw')

        self.assertFalse(res.saturated)
        self.assertEqual(res.score, 18)
        self.assertEqual(res.end_query, 5)
        self.assertEqual(res.end_query, 5)

        with self.assertRaises(AttributeError):
            res.matches
        with self.assertRaises(AttributeError):
            res.similar
        with self.assertRaises(AttributeError):
            res.length

    def test_assert_stats(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1, method='nw',
                    matrix=parasail.pam10, stats=True)

        self.assertFalse(res.saturated)
        self.assertEqual(res.score, 18)
        self.assertEqual(res.end_query, 5)
        self.assertEqual(res.end_query, 5)
        self.assertEqual(res.matches, 4)
        self.assertEqual(res.similar, 4)
        self.assertEqual(res.length, 8)

    def test_table(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1,
                    matrix=parasail.pam10,
                    method='nw',
                    table=True)

        nptest.assert_array_equal(
            res.score_table, np.array(
                [[9, -1, -2, -3, -4, -5, -6, -7],
                 [-1, 18,  8,  7,  6,  5,  4,  3],
                 [-2,  8, 17, 16,  6,  5,  4,  3],
                 [-3,  7,  7, 10,  3, 13,  3,  2],
                 [-4,  6,  6,  5,  2,  3, 22, 12],
                 [-5,  5,  5,  4, -6,  2, 12, 18]]))

    def test_stats_table(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1, method='nw', stats=True,
                    table=True, matrix=parasail.pam10)

        nptest.assert_array_equal(
            res.matches_table, np.array(
                [[1, 1, 1, 1, 1, 1, 1, 1],
                 [1, 2, 2, 2, 2, 2, 2, 2],
                 [1, 2, 2, 3, 2, 2, 2, 2],
                 [1, 2, 2, 2, 3, 3, 3, 3],
                 [1, 2, 2, 3, 2, 3, 4, 4],
                 [1, 2, 2, 3, 2, 3, 4, 4]]))

        nptest.assert_array_equal(
            res.similar_table, np.array(
                [[1, 1, 1, 1, 1, 1, 1, 1],
                 [1, 2, 2, 2, 2, 2, 2, 2],
                 [1, 2, 2, 3, 2, 2, 2, 2],
                 [1, 2, 2, 2, 3, 3, 3, 3],
                 [1, 2, 2, 3, 2, 3, 4, 4],
                 [1, 2, 2, 3, 2, 3, 4, 4]]))

        nptest.assert_array_equal(
            res.length_table, np.array(
                [[1, 1, 1, 4, 5, 6, 7, 8],
                 [1, 2, 2, 4, 5, 6, 7, 8],
                 [3, 3, 3, 3, 5, 6, 7, 8],
                 [4, 4, 4, 4, 4, 6, 7, 8],
                 [5, 5, 5, 5, 5, 7, 7, 8],
                 [6, 6, 6, 6, 8, 8, 8, 8]]))

    def test_stats_rowcol(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(s1, s2, 10, 1, method='nw', stats=True,
                    rowcol=True, matrix=parasail.pam10)

        nptest.assert_array_equal(res.score_row, [-5, 5, 5, 4, -6, 2, 12, 18])
        nptest.assert_array_equal(res.matches_row, [1, 2, 2, 3, 2, 3, 4, 4])
        nptest.assert_array_equal(res.similar_row, [1, 2, 2, 3, 2, 3, 4, 4])
        nptest.assert_array_equal(res.length_row, [6, 6, 6, 6, 8, 8, 8, 8])
        nptest.assert_array_equal(res.score_col, [-7,  3,  3,  2, 12, 18])
        nptest.assert_array_equal(res.matches_col, [1, 2, 2, 3, 4, 4])
        nptest.assert_array_equal(res.similar_col, [1, 2, 2, 3, 4, 4])
        nptest.assert_array_equal(res.length_col, [8, 8, 8, 8, 8, 8])

    def test_cigar(self):
        s1 = "QQEGIL"
        s2 = "QQQERGII"
        res = align(
            s1, s2, 10, 1, method='nw', matrix=parasail.pam10, trace=True
        )

        self.assertIsNotNone(res.cigar)
