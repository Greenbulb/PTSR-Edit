local minimal_laps = function(v, player)
	if not player.ptsr.laptime then return end
	if player.ptsr.pizzaface then return end
	if not (consoleplayer and consoleplayer.valid) then return end

	if not player == consoleplayer then return end
	local hudst = player.hudstuff

	if hudst.anim_active then
		local lapping_pos = {
			x = 160,
			y = 15,
			flags = V_SNAPTOTOP,
			margin = 15
		}
		local lap_string = "LAP"
		local lapping_icon = v.cachePatch("BYELSTAT")
		local lapping_icon2 = v.cachePatch("FNSHICO")
		v.draw(((lapping_pos.x-lapping_pos.margin)-30), (lapping_pos.y-4), lapping_icon, lapping_pos.flags|V_HUDTRANS)
		v.drawScaled((((lapping_pos.x+lapping_pos.margin)-8))*FU, ((lapping_pos.y-4))*FU, FU/2, lapping_icon2, lapping_pos.flags|V_HUDTRANSHALF)
		v.drawString((lapping_pos.x-lapping_pos.margin), lapping_pos.y, lap_string, lapping_pos.flags|V_HUDTRANSDOUBLE, "center")
		v.drawString((lapping_pos.x+lapping_pos.margin), lapping_pos.y, player.ptsr.laps, lapping_pos.flags|V_YELLOWMAP|V_HUDTRANSDOUBLE, "center")
	end
end

return "Lapping", minimal_laps, "game", "minimal"