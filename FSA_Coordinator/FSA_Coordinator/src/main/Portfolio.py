from src.main.core.infra.utils import tools as tool
import os
import pandas as pd

class Portfolio:
    def __init__(self, name):
        self.name = name
        self.positions = pd.read_csv(os.path.dirname(__file__), 'core', 'infra', 'resources', 'input_files', 'positions.csv')


