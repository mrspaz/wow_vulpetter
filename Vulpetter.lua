local VulPetter = CreateFrame("Frame", "VulPetterFrame", nil)
VulPetter.RecentPets = {}


local function doPetInterval(value)
	if (value ~= nil) then
		_VulpetterInterval = value
		return _VulpetterInterval
	else
		if (_VulpetterInterval) then
			return _VulpetterInterval
		else
			_VulpetterInterval = 10
			return _VulpetterInterval
		end
	end
end

local function onEvent(self, event, ...)
	local tRace, tRaceEn = UnitRace("target")
	
	if (tRaceEn == "Vulpera") then
		local name, realm = UnitName("target")
		local cTime = GetTime()
		local petInt = doPetInterval()
		local doPet = true
		
		for idx, pRec in pairs(VulPetter.RecentPets) do
			if ((cTime - pRec[2]) > petInt) then
				-- Supposedly table.remove is of the devil, but this list should never be very long and I ain't writing an entire gorramn array manipulator for this.
				table.remove(VulPetter.RecentPets, idx)
			end
			
			if ((name == pRec[1]) and ((cTime - pRec[2]) < petInt+1)) then
				doPet = false
			end
		end
		
		if (doPet) then
			DoEmote("PET", "target")
			table.insert(VulPetter.RecentPets, {name, cTime})
		end
	end
end

local function slashy(msg, editbox)
	if (msg == "") then
		print("To set the pet interval, type \"/vulpet <number>\" where <number> is the time in seconds between pets.")
		print("Current pet interval is " .. doPetInterval() .. " seconds.")
	else
		if pcall(function() doPetInterval(tonumber(msg)) end) then
			print("Pet interval set to " .. doPetInterval() .. " seconds.")
		else
			print("You gotta enter a number, bro.")
		end
	end
end

SLASH_VULPETTER1 = "/vulpet"
SlashCmdList["VULPETTER"] = slashy
VulPetter:RegisterEvent("PLAYER_TARGET_CHANGED")
VulPetter:SetScript("OnEvent", onEvent)