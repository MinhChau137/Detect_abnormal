FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install sudo && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.8

RUN apt install python3-pip -y

RUN mkdir Detect_abnormal
WORKDIR Detect_abnormal
RUN mkdir data
COPY data/data_add.csv data
COPY knn_3.8.pkl .
COPY requirements.txt .
COPY main.py .
RUN python3 -m pip install -r requirements.txt


EXPOSE 8080
CMD ["python3","main.py"]

