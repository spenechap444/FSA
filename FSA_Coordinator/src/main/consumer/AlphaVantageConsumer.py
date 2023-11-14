#This file is meant for contacting the AlphaVantage API to consume Data
import requests

class API:
    def __init__(self, ticker, api_key):
        self.__ticker = ticker
        self.__api_key = api_key
        self.output = None

    #private method
    def request(self, url):
        response = requests.get(url)
        if response.status_code == 200:
            self.output = response.json()  # json output
        else:
            print('Error occurred while making the request.')

    #private method
    def parse(self):
        # formatting the output from API to be in format for DB
        ticker = self.output['symbol']
        reports = {}
        for statement in self.output['quarterlyReports']:
            fiscalDateEnd = statement['fiscalDateEnding']
            reports[(ticker, fiscalDateEnd)] = statement
            #symbol and fiscal date end are primary keys in all 3 tables

        self.output = reports

    #public~ service level method
    def api_fetch(self, statement):
        # based on input, API request will fetch statement of choice
        if statement == 'IS':
            report = 'INCOME_STATEMENT'
            url = f'https://www.alphavantage.co/query?function={report}&symbol={self.__ticker}&apikey={self.__api_key}'
        elif statement == 'BS':
            report = 'BALANCE_SHEET'
            url = f'https://www.alphavantage.co/query?function={report}&symbol={self.__ticker}&apikey={self.__api_key}'
        elif statement == 'CF':
            report = 'CASH_FLOW'
        else:
            print(
                'Invalid statement ~ Available options:\n\tIS: Income Statement\n\tBS: Balance Sheet\n\tCF: Statement of Cash Flows')

        url = f'https://www.alphavantage.co/query?function={report}&symbol={self.__ticker}&apikey={self.__api_key}'
        self.request_url(url)
        self.parse()