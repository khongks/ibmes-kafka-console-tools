# Getting Started Guide for Apache Kafka Console Tools with IBM Event Streams

This guide is written to provide guide on how to get started in using Apache Kafka Console Tools to produce and consume from IBM Event Streams.

## Setup Kafka Console Tools

1. Clone the repository and CD into the folder
   ```
   git clone https://github.com/khongks/ibmes-kafka-console-tools.git
   cd ibmes-kafka-console-tools
   ```

1. Download Apache Kafka [here](https://kafka.apache.org/downloads)
   ```
   wget https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz
   ```

1. Extract the tarball, you can get a folder `kafka_2.13-4.0.0`
   ```
   tar xzf kafka_2.13-4.0.0.tgz 
   ```

1. Rename the folder to `kafka`

## Set IBM Event Streams environment

1. Login to OpenShift

1. Set environment variables like the following (you need to find out yours)
   ```
   export CLUSTER_NAME=es-min-prod
   export NAMESPACE=es
   ```

1. Create KafkaUser to create a user called `kafka-client` and a secret called `kafka-client` the contains its password.
   ```
   ./create-kafkauser.sh
   ```

1. Generate Kafka Producer properties file into the `kafka` folder.
   ```
   ./set-kafka-producer.sh
   ```

1. Generate Kafka Consumer properties file into the `kafka` folder.
   ```
   ./set-kafka-consumer.sh
   ```

1. The following files are generated in the `kafka` folder
   1. consumer.properties
   1. producer.properties
   1. ca.pem - CA certificate to connect to IBM Event Streams
   1. es-cert.12 - Trust Store that contains certificates needed to connect to IBM Event Streams.

1. As you generate the producer and consumer properties files, it also provide the command line to user the tools

   1. Example, for producer
      ```
      bin/kafka-console-producer.sh --producer.config producer.properties --topic TO.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443
      ```

   1. Example, for consumer
      ```
      bin/kafka-console-consumer.sh --consumer.config consumer.properties --topic FROM.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443 --from-beginning
      ```

## Run Kafka Tools

1. Run Kafka console for consumer
   ```
   bin/kafka-console-consumer.sh --consumer.config consumer.properties --topic FROM.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443 --from-beginning
   ```

2. Run Kafka console for producer
   ```
   bin/kafka-console-producer.sh --producer.config producer.properties --topic TO.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443
   ```

