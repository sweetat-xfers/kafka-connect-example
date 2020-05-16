# kafka-connect-example
This project was done because I could not find kafka-connect documentation at a level I could work with.

## Objectives

What I wanted to do is to:

1. Run a kafka-connect docker image connected to existing kafka brokers
2. Not have to run schema-registry
3. Run the connect with a specific configuration upon docker-compose up
4. Try not to run this with the confluent stack to tools

## Background

As part of a spike, I am learning on the way in which kafka works, which should include the use of 
kstreams and ksql.  

One of the features kafka provides is the connect functionality which allows you
to treat various external systems as either sources or sinks

## References

I had to reference many documents before finally getting something I have here working.

1. [kafka-connect-datagen](https://github.com/confluentinc/kafka-connect-datagen)
2. [kafka-connect-spooldir](https://github.com/jcustenborder/kafka-connect-spooldir)
3. [kafka-connect-spooldir Documentation](https://jcustenborder.github.io/kafka-connect-documentation/projects/kafka-connect-spooldir/index.html)
4. [Kafka Connect Deep Dive – Converters and Serialization Explained](https://www.confluent.io/blog/kafka-connect-deep-dive-converters-serialization-explained/)
5. [Avro Random Generator](https://github.com/confluentinc/avro-random-generator)
    1. [Examples](https://github.com/confluentinc/kafka-connect-datagen/tree/master/src/main/resources)
6. [JDBC Connector (Source and Sink) for Confluent Platform](https://docs.confluent.io/current/connect/kafka-connect-jdbc/index.html)
7. [Kafka Connect Deep Dive – JDBC Source Connector](https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/)

## Technical

### cp-server-connect-base

This image is prepared by Confluent as part of their demos - 
[cp-server-connect-base Dockerfile.deb8](https://github.com/confluentinc/kafka-images/blob/master/kafka-connect-base/Dockerfile.deb8)

The github repository has been marked as defunct, but reading up references on using connect 
eventually led me here.

I use this image as the base to obtain my own Docker image, and add the necessary plugins I need.

### Development

A [Dockerfile](./Dockerfile) is prepared which holds the desired connect plugins required.  

The [docker-compose.yml](./docker-compose.yml) spins up the connect image and the kafka and zookeeper.

A script is run in the docker-compose as part of the launch command of connect to start the various
connect plugins.

To replicate the desired deployment parameters, all parameters used by the application are externally set in the docker-compose environment parameter.

#### Important Notes

* JDBC drivers must be loaded into any subdirectories in the ```/usr/share/java``` directory
  * the instructions on "[JDBC Connector (Source and Sink) for Confluent Platform](https://docs.confluent.io/current/connect/kafka-connect-jdbc/index.html)" 
   suggests using ```share/java/kafka-connect-jdbc```, though any directory will do.
* Most of the literature reference the use of the ```confluent-hub``` to install the connector.
  * The reality is that you do not need to use this command.
  * Plugins just need to be downloaded and installed in any directory defined in CONNECT_PLUGIN_PATH
  * The one defined in [cp-server-connect-base Dockerfile.deb8](https://github.com/confluentinc/kafka-images/blob/master/kafka-connect-base/Dockerfile.deb8) is

    ```ENV CONNECT_PLUGIN_PATH=/usr/share/java/,/usr/share/confluent-hub-components/```

* Avro schema is obviously better than json convertor if you want to optimize the size of the payload in kafka.
  * AvroConvertors require that you use schema-registry

* JSONConvertors will by default emit schema alongside the JSON payload, as described in [Kafka Connect Deep Dive – Converters and Serialization Explained](https://www.confluent.io/blog/kafka-connect-deep-dive-converters-serialization-explained/)
  * You can disable the transport of the schema by setting ```"value.converter.schemas.enable": "false"```

* When using AvroConvertor for datagen to produce random data, you need to specify the avro schema using 

```text
"schema.filename": "/path/to/your_schema.avsc",
"schema.keyfield": "<field representing the key>",
```
