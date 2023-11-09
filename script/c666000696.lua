--アリバティ・フラッグ 
--Libanty Flag
--Scripted by edo9300
local s,id=GetID()
function s.initial_effect(c)
	--If opponent normal summons, special summon 1 insect 100 ATK or less from hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Same as above, but for special summons
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.filter1(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil,tp)
end
function s.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAttackPos() and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FilterMaximumSideFunctionEx(s.cfilter),tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsMonster()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	if Duel.DiscardDeck(tp,3,REASON_EFFECT)>0 then
		--Effect
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,aux.FilterMaximumSideFunctionEx(s.cfilter),tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			g=g:AddMaximumCheck()
			Duel.HintSelection(g,true)
			local tc=g:GetFirst()
			--Cannot be destroyed by battle
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3000)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffectRush(e1)
			Duel.BreakEffect()
			local ct=Duel.GetOperatedGroup():Filter(s.filter,nil):GetSum(Card.GetOriginalLevel)
			if ct>0 and tc then
				local c=e:GetHandler()
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(100*ct)
				e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
				tc:RegisterEffectRush(e2)
			end
		end
	end
end
