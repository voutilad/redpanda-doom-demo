# Doom --> Websockets + MQTT --> Zilla --> Redpanda

```
$ git clone https://github.com/voutilad/redpanda-doom-demo.git
$ git submodule update --init --recursive
```

## Chocolate Doom Telemetry

Firstly, you'll need to build _Chocolate Doom_ from source using the branch in
the included git submodule.

You'll need to use `chocolate-doom-setup` to configure the telemetry mode and
point it towards Zilla. You should use the following settings for now:

```
telemetry_enabled             1
telemetry_mode                5
telemetry_ws_host             "debian-gnu-linux"
telemetry_ws_port             7114
telemetry_ws_path             "/redpanda"
telemetry_ws_tls_enabled      0
```

> Note: tls support is to be added.

## Aklivity Zilla

Currently, this demo requires building Zilla from 
[source](https://github.com/aklivity/zilla) as we need commits made after the
`0.9.63` release that fix issues with MQTT over Websockets.

Building is easy and you can use Java 21 or 17:

```
$ ./mvnw clean install -DskipTests
```

> I've been using Java 21 as that's what Zilla's Docker image uses for runtime.

It will automatically create the Docker image tagged with the
`develop-SNAPSHOT` tag.

Running Zilla in Docker is simplified using [run.sh](./run.sh):

```
$ REDPANDA_BROKERS=<your broker seed> REDPANDA_SASL_PASSWORD=<password> ./run.sh
```

## Redpanda

I've been testing with _Redpanda Serverless_. Your mileage may vary with other
versions.

You'll need to create some topics in advance:

- `mqtt-messages`
- `mqtt-retained`
- `mqtt-sessions`
- `doom`