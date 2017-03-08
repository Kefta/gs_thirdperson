include("code_gs/gs.lua")

if (not code_gs.LoadAddon("code_gs/thirdperson", "gsthirdperson")) then
	error("[GS] GSThirdPerson failed to load!")
end
