--Sevens Road Lancer Magician
local s,id=GetID()
Duel.LoadScript("init.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Summon Procedure
	Influx.AddProcedure(c,160301001,160001037)
end