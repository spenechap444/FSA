#This file is meant for contacting the AlphaVantage API to consume Data
import requests
import os
import json
import ijson
import src.main.core.infra.utils.tools as tool
import datetime

class API_v1:
    def __init__(self, ticker):
        self.ticker = ticker
        self.creds = tool.get_resources('creds')

    #In future, can modularize making the actual request to reduce redundancy and parameterize the parse method used
    def request_company(self, type, max_retries=3, timeout=10):
        retries = 0
        key = self.creds['Alpha']['key']
        url = self.creds['Alpha']['fs_url']
        url = url.format(type, self.ticker, key) #type is BALANCE_SHEET,CASH_FLOW,INCOME_STATEMENT etc...
        while retries < max_retries:
            try:
                response=requests.get(url,timeout=timeout)
                response.raise_for_status() #Raises an HTTP Error for bad responses
                if type=='OVERVIEW':
                    return self.parse_company(response.json(), type)
                else:
                    return self.parse_statement(response.json(), type)
            except requests.exceptions.RequestException as req_exc:
                print(f"Request failed: {req_exc}")
                retries+=1
            except Exception as e:
                print(f"Error encountered: {e}")
                retries+=1
        print('Max retries reached for company requests.  Unable to complete the request')

    def request_prices(self, type, interval, refresh_ts,max_retries=3,timeout=10):
        retries = 0
        key = self.creds['Alpha']['key']
        if refresh_ts == None:
            url = self.creds['Alpha']['bulk_prices_url']
            url = url.format(type, self.ticker, interval, key) #month not passed when all pricing history required
        else:
            month_lst = str(refresh_ts).split(' ')[0].split('-')[:2]
            month = f"{month_lst[0]}-{month_lst[1]}" #formatting for API request
            url = self.creds['Alpha']['prices_url']
            url = url.format(type, self.ticker, interval, month, key) #month passed when historical pricing data in DB
        while retries < max_retries:
            try:
                response=requests.get(url,timeout=timeout)
                response.raise_for_status() #Raises an HTTP Error for bad responses
                stream = ijson.basic_parse(response.content)

            except requests.exceptions.RequestException as req_exc:
                print(f"Request failed: {req_exc}")
                retries+=1
            except Exception as e:
                print(f"Error encountered: {e}")
                retries+=1

        return stream

    def parse_company(self, response, type):
        dtype_file = tool.get_resources('dtype_map')
        dtypes = dtype_file[type]['stored']
        omitted = dtype_file[type]['omitted']
        fields = []
        for item in response:
            if item in dtypes:
                itemDataType = dtypes[item]
                if response[item] == 'None':
                    fields.append(None)
                elif itemDataType == 'date':
                    dt_split = response[item].split('-')
                    fields.append(datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2])))
                elif itemDataType == 'int':
                    fields.append(int(response[item]))
                elif itemDataType == 'float':
                    fields.append(float(response[item]))
                else:
                    fields.append(response[item]) #string data

        fields.append('AVAPI')
        fields.append(datetime.datetime.now())
        print(fields)
        return {self.ticker: tuple(fields)}

    def parse_statement(self, response,type):
        dtype_file = tool.get_resources('dtype_map')
        dtypes = dtype_file[type]['stored']
        omitted = dtype_file[type]['omitted']
        records_formatted = {} #initializing dictionary for output

        for report in response['quarterlyReports']:
            fields = [self.ticker]
            for record in report:
                if record in dtypes: #parsing only required fields to store
                    # fetching data type from dtype_map
                    itemDataType = dtypes[record]
                    #data type mapping
                    if report[record] == 'None':
                        fields.append(None)
                    elif itemDataType == 'date':
                        fiscalDateEnd = report[record] #capturing dictionary key
                        dt_split = report[record].split('-')
                        fields.append(datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2])))
                    elif itemDataType == 'int':
                        fields.append(int(report[record]))
                    else:
                        fields.append(report[record]) #string data

            fields.append('AVAPI')
            fields.append(datetime.datetime.now())
            records_formatted[fiscalDateEnd] = tuple(fields)
            print(f'{self.ticker} --- {fiscalDateEnd} data parsed')
            print(records_formatted[fiscalDateEnd])

        return records_formatted #{[fiscalDateEnding]: tuple of records}

    def parse_prices(self, response,type,interval):
        dtype_file = tool.get_resources('dtype_map')
        dtypes = dtype_file[type]['stored']
        # omitted = dtype_file[type]['omitted']
        records_formatted = {} #initializing dictionary for output
        prices = response[f'Time Series ({interval})']
        latest_window = response['Meta Data']['3. Last Refreshed']
        #need to filter the json response to filter out any dates <= refresh_ts
        for window in prices:
            fields = [self.ticker, datetime.datetime.strptime(window, '%Y-%m-%d %H:%M:%S')]
            for item in prices[window]:
                if item in dtypes:
                    val = prices[window][item]
                    itemDataType = dtypes[item]
                    if val == 'None':
                        fields.append(None)
                    elif itemDataType == 'float':
                        fields.append(float(val))
                    elif itemDataType == 'int':
                        fields.append(int(val))
                    else:
                        fields.append(window[item])
            fields.append('AVAPI')
            fields.append(datetime.datetime.now())
            print(fields)
            records_formatted[window] = tuple(fields)

        return {latest_window: records_formatted}

    def parse_price(self, record, dtype_f):
        if record in dtype_f:
            itemDataType = dtype_f[record]
            if itemDataType == 'float':
                return float(record)
            elif itemDataType == 'int':
                return int(record)
            elif record == 'None':
                return None
            else:
                return record

    def request_prices(self):
        pass
    def parse_prices_v1(self, response, type, interval):
        pass





#old implementation
class API:
    def __init__(self, url):
        self.__url = url
        self.response = ''

    #public
    def request(self, max_retries=3, timeout=10):
        retries = 0
        while retries < max_retries:
            try:
                response = requests.get(self.__url, timeout=timeout)
                response.raise_for_status() # Raises an HTTPError for bad responses
                return response.json()  # json output
            except requests.exceptions.RequestException as req_exc:
                print(f"Request failed: {req_exc}")
                retries+=1

        print('Max retires reached. Unable to complete the request')

    def parse(self):
        pass