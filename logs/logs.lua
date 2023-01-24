local QBCore = exports['qb-core']:GetCoreObject()

local Webhooks = {
    --- Self
    ['noclip'] = 'https://discord.com/api/webhooks/1067098894242168852/45SF58y3oRQ34AkCdxuyvReJ4-rcvU9QVM4MBpyjzMpaXfGWJ8wkLZ1XS7tQURPbbXEK',
    ['godmode'] = 'https://discord.com/api/webhooks/1067403503582060665/QEXlBNfRTDPuQp4TjGsCAZvyZiSWwYeWbf8DiJWsMrUVpGRb8rs5to9PipVKvnSafSSv',
    ['vehicle'] = 'https://discord.com/api/webhooks/1067398428012855359/WpxwcE_GOKJDznSeckjRVMFb-qp0-mtOaAUbw4LozHYwanp4T7JqzbMabNjoTkeLRabF',
    ['revive'] = 'https://discord.com/api/webhooks/1067404067732729898/NJ7cyhPMb84-xUSz4bQ0AzsuffykjeDOisBaLT4Sv-6NtazAixXLlreCmzWa75s1qjIq',
    ['invisible'] = 'https://discord.com/api/webhooks/1067404943461458031/39JnBwmd-qjJ_bRClneTxOGEHmmTqjPIoD06Z5y9A06DsNQMGVMU09z_Ee7XO5qErUsn',
    ['other'] = 'https://discord.com/api/webhooks/1067405677607256107/iJsuXv_mIOWZNPYQlITaWUgeRWJlz-LD5WiM4uXQJFs24gW_RsnEAqn08R_kEkqqYaDj',

    --- Players
    ["kill"] = 'https://discord.com/api/webhooks/1067409790227189811/wjLu2LCnODX2I-35yu9YxXW4OewGmi5x_13w0LReRX9HQuE36eOut6IyRTCDisby2zpl',
    ["revivep"] = 'https://discord.com/api/webhooks/1067414752227246100/6ZKFOH8lYJqJpq_KI1-1oevTlO8F6Ax4pitQR5jEf-f2WrjFJnwD5tLhOwlzJPZaOrev',
    ["freeze"]= 'https://discord.com/api/webhooks/1067505767743234117/hlNLCj3ALOe25BtHqdPyJHsbAqhtlJat2-YdBIN_xrsYw40sktljdyZ-0fGFsWbBPn0b',
    ["spectate"]= 'https://discord.com/api/webhooks/1067505826014691390/sFYjW44nRFMGL7BBgH9pbXPY2vMUv1i5aeJJHjyiha1gQjomfc1gTKegkMbQKSjnp8_P',
    ["gotobring"]= 'https://discord.com/api/webhooks/1067505868771438724/9nbKi_m0OiH29K6gyNxQqLspnKNEDwSso6LM52GLiU7YlmA1nKUouCaW62lkItPAUKVo',
    ["intovehicle"]= 'https://discord.com/api/webhooks/1067505919287631952/t5-qH97iiFL0THOvTJ4r3hpd1PMbq61_Zni0DYslCGw0pcFV64zrabySSUdhxYBM44HJ',
    ["inventory"]= 'https://discord.com/api/webhooks/1067505962728038453/NysjXQgxhkr1uH563WHav54bFCkSdt6EIu6CvZ0HoRW7_hUkkw23Q9iHePCxjCA1ADKa',
    ["clothing"]= 'https://discord.com/api/webhooks/1067506026032668793/Y2Al5-mNLA8homNxb9gXidoNf_NHqMrkCmy2-fOslg8J3LNmMb_YPKfn9H1k8Ea9Dn5m',
    ["perms"] = 'https://discord.com/api/webhooks/1067529943350792312/LdOCt1TqnPy20NW95khvitDj_Mu_ai138XhsCKluoS_4blVu6wtZrxAiy2anyt_CxbYA',

    --- Ban or Kick or Cheater
    ['kick'] = 'https://discord.com/api/webhooks/1067514394591903824/Nei53Y7aAFFlehsHHVk2Ac1fxcOmm1wrwI_c48q1P1GX4zVErrW7iZibzkT0a0pGP7hb',
    ['ban'] = 'https://discord.com/api/webhooks/1067522024194457611/ZU6QK5J7yzf-EMLxNihNaUia8VE_FWZLpKIo36JMNLQVb_jcgZI7nv3sofimSitpm3vR',
    ['cheater'] = 'https://discord.com/api/webhooks/1067530002331078658/dyz8W8_CcFDWeD3awA4yIfBac9BnNodeu7Z-9DgyrttPGF6jfqItWT84pFHZr5TTFTaT',

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
    postWebHook(webhook,event,color,"**---------------------------------------------------------------**".."\n **[Admin]** \n \n **ID:** `[" ..src.. "]`".."\n **CID:** `"..QBCore.Functions.GetPlayer(src).PlayerData.citizenid.. "`".. "\n **Player Name:** `"..GetPlayerName(src).. "`".. "\n **Discord:** " .."`"..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined').."`".. "\n **Steam: **".."`"..(QBCore.Functions.GetIdentifier(src, 'steam') or 'undefined').."`".. "\n **License: **".."`"..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined').."`".."\n **---------------------------------------------------------------**".."\n **[Target]** \n \n **ID:** `[" ..src.. "]`".."\n **CID:** `"..QBCore.Functions.GetPlayer(src).PlayerData.citizenid.. "`".. "\n **Player Name:** `"..GetPlayerName(src).. "`".. "\n **Discord:** " .."`"..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined').."`".. "\n **Steam: **".."`"..(QBCore.Functions.GetIdentifier(src, 'steam') or 'undefined').."`".. "\n **License: **".."`"..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined').."`", everyone)
    Wait(100)
end)