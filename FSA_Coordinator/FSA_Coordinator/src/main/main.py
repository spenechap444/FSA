# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import StatementCoordinator as fin
import CompanyCoordinator as com
import UI as ui

def testing_company():
    company = com.Company('FANG')
    output = company.api_fetch()
    # for item in output:
    #     print(item, output[item])

def testing_store():
    AMZN = fin.Statement('CF', 'AMZN')
    # data = AMZN.api_fetch()

def testing_fetch():
    AMZN = fin.Statement('CF', 'AMZN')
    AMZN.fetch_profitability()

def testing_ui():
    my_gui = ui.FSA_UI()
# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # testing_ui()
    # testing_fetch()
    testing_company()
# See PyCharm help at https://www.jetbrains.com/help/pycharm/
