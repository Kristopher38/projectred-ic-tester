local ICUtils = {}

function ICUtils.toBits(num, bits)
    -- returns a table of bits, most significant first.
    bits = bits or 16
    local t = {} -- will contain the bits        
    for b = 0, bits-1, 1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
        t[b] = t[b] * 255
    end
    return t
end

function ICUtils.toDec(t)
    local sum = 0
    for idx, num in pairs(t) do
      if num > 0 then
        sum = sum + math.pow(2, idx)
      end
    end
    return sum
  end

return ICUtils