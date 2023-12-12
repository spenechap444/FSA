import os
import json
import re
import datetime
from core.infra import DbUtils as db
from consumer import AlphaVantageConsumer as av

class Statement: #statement should be initialized with the output from API request
    def __init__(self, type, ticker):
        self.type = type #statement type
        self.ticker = ticker #company ticker

    #private method
    def getCreds(self, fname):
    #os.path.dirname(__file__) #gets directory of the current script
        resource_path = os.path.join(os.path.dirname(__file__), 'core','resources', f'{fname}.json')
        with open(resource_path,'r') as f:
            resources = json.load(f)

        return resources

    #private method ~ done prior to storing the data in the database
    def parse(self, data):
        # formatting the output from API to be in format for DB
        resources = self.getCreds('queries')
        omitted = resources[self.type]['omitted']
        omitted_cols = omitted.split(',')
        print(omitted_cols)

        # ticker = data['symbol'] --already have self.ticker
        now = datetime.datetime.now()
        reports = {}
        #prepping the data for storing in the database
        for statement in data['quarterlyReports']:
            statement_values = [self.ticker]  #initializing list with ticker
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
            reports[(self.ticker, fiscalDateEnd)] = tuple(statement_values)
            #symbol and fiscal date end are primary keys in all 3 tables
        return reports

    def api_fetch(self):
        #constructing API url
        creds = self.getCreds('creds')
        if self.type == 'IS':
            report = 'INCOME_STATEMENT'
        elif self.type == 'BS':
            report = 'BALANCE_SHEET'
        elif self.type == 'CF':
            report = 'CASH_FLOW'
        key = creds['Alpha']['key']
        url = creds['Alpha']['fs_url']
        url = url.format(report, self.ticker, key)
        #fetch the data
        API = av.API(url)
        data = API.request()
        #prep the data
        parsed_data = self.parse(data)
        #store the data
        self.store(parsed_data)

    def store(self, data):
        query = self.getCreds('queries')
        creds = self.getCreds('creds')
        cnn = db.DB_cnn(creds['DB'])
        conn = cnn.open_cnn()
        cursor = conn.cursor()
        for record in data:
            cursor.execute(query[self.type]['store'], data[record]) #calling proc passing tuple of records
        cursor.execute('COMMIT;')
        conn.close()