FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y python3.10 python3.10-dev python3.10-venv python3-pip python3-wheel build-essential && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

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

