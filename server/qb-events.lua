local QBCore = exports['qb-core']:GetCoreObject()
local players = {}
local frozen = false
local permissions = {
    ['kill'] = 'admin',
    ['ban'] = 'admin',
    ['noclip'] = 'admin',
    ['kickall'] = 'admin',
    ['kick'] = 'admin',
    ["revive"] = "admin",
    ["freeze"] = "admin",
    ["goto"] = "admin",
    ["spectate"] = "admin",
    ["intovehicle"] = "admin",
    ["bring"] = "admin",
    ["inventory"] = "admin",
    ["clothing"] = "admin"
}

-- Callback
QBCore.Functions.CreateCallback('test:getdealers', function(_, cb)
    cb(exports['qb-drugs']:GetDealers())
end)

QBCore.Functions.CreateCallback('um-admin:callback:getplayers', function(_, cb)
    cb(players)
end)

QBCore.Functions.CreateCallback('qb-admin:server:getrank', function(source, cb)
    if QBCore.Functions.HasPermission(source, 'god') or IsPlayerAceAllowed(source, 'command') then
        cb(true)
    else
        cb(false)
    end
end)

-- Functions
local function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

local function BanPlayer(src)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        QBCore.Functions.GetIdentifier(src, 'license'),
        QBCore.Functions.GetIdentifier(src, 'discord'),
        QBCore.Functions.GetIdentifier(src, 'ip'),
        "Trying to revive theirselves or other players",
        2147483647,
        'qb-adminmenu'
    })
    TriggerEvent('um-admin:log:playersEvent',src,"cheater","Banned Cheater \n Trying to trigger admin options which they dont have permission for","red",src)
    DropPlayer(src, 'You were permanently banned by the server for: Exploiting')
end

-- Events
RegisterNetEvent('qb-admin:server:GetPlayersForBlips', function()
    local src = source
    TriggerClientEvent('qb-admin:client:Show', src, players)
end)

RegisterNetEvent('qb-admin:server:kill', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['kill']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerClientEvent('hospital:client:KillPlayer', player)
        TriggerEvent('um-admin:log:playersEvent',src,"kill","Killed".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:revive', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['revive']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerClientEvent('hospital:client:Revive', player)
        TriggerEvent('um-admin:log:playersEvent',src,"revivep","Revive".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:kick', function(data)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerEvent('um-admin:log:playersEvent',src,"kick","Kicked".."["..data[3].."] \n Reason: "..data[4],"yellow",data[3])
        DropPlayer(data[3], Lang:t("info.kicked_server") .. ':\n' .. data[4] .. '\n\n' .. Lang:t("info.check_discord") .. QBCore.Config.Server.Discord)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:ban', function(data)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
        time = tonumber(data[4])
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date('*t', banTime)
        MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(data[3]),
            QBCore.Functions.GetIdentifier(data[3], 'license'),
            QBCore.Functions.GetIdentifier(data[3], 'discord'),
            QBCore.Functions.GetIdentifier(data[3], 'ip'),
            data[5],
            banTime,
            GetPlayerName(src)
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
            args = {GetPlayerName(data[3]), data[5]}
        })
        TriggerEvent('um-admin:log:playersEvent',src,"ban","Banned".."["..data[3].."] \n Reason: "..data[5],"red",data[3])
        if banTime >= 2147483647 then
            DropPlayer(data[3], Lang:t("info.banned") .. '\n' .. data[5] .. Lang:t("info.ban_perm") .. QBCore.Config.Server.Discord)
        else
            DropPlayer(data[3], Lang:t("info.banned") .. '\n' .. data[5] .. Lang:t("info.ban_expires") .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. QBCore.Config.Server.Discord)
        end
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:spectate', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['spectate']) or IsPlayerAceAllowed(src, 'command') then
        local targetped = GetPlayerPed(player)
        local coords = GetEntityCoords(targetped)
        TriggerClientEvent('qb-admin:client:spectate', src, player, coords)
        TriggerEvent('um-admin:log:playersEvent',src,"spectate","Spectate".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:freeze', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['freeze']) or IsPlayerAceAllowed(src, 'command') then
        TriggerEvent('um-admin:log:playersEvent',src,"freeze","Freeze".."["..player.."]","black",player)
        local target = GetPlayerPed(player)
        if not frozen then
            frozen = true
            FreezeEntityPosition(target, true)
        else
            frozen = false
            FreezeEntityPosition(target, false)
        end
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:goto', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['goto']) or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local coords = GetEntityCoords(GetPlayerPed(player))
        SetEntityCoords(admin, coords)
        TriggerEvent('um-admin:log:playersEvent',src,"gotobring","Goto".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:intovehicle', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['intovehicle']) or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local targetPed = GetPlayerPed(player)
        local vehicle = GetVehiclePedIsIn(targetPed,false)
        local seat = -1
        if vehicle ~= 0 then
            for i=0,8,1 do
                if GetPedInVehicleSeat(vehicle,i) == 0 then
                    seat = i
                    break
                end
            end
            if seat ~= -1 then
                SetPedIntoVehicle(admin,vehicle,seat)
                TriggerClientEvent('QBCore:Notify', src, Lang:t("sucess.entered_vehicle"), 'success', 5000)
                TriggerEvent('um-admin:log:playersEvent',src,"intovehicle","Into vehicle".."["..player.."]","black",player)
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_free_seats"), 'danger', 5000)
            end
        end
    else
        BanPlayer(src)
    end
end)


RegisterNetEvent('qb-admin:server:bring', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['bring']) or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local coords = GetEntityCoords(admin)
        local target = GetPlayerPed(player)
        SetEntityCoords(target, coords)
        TriggerEvent('um-admin:log:playersEvent',src,"gotobring","Bring".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:inventory', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['inventory']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('qb-admin:client:inventory', src, player)
        TriggerEvent('um-admin:log:playersEvent',src,"inventory","Open Inventory".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:cloth', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['clothing']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('qb-clothing:client:openMenu', player)
        TriggerEvent('um-admin:log:playersEvent',src,"clothing","Open Clothing".."["..player.."]","black",player)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:setPermissions', function(data)
    local src = source
    if QBCore.Functions.HasPermission(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        QBCore.Functions.AddPermission(data[3], data[4].rank)
        TriggerClientEvent('QBCore:Notify', data[3], Lang:t("info.rank_level")..data[4].label)
        TriggerEvent('um-admin:log:playersEvent',src,"perms","Perm: ["..data[4].rank.."]", "black",data[3])
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        if QBCore.Functions.IsOptin(src) then
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                multiline = true,
                args = {Lang:t("info.admin_report")..name..' ('..targetSrc..')', msg}
            })
        end
    end
end)

RegisterServerEvent('qb-admin:giveWeapon', function(weapon)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem(weapon, 1)
    else
        BanPlayer(src)
    end
end)

RegisterServerEvent('qb-admin:server:givemoneyadmin', function(data)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        local Player = QBCore.Functions.GetPlayer(tonumber(data[3]))
        if Player then
            Player.Functions.AddMoney(tostring(data[4].money), tonumber(data[5]))
            TriggerEvent('um-admin:log:playersEvent',src,"givemoney","Give Money".."[Type:"..tostring(data[4].money).."] Total:"..tonumber(data[5]),"black",tonumber(data[3]))
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
        end
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('qb-admin:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        local Player = QBCore.Functions.GetPlayer(src)
        local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
        if result[1] == nil then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                Player.PlayerData.license,
                Player.PlayerData.citizenid,
                vehicle.model,
                vehicle.hash,
                json.encode(mods),
                plate,
                0
            })
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.success_vehicle_owner"), 'success', 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.failed_vehicle_owner"), 'error', 3000)
        end
    else
        BanPlayer(src)
    end
end)

-- Loop
CreateThread(function()
    while true do
        local tempPlayers = {}
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local targetped = GetPlayerPed(v)
            local ped = QBCore.Functions.GetPlayer(v)
            tempPlayers[#tempPlayers + 1] = {
                name = (ped.PlayerData.charinfo.firstname or '') .. ' ' .. (ped.PlayerData.charinfo.lastname or '') .. ' | (' .. (GetPlayerName(v) or '') .. ')',
                id = v,
                currentping = GetPlayerPing(ped.PlayerData.source)
            }
        end
        -- Sort players list by source ID (1,2,3,4,5, etc) --
        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
            players = tempPlayers
        Wait(1500)
    end
end)