Utils = {}

local phonePriority = {
    {name = 'codem-phone', configKey = 'codem_phone'},
    {name = 'qb-phone', configKey = 'qb_phone'},
    {name = 'gcphone', configKey = 'gcphone'},
    {name = 'np-phone', configKey = 'np_phone'},
    {name = 'qs-smartphone', configKey = 'qs_smartphone'},
    {name = 'lb-phone', configKey = 'lb_phone'},
}

local detectedPhone = nil

function Utils.GetFramework()
    if GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qbox') == 'started' then
        return 'qbox'
    end
    return 'standalone'
end

function Utils.Notify(playerId, msg, type)
    if GetResourceState('ox_lib') == 'started' then
        TriggerClientEvent('ox_lib:notify', playerId, { description = msg, type = type or 'inform' })
    elseif GetResourceState('qb-core') == 'started' then
        TriggerClientEvent('QBCore:Notify', playerId, msg, type or 'primary')
    elseif GetResourceState('es_extended') == 'started' then
        TriggerClientEvent('esx:showNotification', playerId, msg)
    else
        TriggerClientEvent('chat:addMessage', playerId, {
            color = {255, 0, 0},
            multiline = true,
            args = { "MysteryCalls", msg }
        })
    end
end

function Utils.GiveReward(playerId)
    local framework = Utils.GetFramework()
    local inventoryType = Config.Inventory.type

    if inventoryType == "qb-inventory" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            Player.Functions.AddItem(Config.Inventory.item, Config.Inventory.amount)
            Utils.Notify(playerId, ("You received %d x %s"):format(Config.Inventory.amount, Config.Inventory.item), 'success')
        else
            Utils.Notify(playerId, "Player not found (QBCore).", "error")
        end

    elseif inventoryType == "ox_inventory" then
        TriggerClientEvent('ox_inventory:addItem', playerId, Config.Inventory.item, Config.Inventory.amount)
        Utils.Notify(playerId, ("You received %d x %s"):format(Config.Inventory.amount, Config.Inventory.item), 'success')

    elseif inventoryType == "none" then
        local amount = Config.Reward.amount or 500

        if framework == 'qbcore' then
            local QBCore = exports['qb-core']:GetCoreObject()
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player then
                Player.Functions.AddMoney('cash', amount)
                Utils.Notify(playerId, 'You received $' .. amount, 'success')
            else
                Utils.Notify(playerId, "Player not found (QBCore).", "error")
            end
        elseif framework == 'esx' then
            TriggerEvent('esx:getSharedObject', function(ESX)
                local xPlayer = ESX.GetPlayerFromId(playerId)
                if xPlayer then
                    xPlayer.addMoney(amount)
                    Utils.Notify(playerId, 'You received $' .. amount, 'success')
                else
                    Utils.Notify(playerId, "Player not found (ESX).", "error")
                end
            end)
        elseif framework == 'qbox' then
            -- qbox fallback: ox_inventory default, but fallback just notifies cash here
            Utils.Notify(playerId, 'You received $' .. amount, 'success')
        else
            Utils.Notify(playerId, 'You received $' .. amount)
        end

    else
        Utils.Notify(playerId, 'Reward granted but inventory type not supported.', 'error')
    end
end

function Utils.DetectPhoneResource()
    if detectedPhone then return detectedPhone end

    if not Config.PhoneResource.auto_detect then
        -- Manual mode, find first enabled and started phone resource
        for _, phone in ipairs(phonePriority) do
            if Config.PhoneResource[phone.configKey] and GetResourceState(phone.name) == 'started' then
                detectedPhone = phone.name
                return detectedPhone
            end
        end
        return nil
    end

    -- Auto-detect mode
    for _, phone in ipairs(phonePriority) do
        if Config.PhoneResource[phone.configKey] and GetResourceState(phone.name) == 'started' then
            detectedPhone = phone.name
            return detectedPhone
        end
    end

    return nil
end

function Utils.TriggerPhoneCall(playerId, callerName, callMessage)
    local phone = Utils.DetectPhoneResource()

    if phone == 'codem-phone' then
        TriggerClientEvent('codem-phone:call:receive', playerId, {
            caller = callerName,
            message = callMessage,
            duration = 30
        })
    elseif phone == 'qb-phone' then
        TriggerClientEvent('qb-phone:client:CustomNotification', playerId, {
            title = callerName,
            text = callMessage,
            icon = 'fas fa-phone',
            timeout = 10000
        })
    elseif phone == 'gcphone' then
        TriggerClientEvent('gcPhone:receiveCall', playerId, callMessage)
    elseif phone == 'np-phone' then
        exports['np-phone']:SendPhoneNotification(playerId, callerName, callMessage)
    elseif phone == 'qs-smartphone' then
        TriggerClientEvent('qs-smartphone:client:NewCall', playerId, callerName, callMessage)
    elseif phone == 'lb-phone' then
        TriggerClientEvent('lb-phone:client:NewCall', playerId, callerName, callMessage)
    else
        -- fallback chat message if no phone detected
        TriggerClientEvent('chat:addMessage', playerId, {
            color = {255, 0, 0},
            multiline = true,
            args = { callerName, callMessage }
        })
    end
end
