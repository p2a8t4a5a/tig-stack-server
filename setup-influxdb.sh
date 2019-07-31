#!/bin/bash

mkdir ./grafana-volume
mkdir ./influxdb-volume

source dbcreds

docker run --rm \
  -e INFLUXDB_DB=telegraf \
  -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=admin \
  -e INFLUXDB_ADMIN_PASSWORD=$IFDBAPW \
  -e INFLUXDB_USER=telegraf \
  -e INFLUXDB_USER_PASSWORD=$IFDBTPW \
  -v ./influxdb-volume:/var/lib/influxdb \
  influxdb /init-influxdb.sh
