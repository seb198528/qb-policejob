fx_version 'cerulean'
game 'gta5'

author 'Dev RP'
description 'Police Job - ULTIMATE v5.0 (Walkie, HUD, K9, SWAT, Drone)'
version '5.0.0'

shared_script {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'shared/config.lua'
}

server_script 'server/main.lua'

client_scripts {
    'client/main.lua',
    'client/arrest.lua',
    'client/radar.lua',
    'client/camera.lua',
    'client/jail.lua',
    'client/radio.lua',
    'client/helicopter.lua',
    'client/patrol.lua',
    'client/bodycam.lua',
    'client/uniforms.lua',
    'client/k9.lua',
    'client/swat.lua',
    'client/walkie.lua'     -- ✅ Walkie-talkie
}

dependencies {
    'qb-core',
    'qb-menu',
    'qb-target',
    'qb-input',
    'ps-mdt',
    'qb-clothing',
    'qb-hud'
}