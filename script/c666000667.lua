--Super Polymerization
--Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
    --Activate
	local params={nil,Fusion.OnFieldMat(Card.IsFaceup),s.fextra,nil,nil,nil,nil}
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e1:SetOperation(s.operation(Fusion.SummonEffOP(table.unpack(params))))
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function s.operation(oldop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		-- Requirement
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		if Duel.SendtoGrave(g,REASON_COST)>0 then
			-- Effect
			oldop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function s.fextra(e,tp,mg)
    return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
end