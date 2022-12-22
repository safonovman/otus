sudo yum update

sudo yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl start docker

# docker commands
docker

# docker-compose.yml
version: '2'

services:
    zookeeper:
        image: confluentinc/cp-zookeeper:5.5.0
        hostname: zookeeper
        ports:
            - "2181:2181"
        environment:
            ZOOKEEPER_CLIENT_PORT: 2181
            ZOOKEEPER_TICK_TIME: 2000

    broker:
        image: confluentinc/cp-kafka:5.5.0
        hostname: broker
        depends_on:
            - zookeeper
        ports:
            - "29092:29092"
        environment:
            KAFKA_BROKER_ID: 1
            KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
            KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
            KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:9092,PLAINTEXT_HOST://localhost:29092
            KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
            KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
            KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
            KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
    create-topics:
        image: confluentinc/cp-kafka:5.5.0
        hostname: create-topics
        container_name: create-topics
        depends_on:
            - broker
        command: "bash -c 'echo Waiting for Kafka to be ready... && \
                    cub kafka-ready -b broker:9092 1 20 && \
                    kafka-topics --create --if-not-exists --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1 --topic input'"
        environment:
            KAFKA_BROKER_ID: ignored
            KAFKA_ZOOKEEPER_CONNECT: ignored

docker compose up -d

docker exec -it test-broker-1 kafka-console-producer --bootstrap-server 127.0.0.1:29092 --topic input
docker exec -it test-broker-1 kafka-console-consumer --bootstrap-server 127.0.0.1:29092 --topic input --offset earliest --partition 0

example/hello.py:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!\n"

example/Dockerfile:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==2.1.*

# install app
COPY hello.py /

# final configuration
ENV FLASK_APP=hello
EXPOSE 8000
CMD flask run --host 0.0.0.0 --port 8000

docker build -t test:latest .
curl -X GET localhost:8000

#Running flask server locally:
sudo yum install python3 python3-pip
python3 -m pip install --user flask==2.0.*

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
export FLASK_APP=hello

# run flask app as a daemon
setsid flask run --host 0.0.0.0 --port 8001 >/dev/null 2>&1 < /dev/null &

docker run --name some-scylla --hostname some-scylla -d -p 9042:9042 scylladb/scylla:4.6.7

docker inspect --format="{{.Id}}" some-scylla
sudo -i
systemctl stop docker
cd /var/lib/docker/containers/

# modify PortBindings
vim hostconfig.json

# modify ExposedPorts
vim config.v2.json

systemctl start docker


# reconfigure in flight
https://www.baeldung.com/linux/assign-port-docker-container

