curl -X PUT \
  http://15.144.16.203:8083/connectors/sink-mongo-viid-motorvehicle/config \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 08cfaa91-f4fa-4f8a-8be9-034914549873' \
  -H 'cache-control: no-cache' \
  -d '{
	"connector.class": "MongoSinkConnector",
    "topics": "viidMotorVehicle",
    "tasks.max": "1",
    "database":"viid-sink",
    "connection.uri": "mongodb://15.144.16.203:27017/",
    "value.converter.schemas.enable": "false",
    "key.converter.schemas.enable": "false",
    "name": "sink-mongo-viid-motorvehicle",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneTimestampsStrategy",
    "transforms": "IntToDate",
    "transforms.IntToDate.type": "org.apache.kafka.connect.transforms.TimestampConverter$Value",
    "transforms.IntToDate.target.type": "Timestamp",
    "transforms.IntToDate.field": "__create_time"
}'