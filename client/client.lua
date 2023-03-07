-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- ======================================================================
local QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = {}
OnDuty = false


-- onResourceStart
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

------------------------
-- Job Check --
------------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local player = QBCore.Functions.GetPlayerData()
    PlayerJob = player.job
    onDuty = player.job.onduty
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	if JobInfo.name == Config.JobName then
		if PlayerJob.onduty then
			TriggerServerEvent("QBCore:ToggleDuty")
			OnDuty = false
		end
	end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
	OnDuty = false
end)


-----------------------------------------------
-- qb-target Sign In/Out --
-----------------------------------------------
RegisterNetEvent('Toggle:LSFDDuty')
AddEventHandler('Toggle:LSFDDuty', function()
	onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
	if (GetCurrentResourceName() ~= firescript) then
		TriggerServerEvent("fire:ToggleDuty")
	end
end)


CreateThread(function()
		--Sign In/Out --
		for i=1,#Config.Locations["Sign"] do
		exports['qb-target']:AddBoxZone("SignInOut"..i,Config.Locations["Sign"][i], 5, 5, {
			name = "SignInOut"..i,
			heading = 0,
			debugPoly = false,
			minZ = Config.Locations["Sign"][i].z -5,
			maxZ = Config.Locations["Sign"][i].z +5,
		}, {
			options = {
				{
					type = "Client",
					event = "Toggle:LSFDDuty",
					icon = "fas fa-sign-in-alt",
					label = 'Sign In/Out',
					job = Config.JobName,
				},
			},
			distance = 2
		})
	end
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
		---toolsmenu--
		exports['qb-target']:AddTargetBone(Config.Vehicles, { 
  			options = {
			{ 
				type = "client",
				event = "qb-Firestations:toolsmenu",
				icon = "fas fa-fire-extinguisher",
				label = "FireFighter Menu",
				job = Config.JobName,
			}
		},
  		distance = 2.5,
	})

end)


-- stations blip

Citizen.CreateThread(function()
    for k, station1 in pairs(Config.Locations["stations1"]) do
        local blip = AddBlipForCoord(station1.coords.x, station1.coords.y, station1.coords.z)
        SetBlipSprite(blip, 686)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.4)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.label)
        EndTextCommandSetBlipName(blip)
    end

    for k, station7 in pairs(Config.Locations["stations7"]) do
        local blip = AddBlipForCoord(station7.coords.x, station7.coords.y, station7.coords.z)
        SetBlipSprite(blip, 692)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.4)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station7.label)
        EndTextCommandSetBlipName(blip)
    end

    for k, station32 in pairs(Config.Locations["stations32"]) do
        local blip = AddBlipForCoord(station32.coords.x, station32.coords.y, station32.coords.z)
        SetBlipSprite(blip, 717)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.4)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station32.label)
        EndTextCommandSetBlipName(blip)
    end

    for k, station18 in pairs(Config.Locations["stations18"]) do
        local blip = AddBlipForCoord(station18.coords.x, station18.coords.y, station18.coords.z)
        SetBlipSprite(blip, 703)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.4)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station18.label)
        EndTextCommandSetBlipName(blip)
    end
end)
