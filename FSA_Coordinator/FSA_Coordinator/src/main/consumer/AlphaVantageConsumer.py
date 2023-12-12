#This file is meant for contacting the AlphaVantage API to consume Data
import requests
import os
import json

class API:
    def __init__(self, url):
        self.__url = url

    #public
    def request(self, max_retries=3, timeout=10):
        # TEST THIS
        # resource_path = os.path.join(os.path.dirname(__file__), 'resources', 'creds.json')
        # with open(resource_path, 'r') as f:
        #     resources = json.load(f)
        retries = 0
        while retries < max_retries:
            try:
                response = requests.get(self.__url, timeout=timeout)
                response.raise_for_status() # Raises an HTTPError for bad responses
                return response.json()  # json output
            except requests.exceptions.RequestException as req_exc:
                print(f"Request failed: {req_exc}")
                retries+=1

        print('Max retires reached. Unable to complete the request')