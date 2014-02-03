﻿--[[
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

addEventHandler("onClientPedDamage", root,
	function(attacker, weapon, bodypart, loss)
		if (attacker) and (getElementType(attacker) == "player") then
			if (isPedInVehicle(source)) then
				local vehicle = getPedOccupiedVehicle(source)
				if (vehicle) then
					if (isVehicleDamageProof(vehicle)) then
						cancelEvent()
					end
				end
			end
			
			if (bodypart == 9) then
				triggerServerEvent(":_doMurderPlayer_:", source)
			end
		end
	end
)