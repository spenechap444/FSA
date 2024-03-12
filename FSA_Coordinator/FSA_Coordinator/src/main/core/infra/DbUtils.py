import psycopg2
from functools import wraps
import time

def DB_retry(max_retries=5, delay=1):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            attempts = 1
            while attempts <= max_retries:
                try:
                    return func(*args, **kwargs)
                except psycopg2.DatabaseError as e:
                    print(f"Database error: {str(e)}, retry number {attempts}")
                    time.sleep(delay)
                    attempts+=1
                except Exception as e:
                    print(f"Error encountered: {str(e)}, retry number {attempts}")
                    time.sleep(delay)
                    attempts+=1
            raise Exception(f"Failed after {max_retries} retries")
        return wrapper
    return decorator


#establishing a database connection
class DB_cnn:
    def __init__(self, cnn):
        self.__cnn = cnn  # json obj w/ connection details
        self.max_retries = 5
        self.delay = 1

    @DB_retry()
    def open_cnn(self):  # opens the db connection with json object
        return psycopg2.connect(**self.__cnn) # returns conn obj~ allows you to execute SQL commands & procedures

    #store should be passed as dictionary, will log key and store value
    #value will be a tuple datatype
    @DB_retry()
    def store(self, query, records): #list of tuple of records to store as input, and omitted columns from API request
        conn = self.open_cnn()
        try:
            cursor = conn.cursor()
            for item in records: #can add a multithreaded approach to this
                cursor.execute(query, records[item])
                # print(item)
            cursor.execute('COMMIT;')
        finally:
            if conn:
                conn.close()
                print('Connection closed')

    @DB_retry()
    def db_func(self, query, params=()):
        conn = self.open_cnn()
        try:
            cursor=conn.cursor()
            if len(params)==0:
                cursor.execute(query)
            else:
                print('Executing...')
                cursor.execute(query, params)
            return cursor.fetchall()
        finally:
            if conn:
                conn.close()