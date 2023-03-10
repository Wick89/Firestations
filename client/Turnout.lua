-- ==========================FireFighter Job==========================
-- ===============================Turnout===============================
-- ===============================By Wick===============================
-- ======================================================================

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-Firestations:Client:TurnoutOff', function ()
    while not HasAnimDictLoaded("clothingtie") do RequestAnimDict("clothingtie") Wait(100) end
	TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, false, false, false)
    Wait(1200)
    TriggerServerEvent("qb-clothes:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES
    TriggerServerEvent("qb-clothing:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES - Event 2
end)

RegisterNetEvent('qb-Firestations:Client:TurnoutOn', function ()

    while not HasAnimDictLoaded("clothingtie") do RequestAnimDict("clothingtie") Wait(100) end
TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 3.0, 3.0, 1200, 51, 0, false, false, false)
Wait(1200)

    -- Arms
    if Config.turnout['arms'] ~= nil then
        SetPedComponentVariation(PlayerPedId(), 3, Config.turnout['arms'].item, Config.turnout['arms'].texture, 0)
    end
 -- pants / suitpants
    if Config.turnout['suitpants'] ~= nil then
        
        SetPedComponentVariation(PlayerPedId(), 4, Config.turnout['suitpants'].item, Config.turnout['suitpants'].texture, 0)
    end
-- scba
    if Config.turnout['scba'] ~= nil then
        SetPedComponentVariation(PlayerPedId(), 8, Config.turnout['scba'].item, Config.turnout['scba'].texture, 0)
    end
-- top / suittop
    if Config.turnout['suittop'] ~= nil then
        SetPedComponentVariation(PlayerPedId(), 11, Config.turnout['suittop'].item, Config.turnout['suittop'].texture, 0)
    end
 -- mask / suitmask   
    if Config.turnout['suitmask'] ~= nil then
        SetPedComponentVariation(PlayerPedId(), 1, Config.turnout['suitmask'].item, Config.turnout['suitmask'].texture, 0)
    end

    -- Shoes / suitshoes
    if Config.turnout['suitshoes'] ~= nil then
        SetPedComponentVariation(PlayerPedId(), 6, Config.turnout['suitshoes'].item, Config.turnout['suitshoes'].texture, 0)
    end
    
--[[ old
    -- Vest
    if config.turnout.vest ~= nil then
        SetPedComponentVariation(PlayerPedId(), 9, config.turnout.vest.item, config.turnout.vest.texture, 0)
    end

    -- Glass
    if config.turnout.glass ~= nil then
            SetPedPropIndex(PlayerPedId(), 1, config.turnout.glass.item, config.turnout.glass.texture, true)
    end

    -- Ear
    if config.turnout.ear ~= nil then
            SetPedPropIndex(PlayerPedId(), 2, config.turnout.turnout.ear.item, config.turnout.ear.texture, true)
    end
    --]]
    ClearPedProp(ped, 1)
end)

RegisterNetEvent('qb-Firestations:turnoutMenu', function(data)
    exports['qb-menu']:openMenu({
        {
            isMenuHeader = true, 
            header = "👨‍🚒| Fire Turnout Gear | 👨‍🚒",
        },
        {
            
            header = "• Turnout Gear On",
            txt = "Puts your turnout gear on",
            params = {
                event = "qb-Firestations:Client:TurnoutOn",
                args = {
                    number = 1,
                }
            }
        },
		{
            
            header = "• Turnout Gear Off",
            txt = "Takes your turnout gear off",
            params = {
                event = 'qb-Firestations:Client:TurnoutOff',
                args = {
                    number = 1,
                }
            },
        },    
        {
            isMenuHeader = true, 
            header = "Close (ESC)",
        },
    })
end)