local sides = require("sides")
local component = require("component")
local utils = require("icutils")

local BundledCable = {}
BundledCable.__index = BundledCable
setmetatable(BundledCable, {__call = function(cls, addr, side)
	local self = {}
    self.device = component.proxy(addr)
    self.side = side
    self.buffer = {}

    setmetatable(self, cls)
    self:setOutput(0)
    self:commit()
	return self
end })

function BundledCable:setOutput(value)
    self.buffer = utils.toBits(value)
end

function BundledCable:setBit(bit, value)
    self.buffer[bit] = value and 255 or 0
end

function BundledCable:commit()
    self.device.setBundledOutput(self.side, self.buffer)
end

function BundledCable:getOutput()
    return utils.toDec(self.buffer)
end

function BundledCable:getOutputBit(bit)
    return self.buffer[bit]
end

function BundledCable:getInput()
    return utils.toDec(self.device.getBundledInput(self.side))
end

function BundledCable:getInputBit(bit)
    return self.device.getBundledInput(self.side)[bit]
end

function BundledCable:reset()
    self.buffer = utils.toBits(0)
end

return BundledCable