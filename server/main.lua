ESX = exports["es_extended"]:getSharedObject()

RegisterCommand(Config.Command, function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('admin_users:showPlayers',source)
        end
    end
end)
RegisterCommand("advanced"..Config.Command, function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('admin_users:showPlayersAdvanced', source)
        end
    end
end)
RegisterCommand(Config.Command.."fullrad", function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('admin_users:showPlayersFullRad', source)
        end
    end
end)
RegisterCommand(Config.Command.."reload", function(source)
    TriggerClientEvent('admin_users:reloadData', source)
end)

RegisterNetEvent("admin_users:getPlayerData")
AddEventHandler("admin_users:getPlayerData", function(plrname, plr)
    local info = ESX.GetPlayerFromId(plr)
    if info ~= nil then
        TriggerClientEvent("admin_users:receivePlayerData", source, {
            id = plrname,
            id_real = plr,
            data = {
                name = info.name,
                job = info.job,
                group = info.getGroup(),
            }
        })
    end
end)