## NodeMCU projects written in Lua

### Tomatoes

#### Concept

Build autonomous irrigation system that will handle plants (tomatoes in this case) watering.

##### Details

1. NodeMCU controls the relay, which starts/stops the pressure tank unit.
2. Irrigation process starts when all the conditions below are met:
  1. A mean average of last N measurements from YL-38 sensor is below the `start_irrigation` value;
  2. water level in the barrel is sufficient.
3. Irrigation process:
  1. It performs in intervals, where each interval is given with `IRRIGATION_INTERVAL`. When an interval ends, the whole process resets and starts counting from the beginning (this state is called warming up).
  2. It continues until soil humidity is below `MIN_HUMIDITY`.
4. Data gathering and visualization:
  1. Everything what seem to be important is collected and sent to the data store (see `database.lua` and `request.lua`).
  2. InfluxDB is used as a datastore (the data format is `table_name,param=key value=value` and may be sent in batches).
  3. Grafana is used to visualize what's collected in data store.

#### Components

1. NodeMCU ESP–12E controller;
2. DHT22 sensor for temperature and air humidity measurements (not necessary);
3. YL-38 sensor for soil humidity measurements;
4. A SRD-05VDC-SL-C based relay that controls pressure tank unit;
5. CMW55 water level sensor to ensure that there's sufficient amount of water in the barrel for pressure tank unit (it musn't work without water)
