-- this should no longer happen cuz health=0 but just in case
addHook("MobjDeath", function(mobj)
	-- SRB2 does some stuff before we can stop it so
	mobj.flags = $ | MF_SPECIAL
	mobj.health = 1000
	return true
end, MT_PIZZA_ENEMY)