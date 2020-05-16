#!/bin/bash

if [ ! -f docker/connect/datagen/bank_rows.config ]; then
  echo "Wrong directory.  Pls run in the main project directory"
fi

## This is for the datagen to generate insane numbers of data for testing
curl -X POST \
  -H "Content-Type: application/json" \
  --data @docker/connect/datagen/bank_rows.config \
  http://localhost:8083/connectors