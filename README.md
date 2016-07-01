## NodeMCU projects written in Lua

### Tomatoes

#### Concept

Build autonomous irrigation system that will handle plants (tomatoes in this case) watering.

##### Details

1. NodeMCU controls the relay, which starts/stops the pressure tank unit.
2. Irrigation process starts when all the conditions below are met:
  1. A mean average of last N measurements from YL-38 sensor is below the `start_irrigation` value;
  2. water level in the barrel is sufficient.
3. Irrigation process stops when tomatoes feel irrigated (TODO).

#### Components

1. NodeMCU ESP–12E controller;
2. DHT22 sensor for temperature and air humidity measurements;
3. YL-38 sensor for soil humidity measurements;
4. A SRD-05VDC-SL-C based relay that controls pressure tank unit (TODO);
5. CMW55 water level sensor to ensure that there's sufficient amount of water in the barrel for pressure tank unit (it musn't work without water)
