-- Version check logic (example)

local CURRENT_VERSION = '1.0.1'
local REPO_URL = 'https://raw.githubusercontent.com/Robg815/mystery-phone-calls/main/version.json'

CreateThread(function()
    PerformHttpRequest(REPO_URL, function(err, text, headers)
        if err == 200 then
            local data = json.decode(text)
            if data and data.version and data.version ~= CURRENT_VERSION then
                print("^1[MysteryPhoneCalls]^7 Update available: " .. data.version .. " (Current: " .. CURRENT_VERSION .. ")")
            end
        else
            print("^1[MysteryPhoneCalls]^7 Failed to check version info.")
        end
    end)
end)
