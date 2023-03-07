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
				event = "firejob:hose",
				args = {}
			}
		},
		{
			header = "• Grab Attack Line Foam",
			txt = "Foam Variant",
			params = {
				event = "firejob:foam",
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
            
            header = "| stash Stock |",
            isMenuHeader = true, 
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
            
            header = "Close (ESC)",
            isMenuHeader = true, 
        },
    })
end)

-----------------------------------------------
--              Garage                       --
-----------------------------------------------

function MenuGarage(currentSelection)
    local vehicleMenu = {
        {
            header = "🚒 | Fire Vehicles | 🚒",
            isMenuHeader = true,
            icon = "fas fa-warehouse",
        }
    }

    local authorizedVehicles = Config.AuthorizedVehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(authorizedVehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = label,
            icon = "fa-solid fa-car",
            txt = "",
            params = {
                event = "qb-Firestations:Takecar",
                args = {
                    vehicle = veh,
                    currentSelection = currentSelection
                }
            }
        }
    end

    vehicleMenu[#vehicleMenu+1] = {
        header = "Close (ESC)",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

RegisterNetEvent("qb-Firestations:VehicleMenuHeader", function (data)
    MenuGarage(data.spawn)
end)

--New garage
RegisterNetEvent("qb-Firestations:Takecar", function(data)
    local VehicleSpawnCoord = data.currentSelection	
    QBCore.Functions.SpawnVehicle(data.vehicle, function(veh)
	
        local plate = "LSFD" .. math.random(1111, 5555)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, VehicleSpawnCoord.w)
        exports[Config.fuel]:SetFuel(veh, 100.0)
		--TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
    end, vector3(VehicleSpawnCoord.x, VehicleSpawnCoord.y, VehicleSpawnCoord.z), true)
end)

RegisterNetEvent('qb-Firestations:storecar', function()
    QBCore.Functions.Notify(Config.Locales['VehicleStored'], "success")
	local ped = PlayerPedId()
    local car = GetVehiclePedIsIn(ped, true)
    NetworkFadeOutEntity(car, true,false)
	TaskLeaveVehicle(ped, car, 1)
    Citizen.Wait(2000)
    QBCore.Functions.DeleteVehicle(car)
end)

 -- NPC
 CreateThread(function()
	QBCore.Functions.LoadModel('csb_trafficwarden')
	while not HasModelLoaded('csb_trafficwarden') do
		Wait(100)
	end
	for k, station in pairs(Config.Locations["vehicleped"]) do
		customped = CreatePed(0, 'csb_trafficwarden', station.coords.x, station.coords.y, station.coords.z-1.0, station.coords.w, false, true)
		TaskStartScenarioInPlace(customped, true)
		FreezeEntityPosition(customped, true)
		SetEntityInvincible(customped, true)
		SetBlockingOfNonTemporaryEvents(customped, true)
		TaskStartScenarioInPlace(customped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
		exports['qb-target']:AddTargetEntity(customped, {
		options = {
				{
					icon = 'fa-solid fa-warehouse',
					label = 'Open Garage',
					type = "client",
					event = "qb-Firestations:VehicleMenuHeader",
					job = Config.JobName,
					spawn = v.spawn
				},
				{
					icon = 'fa-solid fa-car',
					label = 'Store Vehicle',
					type = "client",
					event  = "qb-Firestations:storecar",
					job = Config.JobName,
				}
			},
			distance = 2.5
		})
	end
end)