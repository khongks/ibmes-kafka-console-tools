#!/bin/bash
set -e

RESOURCE_FOLDER=./kafka

## IBM Event Streams - Connection information gathering
# CLUSTER_NAME=${1:-es-min-prod}
# NAMESPACE=${2:-es}
KAFKA_USER=kafka-client

BOOTSTRAP_SERVER_ENDPOINT=$(oc get route -n ${NAMESPACE} ${CLUSTER_NAME}-kafka-bootstrap -ojsonpath='{.spec.host}'):443
SCHEMA_REGISTRY_URL=https://$(oc get route -n ${NAMESPACE} ${CLUSTER_NAME}-ibm-es-ac-reg-external -ojsonpath='{.spec.host}')

KAFKA_USERNAME=$(oc get kafkauser -n ${NAMESPACE} ${KAFKA_USER} -ojson  | jq -r .status.username)
KAFKA_PASSWORD=$(oc get secret -n ${NAMESPACE} ${KAFKA_USER} -ojson | jq -r .data.password | base64 -d)

oc get secret -n ${NAMESPACE} ${CLUSTER_NAME}-cluster-ca-cert -ojson | jq -r '.data."ca.crt"' | base64 -d > ${RESOURCE_FOLDER}/ca.pem
oc get secret -n ${NAMESPACE} ${CLUSTER_NAME}-cluster-ca-cert -ojson | jq -r '.data."ca.p12"' | base64 -d > ${RESOURCE_FOLDER}/es-cert.p12
TRUSTSTORE_PASSWORD=$(oc get secret -n ${NAMESPACE} ${CLUSTER_NAME}-cluster-ca-cert -ojson | jq -r '.data."ca.password"' | base64 -d)

echo 
echo "Bootstrap Server Endpoint: ${BOOTSTRAP_SERVER_ENDPOINT}"
echo "Schema Registry URL: ${SCHEMA_REGISTRY_URL}"

echo 
echo "--- SSL/TLS Properties ---"
echo "security.protocol: SASL_SSL"
echo "ssl.protocol: TLSv1.3"
echo "ssl.truststore.location: es-cert.p12"
echo "ssl.truststore.password: ${TRUSTSTORE_PASSWORD}"

export BOOTSTRAP_SERVER_ENDPOINT=${BOOTSTRAP_SERVER_ENDPOINT}
export SCHEMA_REGISTRY_URL=${SCHEMA_REGISTRY_URL}
export KAFKA_PASSWORD=${KAFKA_PASSWORD}
export TRUSTSTORE_PASSWORD=${TRUSTSTORE_PASSWORD}

echo 
echo "--- SCRAM Authentication Properties ---"
echo "sasl.mechanism: SCRAM-SHA-512"
echo "sasl.jaas.config: org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${KAFKA_USERNAME}\" password=\"${KAFKA_PASSWORD}\";"

echo
echo "apicurio.registry.url: ${SCHEMA_REGISTRY_URL}"

echo "Generating producer.properties file..."
echo "bootstrap.servers=${BOOTSTRAP_SERVER_ENDPOINT}" > producer.properties
echo "topic=TO.MQ.TOPIC" >> producer.properties
echo "ssl.protocol=TLSv1.3" >> producer.properties
echo "ssl.truststore.location=es-cert.p12" >> producer.properties
echo "ssl.truststore.type=PKCS12" >> producer.properties
echo "ssl.truststore.password=${TRUSTSTORE_PASSWORD}" >> producer.properties
echo "security.protocol=SASL_SSL" >> producer.properties
echo "sasl.mechanism=SCRAM-SHA-512" >> producer.properties
echo "sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${KAFKA_USERNAME}\" password=\"${KAFKA_PASSWORD}\";" >> producer.properties
echo "acks=1" >> producer.properties
echo "batch.size=16384" >> producer.properties
echo "linger.ms=5" >> producer.properties
echo "retries=0" >> producer.properties

mv producer.properties ${RESOURCE_FOLDER}/producer.properties

echo "bin/kafka-console-producer.sh --producer.config producer.properties --topic TO.MQ.TOPIC --bootstrap-server ${BOOTSTRAP_SERVER_ENDPOINT}"