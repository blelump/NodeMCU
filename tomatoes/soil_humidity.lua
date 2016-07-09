local module = {}
local stats = require("stats")
local request = require("request")


local function mean_avg(humidity)
    module.mean_humidity = stats.compute_10_args_mean(humidity)
end

local function ensure_enough_measurements()
    if module.enough_measurements then
        module.min_measurements = nil
        return true
    end
    if module.min_measurements == 0 then
        module.enough_measurements = true
    else
        module.min_measurements = module.min_measurements - 1
    end
end

function module.need_water()
    return module.enough_measurements and
        module.mean_humidity < config.MIN_HUMIDITY
end

function module.reset()
    module.min_measurements = config.MEASUREMENT_COUNT
    module.enough_measurements = false
    module.mean_humidity = 0
end

function module.measure()
    gpio.write(config.YL_PIN, gpio.HIGH)
    tmr.alarm(2, 500, tmr.ALARM_SINGLE, function()
        local humidity
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
    module.reset()
    adc.force_init_mode(adc.INIT_ADC)
end

return module
