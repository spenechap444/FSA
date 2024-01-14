import pandas as pd
import StatementCoordinator as sc

class Ratio:
    def __init__(self, ticker): #allow for multiple tickers or industry in future versions
        self.ticker = ticker

    def profitability(self):
        data = self.fetch_data()  # running method to fetch data
        headers = self.getCreds('headers')  # getting headers for dataframe
        data = pd.DataFrame(data, columns=headers[self.type])
        IS = sc.Statement()
        # for i in range(len(data)):

