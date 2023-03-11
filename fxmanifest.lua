fx_version "adamant"
game "gta5"

author "(Wick)#5854"
description "FirefighterJob"
version '1.3'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/Client.lua',
    'client/VehiclesGarage.lua',
    'client/Tools.lua',
    'client/Turnout.lua',
    'client/pager.lua'
}

server_script 'server/server.lua'

-- NUI Default Page
ui_page "html/index.html"

--[[
files {
    'html/index.html',
    -- Begin Sound Files Here...
    -- html/sounds/ ... .ogg
    'html/sounds/*.mp3'
}
--]]
files {
	"html/index.html",
	"html/sounds/end.mp3",
	"html/sounds/vibrate.mp3",
	"html/sounds/siren1.mp3",
	"html/sounds/siren2.mp3",
	"html/sounds/siren3.mp3",
	"html/sounds/siren4.mp3",
	"html/sounds/cancel.mp3",

	"html/sounds/rescue.mp3",
	"html/sounds/medical.mp3",
	"html/sounds/fire.mp3",
	"html/sounds/other.mp3"
}


-- Export function
export { 
	"PagePagers",
	"SoundFireSiren"
}

lua54 'yes'