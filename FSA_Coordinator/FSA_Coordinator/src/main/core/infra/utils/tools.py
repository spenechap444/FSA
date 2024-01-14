import os
import json

def get_resources(fname):
    # os.path.dirname(__file__) #gets directory of the current script
    resource_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'resources', f'{fname}.json')
    with open(resource_path, 'r') as f:
        return json.load(f)