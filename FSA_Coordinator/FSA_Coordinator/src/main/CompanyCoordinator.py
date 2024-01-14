from core.infra import DbUtils as db
from src.main.core.infra.utils import tools as tool
from consumer import AlphaVantageConsumer as av
import datetime
import re
###########################################################
#  Company class
#    inheritable methods ~
#       store, fetch, api_fetch
#

class Company: #company can be the base class for statements, ratios and prices in which they can inherit from this company class
    def __init__(self, ticker):
        self.ticker = ticker
        self.creds = tool.get_resources('creds')
        self.queries = tool.get_resources('queries')

    def fetch_company(self): #need to still build DB components
        #fetch company information from the company
        DB = db.DB_cnn(self.creds['DB'])
        DB.fetch(self.queries['Company'])

    def api_fetch(self):
        key = self.creds['Alpha']['key']
        url = self.creds['Alpha']['fs_url']
        type = 'OVERVIEW'
        url = url.format(type, self.ticker, key)
        #fetch the data
        API = av.API(url)
        data = API.request()
        print(data)
        record = self.parse(data)
        self.store_company(record)
        # return data

    def parse(self, data): #parse method should be at the API class level!
        omitted_cols = self.queries['Company']['omitted'].split(',')
        # print(omitted_cols)
        now = datetime.datetime.now()
        record = []
        for item in data:
            if item not in omitted_cols:
                if item not in omitted_cols:  # omitted cols represent values not being stored in DB
                    print(item)
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

        return tuple(record)

    def store_company(self, record):
        DB = db.DB_cnn(self.creds['DB'])
        DB.store(self.queries['Company']['store'], record)
        print('Record stored successfully')
        #need to still build out the DB components
        #call the api only if the record is not present in the DB
            #fetch -> if 0 records then call api and store in DB
