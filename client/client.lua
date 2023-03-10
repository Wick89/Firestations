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
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
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
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
	OnDuty = false
end)


-----------------------------------------------
-- qb-target Sign In/Out --
-----------------------------------------------
RegisterNetEvent('LSFD:Duty', function()
	onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
	TriggerServerEvent("police:server:UpdateBlips")
	
	local value = GetConvar("firescript", "false")
    if value == "true" then
        TriggerServerEvent("fire:ToggleDuty")
    end
end)

CreateThread(function()
		--Sign In/Out --
		for i=1,#Config.Locations["Duty"] do
		exports['qb-target']:AddBoxZone("SignInOut"..i,Config.Locations["Duty"][i], 5, 5, {
			name = "SignInOut"..i,
			heading = 0,
			debugPoly = false,
			minZ = Config.Locations["Duty"][i].z -5,
			maxZ = Config.Locations["Duty"][i].z +5,
		}, {
			options = {
				{
					type = "Client",
					event = "LSFD:Duty",
					icon = "fas fa-sign-in-alt",
					label = 'Sign In/Out',
					job = Config.JobName,
				},
			},
			distance = 2
		})
	end
end)

-- stations blip
Citizen.CreateThread(function()
	for _, stationblip in pairs(Config.Locations["stations"]) do
		if Config.UseBlips then
            stationblip.blip = AddBlipForCoord(stationblip.coords.x, stationblip.coords.y, stationblip.coords.z)
	   		SetBlipSprite(stationblip.blip, stationblip.blipid)
	   		--SetBlipDisplay(stationblip.blip, 4)
	   		SetBlipScale(stationblip.blip, 0.4)	
	   		SetBlipColour(stationblip.blip, 0)
	   		SetBlipAsShortRange(stationblip.blip, true)
	   		BeginTextCommandSetBlipName("STRING")
	   		AddTextComponentString(stationblip.label)
	   		EndTextCommandSetBlipName(stationblip.blip)
	 	end
   	end	
end)