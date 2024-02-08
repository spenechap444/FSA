import re
import datetime
from core.infra import DbUtils as db
from src.main.core.infra.utils import tools as tool
from src.main.core.infra import AlphaVantageConsumer as av


#################################################################################################################################
#  Statement class serves purpose for storing financial statement data in order to make data available for other modules to use
#  Nature of adding financial statements will be done when intializing a portfolio or when looking up a stock
#  Ratio coordinator will consume this data when analyzing companies

#  Statment class has one public method api_fetch which calls the parse method to prep the data for storing
    #api_fetch should only be called if the data is not already present in the DB
##################################################################################################################################

class Statement: #statement should be initialized with the output from API request
    def __init__(self, type, ticker):
        self.type = type #statement type
        self.ticker = ticker #company ticker


    #private method ~ done prior to storing the data in the database
    def parse(self, data):
        # formatting the output from API to be in format for DB
        resources = tool.get_resources('queries')
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
                if item not in omitted_cols: #omitted cols represent values not being stored in DB
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

    def api_fetch(self): #primary method for storing api request
        #constructing API url
        creds = tool.get_resources('creds')
        if self.type == 'IS':
            report = 'INCOME_STATEMENT'
        elif self.type == 'BS':
            report = 'BALANCE_SHEET'
        elif self.type == 'CF':
            report = 'CASH_FLOW'
        else:
            report = self.type
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

    def store(self, data): #this should be in the DB utils
        query = tool.get_resources('queries')
        creds = tool.get_resources('creds')
        cnn = db.DB_cnn(creds['DB'])
        conn = cnn.open_cnn()
        cursor = conn.cursor()
        for record in data:
            cursor.execute(query[self.type]['store'], data[record]) #calling proc passing tuple of records
            #this execute statement should be from within the DB_cnn class, allowing for exceptions to be cleanly catched
        cursor.execute('COMMIT;')
        conn.close()

    def fetch_data(self, fiscal_date_end=None):
        try:
            f_date_formatted = fiscal_date_end
            query = tool.get_resources('queries')
            creds = tool.get_resources('creds')
            cnn = db.DB_cnn(creds['DB'])
            conn = cnn.open_cnn()
            cursor = conn.cursor()
            if fiscal_date_end is not None:
                dt_split = fiscal_date_end.split('-') #passed as a string YYYY-MM-DD
                f_date_formatted = datetime.date(int(dt_split[0]), int(dt_split[1]), int(dt_split[2]))
                print(f_date_formatted)
            #The cursor.execute along with setting up a connection should be run from the DB Utils file
            # where a chunk size should be set up
            #This way will separate DB and service level logic
            cursor.execute(query[self.type]['fetch'], (self.ticker, f_date_formatted))
            return cursor.fetchall()

        finally:
            #Close the cursor and connection
            cursor.close()
            conn.close()
            print("Connection closed")


