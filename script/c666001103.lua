--Arcanaika Force MAX - Nebulomania [L]
--Created by Oldmind, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--Attack Thrice or Face-Down Boardwipe
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_COIN+CATEGORY_RECOVER+CATEGORY_TOHAND)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
	--Maximum Handling
    c:AddSideMaximumHandler(e1)
end

--Coin Toss Handling
s.toss_coin=true

--Maximum Handling
s.MaximumSide="Right"

--Gain LP or Spin S/T
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,2000) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(s.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(s.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.fdfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    --Requirement
	Duel.PayLPCost(tp,2000)
	--Effect
	local c=e:GetHandler()
	local res=COIN_NIL
	--If this card is in Maximum Mode, you can apply one of these effects regardless of the result.
	if e:GetHandler():IsMaximumModeCenter() then
		local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
		if opt==0 then
			res=COIN_HEADS
		elseif opt==1 then
			res=COIN_TAILS
		elseif opt==2 then
			res=Duel.TossCoin(tp,1)
		end
	else
		res=Duel.TossCoin(tp,1)
	end
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	--This card can declare up to 3 attacks on monsters this turn.
	if res==COIN_HEADS then
		local ex=Effect.CreateEffect(c)
		ex:SetDescription(aux.Stringid(id,4))
		ex:SetType(EFFECT_TYPE_SINGLE)
		ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		ex:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		ex:SetValue(2)
		ex:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(ex)
	--Destroy all face-down monsters on the field.
	elseif res==COIN_TAILS then
		local sg=Duel.GetMatchingGroup(s.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

