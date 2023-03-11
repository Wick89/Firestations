-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- =================================pager=================================
-- ======================================================================
local QBCore = exports['qb-core']:GetCoreObject()

-- Do not edit this line
local config = {} 
config.DisableAllMessages = false
config.ChatSuggestions = true
config.Reminder = true
config.PageSep = "-"
config.DeptName = "Los Santos Fire"
config.DefaultDetails = "Report to the Fire Station"
config.WaitTime = 7500

config.Tones = {"medical", "rescue", "fire", "other"}
config.Stations = {} -- Do not edit this line
table.insert(config.Stations, {Name = "pb", Loc = vector3(-379.53, 6118.32, 31.85), Radius = 800, Siren = "siren1"}) -- Paleto Bay
table.insert(config.Stations, {Name = "fz", Loc = vector3(-2095.92, 2830.22, 32.96), Radius = 1000, Siren = "siren2"}) -- Fort Zancudo
table.insert(config.Stations, {Name = "ss", Loc = vector3(1691.24, 3585.83, 35.62), Radius = 500, Siren = "siren1"}) -- Sandy Shores
table.insert(config.Stations, {Name = "rh", Loc = vector3(-635.09, -124.29, 39.01), Radius = 60, Siren = "siren3"}) -- Rockford Hills
table.insert(config.Stations, {Name = "els", Loc = vector3(1193.42, -1473.72, 34.86), Radius = 80, Siren = "siren4"}) -- East Los Santos
table.insert(config.Stations, {Name = "sls", Loc = vector3(199.83, -1643.38, 29.8), Radius = 80, Siren = "siren4"}) -- South Los Santos
table.insert(config.Stations, {Name = "dpb", Loc = vector3(-1183.13, -1773.91, 4.05), Radius = 400, Siren = "siren1"}) -- Del Perro Beach
table.insert(config.Stations, {Name = "lsia", Loc = vector3(-1068.74, -2379.96, 14.05), Radius = 500, Siren = "siren2"}) -- LSIA

-- Local Pager Variables
local Pager = {}
-- Is the client's local pager enabled
Pager.Enabled = false
-- Are all clients currently being paged
Pager.Paging = false
-- What the client's local pager is tuned to
Pager.TunedTo = {}
-- How long to wait between tones being played
Pager.WaitTime = config.WaitTime
-- List of tones that can be paged
Pager.Tones = config.Tones

-- Local Fire Siren Variables
local FireSiren = {}
-- Stations that currently have a fire siren being played
FireSiren.EnabledStations = {}
-- Fire Station Variables
FireSiren.Stations = config.Stations

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		PlayerData = QBCore.Functions.GetPlayerData()
		PlayerJob = QBCore.Functions.GetPlayerData().job
	end
end)

--================================--
--              CHAT              --
--================================--
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	local player = QBCore.Functions.GetPlayerData()
	PlayerJob = player.job
	if PlayerJob or PlayerJob.name == Config.JobName then
		-- Create a temporary variables to add more text to
		local ValidTones = "Valid tones:"
		local ValidStations = "Valid stations:"

		-- Loop though all the tones
		for _, Tone in ipairs(Pager.Tones) do
			-- Add a tone to temporary string
			ValidTones = ValidTones .. " " .. Tone
		end

		-- Loop though all the stations
		for _, Station in ipairs(FireSiren.Stations) do
			-- Add a station to temporary string
			ValidStations = ValidStations .. " " .. Station.Name
		end

		TriggerEvent("chat:addSuggestion", "/pager", "From already set, pager turns off. From the pager is turned on, enter tones to set to, or if already set, tones to set to. Put a space between each note.", {
			{ name = "tone", help = ValidTones }
		})

		TriggerEvent("chat:addSuggestion", "/page", "If there are currently no other tones, tones are entered. Put a space between each note.", {
			{ name = "tones", help = ValidTones },
			{ name = "- call details", help = "To add optional details, add a space after the last note, then one '-', then another space and then your details. For example: /page fire or medical - Your details go here" }
		})

		TriggerEvent("chat:addSuggestion", "/cancelpage", "Plays the cancel tone of selected tones and shows notification ignition.", {
			{ name = "tones", help = ValidTones },
			{ name = "- disregard details", help = "To add optional ignorance of details, add a space after the last note, then one '-', hen another space and then your details. For example: /cancelpage fire or medical - Your Ignore Details Go here" }
		})

		TriggerEvent("chat:addSuggestion", "/firesiren", "If there are currently no other sirens, the fire siren will sound at the entered stations. Put a space between each station", {
			{ name = "stations", help = ValidStations }
		})

		TriggerEvent("chat:addSuggestion", "/pagerwhitelist", "Add or reload the whitelist command.", {
			{ name = "{reload} or {player hex/server id}", help = "Type 'reload' to reload whitelist, or if you add to whitelist, type player's steam hex, or set player's server ID from player list." },
			{ name = "commands", help = "List all the commands you want this person to access."}
		})
	end	
	-- Adds page command chat template, including pager icon
	TriggerEvent("chat:addTemplate", "page", "<img src='data:image/gif;base64,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' height='16'> <b>{0}</b>: {1}")
end)

-- /pager command
-- Used to enable and disable pager, and set tones to be tuned to
RegisterCommand("pager", function(Source, Args)
	local player = QBCore.Functions.GetPlayerData()
	PlayerJob = player.job
	if PlayerJob or PlayerJob.name == Config.JobName then
		function EnablePager()
			for _, ProvidedTone in ipairs(Args) do
				for _, ValidTone in ipairs(Pager.Tones) do
					if ProvidedTone:lower() == ValidTone then
						table.insert(Pager.TunedTo, ValidTone)
					end
				end
			end

			if not #Args ~= #Pager.TunedTo and #Args ~= 0 then

				for _, Tone in ipairs(Pager.TunedTo) do
					QBCore.Functions.Notify(Config.Locales['pagerset'].. " " .. Tone:upper(), "success")
				end
				
				QBCore.Functions.Notify(Config.Locales['pagerset'], false, "success")
				Pager.Enabled = true
			else
				QBCore.Functions.Notify(Config.Locales['Invalidtones'], true, "success")
				Pager.Enabled = false
				Pager.TunedTo = {}
			end
		end

		if not Pager.Enabled then
			EnablePager()
		else

			if #Args ~= 0 then
				Pager.TunedTo = {}
				EnablePager()
			else
				QBCore.Functions.Notify(Config.Locales['turnedoff'], false, "success")
				Pager.Enabled = false
				Pager.TunedTo = {}
			end
		end
		-- If player is not whitelisted
	else
		QBCore.Functions.Notify(Config.Locales['whitelisted'], true, "success")
	end
end)

-- Used to page out a tone/s
RegisterCommand("page", function(Source, Args)
	local player = QBCore.Functions.GetPlayerData()
	PlayerJob = player.job
	if PlayerJob or PlayerJob.name == Config.JobName then
		PagePagers(Args)
	end
end)

-- Used to play a fire siren at a specific station/s
RegisterCommand("firesiren", function(Source, Args)
	local player = QBCore.Functions.GetPlayerData()
	PlayerJob = player.job
	if PlayerJob or PlayerJob.name == Config.JobName then
		SoundFireSiren(Args)
	end	
end)

-- /cancelpage command
-- Used to play a sound to signal a canceled call
RegisterCommand("cancelpage", function(Source, Args)
	local ToneCount = 0
	local HasDetails = false
	local ToBeCanceled = {}

	if PlayerJob or PlayerJob.name == Config.JobName then
		if not Pager.Paging then
			for _, ProvidedTone in ipairs(Args) do
				for _, ValidTone in ipairs(Pager.Tones) do
					if ProvidedTone:lower() == ValidTone then
						table.insert(ToBeCanceled, ValidTone)
						break

					elseif ProvidedTone:lower() == Config.PageSep then
						HasDetails = true
						for _ = ToneCount + 1, 1, -1 do
							-- Remove tones from arguments to leave details
							table.remove(Args, 1)
						end

						break
					end
				end

				if HasDetails then
					break
				end

				ToneCount = ToneCount + 1
			end

			if not ToneCount ~= #ToBeCanceled and ToneCount ~= 0 then
				for _, Tone in ipairs(ToBeCanceled) do
					QBCore.Functions.Notify(Config.Locales['Cancel'].. " " .. Tone:upper(), "success")
				end
					QBCore.Functions.Notify(Config.Locales['Cancel'], false, "success")
				TriggerServerEvent("qb-Firestations:CancelPage", ToBeCanceled, HasDetails, Args)

			else
				QBCore.Functions.Notify(Config.Locales['Invalidtones'], true, "success")
			end

		else

			QBCore.Functions.Notify(Config.Locales['examined'], true, "success")
		end
	-- If player is not whitelisted
	else
		QBCore.Functions.Notify(Config.Locales['whitelisted'], true, "success")
	end
end)

-- Plays tones on the client
RegisterNetEvent("qb-Firestations:PlayTones")
AddEventHandler("qb-Firestations:PlayTones", function(Tones, HasDetails, Details)
	local NeedToPlay = false
	local Tuned
	Pager.Paging = true

	if Pager.Enabled then
		for _, Tone in ipairs(Tones) do
			for _, TunedTone in ipairs(Pager.TunedTo) do
				if Tone == TunedTone then
					NeedToPlay = true
				end
			end
		end

		if NeedToPlay then
			Citizen.Wait(1500)
			for _, Tone in ipairs(Tones) do
				Tuned = false
				for _, TunedTone in ipairs(Pager.TunedTo) do
					if Tone == TunedTone then
						Tuned = true
					end
				end

				if Tuned then
					TriggerEvent("qb-Firestations:Bounce:NUI", "PlayTone", "vibrate")

				-- If player is not tuned to it
				QBCore.Functions.Notify(Config.Locales['Reports'].. " " .. Tone:upper(), "success")
				else
					TriggerEvent("qb-Firestations:Bounce:NUI", "PlayTone", Tone)
				end
				Citizen.Wait(Pager.WaitTime)
			end

			TriggerEvent("qb-Firestations:Bounce:NUI", "PlayTone", "end")

			local Hours = GetClockHours()
			local Minutes = GetClockMinutes()

			if Hours <= 9 then
				Hours = "0" .. tostring(Hours)
			end

			if Minutes <= 9 then
				Minutes = "0" .. tostring(Minutes)
			end

			if HasDetails then
				local NewDetails = ""
				local NewTones = ""

				for _, l in ipairs(Details) do
					NewDetails = NewDetails .. " " .. l
				end
				NewDetails = NewDetails:gsub("^%l", string.upper)

				for _, Tone in ipairs(Tones) do
					NewTones = NewTones .. Tone:gsub("^%l", string.upper) .. " "
				end

				TriggerEvent("chat:addMessage", {
					templateId = "page",
					-- Red
					color = { 255, 0, 0},
					multiline = true,
					args = {"Fire control", "\nAttention " .. config.DeptName .. " - " .. NewDetails .. " - " .. NewTones .. "Emergency.\n\nTime out " .. Hours .. Minutes.. "."}
				})
			else
				TriggerEvent("chat:addMessage", {
					templateId = "page",
					-- Red
					color = { 255, 0, 0},
					multiline = true,
					args = {"Fire control", "\nAttention " .. config.DeptName .. " - " .. config.DefaultDetails .. ".\n\nTime out " .. Hours .. Minutes.. "."}
				})
			end
		else
			for _, _ in ipairs(Tones) do
				Citizen.Wait(Pager.WaitTime)
			end

			Citizen.Wait(1500)
		end
	else
		for _, _ in ipairs(Tones) do
			Citizen.Wait(Pager.WaitTime)
		end
	end

	Citizen.Wait(3000)
	Pager.Paging = false
end)

-- Play fire sirens
RegisterNetEvent("qb-Firestations:PlaySirens")
AddEventHandler("qb-Firestations:PlaySirens", function()
	for _, Station in pairs(FireSiren.EnabledStations) do
		TriggerEvent("qb-Firestations:Bounce:NUI", "PlaySiren", {Station.Name, Station.ID, Station.Siren})
	end
end)

-- Plays cancelpage sound on the client
RegisterNetEvent("qb-Firestations:CancelPage")
AddEventHandler("qb-Firestations:CancelPage", function(Tones, HasDetails, Details)
	local NeedToPlay = false
	Pager.Paging = true

	if Pager.Enabled then
		for _, Tone in ipairs(Tones) do
			for _, TunedTone in ipairs(Pager.TunedTo) do
				if Tone == TunedTone then
					NeedToPlay = true
				end
			end
		end

		-- If the player is tuned to one or more of the tones being paged
		if NeedToPlay then
			NewNoti("~g~~h~Your pager is activated!", true)
			Citizen.Wait(1500)

			TriggerEvent("qb-Firestations:Bounce:NUI", "PlayTone", "cancel")

			if HasDetails then
				local NewDetails = ""

				for _, l in ipairs(Details) do
					NewDetails = NewDetails .. " " .. l
				end
				-- Capitalise first letter
				NewDetails = NewDetails:gsub("^%l", string.upper)

				-- Send message to chat, only people tuned to specified tones can see the message
				TriggerEvent("chat:addMessage", {
					templateId = "page",
					-- Red
					color = { 255, 0, 0},
					multiline = true,
					args = {"Fire control", "\nAttention " .. config.DeptName .. " - Call canceled, ignore the answer - " .. NewDetails}
				})
			-- If no details provided
			else
				-- Send message to chat, only people tuned to specified tones can see the message
				TriggerEvent("chat:addMessage", {
					templateId = "page",
					-- Red
					color = { 255, 0, 0},
					multiline = true,
					args = {"Fire control", "\nAttention " .. config.DeptName .. " - Call canceled, ignore the answer."}
				})
			end
		else
			Citizen.Wait(1500)
		end
	else
		Citizen.Wait(1500)
	end

	Citizen.Wait(3500)
	Pager.Paging = false
end)

RegisterNUICallback("RemoveSiren", function(Station)
	-- If the client is the owner of this fire siren, remove fire siren
	-- This check is done so only one event is sent to the server instead of 32+
	if GetPlayerServerId(PlayerId()) == Station.ID then
		TriggerServerEvent("qb-Firestations:RemoveSiren", Station.Name)
	end

	FireSiren.EnabledStations[Station.Name] = nil
end)

RegisterNetEvent("qb-Firestations:Bounce:ServerValues")
AddEventHandler("qb-Firestations:Bounce:ServerValues", function(Sirens) FireSiren.EnabledStations = Sirens end)

RegisterNetEvent("qb-Firestations:Bounce:NUI")
AddEventHandler("qb-Firestations:Bounce:NUI", function(Type, Load)
	SendNUIMessage({
		PayloadType	= Type,
		Payload		= Load
	})
end)

-- Used to page out a tone/s
function PagePagers(Args)
    local ToneCount = 0
    local HasDetails = false
    local ToBePaged = {}
	local player = QBCore.Functions.GetPlayerData()
	PlayerJob = player.job
	
	if PlayerJob or PlayerJob.name == Config.JobName then
        if not Pager.Paging then
            for _, ProvidedTone in ipairs(Args) do
                for _, ValidTone in ipairs(Pager.Tones) do
                    if ProvidedTone:lower() == ValidTone then
                        table.insert(ToBePaged, ValidTone)
                        break
                    elseif ProvidedTone:lower() == config.PageSep then
                        HasDetails = true
                        for _ = ToneCount + 1, 1, -1 do
                            table.remove(Args, 1)
                        end
                        -- Break from loop
                        break
                    end
                end
                -- If a break is needed
                if HasDetails then
                    -- Break from loop
                    break
                end
                ToneCount = ToneCount + 1
            end

            if not ToneCount ~= #ToBePaged and ToneCount ~= 0 then
                for _, Tone in ipairs(ToBePaged) do
					QBCore.Functions.Notify(Config.Locales['search'].. " " .. Tone:upper(), "success")
                end
				QBCore.Functions.Notify(Config.Locales['search'], false, "success")
                TriggerServerEvent("qb-Firestations:PageTones", ToBePaged, HasDetails, Args)
            else
				QBCore.Functions.Notify(Config.Locales['Invalidtones'], true, "success")
            end

        else
			QBCore.Functions.Notify(Config.Locales['searched'], true, "success")
        end
    -- If player is not whitelisted
    else
		QBCore.Functions.Notify(Config.Locales['whitelisted'], true, "success")
    end
end

function SoundFireSiren(Args)
	local ToBeSirened = {}
	for _, ProvidedStation in ipairs(Args) do
		for _, ValidStation in ipairs(FireSiren.Stations) do
			if ProvidedStation:lower() == ValidStation.Name then
				if not FireSiren.EnabledStations[ProvidedStation:lower()] then
					ValidStation.x, ValidStation.y, ValidStation.z = table.unpack(ValidStation.Loc)
					table.insert(ToBeSirened, ValidStation)
					-- Station is already playing a siren
				else
					QBCore.Functions.Notify(Config.Locales['supplied'], true, "success")
					return
				end
			end
		end
	end

	if not #Args ~= #ToBeSirened and #Args ~= 0 then
		for _, Station in ipairs(ToBeSirened) do
			TriggerServerEvent("qb-Firestations:StoreSiren", Station)
				
		end
		Citizen.Wait(2000)
		TriggerServerEvent("qb-Firestations:SoundSirens", ToBeSirened)
	else
		QBCore.Functions.Notify(Config.Locales['SoundSirens'], true, "success")
	end
end

-- Volume loop
-- Sets the volumes of all active fire sirens
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local FireSirenCount = 0
		for _, _ in pairs(FireSiren.EnabledStations) do FireSirenCount = FireSirenCount + 1 end

		if FireSirenCount >= 1 then
			local PlayerPed = PlayerPedId()
			local PlayerCoords = GetEntityCoords(PlayerPed, false)

			for _, Station in pairs(FireSiren.EnabledStations) do
				local Distance = Vdist(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Station.x, Station.y, Station.z) + 0.01 -- Stops divide by 0 errors
				if (Distance <= Station.Radius) then

					local SirenVolume = 1 - (Distance / Station.Radius)
					if IsPedInAnyVehicle(PlayerPedId(), false) then
						local VC = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()), false)
						-- If vehicle is not a motobike or a bicycle
						if VC ~= 8 or VC ~= 13 then
							-- Lower the alarm volume by 45%
							SirenVolume = SirenVolume * 0.45
						end
					end

					TriggerEvent("qb-Firestations:Bounce:NUI", "SetSirenVolume", {Station.Name, SirenVolume})
				else
					TriggerEvent("qb-Firestations:Bounce:NUI", "SetSirenVolume", {Station.Name, 0})
				end
			end
		end

	end
end)
