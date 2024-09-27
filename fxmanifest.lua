fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

name 'interaction'
author '4rkh4m'
version '0.1.0'
repository ''
description 'Simple interaction system for FiveM with RayCasting'

dependencies {
    'ox_lib',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

server_scripts {
    'server/init.lua'
}

client_script 'client/init.lua'

files {
    'locales/*.json',
    'client/*.lua',
}

ox_libs {
    'raycast',
    'locale',
}
