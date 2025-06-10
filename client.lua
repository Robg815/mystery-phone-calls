local searching = false
local searchLocation = nil
local searchRadius = 0

RegisterNetEvent('mysterycalls:startCall', function(callerName, callMessage, location, radius)
    searchLocation = location
    searchRadius = radius
    searching = true

    -- Show phone notification
    TriggerServerEvent('mysterycalls:triggerPhoneCall')

    -- Add map blip
    local blip = AddBlipForRadius(searchLocation.x, searchLocation.y, searchLocation.z, searchRadius)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)

    -- Add red circle on minimap
    local circleBlip = AddBlipForCoord(searchLocation.x, searchLocation.y, searchLocation.z)
    SetBlipSprite(circleBlip, 9)
    SetBlipColour(circleBlip, 1)
    SetBlipScale(circleBlip, 1.0)
    SetBlipAsShortRange(circleBlip, false)

    Utils.Notify(PlayerId(), "You have a new mysterious call! Search the marked area on your map.", 'inform')

    -- Searching loop
    Citizen.CreateThread(function()
        while searching do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local dist = #(playerCoords - searchLocation)

            if dist <= searchRadius then
                searching = false
                RemoveBlip(blip)
                RemoveBlip(circleBlip)

                -- Give reward
                TriggerServerEvent('mysterycalls:rewardPlayer')

                Utils.Notify(PlayerId(), "You found the secret package and received your reward!", 'success')
            end
            Wait(1000)
        end
    end)
end)
