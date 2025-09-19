envsubst < ./kafka-client.yaml.tmpl > "./kafka-client.yaml"

oc apply -f ./kafka-client.yaml

rm kafka-client.yaml