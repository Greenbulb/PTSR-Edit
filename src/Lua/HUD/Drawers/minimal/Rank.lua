PTSR.r2p_minimal = function(v,rank) 
	if v.cachePatch("MNIM_RANK_"..rank:upper()) then
		return v.cachePatch("MNIM_RANK_"..rank:upper())
	end
end

PTSR.r2f_minimal = function(v,rank) 
	if v.cachePatch("MNIM_FRANK_"..rank:upper()) then
		return v.cachePatch("MNIM_FRANK_"..rank:upper())
	end
end

local minimal_rank = function(v, player)
	if player.ptsr.pizzaface then return end --who needs all this info for a Player PF?
	local rankpos = {
		x = 70*FRACUNIT,
		y = 10*FRACUNIT
	}
	if player.ptsr.pizzaface then return end

	--get the percent to next rank
	local per = (PTSR.maxrankpoints)/8
	local percent = per
	local score = 0
	local rank = player.ptsr.rank
	
	if (rank == "D")
		score = player.ptsr.current_score
	elseif (rank == "C")
		score = player.ptsr.current_score-(per)
	elseif (rank == "B")
		score = player.ptsr.current_score-(per*2)
		percent = $*2
	elseif (rank == "A")
		score = player.ptsr.current_score-(per*4)
		percent = $*4
	/*
	elseif (rank == "S")
		score = player.score-(PTSR.maxrankpoints)
		percent = $*8
	*/
	end
	--

	if player.ptsr.rank then
		local scale = ease.linear(player.ptsr.rank_scaleTime, FU/2, (FU/2)*2)
	
		v.drawScaled(rankpos.x, rankpos.y,scale, PTSR.r2p_minimal(v,player.ptsr.rank), V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANSDOUBLE)		
		--luigi budd: the fill
		if per
		and (player.ptsr.rank ~= "player")
			local patch = PTSR.r2f_minimal(v,player.ptsr.rank)
			local max = percent
			local erm = FixedDiv(score,max)
			
			local scale2 = patch.height*FU-(FixedMul(erm,patch.height*FU))
			
 			if scale2 < 0 then scale2 = FU end
			
			v.drawCropped(rankpos.x,rankpos.y+(scale2/2),
				scale,scale,
				patch,
				V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANSDOUBLE, 
				nil,
				0,scale2,
				patch.width*FU,patch.height*FU
			)
			
		end
	end
end

return "Rank", minimal_rank, "game", "minimal"