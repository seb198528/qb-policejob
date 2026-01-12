local QBCore = exports['qb-core']:GetCoreObject()

-- Ajout au menu véhicule
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.Locations.helicopter)
        if dist < 5.0 and QBCore.Functions.GetPlayerData().job.name == "police" then
            exports['qb-target']:AddBoxZone("LSPD_Helicopter", Config.Locations.helicopter, 2, 2, {
                name = "LSPD_Helicopter",
                heading = 0,
                debugPoly = false
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-policejob:client:SpawnHelicopter",
                        icon = "fas fa-helicopter",
                        label = "🚑 Spawn Hélicoptère"
                    }
                },
                distance = 2.5
            })
            break
        end
        Wait(2000)
    end
end)

RegisterNetEvent('qb-policejob:client:SpawnHelicopter', function()
    local model = GetHashKey(Config.Helicopter)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end

    local heli = CreateVehicle(model, Config.Locations.helicopter.x, Config.Locations.helicopter.y, Config.Locations.helicopter.z, Config.Locations.helicopter.w, true, false)
    SetVehicleNumberPlateText(heli, "LSPD-AIR")
    TaskWarpPedIntoVehicle(PlayerPedId(), heli, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(heli))
    QBCore.Functions.Notify("Hélicoptère spawné", "success")
end)