local VulPetter = CreateFrame("Frame", "VulPetterFrame", nil)
VulPetter.RecentPets = {}


local function onEvent(self, event, ...)
	local tRace, tRaceEn = UnitRace("target")
	
	if (tRaceEn == "Vulpera") then
		local name, realm = UnitName("target")
		local cTime = GetTime()
		local doPet = true
		
		for idx, pRec in pairs(VulPetter.RecentPets) do
			if ((cTime - pRec[2]) > 10) then
				-- Supposedly table.remove is of the devil, but this list should never be very long and I ain't writing an entire gorramn array manipulator for this.
				table.remove(VulPetter.RecentPets, idx)
			end
			
			if (name == pRec[1]) then
				doPet = false
			end
		end
		
		if (doPet) then
			DoEmote("PET", "target")
			table.insert(VulPetter.RecentPets, {name, cTime})
		end
	end
end


VulPetter:RegisterEvent("PLAYER_TARGET_CHANGED")
VulPetter:SetScript("OnEvent", onEvent)