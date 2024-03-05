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
        return components[componentType]
    else
        return nil
    end
end
local reactor = component.proxy(getComponent("nc_fission_reactor"))
local gpu = component.proxy(getComponent("gpu"))
local screen = getComponent("screen")
gpu.bind(screen)
local xr, yr = gpu.getResolution()
gpu.fill(1, 1, xr, yr, " ")
local function text(x, y, color, text)
    gpu.setForeground(color or 0xFFFFFF)
    gpu.set(x or 1, y or 1, text or "Hello, world!")
end
text(1, 4, 0xFFFF00, "Heat: "..tostring(reactor.getHeatLevel()) .. "/" .. tostring(reactor.getMaxHeatLevel() .. " H"))
text(1, 5, 0x00FF00, "Power: " .. tostring(reactor.getEnergyStored()) .. "/"..tostring(reactor.getMaxEnergyStored()).. " RF")
while true do
    os.sleep(0.1)
    gpu.setBackground(0x000000)
    text(1, 4, 0xFFFF00, "Heat: "..tostring(reactor.getHeatLevel()) .. "/" .. tostring(reactor.getMaxHeatLevel()) .. " H")
    text(1, 5, 0x00FF00, "Power: " .. tostring(reactor.getEnergyStored()).. "/"..tostring(reactor.getMaxEnergyStored()).. " RF")
    ratio = reactor.getHeatLevel() / reactor.getMaxHeatLevel()
    energyratio = reactor.getEnergyStored / reactor.getMaxEnergyStored
    if ratio >= 0.5 or energyratio >= 0.9 then
        reactor.deactivate()
        gpu.setBackground(0xFF0000)
        if ratio >= 0.5 then
            text(1, 7, 0xFFFFFF, "Overheating!")
        else
            text(1, 7, 0xFFFFFF, "Power Reserve Full!")
        end
    else
        reactor.activate()
        gpu.fill(1, 7, 20, 1, " ")
    end
end
