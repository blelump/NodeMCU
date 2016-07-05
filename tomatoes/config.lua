-- file : config.lua
local module = {}

module.SSID = {}
module.SSID["UPC1391359"] = "ZESZJPXE"
module.DHT_PIN = 3
module.LED_PIN = 4
module.YL_PIN = 5
module.CMW_PIN = 6
module.API_URL = "http://192.168.0.50:3000/data"
module.DHT_INTERVAL = 65000
module.YL_INTERVAL = 60000
module.MEASUREMENT_COUNT = 12


return module
