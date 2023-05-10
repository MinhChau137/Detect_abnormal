FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install sudo && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.10

RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 && \
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    sudo update-alternatives --config python3

RUN apt install python3-pip -y
RUN apt install --reinstall python3.10-distutils -y

RUN mkdir Detect_abnormal
WORKDIR Detect_abnormal
RUN mkdir data
COPY data/data_add.csv data
COPY knn.pkl .
COPY requirements.txt .
COPY main.py .
RUN pip3 install -r requirements.txt


EXPOSE 8080
CMD ["python3","main.py"]

