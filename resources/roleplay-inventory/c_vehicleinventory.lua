local window, inventorygrid, idcolumn, namecolumn, valuecolumn, fixedcolumn, takeitem, takeall, blockitem,deleteitem,deleteall, refreshbutton ,closebutton
local rows = {}
local sx, sy = guiGetScreenSize()
local savedvehicle = nil
local function displayVehicleInventory(vehicle)
	savedvehicle = vehicle
	window = guiCreateWindow((sx-600)/2, (sy-600)/2, 600, 600, "Inventory", false)
	guiWindowSetSizable(window, false)
	guiSetProperty(window, "AlwaysOnTop", "true")
	guiBringToFront(window)
	
	inventorygrid = guiCreateGridList ( 0.02, 0.04, 0.72, 0.95, true, window)
	guiGridListSetSelectionMode ( inventorygrid, 0 )
	idcolumn = guiGridListAddColumn( inventorygrid, "ID", 0.1 )
	namecolumn = guiGridListAddColumn( inventorygrid, "Name", 0.25 )
	if exports["roleplay-accounts"]:isClientTrialAdmin(localPlayer) then
		valuecolumn = guiGridListAddColumn( inventorygrid, "Value", 0.50 )
		fixedcolumn = guiGridListAddColumn( inventorygrid, "Fixed", 0.10 )
	else
		valuecolumn = guiGridListAddColumn( inventorygrid, "Value", 0.60 )
	end

	for i,v in pairs(getElementData(vehicle,"roleplay:vehicles.inventory")) do
		rows[i] = guiGridListAddRow ( inventorygrid )
		guiGridListSetItemText ( inventorygrid, rows[i], idcolumn, i, false, false )
		guiGridListSetItemText ( inventorygrid, rows[i], namecolumn, exports['roleplay-items']:getItemName(v[1]), false, false )
		guiGridListSetItemText ( inventorygrid, rows[i], valuecolumn, v[2], false, false )
		if exports["roleplay-accounts"]:isClientTrialAdmin(localPlayer) then
			if v[5] ~= 0 then
				guiGridListSetItemText ( inventorygrid, rows[i], fixedcolumn, "Yes", false, false )	
			else
				guiGridListSetItemText ( inventorygrid, rows[i], fixedcolumn, "No", false, false )	
			end
		end
	end
	takeitem = guiCreateButton( 0.75,0.05,0.30,0.05, "Take Item", true, window)
	takeall = guiCreateButton( 0.75,0.125,0.30,0.05, "Take All Items", true, window)
	deleteitem = guiCreateButton( 0.75,0.20,0.30,0.05, "Delete Item", true, window)
	if exports["roleplay-accounts"]:isClientTrialAdmin(localPlayer) then
		deleteall = guiCreateButton( 0.75,0.275,0.30,0.05, "Delete All Items", true, window)
		blockitem = guiCreateButton( 0.75,0.35,0.30,0.05, "Block Item", true, window)
	end
    refreshbutton = guiCreateButton( 0.75,0.85,0.30,0.05, "Refresh Inventory", true, window)       
 	closebutton = guiCreateButton( 0.75,0.925,0.30,0.05, "Close Inventory", true, window)
 	showCursor(true)

	addEventHandler("onClientGUIClick", takeitem,
		function()
			local selected = guiGridListGetSelectedItems(inventorygrid)
			if #selected > 0 then
				local id = guiGridListGetItemText(inventorygrid,selected[1]["row"],idcolumn)
				triggerServerEvent(":_takeItemfromVehicleInventory_:", localPlayer,vehicle, id)
				destroyElement(window)
				showCursor(false)
				setTimer(
					function ()
						triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
						displayVehicleInventory(savedvehicle)
					end,500,1)
			else
				outputChatBox("Please select a item.")
			end
		end, false
	)

	addEventHandler("onClientGUIClick", takeall,
		function()
			triggerServerEvent(":_takeAllItemsfromVehicleInventory_:", localPlayer,vehicle, id)
			destroyElement(window)
			showCursor(false)
			setTimer(
				function ()
					triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
					displayVehicleInventory(savedvehicle)
				end,500,1)
		end, false
	)
	if exports["roleplay-accounts"]:isClientTrialAdmin(localPlayer) then
		addEventHandler("onClientGUIClick", blockitem,
			function()
				local selected = guiGridListGetSelectedItems(inventorygrid)
				if #selected > 0 then
					local id = guiGridListGetItemText(inventorygrid,selected[1]["row"],idcolumn)
					triggerServerEvent(":_blockItemAtVehicleInventory_:", localPlayer,vehicle, id)
					destroyElement(window)
					showCursor(false)
					setTimer(
						function ()
							triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
							displayVehicleInventory(savedvehicle)
						end,500,1)
				else
					outputChatBox("Please select a item.")
				end
			end, false
		)

		addEventHandler("onClientGUIClick", deleteitem,
			function()
				local selected = guiGridListGetSelectedItems(inventorygrid)
				if #selected > 0 then
					local id = guiGridListGetItemText(inventorygrid,selected[1]["row"],idcolumn)
					triggerServerEvent(":_deleteItemAtVehicleInventory_:", localPlayer,vehicle, id)
					destroyElement(window)
					showCursor(false)
					setTimer(
						function ()
							triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
							displayVehicleInventory(savedvehicle)
						end,500,1)
				else
					outputChatBox("Please select a item.")
				end
			end, false
		)

		addEventHandler("onClientGUIClick", deleteall,
			function()
				triggerServerEvent(":_deleteAllItemsAtVehicleInventory_:", localPlayer,vehicle, id)
				destroyElement(window)
				showCursor(false)
				setTimer(
					function ()
						triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
						displayVehicleInventory(savedvehicle)
					end,500,1)
			end, false
		)
	end
	addEventHandler("onClientGUIClick", refreshbutton,
		function()
			destroyElement(window)
			showCursor(false)
			setTimer(
				function ()
					triggerServerEvent(":_updateVehicleInventory_:", localPlayer ,savedvehicle)
					displayVehicleInventory(savedvehicle)
				end,500,1)
		end, false
	)
	
	addEventHandler("onClientGUIClick", closebutton,
		function()
			showCursor(false)
			destroyElement(window)
			savedvehicle = nil
		end, false
	)
end

addEvent(":_openVehicleInventory_:", true)
addEventHandler(":_openVehicleInventory_:", root, displayVehicleInventory)

local function destroyVehicleInventory()
	destroyElement(window)
end