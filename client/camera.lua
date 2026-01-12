RegisterCommand("camera", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("qb-policejob:server:TakePhoto", coords)
    PlaySoundFrontend(-1, "CLICK", "WEB_NAVIGATION_SOUNDS_PHONE", true)
    QBCore.Functions.Notify("📸 Photo envoyée au central", "success")
end, false)