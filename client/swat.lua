RegisterCommand("swat", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" or Player.job.grade.level < 3 then return end

    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("qb-policejob:server:SwatAssault", coords)
    QBCore.Functions.Notify("Opération SWAT lancée", "success")
end, false)