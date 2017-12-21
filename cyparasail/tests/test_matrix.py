import re
import unittest

import numpy.testing as nptest

import cyparasail as parasail

from .utils import read_pam10


class TestMatrix(unittest.TestCase):

    def test_from_name(self):
        m = parasail.Matrix("pam10")
        self.assertEqual(m.name, "pam10")

    def test_data(self):
        m = parasail.Matrix("pam10")
        raw_pam10 = read_pam10()

        nptest.assert_array_equal(m.matrix, raw_pam10)

    def test_simple_properties(self):
        m = parasail.Matrix("pam10")

        self.assertEqual(m.size, 24)
        self.assertEqual(m.min, -23)
        self.assertEqual(m.max, 13)

    def test_set_user_value(self):
        m = parasail.Matrix("pam10")
        user_m = m.copy()
        raw_pam10 = read_pam10()

        user_m.set_value(2, 3, -100)
        nptest.assert_array_equal(m.matrix, raw_pam10)

        modified_pam10 = raw_pam10.copy()
        modified_pam10[2, 3] = -100
        nptest.assert_array_equal(user_m.matrix, modified_pam10)

    def test_setitem(self):
        m = parasail.Matrix("pam10")
        user_m = m.copy()
        raw_pam10 = read_pam10()

        user_m[2, 3] = -100
        nptest.assert_array_equal(m.matrix, raw_pam10)

        modified_pam10 = raw_pam10.copy()
        modified_pam10[2, 3] = -100
        nptest.assert_array_equal(user_m.matrix, modified_pam10)


class TestMatrixGlobals(unittest.TestCase):

    def _filter_by_regex(self, items, regex):
        return [item for item in items if re.match(regex, item)]

    def test_matrix_imports(self):
        names = dir(parasail)

        blosums = self._filter_by_regex(names, "blosum\d+$")
        self.assertEqual(len(blosums), 15)

        pams = self._filter_by_regex(names, "pam\d+$")
        self.assertEqual(len(pams), 50)

        self.assertIn("dnafull", names)
        self.assertIn("nuc44", names)
