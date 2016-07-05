local module = {}

function module.has_water()
    return gpio.read(config.CMW_PIN)
end

return module