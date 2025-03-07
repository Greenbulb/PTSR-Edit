local path = "Pizzaface/Functions/Global"
local file_prefix = "pf"

local files = {
	"CanChase",
	"CanDamage",
	"CollideHandle",
	"DoShieldDamage",
	"FindPlayer",
	"ForceShieldParry",
	"RandomTP",
	"SpawnAI",
}

for i,v in ipairs(files) do
	dofile(path.."/"..file_prefix..v)
end