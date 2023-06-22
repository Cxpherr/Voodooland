--Shimmering Phoenix
--Created by MathTurtle, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--All face-up monsters on your opponent's field lose 200 ATK times their level until the end of the turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--All face-up monsters on your opponent's field lose 200 ATK times their level until the end of the turn.
function s.tgfilter(c)
	return c:IsAbleToGrave()
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsAttackAbove(0) and c:IsLevelAbove(0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil,tp) 
		and Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Requirement
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if Duel.SendtoGrave(tc,REASON_COST)>0 then
		--Effect
		local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
		if g and #g>0 then
			for sc in g:Iter() do
			local lv=sc:GetLevel()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(-lv*200)
				sc:RegisterEffect(e1)
				--This card cannot attack directly the turn you activate this effect.
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(3207)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e2)
			end
		end
	end
end