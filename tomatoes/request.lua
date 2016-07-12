local module = {}

function module.post(url, data)
    http.post(url,
        nil,
        data,
        function(code, data)
            if (code < 0) then
              print("HTTP request failed")
            else
              print(code, data)
            end
        end)
end

return module
