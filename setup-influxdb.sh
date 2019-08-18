#!/bin/sh

echo
echo -e "\033[1mStarting Setup...\033[0m"
echo

# Make persistant volumes
echo
echo -e "\033[1mCreating volumes...\033[0m"
echo
mkdir ./grafana-volume
mkdir ./influxdb-volume
mkdir ./ssl

# Grafana folder must have UID/GID perms of '472' to be writeable
echo
echo -e "\033[1mChanging folder permissions for Grafana...\033[0m"
echo
chown -R 472:472 grafana-volume

# Source the passwords
echo
echo -e "\033[1mSourcing data in 'dbcreds'...\033[0m"
echo
source dbcreds

# Generate the SSL certificates
echo
echo -e "\033[1mGenerating SSL Certs, please enter your info when asked...\033[0m"
echo
openssl req -new -newkey rsa:4096 -nodes -keyout ./ssl/influxdb.key -out ./ssl/influxdb.csr
openssl x509 -req -sha256 -days 3650 -in ./ssl/influxdb.csr -signkey ./ssl/influxdb.key -out ./ssl/influxdb.pem

# Run the docker once to setup the database and users in the local influxdb folder/volume
echo
echo -e "\033[1mInitializing InfluxDB and creating 'telegraf' database...\033[0m"
echo

docker run --rm \
  -e INFLUXDB_DB=telegraf \
  -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=admin \
  -e INFLUXDB_ADMIN_PASSWORD=$IFDBAPW \
  -e INFLUXDB_USER=telegraf \
  -e INFLUXDB_USER_PASSWORD=$IFDBTPW \
  -v $(pwd)/influxdb-volume:/var/lib/influxdb \
  influxdb /init-influxdb.sh

echo
echo -e "\033[1mFinished initializing database\033[0m"
echo

# Show current retention policy
echo
echo -e "\033[1mPrinting current DB retention policy...\033[0m"
echo

docker run -d \
  --name influxdb \
  -v $(pwd)/influxdb-volume:/var/lib/influxdb \
  influxdb > /dev/null

docker exec -it \
  influxdb influx -execute "SHOW RETENTION POLICIES ON telegraf" \
  | grep true
echo

# Set retention policy
echo
echo -e "\033[1mSetting new $RETENTIONDAYS day retention policy...\033[0m"
echo
docker exec -it \
  influxdb influx -execute "CREATE RETENTION POLICY default_policy ON telegraf DURATION ${RETENTIONDAYS}d REPLICATION 1 DEFAULT"


# Show new retention policy
echo
echo -e "\033[1mPrinting new DB retention policy...\033[0m"
echo

docker exec -it \
  influxdb influx -execute "SHOW RETENTION POLICIES ON telegraf" \
  | grep true
echo

docker rm -f influxdb > /dev/null

#Remove secret password variables
echo
echo -e "\033[1mCleaning up secrets\033[0m"
echo
IFDBAPW="resetpw"
IFDBTPW="resetpw"

echo -e "\033[1mFinished!\033[0m"
echo
