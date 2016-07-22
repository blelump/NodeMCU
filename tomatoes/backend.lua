local module = {}

function module.init_server()
    sv = net.createServer(net.TCP, 30)
    sv:listen(80, function(c)
        c:on("receive", function(c, payload)
            -- local mimeType = string.match(payload, "Content%-Type: ([%w/-]+)")
            local path = string.sub(payload,
                                    string.find(payload,"POST /") + 6,
                                    string.find(payload,"HTTP/")  - 2 )
            -- local bodyStart = payload:find("\r\n\r\n", 1, true)
            -- local body = payload:sub(bodyStart, #payload)

            if path == "irrigate" then
                local irrigation = require('irrigation')
                irrigation.irrigate()
                unrequire('irrigation')
                -- local request_data
                -- request_data = cjson.decode(body)
                -- for k,v in pairs(request_data) do print(k,v) end
            elseif path == "reset" then
                tmr.alarm(5, 2000, tmr.ALARM_SINGLE, function()
                    node.restart()
                end)
            elseif path == "irrigate/halt" then
                config.PREVENT_IRRIGATION = true
            elseif path == "irrigate/resume" then
                config.PREVENT_IRRIGATION = false
            end
            path = nil



            local response = "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n OK"
            c:send(response)
            c:on("sent",function(conn)
                conn:close()
            end)
            response = nil
        end)

    end)
end

return module
