local ICTester = require("ictester")
local colors = require("colors")

local argv = {...}
local iterations = argv[1] and argv[1] or 10
local stand = ICTester()

local operands = {
    ["add"] = {
        func = function(a,b) return a+b end,
        opstring = "+",
        name = "addition",
        control = 6
    },
    ["or"] = {
        func = function(a,b) return a|b end,
        opstring = "|",
        name = "bitwise or",
        control = 0
    },
    ["and"] = {
        func = function(a,b) return a&b end,
        opstring = "&",
        name = "bitwise and",
        control = 2
    },
    ["not"] = {
        func = function(a,b) return ~a end,
        opstring = "(not a)",
        name = "bitwise not",
        control = 4
    },
    ["sub"] = {
        func = function(a,b) return a-b end,
        opstring = "-",
        name = "subtraction",
        control = 7
    },
    ["shl"] = {
        func = function(a,b) return (a|b) << 1 end,
        opstring = "(shift left a|b)",
        name = "bitwise shift left",
        control = 16
    },
    ["shr"] = {
        func = function(a,b) return (a|b) >> 1 end,
        opstring = "(shift right a|b)",
        name = "bitwise shift right",
        control = 8
    }
}

local function concatOps(a, b)
    return (b << 8) | a
end

local function truncateVal(val)
    return val & 0x000000FF
end

local function testOperand(op, iterations)
    local errors = 0
    print("Performing "..op.name.." test")
    stand.top:reset()
    stand.top:setOutput(op.control)
    stand.top:commit()
    for i = 1, iterations do
        local a = math.random(0, 255)
        local b = math.random(0, 255)
        stand.bottom:setOutput(concatOps(a, b))
        stand.bottom:commit()
        local res = stand.right:getInput()
        local trueRes = truncateVal(op.func(a, b))
        if trueRes ~= res then
            print("Error, "..a.." "..op.opstring.." "..b.." = "..trueRes..", got "..res.." instead")
            errors = errors + 1
        end
    end
    print("Finished running "..op.name.." test, encountered "..errors.." errors")
end

for op, opdata in pairs(operands) do
    testOperand(opdata, iterations)
end

stand:resetAll()
stand:commitAll()

