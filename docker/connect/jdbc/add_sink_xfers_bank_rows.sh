#!/bin/bash -x


CONNECTOR_NAME=jdbc-sink-xfers-bankrows
CONFIG_FILE=/connect/jdbc/sink_xfers_bank_rows.config

/connect/add_connector.sh ${CONNECTOR_NAME} ${CONFIG_FILE}