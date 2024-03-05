component = require("component")
local reactor = component.nc_fission_reactor
local gpu = component.proxy(component.gpu)
local screen = component.screen
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
