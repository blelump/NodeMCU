local database = require("database")

local module = {}

function module.has_water()
    local water_state = gpio.read(config.CMW_PIN)
    print("Barrel water state (1 is enough water): ", water_state)
    database.insert('measurements', { barrel_water_state = water_state })
    return (water_state == 1)
end

return module
