--THE BADNIKS ARENT PIZZAHEAD'S ENEMY
addHook("ShouldDamage", function(target, inflictor)
	if target.valid and target.player and target.player.ptsr.pizzaface then
	--and inflictor and inflictor.valid and (inflictor.flags & MF_ENEMY)
	--this code is gone because we want pizzaface to not die
		return false
	end
end)