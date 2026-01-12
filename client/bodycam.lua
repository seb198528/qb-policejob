local QBCore = exports['qb-core']:GetCoreObject()
local isRecording = false
local recordStart = 0

RegisterCommand("bodycam", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    if not isRecording then
        isRecording = true
        recordStart = GetGameTimer()
        QBCore.Functions.Notify("🎥 Bodycam ACTIVÉE", "success")
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        CreateThread(MonitorRecording)
    else
        StopRecording()
    end
end, false)

function MonitorRecording()
    while isRecording do
        local elapsed = GetGameTimer() - recordStart
        if elapsed > Config.Bodycam.durationLimit then
            StopRecording(true)
        end
        Wait(5000)
    end
end

function StopRecording(timeout)
    isRecording = false
    local duration = math.ceil((GetGameTimer() - recordStart) / 1000)
    TriggerServerEvent("qb-policejob:server:SaveBodycam", duration, timeout)
    QBCore.Functions.Notify(timeout and "⚠️ Enregistrement auto-stop (30 min)" or "⏹️ Bodycam DÉSACTIVÉE", "primary")
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

-- État bodycam visible dans ps-mdt
AddEventHandler('ps-mdt:client:GetOfficerStatus', function(cb)
    cb({
        bodycam = isRecording,
        onDuty = onDuty -- depuis main.lua
    })
end)