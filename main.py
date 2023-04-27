import pandas as pd
from pycaret.anomaly import *
import time

def read_data(file):
    data= pd.read_csv(file) #file = 'test_2.csv'
    return data

def add_data():
    data_add = read_data('test_2.csv').tail(1) #data cần đánh giá (Tạm thời là dòng cuối file test_2) -> append vào file data, write vào file xử lý
    data_add.to_csv('data_add.csv') #write vào file xử lý
    data = read_data('data_add.csv') #đọc data ra 
    return data

def main():
    loaded_model = load_model('knn')
    while True:
        data = add_data()
        predict = predict_model(loaded_model, data=data)
        print(predict.iloc[:,-2])
        time.sleep(1)

if __name__ == "__main__":
    main()