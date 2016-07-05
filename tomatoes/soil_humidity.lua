local module = {}

module.mean_humidity = 0
module.min_measurements = config.MEASUREMENT_COUNT
module.enough_measurements = false

local function mean_avg(humidity)
    module.mean_humidity = stats.compute_10_args_mean(humidity)
end

local function ensure_enough_measurements()
    if module.enough_measurements then
        return true
    end
    if module.min_measurements == 0 then
        module.enough_measurements = true
    else
        module.min_measurements = module.min_measurements - 1
    end
end

function module.measure()
    gpio.write(config.YL_PIN, gpio.HIGH)
    tmr.alarm(2, 500, tmr.ALARM_SINGLE, function()
        humidity = 1023 - adc.read(0)
        mean_avg(humidity)
        ensure_enough_measurements()

        print("humidity: ", humidity,
            ", avg("..config.MEASUREMENT_COUNT.."): ", module.mean_humidity)
        request.post([[{"data": {"yl":{ "humidity": "]]..humidity..[[",
        "mean_avg": "]]..module.mean_humidity..[["}}}]])

        gpio.write(config.YL_PIN, gpio.LOW)
    end)
end

function module.setup()
    adc.force_init_mode(adc.INIT_ADC)
end

return module