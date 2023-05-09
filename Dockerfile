FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y install sudo
RUN sudo apt install software-properties-common -y
RUN sudo add-apt-repository ppa:deadsnakes/ppa
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

