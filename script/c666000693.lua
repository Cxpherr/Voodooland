--Deep Warning Fusion
--Coded by Voodoo
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.RegisterSummonEff{handler=c,extrafil=s.fextra,mincount=2,maxcount=99,stage2=s.stage2}
	c:RegisterEffect(e1)
end

function s.check(tp,sg,fc)
    return sg:GetClassCount(function(c) return c:GetLocation() end)==1
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(nil,tp,LOCATION_HAND|LOCATION_MZONE,0,nil),s.check
end
function s.stage2(e,tc,tp,sg,chk)
    if chk==0 and sg:IsExists(Card.IsCode,1,nil,fc,SUMMON_TYPE_FUSION,tp,666000689)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
        g=g:AddMaximumCheck()
        Duel.HintSelection(g,true)
        Duel.BreakEffect()
        Duel.Destroy(g,REASON_EFFECT)
    end
end