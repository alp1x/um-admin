local QBCore = exports['qb-core']:GetCoreObject()

local Webhooks = {
    --- Self
    ['noclip'] = '',
    ['godmode'] = '',
    ['vehicle'] = '',
    ['revive'] = '',
    ['invisible'] = '',
    ['other'] = '',

    --- Players
    ["kill"] = 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["revivep"] = 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["freeze"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["spectate"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["gotobring"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["intovehicle"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["inventory"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["clothing"]= 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["perms"] = 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["givemoney"] = 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',
    ["setmodel"] = 'https://discord.com/api/webhooks/1082296088033230879/-rOe1P7eFQaa5q3Nl_tWI-MMTrT1OyOp6TGw1dHlBnjrMEWuPVflzBHqn_-t0FgXbaga',

    --- Ban or Kick or Cheater
    ['kick'] = '',
    ['ban'] = '',
    ['cheater'] = '',

}

local Colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ["lightgreen"] = 65309,
}

local function postWebHook(name, title, color, message, tagEveryone)
    local tag = tagEveryone or false
    local webHook = Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'UM - Admin [Logs]',
                ['icon_url'] = 'https://cdn.discordapp.com/attachments/781483089264115712/1067103262089695232/logo_kopya.png',
            },
        }
    }
    PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'UM - Admin [Logs]', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Wait(100)
    if tag then
        PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'UM - Admin [Logs]', content = '@everyone'}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterNetEvent('um-admin:log:minPage', function(webhook,event,color)
    local src = source
    postWebHook(webhook,event.." used",color,"**---------------------------------------------------------------**".."\n **ID:** `[" ..src.. "]`".."\n **CID:** `"..QBCore.Functions.GetPlayer(src).PlayerData.citizenid.. "`".. "\n **Player Name:** `"..GetPlayerName(src).. "`".. "\n **Discord:** " .."`"..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined').."`".. "\n **Steam: **".."`"..(QBCore.Functions.GetIdentifier(src, 'steam') or 'undefined').."`".. "\n **License: **".."`"..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined').."`")
    Wait(100)
end)

RegisterNetEvent('um-admin:log:playersEvent', function(src,webhook,event,color,targetPlayer)
    local src = src
    local everyone = false
    if webhook == 'ban' or webhook == 'cheater' then everyone = true end
    postWebHook(webhook,event,color,"**---------------------------------------------------------------**".."\n **[Admin]** \n \n **ID:** `[" ..src.. "]`".."\n **CID:** `"..QBCore.Functions.GetPlayer(src).PlayerData.citizenid.. "`".. "\n **Player Name:** `"..GetPlayerName(src).. "`".. "\n **Discord:** " .."`"..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined').."`".. "\n **Steam: **".."`"..(QBCore.Functions.GetIdentifier(src, 'steam') or 'undefined').."`".. "\n **License: **".."`"..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined').."`".."\n **---------------------------------------------------------------**".."\n **[Target]** \n \n **ID:** `[" ..targetPlayer.. "]`".."\n **CID:** `"..QBCore.Functions.GetPlayer(targetPlayer).PlayerData.citizenid.. "`".. "\n **Player Name:** `"..GetPlayerName(targetPlayer).. "`".. "\n **Discord:** " .."`"..(QBCore.Functions.GetIdentifier(targetPlayer, 'discord') or 'undefined').."`".. "\n **Steam: **".."`"..(QBCore.Functions.GetIdentifier(targetPlayer, 'steam') or 'undefined').."`".. "\n **License: **".."`"..(QBCore.Functions.GetIdentifier(targetPlayer, 'license') or 'undefined').."`", everyone)
    Wait(100)
end)
