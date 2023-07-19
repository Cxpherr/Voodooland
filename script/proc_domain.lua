if not aux.DomainProcedure then
	aux.DomainProcedure = {}
	Domain = aux.DomainProcedure
end
if not Domain then
	Domain = aux.DomainProcedure
end


function Domain.AddProcedure(c,id)
    --Domain Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Domain.Cost(c,id))
	c:RegisterEffect(e1)
end
function Domain.CostFilter(c,id,tp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,id),tp,LOCATION_FZONE,0,1,nil)
end
function Domain.Cost(c,id)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.IsExistingMatchingCard(Domain.CostFilter,tp,LOCATION_FZONE,0,1,nil,id,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,Domain.CostFilter,tp,LOCATION_FZONE,0,1,1,nil,id,tp)
				Duel.SendtoGrave(g,REASON_COST)
			end
end