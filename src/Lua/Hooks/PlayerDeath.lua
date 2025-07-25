/*
	player has died text
	screams
*/

local lastScreamTic = -1

addHook("MobjDeath", function(mobj)
	if not PTSR.IsPTSR() then return end
	local player = mobj.player
	if PTSR.pizzatime then
		if not player.ptsr.pizzaface then
			if CV_PTSR.showdeaths.value then
				chatprint("\x82*"..player.name.."\x82 has died.")
				if DiscordBot then
					DiscordBot.Data.msgsrb2 = $ .. "[" .. #player .. "]:skull: **" .. player.name .. "** died.\n"
				end
			end
			
			-- [ptsr.death... variables]
			-- this is for making sure rank screen gets a score
			-- saves score and rank before you go to spectator after you die.
			-- reason: when you go to spectator, it resets all your score and stuff
			
			player.ptsr.deathscore = player.score
			player.ptsr.deathrank = player.ptsr.rank
			player.ptsr.deathlaps = player.ptsr.laps
			
			PTSR:ClearCombo(player)
			
			if P_RandomChance(FRACUNIT/4) and CV_PTSR.screams.value and lastScreamTic ~= leveltime then
				lastScreamTic = leveltime
				S_StartSound(nil, sfx_pepdie)
			end
		end
	end
end, MT_PLAYER)
