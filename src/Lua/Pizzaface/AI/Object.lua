freeslot("MT_PIZZA_ENEMY") -- For AI

-- For AI
mobjinfo[MT_PIZZA_ENEMY] = {
	doomednum = -1,
	spawnstate = S_PIZZAFACE,
	spawnhealth = 1000,
	deathstate = S_NULL,
	radius = 24*FU,
	height = 48*FU,
	flags = MF_NOCLIP|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_SPECIAL|MF_BOSS
}