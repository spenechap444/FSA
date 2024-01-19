from core.infra import DbUtils as db
from src.main.core.infra.utils import tools as tool

class Prices:
    def __init__(self, ticker):
        self.ticker = ticker
        self.creds = tool.get_resources('creds')
        self.queries = tool.get_resources('queries')