--Blue Striker: Moon Burst Origins
function c5154242588.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c5154242588.tg)
	e1:SetOperation(c5154242588.op)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--atk up
	--
       local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5154242588,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetTarget(c5154242588.atktg)
	e2:SetOperation(c5154242588.atkop)
	c:RegisterEffect(e2)

		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5154242588,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c5154242588.descon1)
	e3:SetTarget(c5154242588.destg1)
	e3:SetOperation(c5154242588.desop1)
	c:RegisterEffect(e3)
end
--OPT, send a Striker you control to the deck, sp summon a different one frmo the deck.
function c5154242588.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c5154242588.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c5154242588.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5154242588.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c5154242588.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c5154242588.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5154242588.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5154242588.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


--atk 200
function c5154242588.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsFaceup()
end
function c5154242588.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5154242588.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c5154242588.atkop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c5154242588.atkfilter,tp,LOCATION_MZONE,0,nil)
    local codect=Duel.GetMatchingGroup(c5154242588.atkfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
    local atk=codect:GetClassCount(Card.GetCode)*100
    local c=e:GetHandler()
    local tc=sg:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,2)
        tc:RegisterEffect(e1)
        tc=sg:GetNext()
    end
end
function c5154242588.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c5154242588.filter(c)
	return c:IsCode(5154242564) and c:IsAbleToHand()
end
function c5154242588.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c5154242588.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c5154242588.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c5154242588.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
