-- ==========================FireFighter Job==========================
-- ===============================By Wick===============================
-- =================================pager=================================
-- ======================================================================

local FireSirens = {}

RegisterServerEvent("qb-Firestations:StoreSiren")
AddEventHandler("qb-Firestations:StoreSiren", function(Station)
	if not FireSirens[Station.Name:lower()] then
		FireSirens[Station.Name:lower()] = Station
		FireSirens[Station.Name:lower()].ID = source

		TriggerClientEvent("qb-Firestations:Bounce:ServerValues", -1, FireSirens)
	end
end)

RegisterServerEvent("qb-Firestations:RemoveSiren")
AddEventHandler("qb-Firestations:RemoveSiren", function(StationName)
	if FireSirens[StationName] then
		FireSirens[StationName] = nil
	end
end)

-- Plays tones on all clients
RegisterServerEvent("qb-Firestations:PageTones")
AddEventHandler("qb-Firestations:PageTones", function(Tones, HasDetails, Details)
	TriggerClientEvent("qb-Firestations:PlayTones", -1, Tones, HasDetails, Details)
end)

-- Plays cancel sound on all clients
RegisterServerEvent("qb-Firestations:CancelPage")
AddEventHandler("qb-Firestations:CancelPage", function(Tones, HasDetails, Details)
	TriggerClientEvent("qb-Firestations:CancelPage", -1, Tones, HasDetails, Details)
end)

-- Play fire siren on all clients
RegisterServerEvent("qb-Firestations:SoundSirens")
AddEventHandler("qb-Firestations:SoundSirens", function()
	TriggerClientEvent("qb-Firestations:PlaySirens", -1)
end)