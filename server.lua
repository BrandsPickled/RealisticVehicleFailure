------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--
--      Edited by BrandsPickled
--      https://github.com/BrandsPickled/RealisticVehicleFailure/

local CopsConnected       	   = 0

function CountCops()

    local xPlayers = ESX.GetPlayers()

    CopsConnected = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            CopsConnected = CopsConnected + 1
        end
    end

    SetTimeout(120 * 1000, CountCops)
end

CountCops()

local function checkWhitelist(id)
	for key, value in pairs(RepairWhitelist) do
		if id == value then
			return true
		end
	end	
	return false
end

AddEventHandler('chatMessage', function(source, _, message)
	local msg = string.lower(message)
	local identifier = GetPlayerIdentifiers(source)[1]
	if CopsConnected < Config.RequiredRepair.Mechanic then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_mechanic') .. Config.RequiredRepair.Mechanic ..  _U('act_imp_mechanic2'))
		return
	end
	if msg == "/repair" then
		CancelEvent()
		if RepairEveryoneWhitelisted == true then
			TriggerClientEvent('iens:repair', source)
		else
			if checkWhitelist(identifier) then
				TriggerClientEvent('iens:repair', source)
			else
				TriggerClientEvent('iens:notAllowed', source)
			end
		end
	end
end)
