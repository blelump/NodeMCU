local module = {}

function module.irrigate()
    local database = require("database")
    if config.PREVENT_IRRIGATION == true then
        database.insert('events', { irrigation_halted = 1 })
        unrequire('database')
        database = nil
        return false
    end

    local running, mode = tmr.state(3)
    local series = 0
    local barrel = require("barrel")
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
                        unrequire("barrel")
                        soil_humidity.reset()
                    end
                end)
            else
                database.insert('events', { not_enough_water = 1 })
                gpio.write(config.RELAY_PIN, gpio.LOW)
                tmr.unregister(3)
                unrequire("barrel")
            end
            series = series + 1
        end)
    end
end

return module