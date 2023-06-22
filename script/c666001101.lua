--Arcanaika Force MAX - Nebulomania [L]
--Created by Oldmind, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--Gain LP or Spin S/T
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
s.MaximumSide="Left"

--Gain LP or Spin S/T
function s.cfilter(c)
    return c:IsMonster() and c:GetAttack()==c:GetDefense() and c:IsAbleToDeckOrExtraAsCost() and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.recfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.todfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.recfilter(c)
	return c:IsMonster() and c:GetAttack()==c:GetDefense() and c:GetLevel()>0
end
function s.todfilter(c)
	return c:IsSpellTrap() and c:IsAbleToDeck()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    --Requirement
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
	if Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)>0 then
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
		--Gain LP equal to [the Level of 1 monster (with the same ATK and DEF) in your GY] x 300, then add it to the hand.
		if res==COIN_HEADS then
			local g=Duel.SelectMatchingCard(tp,s.recfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				local lvl=0
				Duel.HintSelection(g)
				local tc=g:GetFirst()
				for tc in g:Iter() do
					lvl=lvl+(tc:GetLevel()*300)
				end
				if Duel.Recover(tp,lvl,REASON_EFFECT)>0 then
					Duel.SendtoHand(tc,tp,REASON_EFFECT)
					Duel.ShuffleHand(tp)
				end
			end
		--Shuffle 1 Spell/Trap your opponent controls into the Deck.
		elseif res==COIN_TAILS then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,s.todfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
    end
end

