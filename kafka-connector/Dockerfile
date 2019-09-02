FROM wurstmeister/kafka
MAINTAINER logan <chong.luo@cidatahub.com>
ENV CONNECT_BIN=${KAFKA_HOME}/bin/connect-distributed.sh CONNECT_CFG=${KAFKA_HOME}/config/connect-distributed.properties
ENV MONGO_HOST=localhost
ENV MONGO_PORT=27017

WORKDIR $KAFKA_HOME
COPY start-connector.sh $KAFKA_HOME/start-connect.sh
COPY post-connector.sh $KAFKA_HOME/post-connector.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh 
COPY connectors $KAFKA_HOME/connectors

RUN chmod 700 /docker-entrypoint.sh $KAFKA_HOME/start-connect.sh $KAFKA_HOME/post-connector.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["./start-connect.sh"]

