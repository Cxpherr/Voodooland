--Terrortop2
--Sky Fossil Opabinia

local s,id=GetID()
function s.initial_effect(c)
	--ATK increase + Damage + Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lc = Duel.GetMatchingGroupCountRush(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_LIGHT),tp,0,LOCATION_MZONE,nil)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,lc,nil) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler():GetRace()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.filter(c,race)
	return c:IsRace(race) and c:IsAbleToDeck()
end
function s.tdfilter(c)
    return c:IsMonster() and c:IsAbleToDeckOrExtraAsCost() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Requirement
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local sg=Duel.GetMatchingGroupCountRush(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_LIGHT),tp,0,LOCATION_MZONE,nil)
        local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,sg,sg,nil)
        Duel.HintSelection(g)
        local td=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    --Effect
    if #g>0 then
        local atk=0
        local bc=g:GetFirst()
        for bc in g:Iter() do
            atk=atk+(bc:GetLevel()*100)
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
        Duel.BreakEffect()
        local lm=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_LIGHT),tp,0,LOCATION_MZONE,nil)
        --Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_LIGHT),tp,0,LOCATION_MZONE,1,nil)
        if td>0 and #lm>0 then
                Duel.Damage(1-tp,700,REASON_EFFECT)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg=lm:Select(tp,1,1,nil)
                if #dg==0 then return end
                Duel.HintSelection(dg,true)
                Duel.Destroy(dg,REASON_EFFECT)
        end
    end
end