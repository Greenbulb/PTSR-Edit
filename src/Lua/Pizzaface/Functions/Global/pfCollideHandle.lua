function PTSR.pfCollideHandle(peppino, pizza)
	if peppino.player.ptsr.lastparryframe
	and (leveltime - peppino.player.ptsr.lastparryframe) <= CV_PTSR.parry_safeframes.value
	and not peppino.player.ptsr.cantparry then
		local player = peppino.player
		
		PTSR.DoParry(player.mo, pizza)
		PTSR.DoParryAnim(player.mo, true, true)
		PTSR.DoParryAnim(pizza)
		player.ptsr.lastparryframe = leveltime
	else
		P_KillMobj(peppino,pizza)
	end
end