computer = require("computer")
component = require("component")
local function invertTable(table)
    local newtable = {}
    for i, v in pairs(table) do
        newtable[v] = i
    end
    return newtable
end
local function getComponent(componentType)
    local components = invertTable(component.list())
    if components[componentType] then
        computer.beep(2000, 1)
        return components[componentType]
    else
        return nil
    end
end
local reactor = component.proxy(getComponent("nc_fission_reactor"))
local gpu = component.proxy(getComponent("gpu"))
local screen = getComponent("screen")
gpu.bind(screen)
local function text(x, y, color, text)
    gpu.setForeground(color or 0xFFFFFF)
    gpu.set(x or 1, y or 1, text or "Hello, world!")
end
text(2, 4, "Heat: "..tostring(reactor.getHeatLevel()) .. "/" .. tostring(reactor.getMaxHeatLevel() .. " H"))
text(2, 5, 0x00FF00, "Power: " .. tostring(reactor.getEnergyStored().. "/"..tostring(reactor.getMaxEnergyStored).. " RF"))
while true do
    os.sleep(0.1)
    text(2, 4, 0xFFFF00, "Heat: "..tostring(reactor.getHeatLevel()) .. "/" .. tostring(reactor.getMaxHeatLevel()) .. " H")
    text(2, 5, 0x00FF00, "Power: " .. tostring(reactor.getEnergyStored()).. "/"..tostring(reactor.getMaxEnergyStored()).. " RF")
    ratio = reactor.getHeatLevel() / reactor.getMaxHeatLevel()
    if ratio >= 0.5 then
        reactor.deactivate()
    else
        reactor.activate()
    end
end
