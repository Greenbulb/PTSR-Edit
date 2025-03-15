local PLAYPF_SPEED = 28*FU
local PLAYPF_DEADZONE = 50 / 10

local controls_angle = PTSR.Require("Pizzaface/Functions/ControlsAngle")

return function(player)
	-- handle movement
	-- community feedback recommended us that we do this
	-- literallymario/saxa

	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0

	local speed = PLAYPF_SPEED

	if not player.ptsr.pizzachase then
		player.ptsr.pizzachase_cooldown = max(0, $-1)

		if player.ptsr.pfbuttons & BT_CUSTOM1 then
			player.ptsr.pizzasprint_time = min($ + 1, 15*TICRATE)
			speed = ($*3/2) + (player.ptsr.pizzasprint_time * 2030)
		else
			player.ptsr.pizzasprint_time = $/2
		end

		if max(abs(player.cmd.forwardmove), abs(player.cmd.sidemove)) > PLAYPF_DEADZONE then
			local angle = controls_angle(player)
            local frac = abs(FixedDiv(FixedHypot(
                    abs(player.cmd.sidemove << 16),
                    abs(player.cmd.forwardmove << 16)
                ), 50*FU
            ))
            frac = min($, FU)

			player.mo.momx = P_ReturnThrustX(nil, angle, FixedMul(speed,frac))
			player.mo.momy = P_ReturnThrustY(nil, angle, FixedMul(speed,frac))
		end

		if player.ptsr.pfbuttons & BT_JUMP then
			player.mo.momz = speed
		elseif player.ptsr.pfbuttons & BT_SPIN then
			player.mo.momz = -speed
		end

		if not (player.ptsr.pizzachase_cooldown)
		and player.ptsr.pfbuttons & BT_CUSTOM2 then
			player.ptsr.pizzachase = true
			player.ptsr.pizzachase_time = 10*TICRATE
			player.ptsr.chasepress = true
			S_StartSound(player.mo, PTSR.PFMaskData[player.ptsr.pizzastyle].sound)
		end
	else
		local found_player
		for p in players.iterate do
			if not (p
			and p.mo
			and p.mo.health
			and p.ptsr
			and not p.ptsr.pizzaface
			and PTSR.pfCanChase(p)
			and P_CheckSight(p.mo, player.mo)) then continue end
			if not (found_player and found_player.valid) then
				found_player = p.mo
			end

			if p.mo.x < found_player.x
			and p.mo.y < found_player.y
			and p.mo.z < found_player.z then
				found_player = p.mo
			end
		end

		if found_player and found_player.valid then
			player.ptsr.pizzasprint_time = min($ + 1, 15*TICRATE)

			--speed up because some people like to add characters that go 700 fu/s
			local speedboost = player.ptsr.pizzasprint_time * 1895
			if (found_player.player.speed > FixedMul(PLAYPF_SPEED, found_player.scale) * 3/2) then
				speedboost = $ + FixedDiv(
					found_player.player.speed - FixedMul(PLAYPF_SPEED, found_player.scale) * 3/2,
					found_player.scale
				)
			end
			speed = ($*3/2) + speedboost

			P_FlyTo(player.mo, found_player.x, found_player.y, found_player.z, speed, true)
		else
			player.ptsr.pizzasprint_time = 0
		end

		player.ptsr.pizzachase_time = max(0, $-1)
		if not (player.ptsr.pizzachase_time)
		or not (found_player and found_player.valid)
		or ((player.ptsr.pfbuttons & BT_CUSTOM2) and not player.ptsr.chasepress) then
			player.ptsr.pizzachase = false
			player.ptsr.pizzachase_cooldown = 30*TICRATE
		end

		player.ptsr.chasepress = (player.ptsr.pfbuttons & BT_CUSTOM2)
	end
end