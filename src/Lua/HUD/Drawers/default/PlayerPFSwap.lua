local faceswap_hud = function(v, player)
	if not PTSR.IsPTSR() then return end
	if not (player.ptsr.pizzaface and leveltime) then return end
	if player.realmo.pfstuntime and PTSR.pizzatime_tics < TICRATE*CV_PTSR.pizzatimestun.value then
		v.drawString(160, 150, "Move left and right to swap faces", V_ALLOWLOWERCASE, "small-center")
	end
end

return "PlayerPFSwap", faceswap_hud