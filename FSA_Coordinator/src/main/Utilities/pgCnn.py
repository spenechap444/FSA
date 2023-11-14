import psycopg2

#establishing a database connection
class DB_cnn:
    def __init__(self, cnn):
        self.__cnn = cnn  # json obj w/ connection details

    def open_cnn(self):  # opens the db connection with json object
        conn = psycopg2.connect(**self.__cnn)

        return conn  # conn obj allows you to execute SQL commands & procedures

