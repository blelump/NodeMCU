-- file : application.lua
local module = {}
local barrel = require("barrel")
local soil_humidity = require("soil_humidity")
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
        barrel.check_water()
        local measure_only_mode = (gpio.read(config.MEASURE_ONLY_MODE_PIN) == 0 )
        if measure_only_mode then
            print('measure only mode')
        else
            if soil_humidity.need_water() then
                print("has enough measurements...")


                local running, mode = tmr.state(3)
                local series = 0
                local check_water = barrel.check_water()
                if not running then
                    if check_water then
                        database.insert('events', { irrigation_started = 1 })
                    end
                    tmr.alarm(3, config.DELAY_INTERVAL, tmr.ALARM_AUTO, function()

                        if check_water then
                            gpio.write(config.RELAY_PIN, gpio.HIGH)
                            tmr.alarm(4, config.IRRIGATION_INTERVAL, tmr.ALARM_SINGLE, function()
                                gpio.write(config.RELAY_PIN, gpio.LOW)
                                if series <= config.IRRIGATION_SERIES then
                                    database.insert('events', { irrigation_interval_performed = 1 })
                                else
                                    database.insert('events', { irrigation_performed = 1 })
                                    tmr.unregister(3)
                                    soil_humidity.reset()
                                end
                            end)
                        else
                            database.insert('events', { not_enough_water = 1 })
                            gpio.write(config.RELAY_PIN, gpio.LOW)
                            tmr.unregister(3)
                        end
                        series = series + 1
                    end)
                end
            else
                print("soil humidity is irrigated (above "..config.MIN_HUMIDITY..")")
            end
        end
    end)
end

function module.start()
    measure_dht_22()
    start_measurements()
end

return module
