function PTSR.pfForceShieldParry(toucher, special)
	if not toucher.player.powers[pw_invulnerability] then
		PTSR.DoParry(toucher, special)
		
		PTSR.DoParryAnim(toucher, true)
		PTSR.DoParryAnim(special)
		
		if toucher.player.powers[pw_shield] & SH_FORCEHP then
			toucher.player.powers[pw_shield] = SH_FORCE|((toucher.player.powers[pw_shield] & SH_FORCEHP) - 1)
		else
			PTSR.pfDoShieldDamage(toucher, special, true, true, true)
		end
	end
end
