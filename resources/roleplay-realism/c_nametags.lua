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

local sx, sy = guiGetScreenSize()
local fMaxDistance = 16.5
local bSubPixelPositioning = false
local altpressed = false

local font = dxCreateFont("nametags.ttf",14)
addEventHandler("onClientRender", root,
	function()
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (exports['roleplay-accounts']:getAccountSetting(localPlayer, "5") ~= 1) then return end
		
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:isClientPlaying(v)) and (not getElementData(v, "roleplay:temp.disappear")) then
				if (v ~= localPlayer) then
					local x, y, z = getElementPosition(localPlayer)
					local tx, ty, tz = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < fMaxDistance) then
						if (isElementOnScreen(v)) then
							local mx, my, mz = getCameraMatrix()
							local vehicle = getPedOccupiedVehicle(v) or nil
							local collision, cx, cy, cz, element = processLineOfSight(mx, my, mz, tx, ty, tz+1, true, true, true, true, false, false, true, false, vehicle)
							
							if (not collision) then
								local hx, hy, hz = getPedBonePosition(v, 7)
								local wsx, wsy = 0, 0
								if (getPedOccupiedVehicle(v)) then
									wsx, wsy = getScreenFromWorldPosition(hx, hy, hz+0.7, 100, false)
								else
									wsx, wsy = getScreenFromWorldPosition(hx, hy, hz+0.3, 100, false)
								end
								
								if (wsx) and (wsy) then
									local color = ((exports['roleplay-accounts']:getAdminLevel(v) > 0) and (exports['roleplay-accounts']:getAdminState(v) == 1) and (not exports['roleplay-accounts']:isClientHidden(v)) and tocolor(245, 215, 65, 0.9*255) or tocolor(245, 245, 245, 0.9*255))
									local name = "Contact Developers Team"
									if altpressed  then
										name = exports['roleplay-accounts']:getClientID(v)										
									else
										name = getPlayerName(v):gsub("_", " ")
									end
									
									if (isPedInVehicle(v)) then
										local vehicle = getPedOccupiedVehicle(v)
										if (vehicle) then
											if (exports['roleplay-vehicles']:isVehicleTinted(vehicle)) then
												if (getVehicleOccupant(vehicle, 0) ~= v) and (getVehicleOccupant(vehicle, 1) ~= v) then
													if not altpressed  then
														name = "Unknown (Tinted Windows)"
													end
												end
											end
										end
									end
									
									wsx = ((wsx-((dxGetTextWidth(name, 1.0, font)+10)/2))-5)
									
									dxDrawText(name, wsx+5, wsy+3, sx, sy, color, 1.0, font, "left", "top", true, false, false, false, bSubPixelPositioning)
								end
							end
						end
					end
				end
			end
		end
		
		for i,v in ipairs(getElementsByType("ped")) do
			local x, y, z = getElementPosition(localPlayer)
			local tx, ty, tz = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < fMaxDistance) then
				if (isElementOnScreen(v)) then
					local mx, my, mz = getCameraMatrix()
					local vehicle = getPedOccupiedVehicle(v) or nil
					local collision, cx, cy, cz, element = processLineOfSight(mx, my, mz, tx, ty, tz+1, true, true, true, true, false, false, true, false, vehicle)
					
					if (not collision) then
						local hx, hy, hz = getPedBonePosition(v, 7)
						local wsx, wsy = 0, 0
						if (getPedOccupiedVehicle(v)) then
							wsx, wsy = getScreenFromWorldPosition(hx, hy, hz+0.7, 100, false)
						else
							wsx, wsy = getScreenFromWorldPosition(hx, hy, hz+0.3, 100, false)
						end
						
						if (wsx) and (wsy) then
							if (getElementData(v, "roleplay:peds.name")) then
								local name = ""
								if (getElementData(v, "roleplay:peds.name") == "") then
									name = "Error no Ped Name"
								else
									name = getElementData(v, "roleplay:peds.name"):gsub("_", " ")
								end
								
								if (isPedInVehicle(v)) then
									local vehicle = getPedOccupiedVehicle(v)
									if (vehicle) then
										if (exports['roleplay-vehicles']:isVehicleTinted(vehicle)) then
											if (getVehicleOccupant(vehicle, 0) ~= v) and (getVehicleOccupant(vehicle, 1) ~= v) then
												name = "Unknown (Tinted Windows)"
											end
										end
									end
								end
								
								wsx = ((wsx-((dxGetTextWidth(name, 1.0, font)+10)/2))-5)
								
								dxDrawText(name, wsx+5, wsy+3, sx, sy, tocolor(245, 245, 245, 0.9*255), 1.0, font, "left", "top", true, false, false, false, bSubPixelPositioning)
							end
						end
					end
				end
			end
		end
	end
)

function disableDefaultNametag(player)
	setPlayerNametagShowing(player, false)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			disableDefaultNametag(v)
		end
	end
)

addEventHandler("onClientPlayerJoin", root,
	function()
		disableDefaultNametag(source)
	end
)


local function checkForALT(button, press)
	if button == "lalt" then
    	if press then
        	altpressed = true
        else
        	altpressed = false
   		end
   	end
end
addEventHandler("onClientKey", root, checkForALT)