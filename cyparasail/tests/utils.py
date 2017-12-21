from os.path import join as pjoin, dirname
import numpy as np


def data_dir(fname):
    folder = dirname(__file__)
    return pjoin(folder, 'data', fname)


def read_pam10():
    path = data_dir('pam10.txt')
    return np.genfromtxt(path, skip_header=1, usecols=list(range(1, 25)))
