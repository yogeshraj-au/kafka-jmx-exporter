# kafka-jmx-exporter
[![Docker](https://github.com/yogeshraj-au/kafka-jmx-exporter/actions/workflows/docker-image.yml/badge.svg)](https://github.com/yogeshraj-au/kafka-jmx-exporter/actions/workflows/docker-image.yml)

This repo contains Dockerfile for Kafka along with jmx-exporter. The jmx-exporter will expose the metrics at port 2201.

# Build and Run the docker image:

```
docker build -t kafka .
docker run -d --name kafka -p 9092:9092 -p 2201:2201 -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 kafka
```