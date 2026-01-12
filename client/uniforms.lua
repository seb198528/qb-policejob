local QBCore = exports['qb-core']:GetCoreObject()

-- Changer d'uniforme
RegisterNetEvent('qb-policejob:client:ChangeUniform', function()
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name ~= "police" then return end

    local grade = Player.job.grade.level
    local outfitName = Config.Ranks[grade].outfit

    -- qb-clothing
    TriggerEvent('qb-clothing:client:loadOutfit', outfitName)

    -- Alternative : esx_skin
    -- TriggerServerEvent('esx_skin:save', skin)
end)

-- Bouton dans le menu LSPD
-- Ajoute ceci dans client/main.lua > OpenMenu :
-- table.insert(elements, { header = "👔 Changer d'uniforme", params = { event = "qb-policejob:client:ChangeUniform" } })