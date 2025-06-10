fx_version 'cerulean'
game 'gta5'

description 'Mystery Phone Calls - Cross Framework & Phone Compatible'
author 'Smokey'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'utils.lua',
    'version_check.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

lua54 'yes'
