from core.infra import DbUtils as db
from src.main.core.infra.utils import tools as tool
from src.main.core.infra import AlphaVantageConsumer as av
import datetime
import re
###########################################################
#  Company class
#    inheritable methods ~
#       store, fetch, api_fetch
#
###########################################################

class Company: #company can be the base class for statements, ratios and prices in which they can inherit from this company class
    def __init__(self, ticker, type, api_class):
        self.ticker = ticker
        self.type = type # Company, BS, IS, CF, Price
        self.api_class = api_class #'OVERVIEW', 'INCOME_STATEMENT', 'BALANCE_SHEET', 'CASH_FLOW'
        self.creds = tool.get_resources('creds')
        self.queries = tool.get_resources('queries')

    def fetch(self, cls): #generic
        #fetch company information from the company
        DB = db.DB_cnn(self.creds['DB'])
        DB.fetch(self.queries[self.type]['fetch'])

    def api_fetch(self):
        key = self.creds['Alpha']['key']
        url = self.creds['Alpha']['fs_url']
        url = url.format(self.api_class, self.ticker, key) #formatting the url for raising request
        #fetch the data
        API = av.API(url)
        data = API.request() #returning data from API request
        record = self.parse(data) #move to the API level
        self.store_company(record)

    def parse(self, data): #parse method should be at the API class level!
        omitted_cols = self.queries[self.type]['omitted'].split(',')
        now = datetime.datetime.now()
        records = {}

        record = []
        for item in data:
            if item not in omitted_cols:
                if item not in omitted_cols:  # omitted cols represent values not being stored in DB
                    # date
                    if re.match('[0-9]{4}\-[0-9]{2}\-[0-9]{2}', data[item]):
                        dt_split = data[item].split('-')
                        data[item] = datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2]))
                    # number
                    # elif not re.match('[A-Za-z]', data[item]):
                    #     data[item] = int(data[item])
                    # null data
                    elif data[item] == "None":
                        data[item] = None
                    # adding cleaned data to a list
                    record.append(data[item])

        record.append('AP001')  # app ID
        record.append(now)  # time stored in table
        records[self.ticker] = tuple(record)

        return records

    def store_company(self, records):
        DB = db.DB_cnn(self.creds['DB'])
        DB.store(self.queries[self.type]['store'], records)