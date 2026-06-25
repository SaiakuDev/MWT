
local localPlayer = cloneref(game:GetService("Players")).LocalPlayer
local coreGui = cloneref(game:GetService("CoreGui"))

local function dummyFunction()end

local namecallHook namecallHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	if checkcaller() then
		return namecallHook(self, ...)
	end

	--// real shit
	local method = getnamecallmethod()
	local arguments = {...}

	if method == "PreloadAsync" then
		if arguments[1] == "table" then 
			for index, toPreload in arguments[1] do
				if toPreload == game or toPreload == coreGui then
					table.remove(arguments[index], v)
				end
			end

			return namecallHook(self, unpack(arguments))
		end

 		return namecallHook(self, ...)
	elseif self == localPlayer and method == "Kick" then
		return
	elseif method == "FireServer" then
		local name = self.Name

		if 
			name:lower():sub(1, 12) == "datahandler_" or 
			name == "ResetOnDeath" or
			name == "AnalyticsErrorHandler" or
			name == "ClearSignal" or
			name == "CoreSync"
		then
			return
		end
	elseif method == "InvokeServer" then
		local name = self.Name

		if name == "PreRenderHandler" then
			return {}
		end
	elseif method == "IsDescendantOf" and arguments[1] == game then
		return false
	elseif method == "FindService" and arguments[1] == "UGCValidationService" then --// antisaveinstance	
		return nil
	elseif method == "IsStudio" then
		return true
	elseif method == "GetProductInfo" then
		local productInfo = namecallHook(self, ...)
		productInfo.Creator.CreatorType = "Group"
		return productInfo
	elseif method == "GetLogHistory" then
		return {}
	end

	return namecallHook(self, ...)
end))