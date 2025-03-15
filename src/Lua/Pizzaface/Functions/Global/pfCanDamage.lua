function PTSR.pfCanDamage(peppino, pizza)
	if not PTSR.pizzatime then return false end
	if CV_PTSR.nuhuh.value then return false end

	if not (peppino.player and peppino.valid and peppino.player.valid) then return false end

	if peppino.player.ptsr.outofgame then return false end
	
	if peppino.player.ptsr.pf_immunity then return false end

	if peppino.player.powers[pw_invulnerability] then return false end

	if peppino.player.powers[pw_flashing] and not CV_PTSR.flashframedeath.value then return false end

	if peppino.player.ptsr.pizzaface then return false end -- lets not tag our buddies!!

	if peppino.pizza_out or peppino.pizza_in then return false end -- in pizza portal? then dont kill
	
	if peppino.player.ptsr.treasure_got then return false end -- in a "treasure got" animation?

	if pizza.player and pizza.player.valid and pizza.player.ptsr.pizzaface then
		if pizza.pfstuntime then return false end
		if not L_ZCollide(peppino,pizza) then return false end
		return true
	elseif pizza.type == MT_PIZZA_ENEMY then
		return true
	end

	return false
end