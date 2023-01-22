fx_version 'cerulean'
game 'gta5'
description 'UM-Admin'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

ui_page 'web/index.html'

client_scripts {
    'client/*.lua',
    'entityhashes/entity.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'checker/*.lua'
}

files {
    'web/index.html',
    'web/*.js',
    'web/*.css',
    'web/*.png',
    'web/*.jpg'
}

lua54 'yes'