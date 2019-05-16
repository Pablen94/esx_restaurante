ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'restaurante', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'restaurante', 'Restaurante', 'society_restaurante', 'society_restaurante', 'society_restaurante', {type = 'private'})



RegisterServerEvent('esx_restaurantejob:getStockItem')
AddEventHandler('esx_restaurantejob:getStockItem', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)

		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('you_removed') .. count .. ' ' .. item.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)

end)

ESX.RegisterServerCallback('esx_nightclubjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_restaurantejob:putStockItems')
AddEventHandler('esx_restaurantejob:putStockItems', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)

		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

	end)

end)


RegisterServerEvent('esx_restaurantejob:getFridgeStockItem')
AddEventHandler('esx_restaurantejob:getFridgeStockItem', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)

		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('you_removed') .. count .. ' ' .. item.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_restaurantejob:putFridgeStockItems')
AddEventHandler('esx_restaurantejob:putFridgeStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_restaurantejob:buyItem')
AddEventHandler('esx_restaurantejob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_restaurante', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
        end
    else
        TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
    end

end)


RegisterServerEvent('esx_restaurantejob:craftingFood')
AddEventHandler('esx_restaurantejob:craftingFood', function(itemValue)

    local _source = source
    local _itemValue = itemValue
    TriggerClientEvent('esx:showNotification', _source, _U('assembling_food'))

    if _itemValue == 'pizza' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomate').count
            local bethQuantity      = xPlayer.getInventoryItem('harina').count
            local thirdQuantity      = xPlayer.getInventoryItem('levadura').count
            local fourthQuantity    = xPlayer.getInventoryItem('muzarella').count

            if alephQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tomate') .. '~w~')
            elseif bethQuantity < 4 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('harina') .. '~w~')
            elseif thirdQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('levadura') .. '~w~')
            elseif fourthQuantity < 4 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('muzarella') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('tomate', 3)
                    xPlayer.removeInventoryItem('harina', 4)
                    xPlayer.removeInventoryItem('levadura', 2)
                    xPlayer.removeInventoryItem('muzarella', 4)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('pizza') .. ' ~w~!')
                    xPlayer.removeInventoryItem('tomate', 3)
                    xPlayer.removeInventoryItem('harina', 4)
                    xPlayer.removeInventoryItem('levadura', 2)
                    xPlayer.removeInventoryItem('muzarella', 4)
                end
            end

        end)
    end
    if _itemValue == 'lasagna' then
        SetTimeout(10000, function()        

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomate').count
            local bethQuantity      = xPlayer.getInventoryItem('harina').count
            local thirdQuantity      = xPlayer.getInventoryItem('levadura').count
            local fourthQuantity    = xPlayer.getInventoryItem('muzarella').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tomate') .. '~w~')
            elseif bethQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('harina') .. '~w~')
            elseif thirdQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('levadura') .. '~w~')
            elseif fourthQuantity < 3 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('muzarella') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss'))
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 3)
                    xPlayer.removeInventoryItem('carnepicada', 3)
                    xPlayer.removeInventoryItem('acelga', 3)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft') .. _U('lasagna') .. ' ~w~!')
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 3)
                    xPlayer.removeInventoryItem('carnepicada', 3)
                    xPlayer.removeInventoryItem('acelga', 3)
                end
            end

        end)
    end
   

end)


ESX.RegisterServerCallback('esx_restaurantejob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:addVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:removeVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:getPlayerInventory', function(source, cb)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
