-- By: Luigi Budd

--for external modification
local minim_combo_offsets = function(v)
	if not v.combo_width
		v.combo_width = 0
	end
	if not v.combo_posx
		v.combo_posx = 0
	end
	if not v.combo_posy
		v.combo_posy = 0
	end
end
hud.add(minim_combo_offsets, "game")

local combo_x,combo_y = 0,hudinfo[HUD_RINGS].y

local function combo_hud(v, player)
	if not PTSR.PlayerHasCombo(player) then 
		return
	end
	if player.ptsr.pizzaface then return end --who needs all this info for a Player PF?

	local combo_x,combo_y = 0+v.combo_posx,hudinfo[HUD_RINGS].y+v.combo_posy
	
	local prank_able = player.ptsr.combo_timesfailed == 0 and player.ptsr.combo_times_started == 1 
	local c_count = player.ptsr.combo_count

	v.drawFill(combo_x, combo_y,
		80+v.combo_width, 23,
		31|V_HUDTRANSHALF|V_SNAPTOLEFT|V_SNAPTOTOP
	)
	
	v.drawNum(combo_x + 26,
		combo_y + 6,
		c_count,
		V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP
	
	)
	v.drawString(combo_x + 28,
		combo_y + 6,
		"Combo!",
		V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"thin"
	)
	
	do
		local width = FixedMul(
			FixedDiv(player.ptsr.combo_timeleft, player.ptsr.combo_maxtime),
			40+v.combo_width
		)
		v.drawFill(combo_x + 28 + 1,
			combo_y + 14 + 1,
			40+v.combo_width, 2,
			27|V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS
		)
		v.drawFill(combo_x + 28,
			combo_y + 14,
			width, 2,
			(prank_able and 161 or 3)|V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS
		)
		
	end
end

return "Combo", minim_combo_offsets, "game", "minimal"