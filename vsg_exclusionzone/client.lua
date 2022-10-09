local hasused = false
ESX = nil
local PlayerData = {}
local pdblip = {}
local zoneblip = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)



RegisterCommand(Config.command, function(source, args, raw)
    local radius = tonumber(args[1])
    if radius > Config.maxradius then
        Config.announce("Der Radius für die Sperrzone ist zu groß!")
    else
        radius = radius + .0
        if not hasused then
            hasused = true
            for k, v in pairs(Config.whitelistedjobs) do
                if PlayerData.job.name == v then
                    TriggerServerEvent("sperrzone:get", radius)
                end
            end
        else
            Config.announce("Du hast bereits eine Sperrzone ausgerufen!")
        end
    end
end)


RegisterNetEvent("sperrzone:add", function(radius, coords, source)
    addblip(radius, coords, source)
    if Config.sperrzonentype == 1 or Config.sperrzonentype == 2 then
        local name = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
        Config.announce("Es wurde eine Sperrzone an der "..name.." ausgerufen!")
    end
end)


function addblip(radius, coords, source)
    if Config.sperrzonentype == 1 then
        pdblip[source] = AddBlipForCoord(coords.x, coords.y, coords.z)
        zoneblip[source] = AddBlipForRadius(coords.x, coords.y, coords.z, radius * 2)

        SetBlipAlpha(zoneblip[source], 150)
        SetBlipColour(zoneblip[source], 1)
        SetBlipSprite(pdblip[source], 60)
        SetBlipScale(pdblip[source], 0.8)
        SetBlipColour(pdblip[source], 29)
        SetBlipAsShortRange(pdblip[source], true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Sperrzone')
        EndTextCommandSetBlipName(pdblip[source])


        Citizen.CreateThread(function()
            local blue = false
            while DoesBlipExist(zoneblip[source]) do
                Citizen.Wait(500)
                if blue then
                    blue = false
                    SetBlipColour(zoneblip[source], 1)
                else
                    blue = true
                    SetBlipColour(zoneblip[source], 38)
                end
                
            end
        end)
    elseif Config.sperrzonentype == 2 then
        zoneblip[source] = AddBlipForRadius(coords.x, coords.y, coords.z, radius * 5.6)
        SetBlipSprite(zoneblip[source], 161)
    else
        print("Error: Invalid Sperrzonentype in config.lua")
    end

end

RegisterCommand(Config.deletecommand, function(source)
    if hasused then
        for k, v in pairs(Config.whitelistedjobs) do
            if PlayerData.job.name == v then
                    hasused = false
                    TriggerServerEvent("sperrzone:delete")
                    Config.announce("Die Sperrzone wurde erfolgreich entfernt!")
            end
        end
    end
end)


function removeBlip(source)
    if DoesBlipExist(zoneblip[source]) then
        RemoveBlip(zoneblip[source])
    end
    if DoesBlipExist(pdblip[source]) then
        RemoveBlip(pdblip[source])
    end
end


RegisterNetEvent("sperrzone:deletec")
AddEventHandler("sperrzone:deletec", function(source)
    removeBlip(source)
end)