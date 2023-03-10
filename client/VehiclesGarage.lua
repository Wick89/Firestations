-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- ======================================================================
local QBCore = exports['qb-core']:GetCoreObject()


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
        exports[Config.FuelSystem]:SetFuel(veh, 100.0)
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
	for k, station in pairs(Config.Locations["stations"]) do
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
					spawn = station.spawn
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