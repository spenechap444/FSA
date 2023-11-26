import psycopg2
import json
import os
import re

#establishing a database connection
class DB_cnn:
    def __init__(self, cnn):
        self.__cnn = cnn  # json obj w/ connection details

    def open_cnn(self):  # opens the db connection with json object
        conn = psycopg2.connect(**self.__cnn)
        return conn  # conn obj allows you to execute SQL commands & procedures

    def store_data(self, records): #records to store as input, and omitted columns from API request
        query_path = os.path.join(os.path.dirname(__file__), 'resources','queries.json')
        with open(query_path,'r') as f:
            queries = json.load(f)

        conn = self.open_cnn()
        cursor = conn.cursor()
        cursor.execute(queries['BS']['store'], records) #calling stored proceudre with tuple of records
        cursor.execute('COMMIT;')
        conn.close()

class Query:
    def __init__(self, conn):
        self.conn = conn

    def store_data(self, proc_name):
        cursor = self.conn.cusor()
        pass

    def fetch_data(self, proc_name):
        pass