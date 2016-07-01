-- file : application.lua
local module = {}

local function req_post(data)
    http.post(config.API_URL,
        'Content-Type: application/json\nAccept: application/json\n',
        data,
        function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(code, data)
        end
    end)
end

local function dht_22()

    tmr.alarm(0, config.DHT_INTERVAL, tmr.ALARM_AUTO, function()
         status, temp, humi, temp_dec, humi_dec = dht.readxx(config.DHT_PIN)
         if status == dht.OK then
             -- Float firmware using this example
             print("DHT Temperature:"..temp.."; ".."Humidity:"..humi)

             req_post([[{"data": {"dht":{"temperature": "]]..temp..[[",
                          "humidity": "]]..humi..[["}}}
             ]])

         elseif status == dht.ERROR_CHECKSUM then
             print( "DHT Checksum error." )
         elseif status == dht.ERROR_TIMEOUT then
             print( "DHT timed out." )
         end
    end)
end

local function yl_38()
    adc.force_init_mode(adc.INIT_ADC)

    tmr.alarm(1, config.YL_INTERVAL, tmr.ALARM_AUTO, function()
        gpio.write(config.YL_PIN, gpio.HIGH)
        tmr.alarm(2, 500, tmr.ALARM_SINGLE, function()
            humidity = 1023 - adc.read(0)
            avg = stats.compute_10_args_mean(humidity)
            print("humidity: ", humidity,
                ", avg("..config.MEASUREMENT_COUNT.."): ", avg)
            req_post([[{"data": {"yl":{ "humidity": "]]..humidity..[[",
            "mean_avg": "]]..avg..[["}}}]])

            gpio.write(config.YL_PIN, gpio.LOW)
        end)
    end)
end

function module.start()
    dht_22()
    yl_38()
end

return module
