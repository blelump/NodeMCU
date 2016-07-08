-- file : application.lua
local module = {}
local barrel = require("barrel")
local soil_humidity = require("soil_humidity")
local request = require("request")

local function measure_dht_22()

    tmr.alarm(0, config.DHT_INTERVAL, tmr.ALARM_AUTO, function()
         local status, temp, humi, temp_dec, humi_dec = dht.readxx(config.DHT_PIN)
         if status == dht.OK then
             -- Float firmware using this example
             print("DHT Temperature:"..temp.."; ".."Humidity:"..humi)

             request.post([[{"data": {"dht":{"temperature": "]]..temp..[[",
                          "humidity": "]]..humi..[["}}}
             ]])

         elseif status == dht.ERROR_CHECKSUM then
             print( "DHT Checksum error." )
         elseif status == dht.ERROR_TIMEOUT then
             print( "DHT timed out." )
         end
    end)
end

local function start_measurements()
    tmr.alarm(1, config.YL_INTERVAL, tmr.ALARM_AUTO, function()
        soil_humidity.measure()
        if soil_humidity.enough_measurements and barrel.has_water() then
            print("has enough measurements and has water...")
            gpio.write(config.RELAY_PIN, gpio.HIGH)
            local running, mode = tmr.state(3)
            if not running then
                tmr.alarm(3, 6000, tmr.ALARM_SINGLE, function()
                    print('alarm!!!!')
                    gpio.write(config.RELAY_PIN, gpio.LOW)
                end)
            end
        else
            print("has not enough measurements or water...")
        end
    end)
end

function module.start()
    measure_dht_22()
    start_measurements()
end

return module
