local BundledCable = require("bundledcable")
local component = require("component")
local sides = require("sides")

local ICTester = {}
ICTester.__index = ICTester
setmetatable(ICTester, {__call = function(cls, addr)
    local self = {}
    addr = addr or component.redstone.address
    self.top = BundledCable(addr, sides.left)
    self.bottom = BundledCable(addr, sides.back)
    self.left = BundledCable(addr, sides.front)
    self.right = BundledCable(addr, sides.right)

	setmetatable(self, cls)
	return self
end })

function ICTester:resetAll()
    self.top:reset()
    self.bottom:reset()
    self.left:reset()
    self.right:reset()
end

function ICTester:commitAll()
    self.top:commit()
    self.bottom:commit()
    self.left:commit()
    self.right:commit()
end

return ICTester