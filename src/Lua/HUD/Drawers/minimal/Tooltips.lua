local minimal_tooltips = function(v, player)
	if player.ptsr.pizzaface then return end --who needs all this info for a player PF?
	
	if (not player.ptsr.pizzaface) and (player.ptsr.outofgame) and (player.playerstate ~= PST_DEAD) 
	and not (player.ptsr.laps >= PTSR.maxlaps and CV_PTSR.default_maxlaps.value) and not PTSR.gameover then
		if not player.hold_newlap then
			v.drawString(160, 160, "\x85\* Hold FIRE to try a new lap! *", V_TRANSLUCENT|V_SNAPTOBOTTOM|V_PERPLAYER, "thin-center")
		else
			local percentage = (FixedDiv(player.hold_newlap*FRACUNIT, PTSR.laphold*FRACUNIT)*100)/FRACUNIT
			v.drawString(160, 160, "\x85\* CHARGING \$percentage\% *", V_TRANSLUCENT|V_SNAPTOBOTTOM|V_PERPLAYER, "thin-center")
		end
	end
	
	if PTSR.pizzatime then
		local gm_metadata = PTSR.currentModeMetadata()
		local bartooltips_y = 180
		local tooltip_flags = V_SNAPTOBOTTOM
		
		if gm_metadata.core_endurance then
			--PF Speed
			local pfspeed_string = string.format("%.2fX", PTSR.pizzaface_speed_multi)
			local speed_pos = {
				x = 110,
				y = bartooltips_y
			}
			local speed_icon = v.cachePatch("MINIM_PFSPEED")
			v.draw(speed_pos.x, speed_pos.y, speed_icon, tooltip_flags|V_HUDTRANS)
			v.drawString(speed_pos.x, speed_pos.y, pfspeed_string, tooltip_flags|V_HUDTRANSDOUBLE, "thin-center")
		
			--Difficulty
			local diff_string = string.format("%.2f", PTSR.difficulty)
			local diff_pos = {
				x = 208,
				y = bartooltips_y
			}
			local diff_icon = v.cachePatch("MINIM_DIFF")
			v.draw(diff_pos.x, diff_pos.y, diff_icon, tooltip_flags|V_HUDTRANS)
			v.drawString(diff_pos.x, diff_pos.y, diff_string, tooltip_flags|V_ROSYMAP|V_HUDTRANSDOUBLE, "thin-center")
		end
		
		--Laps
		local laps_pos = {
			x = 154,
			y = bartooltips_y+1
		}
		local laps_icon = v.cachePatch("FNSHICO")
		local infinitelapstext = tostring(player.ptsr.laps)
		local lapstext = player.ptsr.laps.."/"..PTSR.maxlaps
		v.drawScaled((laps_pos.x-4)*FU, (laps_pos.y-10)*FU, FU/2,laps_icon,tooltip_flags|V_20TRANS)
		if CV_PTSR.default_maxlaps.value then
			v.drawString(laps_pos.x+(4-(1/2)), laps_pos.y-6, lapstext, tooltip_flags|V_YELLOWMAP|V_HUDTRANSDOUBLE, "thin-center")
		else
			v.drawString(laps_pos.x+(4-(1/2)), laps_pos.y-6, infinitelapstext, tooltip_flags|V_YELLOWMAP|V_HUDTRANSDOUBLE, "center")
		end
	end
end

return "Tooltips", minimal_tooltips, "game", "minimal"