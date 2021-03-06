from .support import parasail_version  # noqa
from .matrix import Matrix  # noqa
from .profile import Profile  # noqa
from .ssw import ssw, SSWResult  # noqa


# TODO Lazily insert matrices into namespace.
_score_matrix_names = [
    'blosum100', 'blosum30', 'blosum35', 'blosum40', 'blosum45', 'blosum50',
    'blosum55', 'blosum60', 'blosum62', 'blosum65', 'blosum70', 'blosum75',
    'blosum80', 'blosum85', 'blosum90', 'pam10', 'pam100', 'pam110', 'pam120',
    'pam130', 'pam140', 'pam150', 'pam160', 'pam170', 'pam180', 'pam190',
    'pam20', 'pam200', 'pam210', 'pam220', 'pam230', 'pam240', 'pam250',
    'pam260', 'pam270', 'pam280', 'pam290', 'pam30', 'pam300', 'pam310',
    'pam320', 'pam330', 'pam340', 'pam350', 'pam360', 'pam370', 'pam380',
    'pam390', 'pam40', 'pam400', 'pam410', 'pam420', 'pam430', 'pam440',
    'pam450', 'pam460', 'pam470', 'pam480', 'pam490', 'pam50', 'pam500',
    'pam60', 'pam70', 'pam80', 'pam90', 'dnafull', 'nuc44'
]
globals().update({name: Matrix(name) for name in _score_matrix_names})
del _score_matrix_names
