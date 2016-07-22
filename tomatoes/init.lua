function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

config = require("config")
local setup = require("setup")
soil_humidity = require("soil_humidity")
local backend = require("backend")
local app = require("app")

soil_humidity.setup()
setup.start()
backend.init_server()

unrequire("setup")
unrequire("backend")