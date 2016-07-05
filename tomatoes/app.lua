-- file : application.lua
local module = {}

local function measure_dht_22()

    tmr.alarm(0, config.DHT_INTERVAL, tmr.ALARM_AUTO, function()
         status, temp, humi, temp_dec, humi_dec = dht.readxx(config.DHT_PIN)
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
        if soil_humidity.enough_measurements then
            print("has enough_measurements...")
        else
            print("has not enough_measurements...")
        end
    end)
end

function module.start()
    measure_dht_22()
    start_measurements()
end

return module
