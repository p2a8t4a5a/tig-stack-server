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

Note: *openssl* must be installed
```
# Run as sudo if not root:
sudo ./setup-influxdb.sh
# OR run as root:
./setup-influxdb.sh
```

#### 4. Run the docker stack
This will start grafana listening on port 3000, and InfluxDB on port 8086.
```
docker-compose up -d
```

#### 5. Access and setup grafana, add your database
* Grafana available at: yourip:3000, it will ask you to create a new admin username
* Next add your InfluxDB datasource, set name as `telegraf`
* Check "With CA Cert" and paste your certificate that generated in the setup script (`cat cat ssl/influxdb.pem`) and check "Skip TLS Verify"
* DB is `telegraf` username is `telegraf`, password is the second one you set in `dbcreds`
![Grafana Add Datasource](https://gitlab.com/uploads/-/system/personal_snippet/1886760/03299766942173c25e1945ada377fd0f/Capture0.JPG)


* Save and test!

#### 6. Install telegraf client
Install on all servers you wish to monitor (can start on same server)
Instructions in repo:
https://gitlab.com/carverhaines/tig-stack-client


#### 7. Setup dashboards
* You can start creating dashboards, or use my tamplate dashboards, of which there are 3. They can be found in this repo: https://gitlab.com/carverhaines/tig-stack-server/tree/master/dashboards
  * **Servers Overview** (make this your homepage):
    * Gives overview of ALL host servers
    * Has generic alerts setup for 1 & 5min loads (normalized for # of CPUs to a max load of 1), RAM usage, and Disk usage
    * Go into the alerts and set your preferred form of notification (e.g. email, slack, etc)
    * Also has detailed server overviews as dropdowns lower down on the screen
    ![Servers Overview](https://gitlab.com/uploads/-/system/personal_snippet/1886760/413bb8dd9428650bdfca0891edc61997/Capture1.JPG)

  * **Server Dashboard**
    * A server-by-server host view with much more detail, change server by selecting from dropdown in top left.
    ![Server Dashboard](https://gitlab.com/uploads/-/system/personal_snippet/1886760/2721114b14bd2c42549df16d883c8f0f/Capture2.JPG)

  * **Docker Dashboard**
    * Shows all docker containers, docker hosts, images, etc.
    * Drop downs below show details for each container.
    ![Docker Dashboard](https://gitlab.com/uploads/-/system/personal_snippet/1886760/678155ee257e67b29b1eba4b0d942894/Capture3.JPG)
