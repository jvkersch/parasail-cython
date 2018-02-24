import unittest

import cyparasail as parasail


class TestBase(unittest.TestCase):

    def test_version(self):
        version = parasail.parasail_version()
        self.assertEqual(version, (2, 1, 0))
