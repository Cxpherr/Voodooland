-- King of Trilobites
-- Scripted by Avvento
local s, id = GetID()
function s.initial_effect(c)
	-- Draw and tribute summon lock
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 2, nil)
end

function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsPlayerCanDraw(tp, 1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	local draw = Duel.Draw(p, d, REASON_EFFECT)
	if draw > 0 then
		-- Apply restriction on Tribute Summoning
		local e2 = Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(s.sumlimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.sumlimit(e, c, tp, sumtp)
    return (sumtp & SUMMON_TYPE_TRIBUTE) == SUMMON_TYPE_TRIBUTE and not (c:IsRace(RACE_ROCK) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WINGEDBEAST) or c:IsRace(RACE_DINOSAUR))
end