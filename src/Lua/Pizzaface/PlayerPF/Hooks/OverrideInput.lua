addHook("PreThinkFrame", do
	if not PTSR.IsPTSR() then return end
	if PTSR.gameover then return end
	for p in players.iterate do
		if not (p.ptsr and p.ptsr.pizzaface) then continue end
		-- to prevent weird shit lmfao
		p.ptsr.pfbuttons = p.cmd.buttons
		p.cmd.buttons = 0
	end
end)

addHook("PlayerCmd", function (player, cmd)
	if player.ptsr.pizzaface and player.realmo.pfstuntime then
		cmd.buttons = 0
		cmd.forwardmove = 0
		-- dont do sidemove cuz face swapping
	end
end)
