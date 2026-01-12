local radarActive = false

RegisterCommand("radar", function()
    radarActive = not radarActive
    QBCore.Functions.Notify(radarActive and "Radar activé" or "Radar désactivé", radarActive and "success" or "primary")
    if radarActive then
        CreateThread(MonitorSpeed)
    end
end, false)

function MonitorSpeed()
    while radarActive do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for _, veh in ipairs(vehicles) do
            local dist = #(coords - GetEntityCoords(veh))
            if dist < 100.0 then
                local speed = math.ceil(GetEntitySpeed(veh) * 3.6)
                if speed > 80 then
                    local plate = GetVehicleNumberPlateText(veh)
                    TriggerServerEvent("qb-policejob:server:LogSpeeding", plate, speed, coords)
                    QBCore.Functions.Notify("🚨 " .. plate .. " à " .. speed .. " km/h !", "error")
                end
            end
        end
        Wait(3000)
    end
end