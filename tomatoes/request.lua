local module = {}

function module.post(data)
    http.post(local_config.API_URL,
        'Content-Type: application/json\nAccept: application/json\n',
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