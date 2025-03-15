-- Pizza Mask Thinker
addHook("MobjThinker", function(mobj)
	if not PTSR.IsPTSR() then return end
	if mobj.targetplayer and mobj.targetplayer.valid and mobj.targetplayer.mo and mobj.targetplayer.mo.valid then
		local targetplayer = mobj.targetplayer
		P_MoveOrigin(mobj, targetplayer.mo.x, targetplayer.mo.y, targetplayer.mo.z)
		mobj.angle = targetplayer.drawangle
		
		local thisMask = PTSR.PFMaskData[targetplayer.ptsr.pizzastyle]
		
		if mobj.state ~= thisMask.state then
			mobj.state = thisMask.state
			mobj.scale = thisMask.scale
		end
		
		mobj.flags2 = ($ & ~MF2_OBJECTFLIP) | (targetplayer.mo.flags2 & MF2_OBJECTFLIP)
		mobj.eflags = ($ & ~MFE_VERTICALFLIP) | (targetplayer.mo.eflags & MFE_VERTICALFLIP)
		mobj.color = targetplayer.skincolor
	end
end, MT_PIZZAMASK)