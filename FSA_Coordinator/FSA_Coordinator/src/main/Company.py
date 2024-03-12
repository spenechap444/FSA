from core.infra import DbUtils as db
from src.main.core.infra.utils import tools as tool
from src.main.core.infra import AlphaVantageConsumer as av
import datetime
import re
import queue
import threading


class Company_v1:
    def __init__(self, ticker):
        self.ticker = ticker
        self.creds = tool.get_resources('creds')
        self.queries = tool.get_resources('queries')

    def store(self, type): #utilizing API_v1 class, getting rid of api_fetch method
        #type 'OVERVIEW', 'INCOME_STATEMENT', 'BALANCE_SHEET', 'CASH_FLOW'
        API = av.API_v1(self.ticker)
        #data type mapping handled from API method
        if type == 'TIME_SERIES_INTRADAY':
            #pricing window logic
            DB = db.DB_cnn(self.creds['DB'])
            price_config = DB.db_func(self.queries['PRICE_LOAD_LOOKUP']['fetch'], (self.ticker,))
            # no pricing config record available
            if len(price_config) == 0:
                window = None # set max window
                part_name = DB.db_func(self.queries[type]['util'], (self.ticker, 'STOCK_PRICES', 'INTRADAY')) #creating table partition
                print(f'Partition {part_name} created...')
            else:
                window =  list(price_config[0])[1]
            output = API.request_prices(type, '15min', window)
            #data should return a dictionary with latest window as key. Store this key in price config table
            latest_window = str([k for k in output.keys()][0])
            window_formatted = datetime.datetime.strptime(latest_window, '%Y-%m-%d %H:%M:%S')
            DB.store(self.queries['PRICE_LOAD_LOOKUP']['store'], {self.ticker: (self.ticker, window_formatted,None,None,None,None,None,None,None)})
            data = output[latest_window] #restructuring request prior to storing
        else:
            # parse statement called within request_company method
            data = API.request_company(type)

        DB = db.DB_cnn(self.creds['DB'])
        DB.store(self.queries[type]['store'], data)

    def store_intraday_prices(self, interval):
        API = av.API_v1(self.ticker)
        DB = db.DB_cnn(self.creds['DB'])
        price_config = DB.db_func(self.queries['PRICE_LOAD_LOOKUP']['fetch'], (self.ticker,))

        if len(price_config) == 0: #no pricing config record available:
            window = None #max window
            part_name = DB.db_func(self.queries['TIME_SERIES_INTRADAY']['util'], (self.ticker, 'STOCK_PRICES', 'INTRADAY')) #creating table partition
            print(f'Partition {part_name} created...')
        else:
            window = list(price_config[0])[1]

        stream = API.request_prices('TIME_SERIES_INTRADAY', interval, window) #window serves as price refresh ts

        date_flag = False  # whether we've found the pricing record
        start = False  # whether we should create a new window mapping
        output = {}  # window mapping
        count = 0
        dtype_file = tool.get_resources('dtype_map')
        dtypes = dtype_file['TIME_SERIES_INTRADAY']['stored']
        create_ts = datetime.datetime.now()

        for item in stream:
            item_lst = list(item)
            key = item_lst[0]
            field = item_lst[1]

            if date_flag == True:   # starting boundary found
                if start == True:   # expecting date
                    if key == 'map_key':
                        date = datetime.datetime.strptime(field, '%Y-%m-%d %H:%M:%S')
                        output[date] = [date] # create new window mapping
                        start = False
                        count+=1 #maintaining counter for chunking data

                else:   # expecting values
                    if key == 'string':
                        output[date].append(API.parse_price(field, dtypes)) #function for formatting data type
                    elif key == 'end_map': # all window mapping fields found
                        if count == 0:
                            latest_window = date # saving price config table entry
                        output[date].append('AVAPI')
                        output[date].append(create_ts)
                        output[date] = tuple(output[date])
                        start = True # start new window mapping

            else:   # searching for fields to store
                if key == 'map_key' and field == f'Time Series ({interval})':
                    date_flag = True    # breaker for starting boundary
                    start = True        # breaker for new window mapping

    def fetch_company(self): #in future, will need to be able to fetch by industry/sector
        DB = db.DB_cnn(self.creds['DB'])
        return DB.db_func(self.queries['OVERVIEW']['fetch'], (self.ticker,))

    def fetch_statement(self, type, fiscalDateEnd):
        DB = db.DB_cnn(self.creds['DB'])
        if fiscalDateEnd is not None:
            dt_split = fiscalDateEnd.split('-')
            date_param = datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2]))
        else:
            date_param = None
        params = (self.ticker, date_param)
        return DB.db_func(self.queries[type]['fetch'], params)

#old implementation
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
        DB.db_func(self.queries[self.type]['fetch'])

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