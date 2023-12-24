local s, id = GetID()
function s.initial_effect(c)
    --Mill
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DECKDES + CATEGORY_DRAW + CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.battlePositionCost) -- Change the cost function
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

-- Battle pos change
function s.battlePositionCost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsCanChangePosition()
    end
    local pos = e:GetHandler():GetPosition()
    if pos == POS_FACEUP_ATTACK then
        Duel.ChangePosition(e:GetHandler(), POS_FACEUP_DEFENSE)
    elseif pos == POS_FACEUP_DEFENSE then
        Duel.ChangePosition(e:GetHandler(), POS_FACEUP_ATTACK)
    end
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDiscardDeckAsCost(tp, 1) and Duel.IsPlayerCanDiscardDeckAsCost(1 - tp, 1) and
               Duel.IsPlayerCanDraw(1 - tp, 1) and (Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) > 0)
    end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    -- Effect
    local c = e:GetHandler()
    -- mill
    local dc = Duel.GetDecktopGroup(tp, 1):GetFirst()
    local dc2 = Duel.GetDecktopGroup(1 - tp, 1):GetFirst()

    local cards = Group.CreateGroup()
    Group.AddCard(cards, dc)
    Group.AddCard(cards, dc2)
    if Duel.SendtoGrave(cards, REASON_EFFECT) > 0 then
        if dc:IsType(TYPE_MONSTER) or dc2:IsType(TYPE_MONSTER) then
            local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
            local ng = Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
            if ng ~= 0 then
                Duel.BreakEffect()
                Duel.Draw(1 - tp, ng, REASON_EFFECT)
            end
        end
    end
end