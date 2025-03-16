local scoreboard_hud = function(v, player)
	if not PTSR.IsPTSR() then return end
	if not multiplayer then return end

	local zinger_text = "LEADERBOARD"
	local zinger_x = 160*FU
	local zinger_y = 10*FU
	local player_sep = 17*FU -- separation of player infos 

	local player_list = {}
	local faces = {}

	for _player in players.iterate do
		if _player.spectator then continue end

		if _player.ptsr.pizzaface
			table.insert(faces, _player)
			continue
		end
		table.insert(player_list, _player)
	end

	table.sort(player_list, function(a,b) return a.score > b.score end)

	--pizzafaces go to the back
	for _, _player in ipairs(faces) do
		table.insert(player_list, _player)
	end

	--draw the bar OUTSIDE of the iterator, no reason to draw this 20 times
	v.drawFill(0, 25, 640, 1, V_SNAPTOTOP|V_SNAPTOLEFT) -- bar 
		
	for i=1,#player_list do
		if i > 20 then break end
		
		local _player = player_list[i]
		local _skinname = skins[_player.realmo.skin].name
		local _colormap = v.getColormap(_skinname, _player.skincolor)
		local _skinpatch = v.getSprite2Patch(_player.realmo.skin, SPR2_XTRA)
		local commonflags = (V_SNAPTOLEFT|V_SNAPTOTOP)
		local playernameflags = (_player == consoleplayer) and V_YELLOWMAP or (_player.ptsr.pizzaface and V_REDMAP or V_GRAYMAP)
		playernameflags = $|V_ALLOWLOWERCASE
		local aliveflag = (_player.playerstate ~= PST_LIVE or _player.quittime > 0) and V_50TRANS or 0
		
		local playerpingcolor
		local rawpingstring = (_player == server) and "SERV" or ((_player.quittime) and "QUIT" or _player.ping)
		local drawping = rawpingstring
		
		if _player.ping < 128 then
			playerpingcolor = V_GREENMAP
		elseif _player.ping < 256 then
			playerpingcolor = V_YELLOWMAP
		elseif _player.ping < INT32_MAX then
			playerpingcolor = V_REDMAP
		end

		if _player.quittime
			playerpingcolor = V_REDMAP|((leveltime/TICRATE % 2) and V_50TRANS or 0) --hacky
		else
			if (_player ~= server) then
				drawping = $.."ms"
			else
				playerpingcolor = $|V_BLUEMAP
			end
		end
		
		local _xcoord = 22*FU
		local _ycoord = 15*FU + (i*player_sep)

		if i > 10 then
			_xcoord = $ + 160*FU
			_ycoord = $ - (10*player_sep)
			commonflags = $|V_SNAPTORIGHT &~V_SNAPTOLEFT
		end

		if not _player.ptsr.pizzaface
		and (_skinpatch and _skinpatch.valid) then
			-- [Player Icon] --
			v.drawScaled(_xcoord - FU, _ycoord, FU/2,
				_skinpatch, (commonflags)|aliveflag, _colormap
			)

			-- [Player Rank] --
			v.drawScaled(_xcoord - 16*FU + 8*FU, _ycoord + 8*FU, FU/4, 
				PTSR.r2p(v,_player.ptsr.rank), commonflags
			)
		else
			/*
			local mask_data = PTSR.PFMaskData[_player.ptsr.pizzastyle or 1]
			local mask_state = mask_data.state or S_PIZZAFACE

			--get the frame we want
			local mask_sprite = states[mask_state].sprite
			local mask_patch = v.getSpritePatch(mask_sprite, A)

			local scale = FixedDiv(mask_data.scale, (mask_patch.width * mask_patch.height)*5)
			scale = FixedMul($, mask_data.scale)
			print(string.format("%f",scale))

			--get the offets so we can make this a "top-left-corner aligned" patch
			local off = {
				FixedMul(mask_patch.leftoffset*FU, scale),
				FixedMul(mask_patch.topoffset*FU, scale),
			}

			v.drawScaled(
				_xcoord - FU + off[1],
				_ycoord + off[2],
				FU/2,
				v.cachePatch("CHARICO"),
				commonflags
			)
			v.drawScaled(
				_xcoord - FU + mask_patch.width*scale,
				_ycoord + off[2],
				FU/2,
				v.cachePatch("CHARICO"),
				commonflags
			)
			
			v.drawScaled(
				_xcoord - FU + off[1],
				_ycoord + off[2],
				scale,
				mask_patch,
				(commonflags)|aliveflag|V_30TRANS, v.getColormap(TC_DEFAULT, _player.skincolor)
			)
			*/

			-- [Pizzaface Icon] --
			v.drawScaled(_xcoord - FU, _ycoord, FU/8,
				v.cachePatch("PTSR_FACEICON"), (commonflags)|aliveflag
			)

		end
		
		local scorewidth = v.stringWidth(tostring(_player.score), (commonflags|playernameflags), "thin") + 11
		local scoreandpingwidth = scorewidth + v.stringWidth(drawping, (commonflags), "thin")
		
		-- [Player Name] --
		v.drawString(_xcoord + 16*FU,								_ycoord,		_player.name,					(commonflags|playernameflags|aliveflag),	"thin-fixed")
		
		if not _player.ptsr.pizzaface then
			-- [Player Score] --
			v.drawString(_xcoord + 16*FU,							_ycoord + 8*FU,	tostring(_player.score),		(commonflags),								"thin-fixed")

			-- [Player Ping] --
			v.drawString(_xcoord + 8*FU + (scorewidth*FU),			_ycoord + 8*FU,	drawping,						(commonflags|playerpingcolor),				"thin-fixed")
			
			-- [Player Laps] --
			v.drawString(_xcoord + 16*FU + (scoreandpingwidth*FU),	_ycoord + 8*FU,	"laps: ".._player.ptsr.laps,	(commonflags),								"thin-fixed")
		else
			-- [Pizzaface Ping] --
			v.drawString(_xcoord + 16*FU, _ycoord + 8*FU, drawping, (commonflags|playerpingcolor), "thin-fixed")
		end
		
		-- show crown in leaderboard
		-- GAMEMODE: JUGGERNAUT exclusive
		if _player.realmo.hascrown then
			local crown_spr = v.getSpritePatch(SPR_C9W3)
			
			v.drawScaled(_xcoord, _ycoord+(4*FU), FU/4,
				crown_spr, (commonflags)|aliveflag
			)
		end
		
		-- [Finish Flag] --
		if (_player.ptsr.outofgame)
			v.drawScaled(_xcoord - 6*FU,_ycoord+11*FU,FU/2,
				v.getSpritePatch(SPR_FNSF,A,0),
				(commonflags)|V_FLIP
			)		
		end
	end 

	customhud.CustomFontString(v, zinger_x, zinger_y, zinger_text, "PTFNT", (V_SNAPTOTOP), "center", FU/4, SKINCOLOR_BLUE)
end

return "Rankings", scoreboard_hud, "scores"