-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- ======================================================================
Config = {}

Config.Locales = {
    ["VehicleStored"] = "Vehicle Stored!",
    ["Invalidtones"] = "Invalid tones, please check your pagers",
    ["SoundSirens"] = "Invalid stations to sound, check your command arguments",
    ["turnedoff"] = "pager was turned off",
    ["Cancel"] = "pager was cancel",
    ["whitelisted"] = "You are not whitelisted to this command",
    ["pagerset"] = "pager set to:",
    ["examined"] = "Tones are being examined, please wait",
    ["searched"] = "Toner has already been searched",
    ["search"] = "search",
    ["supplied"] = "One or more supplied stations are already sounding!",
}

-- Job name that you use qb -- "ambulance"
Config.JobName = "ambulance"

-- is you use my Blips set it to true or false
Config.UseBlips = true

-- Put here your fuel system LegacyFuel by default
Config.FuelSystem = "cdn-fuel"

-- Config of vehicles players can interact with
Config.Vehicles = {
    "firetruk",
	"fireone",
    "velocityeng",
    "qrescue",
    "pengine"
}
-- Authorized Vehicles Rank
Config.AuthorizedVehicles = {
	-- Recruit
	[0] = {
		["e450b"] = "AMBULAN",
	},
	-- Paramedic
	[1] = {
		["e450b"] = "E450b",
        ["3500hdambo"] = "3500H",
	},
	-- Doctor
	[2] = {
		["e450b"] = "AMBULAN",
        ["3500hdambo"] = "AMBULAN",
        ["ems2020fpiu"] = "EMS 2020",
	},
	-- Surgeon
	[3] = {
        ["ems2020fpiu"] = "EMS 2020",
        ["unraptor17bb"] = "UnRaptor",
        ["lsfdfpiu"] = "Fire chief",
	},
	-- EMS Chief
	[4] = {
        ["e450b"] = "AMBULAN",
        ["3500hdambo"] = "AMBULAN",
        ["unraptor17bb"] = "UnRaptor",
        ["ems2020fpiu"] = "EMS chief",
        ["lsfdfpiu"] = "Fire chief",

	},
    -- Firefighter
    [5] = {
        ["fireone"] = "Engine 1",
        ["velocityeng"] = "Engine 2",
        ["pengine"] = "Engine 3",
    },
    -- Sergeant
    [6] = { 
        ["fireone"] = "Engine 1",
        ["velocityeng"] = "Engine 2",
		["pengine"] = "Engine 3",
        ["axtladder"] = "Ladder 1",
        ["qrescue"] = "qrescue",
    },
    -- Lieutenant    
    [7] = {
        ["fireone"] = "Engine 1",
        ["velocityeng"] = "Engine 2",
		["pengine"] = "Engine 3",
        ["axtladder"] = "Ladder 1",
		["qrescue"] = "qrescue",
        ["firesilv17"] = "Battalion",    
    }, 
    -- Fire Chief    
    [8] = {   
        ["fireone"] = "Engine 1",
        ["velocityeng"] = "Engine 2",
		["pengine"] = "Engine 3",
        ["axtladder"] = "Ladder 1",
		["qrescue"] = "qrescue",
        ["ems2020fpiu"] = "EMS chief",
        ["lsfdfpiu"] = "Fire chief",
    },      
}

Config.turnout = {
    ['suitpants'] = {
        item = 158,
        texture = 0
    },
    ['scba'] = {
        item = 173,
        texture = 0
    },
    ['suittop'] = {
        item = 423,
        texture = 0
    },
    ['suitmask'] = {
        item = 58,
        texture = 0
    },
    ['suitshoes'] = {
        item = 22,
        texture = 0
    },
    ['arms'] = {
        item = 170,
        texture = 3
    },
}

Config.Locations = {
    ["stations"] = {
        -- Rockford Station
        {
            coords = vector4(-633.8, -101.22, 38.05, 114.82),
            spawn = vector4(-645.96, -112.16, 37.9, 118.87),
            -- stations blip
            label = "Fire Dept 1", 
            blipid = 686,
        },
        -- Sandy
        {
            coords = vector4(1681.43, 3596.74, 36.48, 212.09),
            spawn = vector4(1693.86, 3590.73, 36.53, 215.63),
           -- stations blip
            label = "Fire Dept 32", 
            blipid = 717,
        },
        -- Davis Fire DEPT
        {
            coords = vector4(219.39, -1651.29, 29.82, 159.25),
            spawn = vector4(202.75, -1676.46, 29.8, 49.09),
            -- stations blip
            label = "Davis Fire Dept 18", 
            blipid = 703,
        },
        -- Pillbox
        {
            coords = vector4(338.05, -586.37, 28.8, 60.02),
            spawn = vector4(326.71, -572.47, 28.8, 330.76),
            -- stations are in Pillbox<!
            --blipid = 47,
        },
        -- Fire Dept 7
        {
            coords = vector4(1193.38, -1495.59, 34.84, 268.58),
            spawn = vector4(1197.02, -1506.51, 34.69, 87.45),
            -- stations blip
            label = "Fire Dept 7",
            blipid = 692,
        },
    },
    ["Duty"] = { 
        -- Pillbox
        vector3(307.56, -595.23, 43.28),
    },
    
    ["stash"] = { 
        -- Rockford Station
        vector3(-625.01, -111.28, 45.5),
    },  
}

Config.Items = {
    label = "Truck Tools",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_fireextinguisher",
            price = 0,
            amount = 2,
            info = { },
            type = "item",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
        },
        [2] = {
            name = "weapon_wrench",
            price = 0,
            amount = 2,
            info = { },
            type = "weapon",
            slot = 2,
            authorizedJobGrades = {5, 6, 7, 8}
        },
        [3] = {
            name = "firstaid",
            price = 0,
            amount = 6,
            info = { },
            type = "item",
            slot = 3,
            authorizedJobGrades = {1, 2, 3, 4, 5, 6, 7, 8, 9}
        },
        [4] = {
            name = "stabilisers",
            price = 0,
            amount = 5,
            info = { },
            type = "item",
            slot = 4,
            authorizedJobGrades = {5, 6, 7, 8}
        },
        [5] = {
            name = "fan",
            price = 0,
            amount = 2,
            info = { },
            type = "item",
            slot = 5,
            authorizedJobGrades = {5, 6, 7, 8}
        },
    }
}