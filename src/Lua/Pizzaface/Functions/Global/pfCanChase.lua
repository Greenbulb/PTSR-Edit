function PTSR.pfCanChase(player)
	return (not player.ptsr.outofgame and not player.spectator and not player.quittime and not player.ptsr.pizzaface
			and not player.mo.pizza_out and not player.mo.pizza_in and player.playerstate ~= PST_DEAD
			and player.mo.health and not player.ptsr.treasure_got)
end