-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- ======================================================================
local QBCore = exports['qb-core']:GetCoreObject()

-----------------------------------------------
--              Tools                        --
-----------------------------------------------
RegisterNetEvent('qb-Firestations:Tools', function()
    local authorizedItems = {
        label = "Truck Tools",
        slots = 30,
        items = {}
    }
    local index = 1
    for _, FiresItem in pairs(Config.Items.items) do
        for i=1, #FiresItem.authorizedJobGrades do
            if FiresItem.authorizedJobGrades[i] == PlayerJob.grade.level then
                authorizedItems.items[index] = FiresItem
                authorizedItems.items[index].slot = index
                index = index + 1
            end
        end
    end
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "lsfd", authorizedItems)
end)

RegisterNetEvent('qb-Firestations:toolsmenu', function(data)
	local Menu = {
		{
			header = "👨‍🚒 | Tools Menu | 👨‍🚒",
			isMenuHeader = true
		},

		{
			header = "• Grab Attack Line",
			txt = "Water Variant",
			params = {
				event = "fire:hose",
				args = {}
			}
		},
		{
			header = "• Grab Attack Line Foam",
			txt = "Foam Variant",
			params = {
				event = "fire:foam",
				args = {}
			}
		},
		{
			header = "• Rescue Tools Menu",
			text = "Open Rescue Tools Menu",
			params = {
				event = "qb-Firestations:rescuetools",
				args = {}
			}
		}
	}
	exports['qb-menu']:openMenu(Menu)
end)


RegisterNetEvent('qb-Firestations:rescuetools', function(data)
	local MenuRescue = {
		{
			header = "👨‍🚒 | Rescue Menu | 👨‍🚒",
			isMenuHeader = true
		},
		-- Spreaders from FireTools
		{
			header = "• Spreaders",
			txt = "Grab & Retrieve Spreaders",
			params = {
				event = "Client:toggleSpreaders",
				args = {}
			}
		},
		-- Truck Tools
		{
			header = "• Truck Tools",
			txt = "Grab & Retrieve Tools",
			params = {
				event = "qb-Firestations:Tools",
				args = {}
			}
		},
	}
	exports['qb-menu']:openMenu(MenuRescue)
end)




-----------------------------------------------
-- Item that can be added in the locker room --
-----------------------------------------------
RegisterNetEvent('Firestations:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "firestash_"..QBCore.Functions.GetPlayerData().citizenid)
    TriggerEvent("inventory:client:SetCurrentStash", "firestash_"..QBCore.Functions.GetPlayerData().citizenid)
end)

-----------------------------------------------
--              stash                        --
-----------------------------------------------
RegisterNetEvent('qb-Firestations:stash', function(data)
    exports['qb-menu']:openMenu({
        {
            isMenuHeader = true, 
            header = "👨‍🚒| stash Stock | 👨‍🚒",
        },
        {
            
            header = "• Get Tools",
            txt = "Get some yummy Tools to use!",
            params = {
                event = "qb-Firestations:Tools"
            }
        },
		{
            
            header = "• Storage",
            txt = "see Storage",
            params = {
                event = "Firestations:stash"
            }
        },
        {
            isMenuHeader = true, 
            header = "Close (ESC)",
        },
    })
end)


CreateThread(function()
	--Shop/stash --
	for i=1,#Config.Locations["stash"] do
		exports['qb-target']:AddBoxZone("Shopstash"..i,Config.Locations["stash"][i], 5, 5, {
			name = "Shopstash"..i,
			heading = 0,
			debugPoly = false,
			minZ = Config.Locations["stash"][i].z -5,
			maxZ = Config.Locations["stash"][i].z +5,
		}, {
			options = {
				{
					type = "Client",
					event = "qb-Firestations:stash",
					icon = "fas	fa-bolt",
					label = 'Fire Stash',
					job = Config.JobName,
				},
			},
			distance = 2
		})
	end
	---toolsmenu in Vehicles--
		exports['qb-target']:AddTargetModel(Config.Vehicles, {
  			options = {
			{ 
				type = "client",
				event = "qb-Firestations:toolsmenu",
				icon = "fas fa-fire-extinguisher",
				label = "FireFighter Menu",
				job = Config.JobName,
			},
			{ 
				type = "client",
				event = "qb-Firestations:turnoutMenu",
				icon = "fas fa-fire-extinguisher",
				label = "Turnout Gear",
				job = Config.JobName,
			}
		},
  		distance = 2.5,
	})
end)