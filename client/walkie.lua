local QBCore = exports['qb-core']:GetCoreObject()
local isWalkieOn = false
local walkieChannel = "police"

-- Commande rapide
RegisterCommand("walkie", function()
    if not isWalkieOn then
        TurnOnWalkie()
    else
        TurnOffWalkie()
    end
end, false)

function TurnOnWalkie()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then
        QBCore.Functions.Notify(Lang.en.police.walkie_police_only, "error")
        return
    end
    isWalkieOn = true
    QBCore.Functions.Notify(Lang.en.police.walkie_on, "success")
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function TurnOffWalkie()
    isWalkieOn = false
    QBCore.Functions.Notify(Lang.en.police.walkie_off, "primary")
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

-- Écouter le micro
CreateThread(function()
    while true do
        Wait(0)
        if isWalkieOn and IsControlJustPressed(0, 245) then -- Touche par défaut : B (ou remplace par INPUT_VEH_PUSHBIKE_SPRINT)
            local message = lib.inputDialog('Talkie-walkie', {
                { type = 'input', label = 'Message', description = 'Max 100 caractères', required = true, max = 100 }
            })
            if message and message[1] then
                local Player = QBCore.Functions.GetPlayerData()
                local name = Player.charinfo.firstname .. " " .. Player.charinfo.lastname
                local fullMsg = string.format(Lang.en.police.walkie_message, name, message[1])
                
                -- Envoyer à tous les policiers
                local players = QBCore.Functions.GetPlayers()
                for _, id in pairs(players) do
                    local P = QBCore.Functions.GetPlayer(id)
                    if P and P.PlayerData.job.name == "police" then
                        TriggerClientEvent('QBCore:Notify', id, fullMsg, "primary")
                    end
                end
            end
        end
    end
end)

-- Menu walkie (optionnel)
RegisterNetEvent('qb-policejob:walkie:open', function()
    local elements = {
        { header = "<span style='color: #1E90FF;'>📻 Talkie-walkie</span>", txt = "" }
    }

    table.insert(elements, {
        header = isWalkieOn and "📴 Désactiver" or "✅ Activer",
        params = { event = "qb-policejob:client:ToggleWalkie" }
    })

    exports['qb-menu']:openMenu(elements)
end)

RegisterNetEvent('qb-policejob:client:ToggleWalkie', function()
    if isWalkieOn then
        TurnOffWalkie()
    else
        TurnOnWalkie()
    end
end)