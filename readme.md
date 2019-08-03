## Info

#### 1. Clone the repo to the location of your choice.
NOTE: your grafana and influxdb data will be stored in this directory, so make sure it is where you want it, and to back it up. You can change the grafana and influxdb volume locations or make them named volumes by editing the docker-compose file
```
git clone https://gitlab.com/carverhaines/tig-stack-server.git
cd tig-stack-server
```


#### 2. Setup DB Credentials
Copy the example database credential file to `dbcreds` and enter your desired InfluxDB admin and telegraf users' passwords. Also set an integer for the number of days you want data to be stored in the database. By default it is 90 days. Increasing it beyond 90 days will cause very large amounts of data, you may want to look into Downsampling: https://docs.influxdata.com/influxdb/latest/guides/downsampling_and_retention/
```
cp dbcreds.example dbcreds
vim dbcreds
```

#### 3. Run the InfluxDB Setup script
**Run this only once to initalize the folders and database**

This script will create grafana and influxdb data folders for volumes in the current directory, initializing InfluxDB in a docker container, create a database named `telgraf`, with `admin` and `telegraf` users using the passwords you previously set. It
It will then run the InfluxDB setup. Then it will set the retention policy to the number of days specified in the dbcreds file.
```
chmod +x setup-influxdb.sh
./setup-influxdb.sh
```

#### 4. Run the docker stack
This will start grafana listening on port 3000, and InfluxDB on port 8086.
```
docker-compose up -d
```

#### 5. Access and setup grafana
* Grafana available at: https://yourip:3000
