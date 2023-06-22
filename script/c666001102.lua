--Arcanaika Force MAX - Nebulomania
--Created by Oldmind, Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
    Maximum.AddProcedure(c,nil,s.lmfilter,s.rmfilter)
	--Your opponent cannot activate Traps when this card declares an attack.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Cannot be destroyed by Spells/Traps.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.indcon)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--Maximum Handling
	c:AddCenterToSideEffectHandler(e2)
	c:AddMaximumAtkHandler()
end

--Maximum Handling
s.MaximumAttack=4000
function s.lmfilter(c)
    return c:IsCode(666001101) --Arcanaika Force MAX - Nebulomania [L]
end
function s.rmfilter(c)
    return c:IsCode(666001103) --Arcanaika Force MAX - Nebulomania [R]
end

--Your opponent cannot activate Traps when this card declares an attack.
function s.ctfilter(c)
	return c.toss_coin and c:IsMonster() and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetCondition(s.actcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsTrap() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

--Cannot be destroyed by Spells/Traps.
function s.indcon(e)
	return e:GetHandler():IsMaximumMode()
end
function s.indval(e,re,rp)
    return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and aux.indoval(e,re,rp)
end