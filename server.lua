local lastGlobalCall = 0
local playerCooldowns = {}

local function pickSearchLocation()
    return Config.SearchLocations[math.random(#Config.SearchLocations)]
end

local function canCallPlayer(playerId)
    local now = os.time()
    if not playerCooldowns[playerId] or (now - playerCooldowns[playerId]) >= Config.CallCooldown then
        return true
    end
    return false
end

local function setPlayerCooldown(playerId)
    playerCooldowns[playerId] = os.time()
end

local function canGlobalCall()
    local now = os.time()
    return (now - lastGlobalCall) >= Config.CallIntervalMin
end

local function setGlobalCallTime()
    lastGlobalCall = os.time()
end

CreateThread(function()
    while true do
        local waitTime = math.random(Config.CallIntervalMin, Config.CallIntervalMax) * 1000
        Wait(waitTime)

        if canGlobalCall() then
            local players = GetPlayers()
            local eligiblePlayers = {}

            for _, pid in ipairs(players) do
                local playerId = tonumber(pid)
                if canCallPlayer(playerId) then
                    table.insert(eligiblePlayers, playerId)
                end
            end

            if #eligiblePlayers > 0 then
                local selectedPlayer = eligiblePlayers[math.random(#eligiblePlayers)]
                local searchLocation = pickSearchLocation()

                TriggerClientEvent('mysterycalls:startCall', selectedPlayer, Config.CallerName, Config.CallMessage, searchLocation, Config.SearchAreaRadius)

                setPlayerCooldown(selectedPlayer)
                setGlobalCallTime()
            end
        end
    end
end)

RegisterServerEvent('mysterycalls:rewardPlayer')
AddEventHandler('mysterycalls:rewardPlayer', function()
    local src = source
    Utils.GiveReward(src)
end)

-- Call client event to show phone notification when call starts (for sync)
RegisterServerEvent('mysterycalls:triggerPhoneCall')
AddEventHandler('mysterycalls:triggerPhoneCall', function()
    local src = source
    Utils.TriggerPhoneCall(src, Config.CallerName, Config.CallMessage)
end)
