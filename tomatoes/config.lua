-- file : config.lua
local module = {}

module.MEASURE_ONLY_MODE_PIN = 2
module.DHT_PIN = 3
module.LED_PIN = 4
module.YL_PIN = 5
module.CMW_PIN = 6
module.RELAY_PIN = 7
module.DHT_INTERVAL = 64000
module.YL_INTERVAL = 120000
module.MEASUREMENT_COUNT = 5
module.MIN_HUMIDITY = 255
module.DELAY_INTERVAL  = 30000
module.IRRIGATION_INTERVAL = 6000
module.IRRIGATION_SERIES = 2
module.PREVENT_IRRIGATION = false



return module
