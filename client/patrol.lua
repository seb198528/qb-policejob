local QBCore = exports['qb-core']:GetCoreObject()
local onPatrol = false
local lastZone = nil

CreateThread(function()
    while true do
        Wait(60000) -- Vérifie toutes les minutes
        local Player = QBCore.Functions.GetPlayerData()
        if Player.job.name == "police" and onPatrol then
            local coords = GetEntityCoords(PlayerPedId())
            local inZone = false

            for _, zone in ipairs(Config.PatrolZones) do
                if coords.x >= zone.min.x and coords.x <= zone.max.x and
                   coords.y >= zone.min.y and coords.y <= zone.max.y and
                   coords.z >= zone.min.z and coords.z <= zone.max.z then
                    inZone = true
                    lastZone = zone.name
                    break
                end
            end

            if not inZone then
                QBCore.Functions.Notify("⚠️ Vous devez patrouiller dans une zone autorisée ! (Dernière: " .. (lastZone or "Aucune") .. ")", "error")
                -- Optionnel : retirer salaire ou kick après X fois
            else
                QBCore.Functions.Notify("✅ Patrouille active dans " .. lastZone, "success")
            end
        end
    end
end)

-- Activer/désactiver patrouille
RegisterCommand("patrol", function()
    onPatrol = not onPatrol
    QBCore.Functions.Notify(onPatrol and "Patrouille activée" or "Patrouille désactivée", onPatrol and "success" or "primary")
end, false)