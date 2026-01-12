RegisterCommand("k9", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" or Player.job.grade.level < 2 then return end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if distance and distance < 10.0 then
        TriggerServerEvent("qb-policejob:server:DeployK9", GetPlayerServerId(player))
    else
        QBCore.Functions.Notify("Cible non trouvée", "error")
    end
end, false)