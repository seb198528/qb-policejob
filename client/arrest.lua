local QBCore = exports['qb-core']:GetCoreObject()
local isCuffed = false

-- Animation dict
local AnimDict = "mp_arresting"
local AnimName = "idle"

-- Charger l'anim
function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

-- Menotter
RegisterNetEvent('police:cuff', function()
    if isCuffed then return end
    isCuffed = true

    LoadAnimDict(AnimDict)
    local ped = PlayerPedId()
    TaskPlayAnim(ped, AnimDict, AnimName, 8.0, -8, -1, 49, 0, false, false, false)
    SetEnableHandcuffs(ped, true)
    SetPedCanPlayGestureAnims(ped, false)
    SetPedCanSwitchWeapon(ped, false)
    DisableControlAction(0, 24, true)  -- Attaque
    DisableControlAction(0, 257, true) -- T
    DisableControlAction(0, 263, true) -- Entrer véhicule
    QBCore.Functions.Notify("Vous êtes menotté(e).", "error")
end)

-- Libérer
RegisterNetEvent('police:uncuff', function()
    if not isCuffed then return end
    isCuffed = false

    ClearPedTasks(PlayerPedId())
    SetEnableHandcuffs(PlayerPedId(), false)
    SetPedCanPlayGestureAnims(PlayerPedId(), true)
    SetPedCanSwitchWeapon(PlayerPedId(), true)
    EnableAllControlActions(0)
    QBCore.Functions.Notify("Vous avez été libéré(e).", "success")
end)

-- Commande /cuff (réservée police)
RegisterCommand("cuff", function()
    local src = source
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then
        QBCore.Functions.Notify("Accès refusé", "error")
        return
    end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if distance and distance < 2.5 then
        TriggerServerEvent("qb-policejob:server:CuffPlayer", GetPlayerServerId(player))
    else
        QBCore.Functions.Notify("Aucun joueur à proximité", "error")
    end
end, false)

-- Commande /uncuff
RegisterCommand("uncuff", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then
        QBCore.Functions.Notify("Accès refusé", "error")
        return
    end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if distance and distance < 2.5 then
        TriggerServerEvent("qb-policejob:server:UncuffPlayer", GetPlayerServerId(player))
    else
        QBCore.Functions.Notify("Aucun joueur à proximité", "error")
    end
end, false)

-- Fouille
RegisterCommand("search", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if distance and distance < 2.5 then
        TriggerServerEvent("qb-policejob:server:SearchPlayer", GetPlayerServerId(player))
    else
        QBCore.Functions.Notify("Personne à fouiller", "error")
    end
end, false)

-- Amende
RegisterCommand("fine", function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    local player, distance = QBCore.Functions.GetClosestPlayer()
    if not (distance and distance < 2.5) then
        QBCore.Functions.Notify("Personne à proximité", "error")
        return
    end

    local fineInput = lib.inputDialog('Amende', {
        { type = 'select', label = 'Infraction', options = {
            { value = 'speeding', text = 'Excès de vitesse' },
            { value = 'weapon', text = 'Arme illégale' },
            { value = 'drugs', text = 'Drogue' },
            { value = 'stolen', text = 'Véhicule volé' }
        }},
        { type = 'number', label = 'Montant ($)', default = 150, min = 50, max = 5000 }
    })

    if fineInput then
        local reason = fineInput[1] or "speeding"
        local amount = tonumber(fineInput[2]) or Config.Fines[reason].base
        TriggerServerEvent("qb-policejob:server:FinePlayer", GetPlayerServerId(player), amount, Config.Fines[reason].label, reason)
    end
end, false)