PTSR.ParrySpendRequirement = 20 
PTSR.ParryHitLagFrames = 5
PTSR.ParryStunFrames = 45

PTSR.ParryList = {

}

PTSR.HitlagList = {

}

freeslot("MT_INSTAPARRY", "S_INSTAPARRY", "SPR_INSTAPARRY")

mobjinfo[MT_INSTAPARRY] = {
	doomednum = -1,
	spawnstate = S_INSTAPARRY,

	radius = 16*FU,
	height = 24*FU,

	dispoffset = 2,
	
	flags = MF_SLIDEME|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP,
}

states[S_INSTAPARRY] = {
	sprite = SPR_INSTAPARRY,
	frame = FF_ANIMATE|A,
	tics = 7+1,
	var1 = 7,
	var2 = 1,
	nextstate = S_NULL
}

-- helper function so we can get whose pizzaface easily
local function _isPF(mobj)
	if not mobj and mobj.valid then
		return false; end

	if mobj.type == MT_PLAYER
	and mobj.player
	and mobj.player.ptsr
	and mobj.player.ptsr.pizzaface then
		return true; end

	if mobj.type == MT_PIZZA_ENEMY then
		return true; end
end

addHook("ThinkFrame", function()
	-- Hitlag Table:
	for object, v in pairs(PTSR.HitlagList) do
		if v.time_left then
			v.time_left = $ - 1
			
			if not v.time_left then
				if v.old_momx ~= nil and v.old_momy ~= nil and v.old_momz ~= nil then
					if object and object.valid then
						object.momx = v.old_momx;
						object.momy = v.old_momy;
						object.momz = v.old_momz;
						object.flags = $ & ~MF_NOTHINK
					end
				end
				
				PTSR.HitlagList[object] = nil
				continue
			end
			
			if object and object.valid then
				local player = object.player
				
				if v.old_x ~= nil and v.old_y ~= nil and v.old_z ~= nil and
				v.old_sprite ~= nil and v.old_frame ~= nil then
					P_SetOrigin(object, v.old_x, v.old_y, v.old_z);
					
					object.sprite = v.old_sprite;
					object.frame = v.old_frame;
					
					object.momx = 0;
					object.momy = 0;
					object.momz = 0;
					
					if player and player.valid then
						if player == displayplayer then
							camera.momx = 0
							camera.momy = 0
							camera.momz = 0
						end
					end
				end
			else
				PTSR.HitlagList[object] = nil
				continue
			end
		end
	end
	
	-- Parry-stun Table:
	for object, v in pairs(PTSR.ParryList) do
		if v.time_left then
			v.time_left = $ - 1
			
			if not v.time_left then
				if object and object.valid then
					local player = object.player
					
					if player and player.valid then
						object.state = S_PLAY_FALL
					end
				end
				
				PTSR.ParryList[object] = nil
				continue
			end
			
			if object and object.valid then
				local player = object.player
				local speed = FixedHypot(object.momx, object.momy)
				
				if (leveltime % 3) == 0 then
					local ghost = P_SpawnGhostMobj(object)
				
					if ghost and ghost.valid then
						ghost.color = SKINCOLOR_WHITE
						ghost.colorized = true
					end
				end
				
				if player and player.valid then
					player.drawangle = v.add_angle 
					v.add_angle = $ + FixedAngle(speed*2)
					object.state = S_PLAY_PAIN
					player.pflags = $|PF_THOKKED
				else
					object.angle = $ + v.add_angle 
					v.add_angle = $ + FixedAngle(speed*2)
				end
				
				if (object.eflags & MFE_JUSTHITFLOOR) then
					S_StartSound(object, sfx_s3k49)
					P_SetObjectMomZ(object, 7*FRACUNIT)
					P_SpawnMobj(object.x, object.y, object.z, MT_PTSR_VFX_BUMP)
					
					v.time_left = $ - TICRATE
					
					if v.time_left <= 0 then
						if object and object.valid then
							local player = object.player
							
							if player and player.valid then
								object.state = S_PLAY_FALL
							end
						end
						
						PTSR.ParryList[object] = nil
						continue
					end
				end
			else
				PTSR.ParryList[object] = nil
				continue
			end
		end
	end
end)

-- TODO: Remove in 2.2.14. Instead, use searchblockmap in the parrylist thinker.
addHook("MobjMoveBlocked", function(mobj, thing, line)
	if line and line.valid then
		if PTSR.ParryList[mobj] then
			local speed = FixedHypot(mobj.momx, mobj.momy)
			local ang = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
			local side = mobj.subsector.sector == line.frontsector and 1 or -1
			
			P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_PTSR_VFX_BUMP)
			S_StartSound(mobj, sfx_s3k49)
			P_InstaThrust(mobj, ang-ANGLE_90*side, 30*FU)
		end
	end
end)

-- Parry animation function with sound parameter.
mobjinfo[freeslot "MT_PTSR_LOSSRING"] = {
	spawnstate = S_RING,
	radius = 32*FU,
	height = 32*FU,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT
}

addHook("MobjThinker", function(mobj)
	if not (mobj and mobj.valid) then return end
	local speed = mobj.throwspeed or 16*FU

	mobj.momx = FixedMul(speed, cos(mobj.angle))
	mobj.momy = FixedMul(speed, sin(mobj.angle))
	mobj.frame = $|FF_TRANS40

	if mobj.z > mobj.ceilingz
	or mobj.z+mobj.height < mobj.floorz then
		P_RemoveMobj(mobj)
		return
	end
end, MT_PTSR_LOSSRING)

addHook("MobjThinker", function(mobj)
	if not (mobj and mobj.valid) then return end
	if not (mobj.target and mobj.target.valid) then return end
	local target = mobj.target
	
	P_MoveOrigin(mobj, target.x, target.y, target.z - 4*FU)
end, MT_INSTAPARRY)

PTSR.DoParryAnim = function(mobj, withsound, ringloss)
	local parry = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_PT_PARRY)
	P_SpawnGhostMobj(parry)
	P_SetScale(parry, 3*FRACUNIT)
	parry.fuse = 5
	
	if withsound then
		S_StartSound(mobj, sfx_pzprry)
	end

	if ringloss then
		for i = 1,20 do
			local ring = P_SpawnMobjFromMobj(mobj,
				0,0,0,
				MT_PTSR_LOSSRING)

			ring.throwspeed = P_RandomRange(-16, 16)*FU
			ring.angle = fixangle(P_RandomRange(0, 360)*FU)
			ring.momz = P_RandomRange(0, 32)*FU
		end
	end
end

PTSR.DoParry = function(parrier, victim, kbmulti_xy, kbmulti_z)
	local anglefromparrier = R_PointToAngle2(victim.x, victim.y, parrier.x, parrier.y)
	local knockback_xy = CV_PTSR.parryknockback_xy.value
	local knockback_z = CV_PTSR.parryknockback_z.value
	local victim_speed = FixedHypot(victim.momx, victim.momy)

	local haswhirlwind = false
	
	if parrier.player and parrier.player.valid then
		haswhirlwind = (parrier.player.powers[pw_shield] & SH_WHIRLWIND)
	end
	
	victim.pfstunmomentum = true
	victim.pfstuntime = CV_PTSR.parrystuntime.value

	if haswhirlwind then
		knockback_xy = $ * 2
	end
	
	if not _isPF(victim) then
		if PTSR.isOvertime() then
			knockback_xy = $ * 3
		end
		
		if parrier.hascrown then
			knockback_xy = $ * 2
		end
	end
	
	if victim_speed > 100*FU then
		knockback_xy = $ * 2
	end
	
	if kbmulti_xy then
		knockback_xy = FixedMul($, kbmulti_xy)
	end
	
	if kbmulti_z then
		knockback_z = FixedMul($, kbmulti_z)
	end
	
	P_SetObjectMomZ(victim, knockback_z)
	P_InstaThrust(victim, anglefromparrier + ANGLE_180, knockback_xy)

	if victim.type == MT_PIZZA_ENEMY and PTSR.PFMaskData[victim.pizzastyle or 1].parrysplit and #PTSR.pizzas < 25 then
		local newpf = PTSR.pfSpawnAI(victim.pizzastyle)
		P_SetOrigin(newpf, victim.x, victim.y, victim.z)
		newpf.pfstunmomentum = true
		newpf.pfstuntime = CV_PTSR.parrystuntime.value
		P_SetObjectMomZ(newpf, knockback_z/2)
		P_InstaThrust(newpf, anglefromparrier + ANGLE_180, knockback_xy/2)
	end
end

PTSR.DoHitlag = function(mobj)
	mobj.flags = $ | MF_NOTHINK
	
	if PTSR.HitlagList[mobj] and PTSR.HitlagList[mobj].timeleft then
		PTSR.HitlagList[mobj].timeleft = $ + PTSR.ParryHitLagFrames
	else
		PTSR.HitlagList[mobj] = {
			time_left = PTSR.ParryHitLagFrames,
			old_x = mobj.x,
			old_y = mobj.y,
			old_z = mobj.z,
			old_momx = mobj.momx,
			old_momy = mobj.momy,
			old_momz = mobj.momz,
			old_sprite = mobj.sprite,
			old_frame = mobj.frame,
		}
	end
end

PTSR.StopHitlag = function(mobj, dontapplymom)
	if PTSR.HitlagList[mobj] then
		if not dontapplymom then
			if v.old_momx ~= nil and v.old_momy ~= nil and v.old_momz ~= nil then
				v.object.momx = v.old_momx;
				v.object.momy = v.old_momy;
				v.object.momz = v.old_momz;
				v.object.flags = $ & ~MF_NOTHINK
			end
			
			PTSR.HitlagList[mobj] = nil
		end
	end
end

addHook("PlayerThink", function(player)
	if not (player and player.mo and player.mo.valid) then return end
	if (player.playerstate == PST_DEAD) or (player.ptsr.outofgame) then return end 
	if (player.ptsr.pizzaface) then return end
	if PTSR.gameover then return end

	local cmd = player.cmd
	local pmo = player.mo
	
	local gm_metadata = PTSR.currentModeMetadata()
	local can_parry = not PTSR_DoHook("canparry", player)

	if not player.mo.ptsr.parry_cooldown
	and not player.mo.pizza_in
	and not player.mo.pizza_out then
		if cmd.buttons & BT_ATTACK
		and can_parry then
			if not player.mo.pre_parry then -- pre parry start
				local friendlyfire = (CV_PTSR.parry_friendlyfire.value or gm_metadata.parry_friendlyfire)
				local gotapf = false
				local gotanobject = false
				local range = 1000*FU
				local real_range = CV_PTSR.parry_radius.value
				
				local insta = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z - 4*FU, MT_INSTAPARRY)
				insta.target = player.mo
				S_StartSound(player.mo, sfx_s3k42)
				
				searchBlockmap("objects", function(refmobj, foundmobj)
					if R_PointToDist2(foundmobj.x, foundmobj.y, pmo.x, pmo.y) < real_range 
					and abs(foundmobj.z-pmo.z) < CV_PTSR.parry_height.value then
						if (_isPF(foundmobj) or (foundmobj.flags & MF_ENEMY)
						or (foundmobj.type == MT_PLAYER))
						and not PTSR_DoHook("preparry", pmo, foundmobj) then
							if foundmobj.type == MT_PLAYER then
								if foundmobj.player and foundmobj.player.valid then	
									if not foundmobj.player.ptsr.pizzaface then
										if not friendlyfire then
											return
										end
									
										if not PTSR.pizzatime then
											return
										end
										
										if foundmobj.player.powers[pw_invulnerability] then
											return
										end
										
										if PTSR.HitlagList[player.mo] 
										or PTSR.ParryList[player.mo] then
											return
										end
									elseif PTSR.pizzatime_tics < CV_PTSR.pizzatimestun.value*TICRATE then
										return
									end
								end
							end
							
							if _isPF(foundmobj) then
								-- Prevents players from parrying pizza face before he is released.
								if (foundmobj.pfstuntime and not foundmobj.pfstunmomentum) then
									return
								end
								
								PTSR:AddComboTime(player, player.ptsr.combo_maxtime/4)
								
								gotapf = true
							else
								local set_timeleft = PTSR.ParryStunFrames
				
								if PTSR.isOvertime() then
									set_timeleft = $*2
								end
								
								if PTSR.ParryList[foundmobj]
								and PTSR.ParryList[foundmobj].time_left then
									PTSR.ParryList[foundmobj].time_left = $ + set_timeleft
								else
									PTSR.ParryList[foundmobj] = {
										time_left = set_timeleft,
										add_angle = 0,
									}
								end
	
								PTSR_DoHook("onparried", foundmobj, pmo)
							end

							if PTSR_DoHook("onparry", pmo, foundmobj) then
								return true
							end

							PTSR.DoParry(player.mo, foundmobj)
							player.ptsr.lastparryframe = leveltime

							PTSR.DoParryAnim(player.mo, true, _isPF(foundmobj) and player.rings >= PTSR.ParrySpendRequirement)
							PTSR.DoParryAnim(foundmobj)
							
							PTSR.DoHitlag(player.mo)
							PTSR.DoHitlag(foundmobj)
							
							S_StopSoundByID(player.mo, sfx_s3k42)
							
							gotanobject = true
						end
					end
				end,
				player.mo,
				player.mo.x-range, player.mo.x+range,
				player.mo.y-range, player.mo.y+range)
				
				if not gotanobject then
					player.ptsr.lastparryframe = leveltime
					player.mo.ptsr.parry_cooldown = CV_PTSR.parrycooldown.value
				end
				
				if gotapf then
					if player.rings >= 150 then
						player.rings = $-($/10)
					elseif player.rings >= PTSR.ParrySpendRequirement then
						player.rings = max(0, $ - PTSR.ParrySpendRequirement)
					else -- you're broke buddy
						player.mo.ptsr.parry_cooldown = CV_PTSR.pfparrycooldown.value
					end
				else
					player.mo.ptsr.parry_cooldown = CV_PTSR.parrycooldown.value
				end
			
				player.mo.pre_parry = true
			end
		else
			player.mo.pre_parry = false
		end
	end
	
	if player.mo.ptsr.parry_cooldown then
		player.mo.ptsr.parry_cooldown = $ - 1
		if not player.mo.ptsr.parry_cooldown then
			S_StartSound(player.mo, sfx_ngskid)
			local tryparry = P_SpawnGhostMobj(player.mo)
			tryparry.color = SKINCOLOR_GOLDENROD
			tryparry.fuse = 5
			P_SetScale(tryparry, (3*FRACUNIT)/2)
		end
	end
end)