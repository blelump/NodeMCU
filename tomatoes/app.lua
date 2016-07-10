-- file : application.lua
local module = {}
local barrel = require("barrel")
local soil_humidity = require("soil_humidity")
local request = require("request")

module.performing_water = false

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
        local measure_only_mode = (gpio.read(config.MEASURE_ONLY_MODE_PIN) == 0 )
        if measure_only_mode then
            print('measure only mode')
        else
            if soil_humidity.need_water() then
                if barrel.has_water() then
                    print("has enough measurements...")

                    gpio.write(config.RELAY_PIN, gpio.HIGH)
                    local running, mode = tmr.state(3)
                    if not running then
                        tmr.alarm(3, config.IRRIGATION_INTERVAL, tmr.ALARM_SINGLE, function()
                            soil_humidity.reset()
                            gpio.write(config.RELAY_PIN, gpio.LOW)
                        end)
                    end
                else
                    print("has not enough water...")
                end
            else
                print("has not enough measurements...")
            end
        end
    end)
end

function module.start()
    measure_dht_22()
    start_measurements()
end

return module
