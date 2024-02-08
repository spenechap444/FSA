# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import StatementCoordinator as fin
import Company as com
import RatioCoordinator as rat
import UI as ui
import src.main.Portfolio as pos
#db testing dependencies
import src.main.core.infra.DbUtils as db
import src.main.core.infra.utils.tools as tl
import os


if __name__ == '__main__':
    portfolio = pos.Portfolio('My Portfolio')
    portfolio.initialize_positions()

# See PyCharm help at
# https://www.jetbrains.com/help/pycharm/
