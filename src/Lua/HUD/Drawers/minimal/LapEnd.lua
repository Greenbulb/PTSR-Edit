local gm_metadata = PTSR.currentModeMetadata()
local count = PTSR_COUNT()
local lapbonus
local ringbonus

local minimal_lapbonus = function(v,player)
	if player.ptsr.pizzaface then return end --who needs all this info for a player PF?
	if PTSR.pizzatime then
		local hudst = player.hudstuff
		--Info here
		
		-- flickering effects. uncomment if you want it
		/*local cycle_timer = 2
		if not v.showtimer
			if not v.showcycle
				v.showcycle = true
				v.showtimer = cycle_timer
			else
				v.showcycle = false
				v.showtimer = cycle_timer
			end
		else
			v.showtimer = $-1
		end*/
		
		if hudst.anim_active --HUD here
			local general_pos = {
				x = 250,
				y = 90
			}
			local clock_icon = v.cachePatch("MINIM_CLOCK")
			local rings_icon = v.cachePatch("NRNG1")
			local bonus_icon = v.cachePatch("MINIM_BONUS")
			local flags = V_SNAPTORIGHT|V_HUDTRANS
			local string_flags = "left"
			local bonus_pos = {
				x = 6,
				y = 6
			}
			if not v.showcycle
			--Lap Bonus
			v.draw(general_pos.x, general_pos.y, clock_icon, flags)
			v.draw(general_pos.x+bonus_pos.x, general_pos.y+bonus_pos.y, bonus_icon, flags)
			v.drawString(general_pos.x+23, general_pos.y+5, player.lapbonus, flags, string_flags)
			--Ring Bonus
			v.draw(general_pos.x, general_pos.y+20, rings_icon, flags)
			v.draw(general_pos.x+bonus_pos.x, general_pos.y+20+bonus_pos.y, bonus_icon, flags)
			v.drawString(general_pos.x+23, general_pos.y+25, player.ringbonus, flags, string_flags)
			end
		end
	end
end

return "LapEnd", minimal_lapbonus, "game", "minimal"