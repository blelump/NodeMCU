local module = {}

function module.has_water()
    print("Barrel water state (1 is enough water): ", gpio.read(config.CMW_PIN))
    return (gpio.read(config.CMW_PIN) == 1)
end

return module
