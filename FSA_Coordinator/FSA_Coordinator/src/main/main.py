# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import StatementCoordinator as fin
import BaseCompany as com
import RatioCoordinator as rat
import UI as ui
#db testing dependencies
import src.main.core.infra.DbUtils as db
import src.main.core.infra.utils.tools as tl
import os

def testing_ratios():
    ratio = rat.Ratio('TSLA')

def testing_company():
    company = com.Company('TSLA')
    output = company.api_fetch()
    # for item in output:
    #     print(item, output[item])

def testing_store():
    AMZN = fin.Statement('CF', 'TSLA')
    data = AMZN.api_fetch()

def testing_fetch():
    AMZN = fin.Statement('CF', 'AMZN')
    AMZN.fetch_profitability()

def testing_ui():
    my_gui = ui.FSA_UI()
# Press the green button in the gutter to run the script.

def testing_db():
    # creds = tl.get_resources('creds')
    # database = db.DB_cnn(creds['DB'])
    company = com.Company('AMAT')
    company.api_fetch()
if __name__ == '__main__':
    # testing_ui()
    # testing_fetch()
    # testing_company()
    # testing_store()
    # testing_db()
    print(os.path.dirname(__file__))


# See PyCharm help at
# https://www.jetbrains.com/help/pycharm/
