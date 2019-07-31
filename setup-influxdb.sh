#!/bin/bash

# Make persistant volumes
mkdir ./grafana-volume
mkdir ./influxdb-volume

# Grafana folder must have UID/GID perms of '472' to be writeable
sudo chown -R 472:472 grafana-volume

# Source the passwords
source dbcreds

# Run the docker once to setup the database and users in the local influxdb folder/volume
docker run --rm \
  -e INFLUXDB_DB=telegraf \
  -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=admin \
  -e INFLUXDB_ADMIN_PASSWORD=$IFDBAPW \
  -e INFLUXDB_USER=telegraf \
  -e INFLUXDB_USER_PASSWORD=$IFDBTPW \
  -v $(pwd)/influxdb-volume:/var/lib/influxdb \
  influxdb /init-influxdb.sh

#Remove secret password variables
IFDBAPW="resetpw"
IFDBTPW="resetpw"
