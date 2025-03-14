addHook("MobjCollide", function(peppino, pizza)
	local player = peppino.player
	local pizza_player = pizza.player
	
	if not (player and player.valid) then return end
	if not (pizza_player.ptsr) then return end
	if not (pizza_player and pizza_player.valid) then return end
	if not (pizza_player.ptsr.pizzaface) then return end

	if not PTSR.pfCanDamage(peppino, pizza) then return end

	if not PTSR.pfCanChase(player) then return end
	
	if player.powers[pw_shield] & SH_FORCE then
		PTSR.pfForceShieldParry(peppino, pizza)
		return
	elseif player.powers[pw_shield] > 0 then
		PTSR.pfDoShieldDamage(peppino, pizza)
		return
	end
	
	PTSR.pfCollideHandle(peppino, pizza)
end, MT_PLAYER)