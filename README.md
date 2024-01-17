# Doom --> Websockets + MQTT --> Zilla --> Redpanda

```
$ git clone https://github.com/voutilad/redpanda-doom-demo.git
$ git submodule update --init --recursive
```

## Chocolate Doom Telemetry

Firstly, you'll need to build _Chocolate Doom_ from source using the branch in
the included git [submodule](./chocolate-doom/).

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

## Aklivity Zilla

Currently, this demo requires building Zilla from source as we need commits
made after the `0.9.63` release that fix issues with MQTT over Websockets.

## Redpanda

I've been testing with _Redpanda Serverless_. Your mileage may vary with other
versions.