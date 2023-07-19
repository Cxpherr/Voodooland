--Arts Angel Wire Tamer
--Created by Oldmind, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--Change 2 monsters face-down and destroy 1 face-down Spell/Trap
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.poscost)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
end

function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
end
function s.posfilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsCanChangePositionRush()
end
function s.posfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
		and c:IsFaceup() and c:IsCanTurnSet() and c:IsCanChangePositionRush()
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.posfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	--Requirement
	Duel.PayLPCost(tp,500)
	--Effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Group.CreateGroup()
	local tc1=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	local tc2=Duel.SelectMatchingCard(tp,s.posfilter2,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	g:AddCard(tc1)
	g:AddCard(tc2)
	if #g>1	then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local c=e:GetHandler()
		if ((tc1:IsLevelAbove(7) and tc1:IsFacedown()) or (tc2:IsLevelAbove(7) and tc2:IsFacedown()))
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local dg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
			if #dg>0 then
				local sg=dg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end