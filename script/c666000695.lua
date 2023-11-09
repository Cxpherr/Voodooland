--Deep Space Impact
--Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--Opponent's attacking monster loses ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local g=Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_GRAVE,0,nil)
	return tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsRace(RACE_CYBERSE) and tc:IsType(TYPE_FUSION) and #g>2 and #g2>0
end
function s.cfilter1(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeckOrExtraAsCost()
end
function s.cfilter2(c)
	return (c:IsCode(CARD_FUSION) or c:IsCode(666000693)) and c:IsAbleToDeckOrExtraAsCost()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttackTarget()
	if chk==0 then return tg:IsControler(tp) and tg:IsOnField() end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	local g=Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_GRAVE,0,3,3,nil)
	local sg2=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	sg:Merge(sg2)
	if #sg==0 then return end
	Duel.HintSelection(sg,true)
	if Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #og>0 then Duel.SortDecktop(tp,tp,#og) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.BreakEffect()
	local tc=Duel.GetAttacker()
	local tg=Group.CreateGroup()
	tg:AddCard(tc)
	tg=tg:AddMaximumCheck()
	Duel.Destroy(tg,REASON_EFFECT)
end
