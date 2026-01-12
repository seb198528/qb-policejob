local QBCore = exports['qb-core']:GetCoreObject()

-- Toggle service
RegisterNetEvent('qb-policejob:server:ToggleDuty', function(toggle)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name == "police" then
        -- Optionnel : log horaire
    end
end)

-- === MENOTTAGE ===
RegisterNetEvent('qb-policejob:server:CuffPlayer', function(targetId)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" then return end

    TriggerClientEvent('police:cuff', targetId)
    TriggerClientEvent('QBCore:Notify', src, "Menotté", "success")
end)

RegisterNetEvent('qb-policejob:server:UncuffPlayer', function(targetId)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" then return end

    TriggerClientEvent('police:uncuff', targetId)
    TriggerClientEvent('QBCore:Notify', src, "Libéré", "success")
end)

-- === FOUILLE ===
RegisterNetEvent('qb-policejob:server:SearchPlayer', function(targetId)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Officer or Officer.PlayerData.job.name ~= "police" or not Target then return end

    local items = {}
    for _, item in pairs(Target.PlayerData.items) do
        if item and item.amount > 0 then
            table.insert(items, item.name .. " x" .. item.amount)
        end
    end
    local msg = #items > 0 and table.concat(items, ", ") or "Rien trouvé."
    TriggerClientEvent('QBCore:Notify', src, "🔍 Fouille : " .. msg, "primary")
end)

-- === AMENDES + PERMIS ===
RegisterNetEvent('qb-policejob:server:FinePlayer', function(targetId, amount, reasonLabel, fineType)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Officer or not Target then return end

    if not Target.Functions.RemoveMoney('cash', amount, "fine") then
        TriggerClientEvent('QBCore:Notify', src, "Pas assez d'argent", "error")
        return
    end

    MySQL.insert('INSERT INTO player_fines (citizenid, amount, reason, officer_id) VALUES (?, ?, ?, ?)', {
        Target.PlayerData.citizenid, amount, reasonLabel, src
    })

    local points = Config.License.pointsPerFine[fineType] or 1
    AddLicensePoints(Target.PlayerData.citizenid, points)

    -- Notification
    TriggerClientEvent('QBCore:Notify', targetId, "Amende de $" .. amount .. " pour : " .. reasonLabel, "error")
    TriggerClientEvent('QBCore:Notify', src, "Amende appliquée", "success")

    -- Log dans ps-mdt
    if GetResourceState('ps-mdt') == 'started' then
        exports['ps-mdt']:addPoliceReport({
            title = "Amende",
            description = reasonLabel .. " - $" .. amount,
            author = Officer.PlayerData.charinfo.firstname .. " " .. Officer.PlayerData.charinfo.lastname,
            time = os.time(),
            charges = { reasonLabel },
            associated = Target.PlayerData.citizenid
        })
    end
end)

-- === GARDE À VUE ===
RegisterNetEvent('qb-policejob:server:JailPlayer', function(targetId, minutes)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Officer or Officer.PlayerData.job.name ~= "police" or not Target then return end

    TriggerClientEvent('qb-policejob:client:Jail', targetId, minutes * 60000)
    TriggerClientEvent('QBCore:Notify', src, "Dépôt en garde à vue (" .. minutes .. " min)", "success")

    -- Log MDT
    if GetResourceState('ps-mdt') == 'started' then
        exports['ps-mdt']:addPoliceReport({
            title = "Garde à vue",
            description = "Durée : " .. minutes .. " minutes",
            author = Officer.PlayerData.charinfo.firstname .. " " .. Officer.PlayerData.charinfo.lastname,
            time = os.time(),
            associated = Target.PlayerData.citizenid
        })
    end
end)

-- === RADIO 10-CODES ===
RegisterNetEvent('qb-policejob:server:BroadcastRadio', function(message)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" then return end

    local players = QBCore.Functions.GetPlayers()
    for _, id in pairs(players) do
        local P = QBCore.Functions.GetPlayer(id)
        if P and P.PlayerData.job.name == "police" then
            TriggerClientEvent('QBCore:Notify', id, "📻 RADIO: " .. message, "primary")
        end
    end
end)

-- === BODYCAM ===
RegisterNetEvent('qb-policejob:server:SaveBodycam', function(duration, timeout)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer then return end

    if GetResourceState('ps-mdt') == 'started' then
        exports['ps-mdt']:addPoliceReport({
            title = timeout and "Bodycam (Auto-stop)" or "Bodycam",
            description = "Enregistrement de " .. duration .. " secondes",
            author = Officer.PlayerData.charinfo.firstname .. " " .. Officer.PlayerData.charinfo.lastname,
            time = os.time(),
            type = "bodycam"
        })
    end
end)

-- === K9 (CHIEN POLICIER) ===
RegisterNetEvent('qb-policejob:server:DeployK9', function(targetId)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" or Officer.PlayerData.job.grade.level < 2 then
        TriggerClientEvent('QBCore:Notify', src, "Grade insuffisant (Sergent+)", "error")
        return
    end

    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Target then return end

    -- Simuler attaque K9 (sans dégâts réels)
    TriggerClientEvent('QBCore:Notify', targetId, "🚨 K9 LÂCHÉ ! Obéissez immédiatement !", "error")
    TriggerClientEvent('QBCore:Notify', src, "K9 déployé", "success")

    -- Log MDT
    if GetResourceState('ps-mdt') == 'started' then
        exports['ps-mdt']:addPoliceReport({
            title = "Déploiement K9",
            description = "Cible : " .. Target.PlayerData.charinfo.firstname,
            author = Officer.PlayerData.charinfo.firstname .. " " .. Officer.PlayerData.charinfo.lastname,
            time = os.time(),
            associated = Target.PlayerData.citizenid
        })
    end
end)

-- === SWAT ASSAULT ===
RegisterNetEvent('qb-policejob:server:SwatAssault', function(coords)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" or Officer.PlayerData.job.grade.level < 3 then
        TriggerClientEvent('QBCore:Notify', src, "Grade insuffisant (Lieutenant+)", "error")
        return
    end

    -- Annoncer l'assaut
    local players = QBCore.Functions.GetPlayers()
    for _, id in pairs(players) do
        local dist = #(GetEntityCoords(GetPlayerPed(id)) - coords)
        if dist < 150.0 then
            TriggerClientEvent('QBCore:Notify', id, "⚠️ SWAT EN APPROCHE – COUCHEZ-VOUS !", "error")
        end
    end

    -- Log MDT
    if GetResourceState('ps-mdt') == 'started' then
        exports['ps-mdt']:addPoliceReport({
            title = "Opération SWAT",
            description = "Zone ciblée : " .. json.encode({ x = coords.x, y = coords.y }),
            author = Officer.PlayerData.charinfo.firstname .. " " .. Officer.PlayerData.charinfo.lastname,
            time = os.time()
        })
    end

    TriggerClientEvent('QBCore:Notify', src, "Opération SWAT lancée", "success")
end)

-- === GESTION RH (BOSS) ===
RegisterNetEvent('qb-policejob:server:BossAction', function(citizenid, action)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    if not Officer or Officer.PlayerData.job.name ~= "police" or Officer.PlayerData.job.grade.level < 4 then
        TriggerClientEvent('QBCore:Notify', src, "Accès refusé", "error")
        return
    end

    local target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if not target then
        TriggerClientEvent('QBCore:Notify', src, "Joueur introuvable", "error")
        return
    end

    if action == "hire" then
        target.Functions.SetJob("police", 0)
    elseif action == "fire" then
        target.Functions.SetJob("unemployed", 0)
    elseif action == "promote" then
        target.Functions.SetJob("police", math.min(target.PlayerData.job.grade.level + 1, 4))
    elseif action == "demote" then
        target.Functions.SetJob("police", math.max(target.PlayerData.job.grade.level - 1, 0))
    end

    TriggerClientEvent('QBCore:Notify', src, "Action effectuée", "success")
end)

-- === GESTION PERMIS ===
function AddLicensePoints(citizenid, points)
    MySQL.update('UPDATE players SET drivingpoints = drivingpoints - ? WHERE citizenid = ?', { points, citizenid })
    MySQL.scalar('SELECT drivingpoints FROM players WHERE citizenid = ?', { citizenid }, function(drivingpoints)
        if drivingpoints and drivingpoints <= 0 then
            MySQL.update('UPDATE players SET licenseloss = ? WHERE citizenid = ?', {
                os.time() + (Config.License.suspensionDuration / 1000),
                citizenid
            })
            -- Notifier le joueur
            local target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            if target then
                TriggerClientEvent('QBCore:Notify', target.PlayerId, "⚠️ Permis suspendu 10 min !", "error")
            end
        end
    end)
end)