local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand("10code", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then
        QBCore.Functions.Notify("Accès refusé", "error")
        return
    end

    local selected = lib.menu({
        title = "📻 Radio 10-Codes",
        options = Config.TenCodes
    })

    if selected then
        local message = Config.TenCodes[selected]
        TriggerServerEvent("qb-policejob:server:BroadcastRadio", message)
    end
end, false)