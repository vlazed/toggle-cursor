if SERVER then
    AddCSLuaFile("tmc/init.lua")
else
    include("tmc/init.lua")
end