## 单节点KAFKA docker部署

使用[wurstmeister](https://github.com/wurstmeister/kafka-docker)的docker image作为base image, 并且增加了`connector service`用于数据导入至mongo.

### 使用

```
docker-compose up -d
```

#### 配置
##### kafka配置
注意!需要配置多个`Listener`来接收`container`外部的producer请求,  
相关配置:

```
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP # 设置多个linster地址 和协议
KAFKA_ADVERTIESED_LINSTNERS # 配置多个listener地址
KAFKA_INTER_BROKER_LISTENER_NAME # 内部路由名称
```
##### connector 配置
`connector` service 内置mongodb connector.
如果要添加connectors, 将其拷贝值 `kafka-connector/connectors` 目录中.

在`kafka-connector/post-connector.sh`中添加要运行的connector, container启动后会自动创建script中的的connector.

-------
<contact>contact</contact>: chong.luo@cidatahub.com
