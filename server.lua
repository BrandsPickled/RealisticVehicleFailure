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

local MechanicConnected       	   = 0

function CountMechanic()

    local xPlayers = ESX.GetPlayers()

    MechanicConnected = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'mechanic' then
            MechanicConnected = MechanicConnected + 1
        end
    end

    SetTimeout(120 * 1000, CountMechanic)
end

CountMechanic()

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
	if MechanicConnected > RequiredRepairMechanic then
		TriggerClientEvent('esx:showNotification', source, 'You cant repair your vehicle because there are' .. Config.RequiredRepair.Mechanic ..  'Mechanics on duty!')
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
