local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local onDuty = false

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == "police" then
        CreateThread(function() PoliceBlips() end)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    if JobInfo.name == "police" then
        CreateThread(PoliceBlips)
    else
        RemoveBlip(blip)
    end
end)

local blip = nil
function PoliceBlips()
    if blip then RemoveBlip(blip) end
    blip = AddBlipForCoord(Config.Locations.station.x, Config.Locations.station.y, Config.Locations.station.z)
    SetBlipSprite(blip, 60)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 38)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("LSPD")
    EndTextCommandSetBlipName(blip)
end

-- NPC Menu
CreateThread(function()
    local model = GetHashKey("s_m_y_cop_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local npc = CreatePed(2, model, Config.Locations.station.x, Config.Locations.station.y, Config.Locations.station.z - 1, Config.Locations.station.w, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    TaskStandStill(npc, -1)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "client",
                event = "qb-policejob:client:OpenMenu",
                icon = "fas fa-shield-alt",
                label = "Menu LSPD"
            }
        },
        distance = 2.0
    })
end)

RegisterNetEvent('qb-policejob:client:OpenMenu', function()
    local elements = {
        { header = "<span style='color: #1E90FF;'>👮‍♂️ LSPD</span>", txt = "" }
    }

    if not onDuty then
        table.insert(elements, {
            header = "✅ Prendre son service",
            params = { event = "qb-policejob:client:ToggleDuty", args = true }
        })
    else
        table.insert(elements, {
            header = "⏹️ Quitter le service",
            params = { event = "qb-policejob:client:ToggleDuty", args = false }
        })
        table.insert(elements, { header = "🧰 Armurerie", params = { event = "qb-policejob:client:Armory" } })
        table.insert(elements, { header = "🚗 Véhicules", params = { event = "qb-policejob:client:VehicleMenu" } })
        table.insert(elements, { header = "🗄️ Casier perso", params = { event = "qb-policejob:client:Stash" } })
        if PlayerData.job.grade.level >= 3 then
            table.insert(elements, { header = "👔 Bureau du chef", params = { event = "qb-policejob:client:BossMenu" } })
        end
    end

    exports['qb-menu']:openMenu(elements)
end)

-- Toggle service
RegisterNetEvent('qb-policejob:client:ToggleDuty', function(toggle)
    TriggerServerEvent('qb-policejob:server:ToggleDuty', toggle)
    onDuty = toggle
    QBCore.Functions.Notify(toggle and "En service." or "Hors service.", toggle and "success" or "primary")
end)

-- Armurerie
RegisterNetEvent('qb-policejob:client:Armory', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'police_armory')
    TriggerEvent('inventory:client:SetCurrentStash', 'police_armory')
end)

-- Casier
RegisterNetEvent('qb-policejob:client:Stash', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'police_' .. PlayerData.citizenid)
    TriggerEvent('inventory:client:SetCurrentStash', 'police_' .. PlayerData.citizenid)
end)

-- Véhicules
RegisterNetEvent('qb-policejob:client:VehicleMenu', function()
    local elements = {}
    for model, label in pairs(Config.Vehicles) do
        table.insert(elements, {
            header = "🚘 " .. label,
            params = { event = "qb-policejob:client:SpawnVehicle", args = model }
        })
    end
    exports['qb-menu']:openMenu(elements)
end)

RegisterNetEvent('qb-policejob:client:SpawnVehicle', function(model)
    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "LSPD-" .. math.random(1000, 9999))
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end, Config.Locations.vehicle, true)
end)

-- Boss menu
RegisterNetEvent('qb-policejob:client:BossMenu', function()
    local input = lib.inputDialog('Gestion RH', {
        { type = 'input', label = 'CitizenID', description = 'ID du joueur', required = true },
        { type = 'select', label = 'Action', options = {
            { value = 'hire', text = 'Embaucher' },
            { value = 'fire', text = 'Renvoyer' },
            { value = 'promote', text = 'Promouvoir' },
            { value = 'demote', text = 'Rétrograder' }
        }}
    })

    if input then
        TriggerServerEvent('qb-policejob:server:BossAction', input[1], input[2])
    end
end)

if onDuty then
    table.insert(elements, { header = "📻 Talkie-walkie", params = { event = "qb-policejob:client:OpenWalkieMenu" } })
end

RegisterNetEvent('qb-policejob:client:OpenWalkieMenu', function()
    TriggerEvent('qb-policejob:walkie:open')
end)