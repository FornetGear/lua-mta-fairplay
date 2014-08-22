function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "roleplay:vehicles.radio.station", station, true)
end
addEvent(":_SyncRadioStation_:", true)
addEventHandler(":_SyncRadioStation_:", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "roleplay:vehicles.radio.volume", vol, true)
end
addEvent(":_SyncRadioVolume_:", true)
addEventHandler(":_SyncRadioVolume_:", getRootElement(), syncRadio)

function stopAllRadios()
	for _, theVehicle in ipairs(getElementsByType("vehicle")) do
		setElementData(theVehicle, "roleplay:vehicles.radio.station", 0, true)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), stopAllRadios)

function turnOffDistrictVehicles(thePlayer, commandName)
	if exports['roleplay-accounts']:isClientTrialAdmin( thePlayer ) then
		local district = getElementZoneName(thePlayer, false)
		local city = getElementZoneName(thePlayer, true)
		local counter = 0
		for i,v in ipairs(getElementsByType("vehicle")) do
			if (exports['roleplay-vehicles']:getVehicleRealType(v) and exports['roleplay-vehicles']:getVehicleRealType(v) > 0) then
				if (getElementZoneName(v, false) == district) then
					if getElementData(v, "roleplay:vehicles.radio.station") ~= 0 then
						setElementData(v, "roleplay:vehicles.radio.station", 0, true)
						counter = counter + 1
					end
				end
			end
		end
		exports['roleplay-accounts']:outputAdminLog("Admin-Vehicle: " .. getPlayerName(thePlayer):gsub("_"," ") .. " [" .. exports['roleplay-accounts']:getAccountName(thePlayer) .. "] turned the radio off for ".. counter .." vehicles at " .. district .. ", " .. city .. ".")
		outputServerLog("Admin-Vehicle: " .. getPlayerName(thePlayer) .. " [" .. exports['roleplay-accounts']:getAccountName(thePlayer) .. "] turned the radio off for ".. counter .." vehicles at " .. district .. ", " .. city .. ".")
	end
end
addCommandHandler("stopradiodistrict", turnOffDistrictVehicles, false, false)
addCommandHandler("srd", turnOffDistrictVehicles, false, false)