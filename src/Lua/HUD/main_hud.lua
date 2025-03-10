local path = "HUD/Drawers"

PTSR.hud_style = "default"

function PTSR.isHudStyle(style)
	return PTSR.hud_style == style
end

function PTSR.SetupHud(filepath)
	local funcname, drawfunc, type, style, hudlayer = dofile(filepath)
	local hudstyle = (style or "default")
	
	-- Make a new function from the current function.
	-- Currently makes it so huds don't draw if it's not PTSR.
	-- And makes it so it only draws the current style
	
	if drawfunc then
		local new_drawfunc = function(v, player)
			if gametype ~= GT_PTSPICER then return end
			if not PTSR.isHudStyle(hudstyle) then return end
			
			drawfunc(v, player)
		end
		
		if PTSR.HUD[hudstyle] == nil then
			PTSR.HUD[hudstyle] = {}
		end
		
		PTSR.HUD[hudstyle][funcname] = {draw = new_drawfunc, draw_type = type, draw_layer = hudlayer, draw_style = hudstyle}
		
		customhud.SetupItem(
			"PTSR:"..string.upper(funcname), 
			ptsr_hudmodname, PTSR.HUD[hudstyle][funcname].draw, 
			PTSR.HUD[hudstyle][funcname].draw_type or "game", 
			PTSR.HUD[hudstyle][funcname].draw_layer or 0
		)
	end
end

local function SetupHud(filename)
	PTSR.SetupHud(path.."/"..filename)
end

rawset(_G, "ptsr_hudmodname", "spicerunners")
-- time expected to reach to the final tween position, when pizza time starts
rawset(_G, "pthud_expectedtime", TICRATE*3)
-- pt animation position start
rawset(_G, "pthud_start_pos", 225*FRACUNIT)
-- pt animation position end
rawset(_G, "pthud_finish_pos", 175*FRACUNIT)

-- Remove vanilla crap.
customhud.SetupItem("score", ptsr_hudmodname, nil, "game", 0)
customhud.SetupItem("time", ptsr_hudmodname, nil, "game", 0)
customhud.SetupItem("rankings", ptsr_hudmodname, nil, "scores", 0)

-- rank to patch
PTSR.r2p = function(v,rank) 
	if v.cachePatch("PTSR_RANK_"..rank:upper()) then
		return v.cachePatch("PTSR_RANK_"..rank:upper())
	end
end

-- rank to fill
PTSR.r2f = function(v,rank) 
	if v.cachePatch("PTSR_FRANK_"..rank:upper()) then
		return v.cachePatch("PTSR_FRANK_"..rank:upper())
	end
end

addHook("HUD", function(v,p,c)
	if PTSR.IsPTSR() then
		hud.disable("textspectator") -- sonic team junior
	end
end)

SetupHud "DoorFade"
SetupHud "Bar"
SetupHud "ItsPizzaTime"
SetupHud "Tooltips"
SetupHud "Lapping"
SetupHud "Rank"
SetupHud "PlayerPFSwap"
SetupHud "Gamemode"
SetupHud "OvertimeMultiplier"
SetupHud "UntilEnd"

-- Hardcoded. (And has the legacy prefix)
dofile "HUD/intermission/drawVoteScreenChosenMap.lua"
dofile "HUD/intermission/drawVoteScreenRoulette.lua"
dofile "HUD/intermission/drawVoteScreenMaps.lua"
dofile "HUD/intermission/drawVoteScreenTimer.lua"
dofile "HUD/intermission/draw_p_rank_animation.lua"
dofile "HUD/intermission/drawBackground.lua"
dofile "HUD/intermission/main.lua"

SetupHud "Combo"
SetupHud "Overtime"
SetupHud "Rankings"
SetupHud "Score"
SetupHud "HurryUp"
SetupHud "PFViewpoint"

