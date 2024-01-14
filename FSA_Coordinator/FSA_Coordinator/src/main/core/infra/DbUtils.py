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

    def store(self, query, record): #records to store as input, and omitted columns from API request
        try:
            conn = self.open_cnn()
            cursor = conn.cursor()
            cursor.execute(query, record) #calling stored proceudre with tuple of records
            cursor.execute('COMMIT;')
            conn.close()
        except psycopg2.DatabaseError as e:
            error_message = str(e)
            print(f"Database error: {error_message}")
        finally:
            if conn:
                conn.close()

    def fetch(self, query):
        attempts = 1
        max_retries = 5
        conn = self.open_cnn()
        while attempts <= max_retries:
            try:
                cursor=conn.cursor
                cursor.execute(query)
                return cursor.fetchall()
            except Exception as e:
                print(f'DB Error raised: {e}')
                attempts+=1
            finally:
                conn.close()
                print(f'DB connection closed after {attempts}')

    def fetch_fs_cursor(self):
        query_path = os.path.join(os.path.dirname(__file__),'resources', 'queries.json')
        with open(query_path, 'r') as f:
            queries = json.load(f)

        conn = self.open_cnn()
        cursor = conn.cursor
        cursor.execute(queries[''])