PTSR.ESLOCATIONS = {loaded = false}; -- "Escape Spawner Locations"
local table_cycle = 1

freeslot(
"MT_ESCAPESPAWNER_ANIM",
"S_ESCAPESPAWNER_ANIM",
"SPR_SPWE",
"sfx_espawn"
)

sfxinfo[sfx_espawn].caption = "Escape Spawn!"

mobjinfo[MT_ESCAPESPAWNER_ANIM] = {
	doomednum = -1,
	spawnstate = S_ESCAPESPAWNER_ANIM,

	radius = 16*FU,
	height = 24*FU,

	flags = MF_SLIDEME|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP,
}

states[S_ESCAPESPAWNER_ANIM] = {
	sprite = SPR_SPWE,
	frame = FF_ANIMATE|A,
	tics = T,
	var1 = T,
	var2 = 1,
	nextstate = S_NULL
}

-- If a mobj type is on this list, they are given the norespawn flag.
local nonrespawn_list = {
	[MT_RING] = true,
	[MT_COIN] = true
}

-- Arealock: The distance where an object is forced back to its spawn.
PTSR.EscapeSpawnList = {
	-- [MT_ ...]{ }
	[MT_RING] = true,
	[MT_COIN] = true,
	[MT_BLUECRAWLA] = {arealock = 512*FU},
	[MT_REDCRAWLA] = {arealock = 512*FU},
	[MT_GFZFISH] = {arealock = 512*FU},
	[MT_GOLDBUZZ] = {arealock = 512*FU},
	[MT_REDBUZZ] = {arealock = 512*FU},
	[MT_JETTBOMBER] = {arealock = 512*FU},
	[MT_JETTGUNNER] = {arealock = 512*FU},
	[MT_CRAWLACOMMANDER] = {arealock = 512*FU},
	[MT_SKIM] = {arealock = 512*FU},
	[MT_POPUPTURRET] = {arealock = 512*FU},
	[MT_SPINCUSHION] = {arealock = 512*FU},
	[MT_CRUSHSTACEAN] = {arealock = 512*FU},
	[MT_BANPYURA] = {arealock = 512*FU},
	[MT_JETJAW] = {arealock = 512*FU},
	[MT_VULTURE] = {arealock = 512*FU},
	[MT_POINTY] = {arealock = 512*FU},
	[MT_ROBOHOOD] = {arealock = 512*FU},
	[MT_FACESTABBER] = {arealock = 512*FU},
	[MT_EGGGUARD] = {arealock = 512*FU},
	[MT_GSNAPPER] = {arealock = 512*FU},
	[MT_MINUS] = {arealock = 512*FU},
	[MT_SPRINGSHELL] = {arealock = 512*FU},
	[MT_YELLOWSHELL] = {arealock = 512*FU},
	[MT_UNIDUS] = {arealock = 512*FU},
	[MT_CANARIVORE] = {arealock = 512*FU},
	[MT_PYREFLY] = {arealock = 512*FU},
	[MT_PTERABYTE] = {arealock = 512*FU},
	[MT_DRAGONBOMBER] = {arealock = 512*FU},
	[MT_CRAWLASTATUE] = {arealock = 512*FU},
	[MT_FACESTABBERSTATUE] = {arealock = 512*FU},
	[MT_SUSPICIOUSFACESTABBERSTATUE] = {arealock = 512*FU},
	[MT_GOOMBA] = {arealock = 512*FU},
	[MT_BLUEGOOMBA] = {arealock = 512*FU},
	[MT_PIAN] = {arealock = 512*FU},
	[MT_SHLEEP] = {arealock = 512*FU},
	[MT_PENGUINATOR] = {arealock = 512*FU},
	[MT_POPHAT] = {arealock = 512*FU},
	[MT_HIVEELEMENTAL] = {arealock = 512*FU},
	[MT_BUMBLEBORE] = {arealock = 512*FU},
	[MT_BUGGLE] = {arealock = 512*FU},
	[MT_CACOLANTERN] = {arealock = 512*FU},
	[MT_SPINBOBERT] = {arealock = 512*FU},
	[MT_HANGSTER] = {arealock = 512*FU},
}

function PTSR.EscapeSpawnFromTable(_table)
	_table.child = P_SpawnMobj(_table.x, _table.y, _table.z, _table.type)
	_table.child.angle = _table.angle
	P_SpawnMobj(_table.x, _table.y, _table.z, MT_ESCAPESPAWNER_ANIM)
	S_StartSound(_table.child, sfx_espawn)
	
	if _table.flipped == true then
		_table.child.eflags = $|MFE_VERTICALFLIP
	end
end

local luaOnly = P_RandomFixed()..P_RandomFixed()

addHook("NetVars", function(net)
	luaOnly = net($)
end)

COM_AddCommand("_PTSR_SS_ENEMY_RESPAWN", function(player, testkey, ...)
	local isNotServer = player ~= server 
	local isNotKey = luaOnly ~= testkey
	
	if isNotKey or isNotServer then
		local text = ""
		
		if isNotServer then
			text = "You are not the server!"
		elseif isNotKey then
			text = "Invalid Key!"
		end
		
		CONS_Printf(player, text)
		
		return
	end
	
	local args = {...}
	
	for i=1,#args do
		local arg = tonumber(args[i])
		
		if arg then
			if PTSR.ESLOCATIONS[arg] then
				local v = PTSR.ESLOCATIONS[arg]
				
				PTSR.EscapeSpawnFromTable(v)
				v.pending = false
				
				if CV_PTSR.serversided_enemyrespawn_debug.value then
					print("Spawned: ".. arg.. " " .. i)
				end
			end
		end
	end
end, 1)

COM_AddCommand("_PTSR_SS_ENEMY_TELEPORT", function(player, testkey, ...)
	local isNotServer = player ~= server 
	local isNotKey = luaOnly ~= testkey
	
	if isNotKey or isNotServer then
		local text = ""
		
		if isNotServer then
			text = "You are not the server!"
		elseif isNotKey then
			text = "Invalid Key!"
		end
		
		CONS_Printf(player, text)
		
		return
	end
	
	local args = {...}
	
	for i=1,#args do
		local arg = tonumber(args[i])
		
		if arg then
			if PTSR.ESLOCATIONS[arg] then
				local v = PTSR.ESLOCATIONS[arg]
				
				P_SetOrigin(v.child, v.x, v.y, v.z)
				v.child.angle = v.angle
				P_SpawnMobj(v.x, v.y, v.z, MT_ESCAPESPAWNER_ANIM)
				S_StartSound(v.child, sfx_espawn)
				
				if CV_PTSR.serversided_enemyrespawn_debug.value then
					print("Teleported: ".. arg.. " " .. i)
				end
			end
		end
	end
end, 1)

addHook("ThinkFrame", function()
	if not (PTSR.ESLOCATIONS.loaded) then return end
	if not leveltime then return end -- man srb2 sucks
	if not PTSR.IsPTSR() then return end
	if PTSR.gameover then return end
	
	local serversided = (CV_PTSR.serversided_enemyrespawn.value and isserver) 
	
	-- Block logic if not server, and if server-sided option is on.
	if CV_PTSR.serversided_enemyrespawn.value and not isserver then
		return
	end
	
	-- Server-Side exclusive
	local teleport_queue = {}
	local respawn_queue = {}
	
	local count = PTSR_COUNT()

	local cyclesleft = 8 + (42/count.peppinos)
	
	if serversided then
		cyclesleft = 5
	end
	
	while cyclesleft > 0 do
		cyclesleft = $ - 1
		
		if not PTSR.ESLOCATIONS[table_cycle] then
			table_cycle = 1
			break
		end
		
		local i = table_cycle
		local v = PTSR.ESLOCATIONS[table_cycle]
		
		if not (v.child and v.child.valid) then
			-- Clean up invalid type, or left over players.
			for k,a in pairs(v.lap_list) do
				if userdataType(k) ~= "player_t"
				or not (k and k.valid) then
					v.lap_list[k] = nil
					break
				end
			end
			
			if PTSR.pizzatime then
				for player in players.iterate do
					if (player.mo and player.mo.valid) 
					and (player.mo.health) and (not player.spectator)
					and (not player.ptsr.outofgame) then
						local dist = R_PointToDist2(player.mo.x, player.mo.y, v.x, v.y)
						
						if dist < 5120*FU then
							local vMobj = P_SpawnMobj(v.x, v.y, v.z, MT_RAY) -- Spawn a ray to check position (Because P_CheckSight only takes mobj_t)
							vMobj.fuse = 1
							
							/*
							if v.lap_list[player] == nil then
								v.lap_list[player] = player.ptsr.laps
							end
							*/
							
							if (vMobj and vMobj.valid) and P_CheckSight(vMobj, player.mo) then							
								if (v.lap_list[player] < player.ptsr.laps) or v.pending then
									v.lap_list[player] = player.ptsr.laps
									
									if serversided then
										table.insert(respawn_queue, table_cycle)
									else
										PTSR.EscapeSpawnFromTable(v)
										v.pending = false
									end
								end
							end
						end
					end
				end
			else
				if not v.pending then
					v.pending = true
				end
			end
		else
			if PTSR.pizzatime then
				local dist = R_PointToDist2(v.child.x, v.child.y, v.x, v.y)
				
				-- we can't check if the player killed or collected this object.
				-- so we have to disable respawn for the player if they go near it instead.
				for player in players.iterate do
					local pdist = R_PointToDist2(v.child.x, v.child.y, v.x, v.y)
					
					if pdist < 256*FU then
						v.lap_list[player] = player.ptsr.laps
					end
				end
				
				if PTSR.EscapeSpawnList[v.type] and type(PTSR.EscapeSpawnList[v.type]) == "table" and 
				PTSR.EscapeSpawnList[v.type].arealock then
					if dist > PTSR.EscapeSpawnList[v.type].arealock then
						if serversided then
							table.insert(teleport_queue, table_cycle)
						else -- if server sided
							P_SetOrigin(v.child, v.x, v.y, v.z)
							v.child.angle = v.angle
							P_SpawnMobj(v.x, v.y, v.z, MT_ESCAPESPAWNER_ANIM)
							S_StartSound(v.child, sfx_espawn)
						end
					end
				end
			end
		end
		
		if serversided then
			if #teleport_queue then
				local no_repeat = {}
				
				for i=1, #teleport_queue do
					for r,v in ipairs(no_repeat) do
						if v == teleport_queue[i] then
							print("found_repeat")
							continue
						end
					end
					
					table.insert(no_repeat, teleport_queue[i])
				end
				
				local arglist = ""
				
				for i=1, #no_repeat do
					arglist = $ .. no_repeat[i] .. " "
				end
				
				if #no_repeat then
					local text = "_PTSR_SS_ENEMY_TELEPORT "..luaOnly.." "..arglist
					
					COM_BufAddText(nil, text)
				end
			end
			
			if #respawn_queue then
				local no_repeat = {}
				
				for i=1, #teleport_queue do
					for r,v in ipairs(no_repeat) do
						if v == teleport_queue[i] then
							print("found_repeat")
							continue
						end
					end
					
					table.insert(no_repeat, teleport_queue[i])
				end
				
				local arglist = ""
				
				for i=1, #no_repeat do
					arglist = $ .. no_repeat[i] .. " "
				end
				
				if #no_repeat then
					local text = "_PTSR_SS_ENEMY_RESPAWN "..luaOnly.." "..arglist
					
					COM_BufAddText(nil, text)
				end
			end
		end
		
		table_cycle = $ + 1
	end
end)

addHook("NetVars", function(net)
	PTSR.ESLOCATIONS = net($)
	table_cycle = net($)
end)

addHook("MapLoad", function()
	if not PTSR.IsPTSR() then 
		return 
	end
	
	table_cycle = 1
	PTSR.ESLOCATIONS = {loaded = false}
	
	for thing in mapthings.iterate do
		if thing and thing.valid then
			local mobj = thing.mobj
			
			if mobj and mobj.valid then
				if nonrespawn_list[mobj.type] then
					mobj.flags2 = $|MF2_DONTRESPAWN
				end
				
				if PTSR.EscapeSpawnList[mobj.type] then
					table.insert(PTSR.ESLOCATIONS, {
						child = mobj,
						x = mobj.x,
						y = mobj.y,
						z = mobj.z,
						pending = false, -- if true, then any player near it respawns it.
						flipped = (thing.options & MTF_OBJECTFLIP) == MTF_OBJECTFLIP,
						lap_list = {}, -- [player_t] = latestlap
						type = mobj.type,
						angle = mobj.angle,
					})
				end
			end
		end
	end
	
	PTSR.ESLOCATIONS.loaded = true
end)