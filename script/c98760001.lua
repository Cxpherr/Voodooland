--Rut Trap
--Original Code made by Bigmen
--Modified by Avvento
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.filter1(c,tp)
    return c:IsSummonPlayer(1-tp) and (c:IsLevelAbove(5)) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function s.filter(c)
    return c:IsRace(RACE_BEAST) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsFaceup() and c:IsCanChangePosition()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.filter1,1,nil,tp) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.gyfilter(c)
    return c:IsMonster() and c:IsRace(RACE_REPTILE) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.filter, tp, LOCATION_MZONE, 0, nil)
    Duel.ChangePosition(g, POS_FACEUP_DEFENSE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    --Effect
        local tc=Duel.SelectTarget(tp, s.filter2, tp, LOCATION_MZONE, 0, 1,1,false,nil):GetFirst()
        if tc then
            local c=e:GetHandler()
            local e2=Effect.CreateEffect(c)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e2:SetType(EFFECT_TYPE_FIELD)
            e2:SetCode(EFFECT_MUST_ATTACK)
            e2:SetRange(LOCATION_MZONE)
            e2:SetTargetRange(0,LOCATION_MZONE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e2:SetCondition(s.poscon)
            tc:RegisterEffect(e2)
            local e3=e2:Clone()
            e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
            e3:SetValue(s.atklimit)
            tc:RegisterEffect(e3)
    
        end
    end
    function s.filter2(c)
        return c:IsRace(RACE_BEAST) and c:IsFaceup()
    end
    
    function s.poscon(e)
        return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
    end
    function s.atklimit(e,c)
        return c==e:GetHandler()
    end
