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

1. As you generate the producer and consumer properties files, it also provide the command line to use the tools

   1. Example, for producer
      ```
      bin/kafka-console-producer.sh --producer.config producer.properties --topic TO.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443
      ```

      A `producer.properties` is generated in the `kafka` folder. Here is a sample of the file
      ```
      bootstrap.servers=es-min-prod-kafka-bootstrap-es.apps.{{DOMAIN_NAME}}:443
      topic=TO.MQ.TOPIC
      ssl.protocol=TLSv1.3
      ssl.truststore.location=es-cert.p12
      ssl.truststore.type=PKCS12
      ssl.truststore.password={{TRUSTSTORE_PASSWORD}}
      security.protocol=SASL_SSL
      sasl.mechanism=SCRAM-SHA-512
      sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="kafka-client" password="{{KAFKAUSER_PASSWORD}}";
      acks=1
      batch.size=16384
      linger.ms=5
      retries=0
      ```

   1. Example, for consumer
      ```
      bin/kafka-console-consumer.sh --consumer.config consumer.properties --topic FROM.MQ.TOPIC --bootstrap-server es-min-prod-kafka-bootstrap-es.apps.{domain}:443 --from-beginning
      ```

      A `consumer.properties` is generated in the `kafka` folder. Here is a sample of the file
      ```
      bootstrap.servers=es-min-prod-kafka-bootstrap-es.apps.{{DOMAIN_NAME}}:443
      topic=TO.MQ.TOPIC
      ssl.protocol=TLSv1.3
      ssl.truststore.location=es-cert.p12
      ssl.truststore.type=PKCS12
      ssl.truststore.password={{TRUSTSTORE_PASSWORD}}
      security.protocol=SASL_SSL
      sasl.mechanism=SCRAM-SHA-512
      sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="kafka-client" password="{{KAFKAUSER_PASSWORD}}";
      group.id=test-consumer-group
      auto.offset.reset=earliest
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

