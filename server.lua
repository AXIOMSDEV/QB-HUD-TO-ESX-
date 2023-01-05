ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local ResetStress = false

RegisterCommand('cash', function(source, args)
    local Player = ESX.GetPlayerFromId(source)
    local cashamount = Player.getMoney()
    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

RegisterCommand('bank', function(source, args)
    local Player = ESX.GetPlayerFromId(source)
    local bankamount = Player.getAccount('bank').cash
    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)

RegisterCommand("dev", function(source, args)
    TriggerClientEvent("qb-admin:client:ToggleDevmode", source)
end, 'admin')


RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local newStress
    if not Player then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    -- TriggerClientEvent('QBCore:Notify', src, Lang:t("notify.stress_removed"))
end)

ESX.RegisterServerCallback('hud:server:HasHarness', function(source, cb)
    local Ply = ESX.GetPlayerFromId(source)
    local Harness = Ply.getQuantity("harness")
    if Harness ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
ESX.RegisterServerCallback('hud:server:getMenu', function(source, cb)
    cb(Config.Menu)
end) 
