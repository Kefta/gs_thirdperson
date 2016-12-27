include("code_gs/gs.lua")

if (not code_gs.LoadAddon("thirdperson", true)) then
	error("[GS] Third-person failed to load!")
end
