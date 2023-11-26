# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import FinCoordinator as fin

def testing_new():
    AMZN = fin.Statement('BS', 'AMZN')
    data = AMZN.api_fetch()

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    testing_new()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
