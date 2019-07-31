## Info

#### 1. Clone the repo to the location of your choice.
NOTE: your grafana and influxdb data will be stored in this directory, so make sure it is where you want it, and to back it up. You can change the grafana and influxdb volume locations or make them named volumes by editing the docker-compose file
```
git clone https://gitlab.com/carverhaines/tig-stack-server.git
cd tig-stack-server
```


#### 2. Setup DB Credentials
Copy the example database credential file to `dbcreds` and enter your desired InfluxDB admin and telegraf users' passwords.
```
cp dbcreds.example dbcreds
vim dbcreds
```

#### 3. Run the InfluxDB Setup script
This script will start a docker Influx DB container, create a database named `telgraf`, with `admin` and `telegraf` users using the passwords you previously set.
It will then run the InfluxDB setup.
```
chmod +x setup-influxdb.sh
./setup-influxdb.sh
```

#### 4. Run the docker stack
This will start grafana listening on port 3000, and InfluxDB on port 8086.
```
docker-compose up -d
```
