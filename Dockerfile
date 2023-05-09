FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.10

RUN apt install python3-pip -y

RUN mkdir Detect_abnormal
WORKDIR Detect_abnormal
RUN mkdir data
ADD data/data_add.csv Detect_abnormal/data
COPY knn.pkl .
COPY requirements.txt .
COPY main.py .
RUN pip3 install -r requirements.txt


EXPOSE 8080
CMD ["python3","main.py"]

