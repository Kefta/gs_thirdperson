code_gs.thirdperson = {
	XMin = -100,
	XMax = 100,
	YMin = -300,
	YMax = 30,
	ZMin = -50,
	ZMax = 100,
	FOVMin = 0.1, -- Limtis from camera
	FOVMax = 175
}

-- TODO: Add maya mode

local gs_thirdperson = CreateConVar( "gs_thirdperson", "0", FCVAR_ARCHIVE, "Enables third-person" )
local gs_thirdperson_fov = CreateConVar( "gs_thirdperson_fov", "0", FCVAR_ARCHIVE, "Forces FOV in third-person. 0 = default" )
local gs_thirdperson_offset_right = CreateConVar( "gs_thirdperson_offset_right", "0", FCVAR_ARCHIVE, "X-axis offset. Can be between " )
local gs_thirdperson_offset_forward = CreateConVar( "gs_thirdperson_offset_forward", "0", FCVAR_ARCHIVE, "Y-axis offset. Can be between " )
local gs_thirdperson_offset_up = CreateConVar( "gs_thirdperson_offset_up", "0", FCVAR_ARCHIVE, "Z-axis offset. Can be between " )

hook.Add("ShouldDrawLocalPlayer", "GS-Thirdperson", function()
	if (gs_thirdperson:GetBool()) then
		return true
	end
end)

hook.Add("CalcView", "GS-Thirdperson", function(pPlayer, vPos, aRot)
	if (gs_thirdperson:GetBool() and pPlayer:GetObserverMode() == OBS_MODE_NONE and not (pPlayer:GetCanZoom() and pPlayer:KeyDown(IN_ZOOM))) then
		local tLimits = code_gs.thirdperson
		local tRet = {
			origin = vPos + aRot:Right() * math.Clamp(gs_thirdperson_offset_right:GetFloat(), tLimits.XMin, tLimits.XMax)
				+ aRot:Forward() * math.Clamp(gs_thirdperson_offset_forward:GetFloat(), tLimits.YMin, tLimits.YMax)
				+ aRot:Up() * math.Clamp(gs_thirdperson_offset_up:GetFloat(), tLimits.ZMin, tLimits.ZMax)
		}
		
		-- TODO: Find a better way to fix angles to make the player look where they're actually shooting
		--tRet.angles = (pPlayer:GetEyeTrace().HitPos - tRet.origin):Angle()
		local flFOV = gs_thirdperson_fov:GetFloat()
		
		if (flFOV ~= 0) then
			tRet.fov = math.Clamp(flFOV, tLimits.FOVMin, tLimits.FOVMax)
		end
		
		local tr = {
			start = pPlayer:EyePos(),
			endpos = tRet.origin,
			mask = MASK_SOLID,
			filter = pPlayer
		}
		
		tr.output = tr
		util.TraceLine(tr)
		
		if (tr.Hit) then
			tRet.origin = tr.HitPos + tr.HitNormal * 6 -- Magic number (not really)
		end
		
		-- TODO: Trace left and right for bound limits?
		
		return tRet
	end
end)
