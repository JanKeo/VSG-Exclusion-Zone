ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)
RegisterServerEvent("sperrzone:get")
AddEventHandler("sperrzone:get", function(radius)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local coords = xPlayer.getCoords(true)
    TriggerClientEvent("sperrzone:add", -1, radius, coords, _source)
end)


RegisterServerEvent("sperrzone:delete")
AddEventHandler("sperrzone:delete", function()
    local _source = source
    TriggerClientEvent("sperrzone:deletec", -1, _source)
end)