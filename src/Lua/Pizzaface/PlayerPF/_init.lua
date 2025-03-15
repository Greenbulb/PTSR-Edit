local path = "Pizzaface/PlayerPF/Hooks"
local file_prefix = ""

local files = {
	"Thinker",
	"PizzaMaskThinker",
	"OverrideInput",
	"PlayerTouch",
	"IgnoreEnemy",
}

for i,v in ipairs(files) do
	dofile(path.."/"..file_prefix..v)
end