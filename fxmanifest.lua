fx_version "adamant"
game "gta5"

author "(Wick)#5854"
description "FirefighterJob"
version '1.1'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/Client.lua',
    'client/VehiclesGarage.lua',
    'client/Tools.lua',
    'client/Turnout.lua'
}

server_script 'server/server.lua'

lua54 'yes'