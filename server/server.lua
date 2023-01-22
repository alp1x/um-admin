local QBCore = exports['qb-core']:GetCoreObject()

local function GetIdentifier(player,set)
    local identifier = QBCore.Functions.GetIdentifier(player, set)
    if identifier ~= nil then
        return identifier
    else
        return 'no' ..set
    end
end

--- Event [Nui]
RegisterNetEvent('um-admin:server:getMoney', function(moneytype)
    local src = source
    local result =  MySQL.query.await('SELECT money FROM players', {})
        if result then
            local totalMoney = 0
            for k, v in pairs(result) do
                totalMoney += json.decode(v.money)[moneytype]
            end
            TriggerClientEvent('um-admin:client:getMoney', src, totalMoney, moneytype)
        end
end)

RegisterNetEvent('um-admin:server:getPlayerProfile', function(player)
    local Player = QBCore.Functions.GetPlayer(player)
    local steam = GetIdentifier(player,'steam')
    local discord = GetIdentifier(player,'discord')
    local license = GetIdentifier(player,'license')
    local data = {
        ["name"] = player.. ' | '..( Player.PlayerData.charinfo.firstname or '') .. ' ' .. (Player.PlayerData.charinfo.lastname or ''),
        ["status"] = {
            food = math.floor(Player.PlayerData.metadata['hunger']),
            water = math.floor(Player.PlayerData.metadata['thirst']),
            armor = math.floor(Player.PlayerData.metadata['armor']),
            stress = math.floor(Player.PlayerData.metadata['stress']),
        },
        ["citizenid"] = Player.PlayerData.citizenid,
        ["license"] = license:gsub("license:", ""),
        ["steam"] = steam,
        ["steampic"] = tonumber(steam:gsub("steam:", ""),16),
        ["discord"] = discord,
        ["discordpic"] = discord:gsub("discord:", ""),
        ["cash"] = Player.PlayerData.money["cash"],
        ["bank"] = Player.PlayerData.money["bank"],
        ["job"] = Player.PlayerData.job.label,
        ["gang"] = Player.PlayerData.gang.label,
        ["phone"] = Player.PlayerData.charinfo.phone,
        ["player"] = Player.PlayerData.source,
    }
    TriggerClientEvent('um-admin:client:getPlayerProfile',source,data)
end)
