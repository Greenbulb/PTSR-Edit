-- And rings too.

local minimal_score = function(v, player)
	if player.ptsr.pizzaface then return end --who needs all this info for a Player PF?
	
	local general_pos = {
		x = 2,
		y = 2
	}
	local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS
	local string_flags = "thin-right"
	--score
	local score = player.score
	local score_icon = v.cachePatch("NHUD1")
	v.draw(general_pos.x, general_pos.y, score_icon, flags)
	v.drawString(general_pos.x+55, general_pos.y+5, score, flags, string_flags)
	--rings
	local rings = player.rings
	local rings_icon = v.cachePatch("NRNG1")
	v.draw(general_pos.x, general_pos.y+20, rings_icon, flags)
	v.drawString(general_pos.x+35, general_pos.y+25, rings, flags, string_flags)
	if hud.enabled("rings")
		hud.disable("rings")
	end
end

return "Score", minimal_score, "game", "minimal"