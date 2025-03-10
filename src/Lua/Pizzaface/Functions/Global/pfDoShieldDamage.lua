-- When Pizzaface damages a shield.
function PTSR.pfDoShieldDamage(toucher, special, disablepfstop, nosound, disableparry)
	if not toucher.player.powers[pw_invulnerability] then
		local pointangle = R_PointToAngle2(toucher.x, toucher.y, special.x, special.y)
		local pfspeed = FixedHypot(special.momx, special.momy)
		local flashtime = TICRATE
		local pfstoptime = TICRATE
		
		toucher.player.powers[pw_flashing] = $ + flashtime
		
		if toucher.player.ptsr then
			toucher.player.ptsr.pf_immunity = $ + flashtime
		end
		
		if not disablepfstop then
			if PTSR.isOvertime() then
				pfstoptime = $ / 2
			end
			
			special.momx = $/3
			special.momy = $/3
			special.momz = $/3
			
			special.pfstuntime2 = $ + pfstoptime
		end

		toucher.state = S_PLAY_FALL
		
		if PTSR.isOvertime() and not disableparry then
			nosound = true
			
			PTSR.DoParry(special, toucher, (FU) + (FU/2))
			PTSR.DoParryAnim(special, true)
			
			PTSR.DoHitlag(special)
			PTSR.DoHitlag(toucher)
			
			PTSR.ParryList[toucher] = {
				time_left = PTSR.ParryStunFrames,
				add_angle = 0,
			}
		else
			P_Thrust(toucher, pointangle - ANGLE_180, pfspeed*2)
			P_SetObjectMomZ(toucher, 5*FU, true)
		end
		
		if not nosound then
			S_StartSound(toucher, sfx_s1a3)
		end
		
		toucher.player.powers[pw_shield] = SH_NONE
	end
end