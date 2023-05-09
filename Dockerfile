FROM ubuntu:20.04

RUN apt update -y
RUN apt install python3.10

RUN mkdir Detect_abnormal
WORKDIR Detect_abnormal
RUN mkdir data
ADD data/data_add.csv Detect_abnormal/data
COPY knn.pkl .
COPY requirements.txt .
COPY main.py .
RUN pip install -r requirements.txt


EXPOSE 8080
CMD ["python3","main.py"]

