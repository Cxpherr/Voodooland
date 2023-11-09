--Deep Space Yggdrago
--Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,true,true,666000689,3)
	--Cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3001)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.indval)
	c:RegisterEffect(e1)
	--Inflict piercing battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
end

function s.indval(e,re,rp)
	return aux.indoval(e,re,rp)
end