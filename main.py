import pandas as pd
from pycaret.anomaly import *
from flask import Flask
import threading
import time
import os
import socket

app = Flask(__name__)
IS_TERMINATE = False


@app.route('/api/stream/<ip>:<int:port>/<int:time_detect>/<int:time_sleep>', methods=['GET'])
def handle_data_thread_init(ip, port, time_detect, time_sleep):
    ip_server = ip
    port_server = port
    time_to_detect = time_detect
    time_sleep = time_sleep
    try:
        s = socket.socket(socket.AF_INET,
            socket.SOCK_STREAM)
        try:
            s.connect((ip_server, port_server))
            s.send(str(time_sleep).encode())
            th = threading.Thread(target=detect_abnormal, args=(
                s,time_to_detect, time_sleep))
            th.start()
        except:
            print('Connect failed')
            return 'Connect failed', 404
    except:
        print("error when start thread")
        
    th.join()
    return 'OK', 200


@app.route('/api/active', methods=['GET'])
def active_process():
    return 'Active process', 200


@app.route('/api/terminate', methods=['GET'])
def terminate_process():
    global IS_TERMINATE
    IS_TERMINATE = True
    os._exit(0)
    return

def detect_abnormal(s: socket ,time_to_detect: int, time_sleep: int):
    loaded_model = load_model('knn')
    
    start_time = time.monotonic()
    
    msg = s.recv(8192)
    while msg:
        msg_recv = msg.decode()
        with open('./data/data_add.csv', 'a') as the_file:
            the_file.write(msg_recv)
            
        data = pd.read_csv('./data/data_add.csv').tail(1)
        
        predict = predict_model(loaded_model, data=data)
        print(predict.iloc[:,-2])                
        time.sleep(time_sleep)
        
        if time.monotonic() - start_time > time_to_detect or IS_TERMINATE:
            # disconnect the client
            s.close()
            return True
        msg = s.recv(8192)



if __name__ == "__main__":
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
