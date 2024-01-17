#!/bin/sh
set -e

# Zilla specific configs
ZILLA_VERSION="${ZILLA_VERSION:-develop-SNAPSHOT}"
ZILLA_LISTEN_ON="${ZILLA_LISTEN_ON:-0.0.0.0}"
ZILLA_HOST="${ZILLA_HOST:-debian-gnu-linux}"
ZILLA_PORT_HTTP="${ZILLA_PORT_HTTP:-7114}"
ZILLA_PORT_MQTT="${ZILLA_PORT_MQTT:-7183}"
ZILLA_PORT_PROMETHEUS="${ZILLA_PORT_PROMETHEUS:-7190}"

# Redpanda configs. 
# Note: we split the broker seed host:port into parts. We also lowercase the
#       sasl mechanism because that's what Zilla wants :(
REDPANDA_BROKERS="${REDPANDA_BROKERS:-localhost:9092}"
REDPANDA_SASL_MECHANISM="$(echo ${RP_SASL_MECHANISM:-SCRAM-SHA-256} | tr '[:upper:]' '[:lower:]')"
REDPANDA_SASL_USERNAME="${REDPANDA_SASL_USERNAME:-zilla}"
REDPANDA_SASL_PASSWORD="${REDPANDA_SASL_PASSWORD}"
REDPANDA_HOST="$(echo ${REDPANDA_BROKERS} | awk -F ':' '{ print $1 }')"
REDPANDA_PORT="$(echo ${REDPANDA_BROKERS} | awk -F ':' '{ print $2 }')"

# Make rocket go now.
docker run -e "JAVA_OPTIONS=-Dzilla.binding.kafka.debug=true" \
    -p 8000:8000 -p 7190:7190 -p 7114:7114 -p 7183:7183 \
    --env "ZILLA_VERSION=${ZILLA_VERSION}" \
    --env "ZILLA_LISTEN_ON=${ZILLA_LISTEN_ON}" \
    --env "ZILLA_HOST=${ZILLA_HOST}" \
    --env "ZILLA_PORT_HTTP=${ZILLA_PORT_HTTP}" \
    --env "ZILLA_PORT_MQTT=${ZILLA_PORT_MQTT}" \
    --env "ZILLA_PORT_PROMETHEUS=${ZILLA_PORT_PROMETHEUS}" \
    --env "REDPANDA_SASL_MECHANISM=${REDPANDA_SASL_MECHANISM}" \
    --env "REDPANDA_SASL_USERNAME=${REDPANDA_SASL_USERNAME}" \
    --env "REDPANDA_SASL_PASSWORD=${REDPANDA_SASL_PASSWORD}" \
    --env "REDPANDA_HOST=${REDPANDA_HOST}" \
    --env "REDPANDA_PORT=${REDPANDA_PORT}" \
    -v ./zilla.yaml:/etc/zilla/zilla.yaml \
    "ghcr.io/aklivity/zilla:${ZILLA_VERSION}" \
    start -v
