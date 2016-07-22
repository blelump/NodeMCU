-- file : application.lua
local module = {}

local database = require("database")

module.performing_water = false

local function measure_dht_22()

    tmr.alarm(0, config.DHT_INTERVAL, tmr.ALARM_AUTO, function()
         local status, temp, humi, temp_dec, humi_dec = dht.readxx(config.DHT_PIN)
         if status == dht.OK then
             -- Float firmware using this example
             print("DHT Temperature:"..temp.."; ".."Humidity:"..humi)

             database.insert('measurements', { air_temperature = temp,
                air_humidity = humi})

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
        local barrel = require('barrel')
        barrel.check_water()
        unrequire('barrel')

        local measure_only_mode = (gpio.read(config.MEASURE_ONLY_MODE_PIN) == 0 )
        if measure_only_mode then
            print('measure only mode')
        else
            if soil_humidity.need_water() then
                print("has enough measurements...")

                local irrigation = require('irrigation')
                irrigation.irrigate()
                unrequire('irrigation')
                irrigation = nil
            else
                print("soil humidity is irrigated (above "..config.MIN_HUMIDITY..")")
            end
        end
    end)
end

function module.start()
    database.insert('events', { node_started = 1 })
    measure_dht_22()
    start_measurements()
end

return module
