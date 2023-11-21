#This file is meant for contacting the AlphaVantage API to consume Data
import requests
import datetime
import re


class API:
    def __init__(self, ticker, api_key, url):
        self.__ticker = ticker
        self.__api_key = api_key
        self.__url = url
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
        omitted_cols = ['capitalLeaseObligations', 'longTermDebt', 'otherCurrentLiabilities', 'otherNonCurrentLiabilities']
        ticker = self.output['symbol']
        now = datetime.datetime.now()
        reports = {}
        #prepping the data for storing in the database
        for statement in self.output['quarterlyReports']:
            statement_values = [] #initializing empty list for fiscal period data
            statement_values.append(ticker)
            fiscalDateEnd = statement['fiscalDateEnding']
            for item in statement:
                if item not in omitted_cols:
                    #date
                    if re.match('[0-9]{4}\-[0-9]{2}\-[0-9]{2}', statement[item]):
                        dt_split = statement[item].split('-')
                        statement[item] = datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2]))
                    #number
                    elif re.match('[0-9]', statement[item]):
                        statement[item] = int(statement[item])
                    #null data
                    elif statement[item] == "None":
                        statement[item] = None

                    # adding cleaned data to a list
                    statement_values.append(statement[item])

                # Adding values to the end of the report
            statement_values.append('AP001')  # app ID
            statement_values.append(now)  # time stored in table

            # storing list as a tuple in dictionary
            reports[(ticker, fiscalDateEnd)] = tuple(statement_values)
            #symbol and fiscal date end are primary keys in all 3 tables
        self.output = reports


    #public~ service level method
    def api_fetch(self, statement):
        # based on input, API request will fetch statement of choice
        if statement == 'IS':
            report = 'INCOME_STATEMENT'
        elif statement == 'BS':
            report = 'BALANCE_SHEET'
        elif statement == 'CF':
            report = 'CASH_FLOW'
        else:
            print(
                'Invalid statement ~ Available options:\n\tIS: Income Statement\n\tBS: Balance Sheet\n\tCF: Statement of Cash Flows')

        url_instance = self.__url.format(report, self.__ticker, self.__api_key)
        self.request(url_instance)
        self.parse()