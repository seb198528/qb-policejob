local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand("jail", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if not (distance and distance < 2.5) then
        QBCore.Functions.Notify("Personne à proximité", "error")
        return
    end

    local time = lib.inputDialog('Garde à vue', {
        { type = 'number', label = 'Durée (minutes)', default = 5, min = 1, max = 60 }
    })

    if time and tonumber(time[1]) then
        local minutes = tonumber(time[1])
        TriggerServerEvent("qb-policejob:server:JailPlayer", GetPlayerServerId(player), minutes)
    end
end, false)

-- Libération manuelle
RegisterCommand("unjail", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    TriggerServerEvent("qb-policejob:server:UnjailAll")
    QBCore.Functions.Notify("Tous les détenus libérés", "success")
end, false)

RegisterNetEvent('qb-policejob:client:Jail', function(duration)
    local jailPos = Config.Locations.jail
    SetEntityCoords(PlayerPedId(), jailPos.x, jailPos.y, jailPos.z)
    FreezeEntityPosition(PlayerPedId(), true)
    QBCore.Functions.Notify("Vous êtes en garde à vue. Attendez...", "error")

    Wait(duration)
    FreezeEntityPosition(PlayerPedId(), false)
    QBCore.Functions.Notify("Vous avez été libéré(e).", "success")
end)