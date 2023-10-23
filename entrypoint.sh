#!/bin/bash

sed -i "s/\${KAFKA_ZOOKEEPER_CONNECT}/$KAFKA_ZOOKEEPER_CONNECT/g" /opt/kafka_2.13-3.1.2/config/server.properties
./opt/kafka_2.13-3.1.2/bin/kafka-server-start.sh /opt/kafka_2.13-3.1.2/config/server.properties
