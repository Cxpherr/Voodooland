--天装ダグラシック
--Heavenly Arms - Daglassic
--scripted by CyberVII
local s,id=GetID()
function s.initial_effect(c)
	--equip
	aux.AddEquipProcedure(c,0,s.eqfilter,s.eqlimit)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--gain lp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHIC) and not c:IsMaximumModeSide()
end
s.listed_series={0x7f}
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	return e:GetHandler():GetEquipTarget()==ec and ec:IsControler(tp)
		and bc:IsPreviousControler(1-tp) and bc:IsReason(REASON_BATTLE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,1000,REASON_EFFECT)
end
function s.eqlimit(e,c)
	return c:IsFaceup()
end