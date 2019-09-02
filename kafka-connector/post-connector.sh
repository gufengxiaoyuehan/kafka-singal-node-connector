#!/usr/bin/env bash
CONNECTORS="Person Face MotorVehicle"

for CONN in $CONNECTORS; do
    curl -X PUT \
      http://kafka-connector:8083/connectors/sink-mongo-${CONN}/config \
      -H 'Content-Type: application/json' \
      -H 'cache-control: no-cache' \
      --data @- <<END_TXT
      {
    	"connector.class": "MongoSinkConnector",
        "topics": "viid${CONN}",
        "tasks.max": "1",
        "database":"viid-sink",
        "connection.uri": "mongodb://${MONGO_HOST}:${MONGO_PORT}/",
        "value.converter.schemas.enable": "false",
        "key.converter.schemas.enable": "false",
        "name": "sink-mongo-${CONN}",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneTimestampsStrategy",
        "transforms": "IntToDate",
        "transforms.IntToDate.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
        "transforms.IntToDate.target.type": "Timestamp",
        "transforms.IntToDate.field": "__create_time"
    }
END_TXT

    curl -X PUT \
      http://kafka-connector:8083/connectors/short-mongo-${CONN}/config \
      -H 'Content-Type: application/json' \
      -H 'cache-control: no-cache' \
      -d @- << END_TXT
          {
    	"connector.class": "MongoSinkConnector",
        "topics": "viid${CONN}",
        "tasks.max": "1",
        "database":"viid-short",
        "connection.uri": "mongodb://${MONGO_HOST}:${MONGO_PORT}/",
        "value.converter.schemas.enable": "false",
        "key.converter.schemas.enable": "false",
        "name": "short-mongo-${CONN}",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneTimestampsStrategy",
        "transforms": "IntToDate",
        "transforms.IntToDate.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
        "transforms.IntToDate.target.type": "Timestamp",
        "transforms.IntToDate.field": "__create_time"
    }
END_TXT

done

