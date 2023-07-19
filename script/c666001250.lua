--Arts Angel Full Metal Position
--Created by Oldmind, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,160011014,160011013)
	--Flip 1 monster face-down and inflict damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	if sc and Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)>0 then
		local val=sc:GetFirst():GetLevel()
		if val==0 then return end
		Duel.BreakEffect()
		if Duel.Damage(1-tp,val*200,REASON_EFFECT)>0 then
			c:AddPiercing(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		end
	end
end