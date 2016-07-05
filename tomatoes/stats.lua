local module = {}

module.elements = {}

local function shift()
  table.remove(module.elements, 1)
end

local function push(arg)
  table.insert(module.elements, arg)
end

local function mean()
  local sum = 0
  local count= 0

  for i, num in ipairs(module.elements) do
    sum = sum + num
    count = count + 1
  end

  return (sum / count)
end

function module.compute_10_args_mean(arg)
    local mean_avg = 0
    push(arg)
    mean_avg = mean()
    if table.maxn(module.elements) == config.MEASUREMENT_COUNT + 1 then
        shift()
    end
    return mean_avg
end

return module
