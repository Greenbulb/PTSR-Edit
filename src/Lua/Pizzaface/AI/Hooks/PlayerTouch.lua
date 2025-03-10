-- Player Touches AI
addHook("TouchSpecial", function(special, toucher)
	-- toucher: player
	-- special: pizzaface
	
	return PTSR.pfAITryDamage(special, toucher)
end, MT_PIZZA_ENEMY)