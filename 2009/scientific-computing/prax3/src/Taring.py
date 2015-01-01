# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

from random import Random

# Abiklass täringuvisete jaoks.
class Taring:
    def __init__(self):
        self.random = Random()
    
    # Teostab täringu viske.
    # Tagastab viske tulemuse täisarvuna 1,...,6.
    def viska(self):
        return self.random.randint(1, 6)