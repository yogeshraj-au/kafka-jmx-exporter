# Use CentOS 7 as the base image
FROM centos:7

# Install Java (required for Kafka)
RUN yum install java-1.8.0-openjdk -y

#Install wget
RUN yum install wget -y

# Set the Kafka version
ENV KAFKA_VERSION=3.1.2
ENV SCALA_VERSION=2.13
ENV KAFKA_HOME=/opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Download and extract Kafka
RUN wget "https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz && \
    tar -xzf /tmp/kafka.tgz -C /opt && \
    rm /tmp/kafka.tgz

# Define Kafka environment variables
ENV PATH="$KAFKA_HOME/bin:$PATH"
ENV KAFKA_ZOOKEEPER_CONNECT=""

# Create Directory structure for monitoring
RUN mkdir -p $KAFKA_HOME/monitoring
ADD https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.15.0/jmx_prometheus_javaagent-0.15.0.jar $KAFKA_HOME/monitoring/
ADD https://raw.githubusercontent.com/prometheus/jmx_exporter/main/example_configs/kafka-2_0_0.yml $KAFKA_HOME/monitoring/kafka.yml

# Copy server config
COPY server.properties $KAFKA_HOME/config/

# Add the jmx config
RUN sed -i '43i export KAFKA_OPTS="-javaagent:$KAFKA_HOME/monitoring/jmx_prometheus_javaagent-0.15.0.jar=2201:$KAFKA_HOME/monitoring/kafka.yml"' $KAFKA_HOME/bin/kafka-server-start.sh

# Expose Kafka and JMX ports (adjust as needed)
EXPOSE 9092 2201

COPY entrypoint.sh $KAFKA_HOME/bin/

RUN chmod 777 $KAFKA_HOME/bin/entrypoint.sh

ENTRYPOINT [ "/opt/kafka_2.13-3.1.2/bin/entrypoint.sh" ]