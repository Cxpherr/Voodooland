--Terrortop2
--Golondrinas Glimmering Cave
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
    c:RegisterEffect(e1)
	--Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.costfilter(c)
	return c:IsMonster() and c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.val(e,c)
	if Card.IsRace(c,RACE_ZOMBIE) then
		return c:GetAttribute()
	else
		return ATTRIBUTE_LIGHT
    end    
end