local request = require("request")
local local_config = require("local_config")

local module = {}

local function db_address()
    return local_config.DB_ADDRESS.."?db="..local_config.DB_NAME
end

function module.insert(table_name, data_hash)
    local data = ""
    for key,value in pairs(data_hash) do
      data = data.." "..table_name..",param="..key.." value="..value.."\n"
    end
    print(db_address())
    print(data)
    request.post(db_address(), data)
    unrequire("database")
end



return module