--Terrortop2
--Sky Fossil Marella
local s,id=GetID()
function s.initial_effect(c)
	--Change selected monster's attribute to LIGHT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.costfilter(c)
	return c:IsMonster() and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCountRush(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, nil)>0 
end
function s.attfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(tp,g,REASON_COST) 
	if g then
		--Effect
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
        local g=Duel.SelectMatchingCard(tp,s.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ATTRIBUTE_LIGHT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffectRush(e1,true)
            local i=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_LIGHT),tp,0,LOCATION_MZONE,1,nil)
            if i then
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end
	end
end