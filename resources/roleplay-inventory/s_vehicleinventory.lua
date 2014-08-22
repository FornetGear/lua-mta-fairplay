addEvent(":_updateVehicleInventory_:", true)
addEventHandler(":_updateVehicleInventory_:", root,
	function(vehicle)
		exports['roleplay-vehicles']:updateVehicleInventory(vehicle)
	end
)

addEvent(":_takeItemfromVehicleInventory_:", true)
addEventHandler(":_takeItemfromVehicleInventory_:", root,
	function(vehicle,id)
		local items = getElementData(vehicle,"roleplay:vehicles.inventory")
		local itemid = 0
		local itemvalue = ""
		local ringtone = 0
		local messagetone = 0
		local fixed = 0
		local found = 0
		id = tonumber(id)
		for i,v in pairs(items) do
			if i == id then
				itemid = v[1]
				itemvalue = v[2]
				ringtone = v[3]
				messagetone = v[4]
				fixed = v[5]
				found = 1
			end
		end
		if found == 1 then
			if fixed == 0 then
				exports['roleplay-chat']:outputLocalActionMe(client,"takes a "..exports['roleplay-items']:getItemName(itemid).. " from a vehicle.")
				exports['roleplay-items']:takeItem(vehicle,itemid,itemvalue,id)
				if not exports['roleplay-items']:giveItem(client,itemid,itemvalue,nil,ringtone,messagetone) then
					outputChatBox("You have no space for that item.", client)
					exports['roleplay-items']:giveItem(vehicle,itemid,itemvalue,nil,ringtone,messagetone)
				end
			else
				outputChatBox("That item is fixed on the vehicle.", client)
			end
		end
	end
)


addEvent(":_takeAllItemsfromVehicleInventory_:", true)
addEventHandler(":_takeAllItemsfromVehicleInventory_:", root,
	function(vehicle)
		local items = getElementData(vehicle,"roleplay:vehicles.inventory")
		local full = 0
		for i,v in pairs(items) do
			if full == 0 then
				if v[5] == 0 then
					local itemid = v[1]
					local itemvalue = v[2]
					local ringtone = v[3]
					local messagetone = v[4]
					exports['roleplay-chat']:outputLocalActionMe(client,"takes a "..exports['roleplay-items']:getItemName(itemid).. " from a vehicle.")
					exports['roleplay-items']:takeItem(vehicle,itemid,itemvalue,id)
					if not exports['roleplay-items']:giveItem(client,itemid,itemvalue,nil,ringtone,messagetone) then
							outputChatBox("You have no space for that item.", client)
							exports['roleplay-items']:giveItem(vehicle,itemid,itemvalue,nil,ringtone,messagetone)
							full = 1
							break;
					end
				end
			else
				break;
			end
		end
	end
)


addEvent(":_blockItemAtVehicleInventory_:", true)
addEventHandler(":_blockItemAtVehicleInventory_:", root,
	function(vehicle,id)
		local items = getElementData(vehicle,"roleplay:vehicles.inventory")
		id = tonumber(id)
		if items[id][5] == 0 then
			items[id][5] = 1
		else
			items[id][5] = 0
		end
		setElementData(vehicle,"roleplay:vehicles.inventory",items,true)
		triggerEvent(":_saveVehicle_:",vehicle)
	end
)

addEvent(":_deleteItemAtVehicleInventory_:", true)
addEventHandler(":_deleteItemAtVehicleInventory_:", root,
	function(vehicle,id)
		local items = getElementData(vehicle,"roleplay:vehicles.inventory")
		local itemid = 0
		local itemvalue = ""
		local fixed = 0
		local found = 0
		id = tonumber(id)
		for i,v in pairs(items) do
			if i == id then
				itemid = v[1]
				itemvalue = v[2]
				fixed = v[5]
				found = 1
			end
		end
		if found == 1 then
			if fixed == 0 then		
				exports['roleplay-items']:takeItem(vehicle,itemid,itemvalue,id)
				exports['roleplay-chat']:outputLocalActionMe(client,"destroys a "..exports['roleplay-items']:getItemName(itemid).. " from a vehicle.")
			else
				outputChatBox("That item is fixed on the vehicle.", client)
			end
		end
	end
)

addEvent(":_deleteAllItemsAtVehicleInventory_:", true)
addEventHandler(":_deleteAllItemsAtVehicleInventory_:", root,
	function(vehicle)
		setElementData(vehicle,"roleplay:vehicles.inventory", {}, true)
		triggerEvent(":_saveVehicle_:",vehicle)
	end
)