# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import Utilities.Query as db
import consumer.AlphaVantageConsumer as av
import os
import json



def testing():
    #os.path.dirname(__file__) gets directory of current script
    resource_path = os.path.join(os.path.dirname(__file__),'Utilities', 'resources','creds.json')
    with open(resource_path,'r') as f:
        creds = json.load(f)

    cnn = db.DB_cnn(creds['DB'])
    db_conn = cnn.open_cnn

    BS = av.API('TSLA', creds['Alpha']['key'], creds['Alpha']['fs_url'])
    BS.api_fetch('BS')
    # cnn.store_data(BS.output)
    for item in BS.output:
        cnn.store_data(BS.output[item])
        print(BS.output[item])


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    testing()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
