function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

config = require("config")
local setup = require("setup")
local soil_humidity = require("soil_humidity")

soil_humidity.setup()
setup.start()

unrequire("setup")
unrequire("soil_humidity")
