--[[
	- FairPlay Gaming: Roleplay
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
	
	(c) Copyright 2014 FairPlay Gaming. All rights reserved.
]]

function getVehicleRealFuel(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.fuel"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:vehicles.fuel"))
end

function isVehicleEngineOn(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.engine"))) then return false, 3 end
	if (tonumber(getElementData(element, "roleplay:vehicles.engine")) == 0) then
		return false
	else
		return true
	end
end

function saveVehicle(vehicle)
	if isElement(vehicle) then
		if getElementType(vehicle) == "vehicle" then
			local x, y, z = getElementPosition(vehicle)
			local rx, ry, rz = getElementRotation(vehicle)
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle)
			local color1 = toJSON({r1, g1, b1})
			local color2 = toJSON({r2, g2, b2})
			local plateText = getVehiclePlateText(vehicle)

			local panel0 = getVehiclePanelState(vehicle, 0)
			local panel1 = getVehiclePanelState(vehicle, 1)
			local panel2 = getVehiclePanelState(vehicle, 2)
			local panel3 = getVehiclePanelState(vehicle, 3)
			local panel4 = getVehiclePanelState(vehicle, 4)
			local panel5 = getVehiclePanelState(vehicle, 5)
			local panel6 = getVehiclePanelState(vehicle, 6)
			local panelState = toJSON({panel0, panel1, panel2, panel3, panel4, panel5, panel6})

			local door0 = getVehicleDoorState(vehicle, 0)
			local door1 = getVehicleDoorState(vehicle, 1)
			local door2 = getVehicleDoorState(vehicle, 2)
			local door3 = getVehicleDoorState(vehicle, 3)
			local door4 = getVehicleDoorState(vehicle, 4)
			local door5 = getVehicleDoorState(vehicle, 5)
			local doorState = toJSON({door0, door1, door2, door3, door4, door5})

			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(vehicle)
			local wheelState = toJSON({wheel1, wheel2, wheel3, wheel4})
			local description = getElementData(vehicle,"roleplay:vehicles.description")
			if type(description) == "table" then
				description = toJSON(description)
			end
			local inventory = "[[]]"
			local oldinventory = getElementData(vehicle,"roleplay:vehicles.inventory")
			if type(oldinventory) == "table" then
				for i,v in pairs(oldinventory) do
					if type(v) == "table" then
						oldinventory[i] = toJSON(v)
					end
				end
				inventory = toJSON(oldinventory)
			end
			local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "vehicles", "posX", x, "posY", y, "posZ", z, "rotX", rx, "rotY", ry, "rotZ", rz, "interior", getElementInterior(vehicle), "dimension", getElementDimension(vehicle), "health", (getElementHealth(vehicle) == 0 and 350 or getElementHealth(vehicle)), "userID", getVehicleOwner(vehicle), "engineState", (isVehicleEngineOn(vehicle) == true and 1 or 0), "lightState", (getVehicleOverrideLights(vehicle) == 1 and 0 or 1), "handbraked", (isVehicleHandbraked(vehicle) == true and 1 or 0), "damageproof", (isVehicleDamageProof(vehicle) == true and 1 or 0), "tinted", isVehicleTinted(vehicle), "lastused", getVehicleLastUsed(vehicle), "color1", color1, "color2", color2, "fuel", getVehicleRealFuel(vehicle), "locked", (isVehicleLocked(vehicle) and 1 or 0), "description", getVehicleDescription(vehicle), "wheelState", wheelState, "panelState", panelState, "doorState", doorState, "manualGearbox", (getVehicleGearType(vehicle)), "plateText", plateText, "inventory", inventory,"description",description,"id", getVehicleRealID(vehicle))

			if (query) then
				outputDebugString("Saved vehicle ID " .. getVehicleRealID(vehicle) .. ".")
			else
				outputDebugString("Failed to save vehicle ID " .. getVehicleRealID(vehicle) .. " to the database when querying.", 1)
			end
		else
			outputDebugString(tostring(getElementType(vehicle)))
		end
	else
		outputDebugString(tostring(isElement(vehicle)))
		outputDebugString(tostring(vehicle))
	end
end

function saveVehicleEvent()
	saveVehicle(source)
end

addEvent(":_saveVehicle_:",true)
addEventHandler(":_saveVehicle_:",resourceRoot, saveVehicleEvent)

function updateVehicleInventory(vehicle)
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT inventory FROM `vehicles` WHERE id='?'", getVehicleRealID(vehicle))
	if (query) then
		local result, num_affected_rows, errmsg = dbPoll(query, -1)
		if (num_affected_rows == 1) then
			setElementData(vehicle, "roleplay:vehicles.inventory",{}, true)
			for result,row in pairs(result) do
				local inventory = row["inventory"]
				local weight = 0
				if inventory ~= nil then
					if type(inventory) == "string" then
						inventory = fromJSON(inventory)
						for k,v in ipairs(inventory) do
							if(type(v) == "string") then
								inventory[k] = fromJSON(v)
								weight = exports['roleplay-items']:getItemWeight(inventory[k][1]) + weight
							else
								inventory[k] = {}
							end
						end
						setElementData(vehicle, "roleplay:vehicles.inventory",inventory, true)
						setElementData(vehicle, "roleplay:vehicles.weight", weight, true)
						setElementData(vehicle, "roleplay:vehicles.maxweight", 100, true)
					end
				end
			end
		else
			outputDebugString("Error, vehicle not found")
		end
	else
		outputServerLog("Error: MySQL query failed when tried to fetch all vehicles.")
	end
end