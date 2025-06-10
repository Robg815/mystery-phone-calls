Config = {}

-- Cooldown time per player in seconds before they can receive a new call
Config.CallCooldown = 600

-- Global interval range in seconds between mystery calls (random between min and max)
Config.CallIntervalMin = 600
Config.CallIntervalMax = 1800

-- Caller details
Config.CallerName = "Unknown Caller"
Config.CallMessage = "I've got a secret for you. Find the hidden package at the marked location."

-- Search area radius in meters
Config.SearchAreaRadius = 50.0

-- Default GTA V map locations (vector3) - fully editable
Config.SearchLocations = {
    vector3(215.76, -810.12, 30.73),   -- Pillbox Hill
    vector3(-500.24, 200.52, 43.48),   -- Little Seoul
    vector3(1200.56, -1300.36, 35.22), -- Davis Quartz
    vector3(-170.03, 6554.11, 32.61),  -- Paleto Bay
    vector3(346.54, -583.42, 28.79),   -- Strawberry
}

-- Inventory reward config
-- type: "qb-inventory", "ox_inventory", or "none"
Config.Inventory = {
    type = "ox_inventory",
    item = "secret_package",
    amount = 1,
}

-- Cash reward fallback if inventory type is "none"
Config.Reward = {
    amount = 500,
}

-- Phone resource compatibility toggles & auto detect switch
Config.PhoneResource = {
    auto_detect = true,  -- If true, script auto detects best available phone resource

    codem_phone = true,
    qb_phone = true,
    gcphone = true,
    np_phone = true,
    qs_smartphone = true,
    lb_phone = true,
}
