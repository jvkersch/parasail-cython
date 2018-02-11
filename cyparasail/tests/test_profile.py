import unittest

from cyparasail import Profile, nuc44


class TestProfile(unittest.TestCase):

    def test_profile_simple(self):
        p = Profile("actg", nuc44, "nw", vector="scan", stats=True)
        res = p.align("aatg", 12, 4)
        self.assertEqual(res.matches, 3)
