from src.main.core.infra.utils import tools as tool
import os
import pandas as pd
import src.main.Company as co

class Portfolio:
    def __init__(self, name):
        self.name = name
        self.positions = pd.read_csv(os.path.join(os.path.dirname(__file__), 'core', 'resources', 'input_files', 'positions.csv'))

    def initialize_positions(self):
        for i in range(len(self.positions)):
            ticker = self.positions.iloc[i].iloc[0]
            print(ticker)
            company = co.Company_v1(ticker)
            # company.store('BALANCE_SHEET')
            # company.store('OVERVIEW')
            company.store('TIME_SERIES_INTRADAY')
            # for item in company.fetch_statement('BALANCE_SHEET', None):
            #     print(item)

    def analyze_benchmarks(self):
        pass

    def forecast_value(self):
        pass

    def generate_report(self):
        pass