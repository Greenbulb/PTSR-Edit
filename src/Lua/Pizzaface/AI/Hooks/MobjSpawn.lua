addHook("MobjSpawn", function(mobj)
	mobj.spritexscale = $ / 2
	mobj.spriteyscale = $ / 2

	mobj.pfstuntime = multiplayer and CV_PTSR.pizzatimestun.value*TICRATE or TICRATE
	mobj.pfstuntime2 = 0
end, MT_PIZZA_ENEMY)