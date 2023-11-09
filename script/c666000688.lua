--Dual Space Yggdrago
--Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,true,true,666000689,2)
	--Attack any number of times equal to [the number of monsters on your opponent's field]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.mltg)
	e1:SetOperation(s.mlop)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCountRush(tp,0,LOCATION_MZONE)>0
end
function s.mltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFieldGroupCountRush(tp,0,LOCATION_MZONE)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp) and mg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,0,mg,tp,0)
end

function s.mlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Requirement
	local mg=Duel.GetFieldGroupCountRush(tp,0,LOCATION_MZONE)
	if mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE)),tp,LOCATION_GRAVE,0,mg,mg,nil)
		Duel.HintSelection(g)
		if #g>0 then
			local td=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			--Effect
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(td-1)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			c:RegisterEffect(e1)
			if td==3 then
				--Inflict piercing battle damage
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_PIERCE)
				e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
				c:RegisterEffect(e2)
			end
		end
	end
end
