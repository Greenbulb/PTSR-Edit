local minimal_otmulti = function(v, player)
	if not PTSR.timeover or PTSR.gameover then return end
	local gm_metadata = PTSR.currentModeMetadata()
	if gm_metadata.core_endurance then return end
	
	local graphic = v.cachePatch("MINIM_PFSPEED")
	
	if gm_metadata.player_pizzaface then
		graphic = v.cachePatch("MINIM_MAGNET")
	end
	
	local speed = (PTSR.timeover_tics*CV_PTSR.overtime_speed.value)
	local speedtext = L_FixedDecimal(FRACUNIT + speed,2)
	
	local bartooltips_y = 180
	local speed_pos = {
		x = 110,
		y = bartooltips_y
	}
	if gm_metadata.player_pizzaface
		v.draw(speed_pos.x-2, speed_pos.y+3, graphic, V_SNAPTOBOTTOM|V_HUDTRANS)
	else
		v.draw(speed_pos.x, speed_pos.y, graphic, V_SNAPTOBOTTOM|V_HUDTRANS)
	end
	v.drawString(speed_pos.x, speed_pos.y, speedtext.."X", V_SNAPTOBOTTOM|V_HUDTRANSDOUBLE, "thin-center")
end

return "OvertimeMultiplier", minimal_otmulti, "game", "minimal"