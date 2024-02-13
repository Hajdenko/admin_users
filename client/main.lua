ESX = exports["es_extended"]:getSharedObject()

local draw = false
local advanced = false
local fullradius = false
local visiblePlayers = {}
local VEHICLE_ESTIMATED_SPEED = {}

function MsgToChat(message)
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.45); border-radius: 3px;"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(190, 80, 80); border-radius: 5px; font-size: 15px;"> <b>USERS</b></font><font style="background-color:rgba(20, 20, 20, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">'..message..'</font></div>',
        args = {}
    })
end

RegisterNetEvent('admin_users:showPlayers')
AddEventHandler('admin_users:showPlayers',function()
    if draw then
        draw = false
        MsgToChat('Names and ID of players <b>turned off</b>!')
    else
        draw = true
        MsgToChat('Names and ID of players <b>turned on</b>!')
    end
end)

RegisterNetEvent('admin_users:showPlayersAdvanced')
AddEventHandler('admin_users:showPlayersAdvanced',function()
    if advanced then
        advanced = false
        MsgToChat('You <b>turned off</b> admin users!')
    else
        draw = true
        advanced = true
        MsgToChat('You <b>turned on</b> admin users!')
    end
end)

RegisterNetEvent('admin_users:showPlayersFullRad')
AddEventHandler('admin_users:showPlayersFullRad',function()
    if fullradius then
        fullradius = false
        MsgToChat('You <b>turned off</b> full radius mode (max FIVEM player radius)!')
    else
        draw = true
        fullradius = true
        MsgToChat('You <b>turned on</b> full radius mode (max FIVEM player radius)!')
    end
end)

function string_split(input, thing)
    local output = {}
    local pattern = string.format("([^%s]+)", thing)
    for word in input:gmatch(pattern) do
        table.insert(output, word)
    end
    return output
end

function DrawTxt(text, x, y, scale, size)
    RegisterFontFile('BBN')
    fontId = RegisterFontId('BBN') 
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 750 -- Edit this number if you want faster flashing

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	result.a = 234

	return result
end

local function draw3DText(pos, text, options)
    local rgb = RGBRainbow(1)
    options = options or { }
    --local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    --local scaleOption = options.size or 0.8
    local camCoords      = GetGameplayCamCoords()
    local dist           = #( vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(pos.x, pos.y, pos.z) )
    --local scale = (scaleOption / dist) * 2
    --local fov   = (1 / GetGameplayCamFov()) * 100
    -- local scaleMultiplier = scale * fov

    RegisterFontFile('BBN')
    fontId = RegisterFontId('BBN') 
    SetDrawOrigin(pos.x, pos.y, pos.z + 0.25, 0);
    SetTextProportional(0)
    SetTextScale(0.0, 0.28)
    SetTextColour(rgb.r,rgb.g,rgb.b,rgb.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextFont(fontId)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < Config.DrawDistance or fullradius then
                visiblePlayers[v] = v
            end
        end
    end
end)--]]

local plrDatas = {}
RegisterNetEvent("admin_users:receivePlayerData", function(plr)
    plrDatas[plr.id] = plr.data
end)

RegisterNetEvent('admin_users:reloadData')
AddEventHandler('admin_users:reloadData',function()
    plrDatas = {}
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if draw then
            local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))

            for _,v in pairs(GetActivePlayers()) do
                local ped_server_id = GetPlayerServerId(v)

                if ped_server_id ~= 0 then
                    local ped       = GetPlayerPed(v)
                    local cords = GetEntityCoords(ped)

                    if (#(cords-currentCoords) < Config.DrawDistance) or fullradius then
                        local speed     = GetEntitySpeed(ped)
                        local ped_name = GetPlayerName(v)
                        
                        local health = GetEntityHealth(GetPlayerPed(v))
                        local armor = GetPedArmour(GetPlayerPed(v))
                        if health >= 101 then health=health-100
                        elseif health <= 1 then armor = "~r~DEAD"
                        else health=health end
    
                        if not IsPedInAnyVehicle(ped, false) then                
                            speed = string.format("%0.1f", speed)
                        else
                            local vehicle = GetVehiclePedIsIn(ped, false)
    
                            if DoesEntityExist(vehicle) then
                                local maxI = GetVehicleMaxNumberOfPassengers(vehicle)
                                local Zoffset = 0
                                for i = -1, maxI do
                                    if GetPedInVehicleSeat(vehicle, i) == ped then
                                        local a = i + 1
                                        Zoffset = advanced and a or a * 0.5
                                        break
                                    end
                                end
                                cords = vector3(cords.x, cords.y, cords.z + Zoffset)
    
                                local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
                                if VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped] == nil then
                                    VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped] = maxSpeed
                                else
                                    if tonumber(VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped]) then
                                        if VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped] > 1 then
                                            maxSpeed = VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped]
                                        else VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped] = nil end
                                    else VEHICLE_ESTIMATED_SPEED[vehicle .. "_" .. ped] = nil end
                                end
    
                                local speed_    = GetEntitySpeed(vehicle)
                                local total_    = maxSpeed + 30
                                speed = string.format("%0.0f", speed_) .. "/" .. string.format("%0.0f", total_) .. ""
                            else
                                speed = "???"
                            end
                        end
    
                        if advanced then
                            local peddata = plrDatas[ped_name]
                            if peddata == nil then
                                TriggerServerEvent("admin_users:getPlayerData", ped_name, ped_server_id)
                                peddata = plrDatas[ped_name]
                            end
        
                            if peddata == nil then
                                draw3DText(
                                    cords, 
                                        "[ID: " .. ped_server_id .. " | " .. ped_name.. "]\n"
                                        .. "~r~".. health .. " ~s~| ~b~" .. armor.. " ~s~| Speed:  ~b~" .. speed,
                                    { size = Config.TextSize }
                                )
                            else
                                draw3DText(
                                    cords, 
                                        "[ID: " .. ped_server_id.. " | " .. ped_name .. " | " .. tostring(peddata.group) .. "]\n"
                                        .. tostring(peddata.job.name).." ["..tostring(peddata.job.grade).."]" .. " - " .. tostring(peddata.name) .. "\n"
                                        .. "~r~".. health .. " ~s~| ~b~" .. armor.. "~s~\n~b~" .. speed .. "~s~ | ~g~".. string.format("%0.0f", #(cords-currentCoords))
                                        ,
                                    { size = Config.TextSize }
                                )
                            end
                        else
                            draw3DText(
                                cords, 
                                    "[ID: " .. ped_server_id .. " | " .. ped_name.. "]\n"
                                    .. "~r~".. health .. " ~s~| ~b~" .. armor,
                                { size = Config.TextSize }
                            )
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(120000)
        plrDatas = {}
    end
end)