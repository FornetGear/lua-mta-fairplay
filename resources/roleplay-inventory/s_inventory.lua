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

addEventHandler("onResourceStart", root,
	function(resource)
		if (resource) and (getResourceName(resource) == "roleplay-items") then
			restartResource(getThisResource())
		end
	end
)

addEventHandler("onResourceStop", root,
	function(resource)
		if (getResourceName(resource) == "roleplay-realism") then
			for i,v in ipairs(getElementsByType("player")) do
				triggerClientEvent(v, ":_updateLockVar_:", v, true)
			end
		end
	end
)
addEvent(":_getInventoryTipsUpdate_:",true)
addEventHandler(":_getInventoryTipsUpdate_:", root,
	function ()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??`, `??`, `??` FROM `??` WHERE `??` = '??' LIMIT 1", "invtip1","invtip2","invtip3","accounts", "id", exports['roleplay-accounts']:getAccountID(client))
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			for result,row in pairs(result) do
				if (row["invtip1"] and row["invtip2"] and row["invtip3"]) then
					triggerClientEvent(client,":_updateInventoryTips_:",client,tonumber(row["invtip1"]),tonumber(row["invtip2"]),tonumber(row["invtip3"]))
				end
			end	
		else
			triggerClientEvent(client,":_updateInventoryTips_:",client,0,0,0)
		end
	end
)


addEvent(":_updateSQLInventoryTips_:",true)
addEventHandler(":_updateSQLInventoryTips_:", root,
	function (invtip1,invtip2,invtip3)
		local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE accounts SET invtip1 = '?', invtip2 = '?', invtip3 = '?' WHERE id = '?' LIMIT 1", invtip1,invtip2,invtip3, exports['roleplay-accounts']:getAccountID(client))
	end
)