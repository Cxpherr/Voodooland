-- Tunnelado Buster
-- Scripted by Avvento
-- [REQUIREMENT]
-- Change 1 Attack Position EARTH Attribute Machine Type monster on your field to face-up Defense Position.
-- [EFFECT]
-- Inflict damage to your opponent equal to [the Level of the monster changed to face-up Defense Position to meet the requirement] x 100, then if you control a face-up Level 7 or higher EARTH Attribute Machine Type monster, you can change 1 face-up monster on the field to face-down Defense Position.
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION + CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.con)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
end

function s.cfilter(c)
    return c:IsFaceup() and c:IsAttackPos() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsCanChangePositionRush()
end

function s.con(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.cfilter1(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(7)
end

function s.cfilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsCanChangePositionRush()
end


function s.op(e, tp, eg, ep, ev, re, r, rp)
    -- Requirement and burn
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
    local g = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
    if #g > 0 and Duel.ChangePosition(g, POS_FACEUP_DEFENSE) == #g then
        local val = g:GetFirst():GetLevel() * 100
        Duel.Damage(1 - tp, val, REASON_EFFECT)

        -- Change to face-down
        if Duel.IsExistingMatchingCard(s.cfilter1, tp, LOCATION_MZONE, 0, 1, nil)
        and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
            local tc=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	        Duel.HintSelection(Group.FromCards(tc))
	        if tc and tc:IsFaceup() then
		        Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
            end
        end
    end
end