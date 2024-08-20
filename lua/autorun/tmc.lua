if SERVER then
    AddCSLuaFile("tmc/notification.lua")
    AddCSLuaFile("tmc/init.lua")
else
    include("tmc/notification.lua")
    include("tmc/init.lua")
end