return function(player)
	local forwardmove = player.cmd.forwardmove
	local sidemove = player.cmd.sidemove

	if not (player.mo and player.mo.flags2 & MF2_TWOD) then
		local camera_angle = (player.cmd.angleturn<<16)
		local controls_angle = R_PointToAngle2(0,0, forwardmove<<16, -sidemove<<16)

		return camera_angle + controls_angle
	end

	if sidemove > 0 then
		return 0
	elseif sidemove < 0 then
		return ANGLE_180
	end
end