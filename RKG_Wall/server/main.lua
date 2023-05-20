local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRPclient = Tunnel.getInterface('vRP')
vRP = Proxy.getInterface('vRP')

api = {}
Tunnel.bindInterface('RKG_Wall', api)
apiClient = Tunnel.getInterface('RKG_Wall')

GlobalState.UserWallInfos = {}

local usersInWall = {}

RegisterCommand(CONFIG.COMMAND.USE, function(source, args)
    local source = source
    local userId = vRP.getUserId(source)

    if vRP.hasPermission(userId, CONFIG.COMMAND.PERMISSION) then
        local firstArgs = args[1]

        if firstArgs == CONFIG.COMMAND.SHOW_LINES then
            if usersInWall[source] then
                local status = apiClient.toogleLines(source)
    
                if status then
                    TriggerClientEvent('Notify', source, 'sucess', 'Você ativou as linhas do wall.', 10000, 'Wall Lines')
                else
                    TriggerClientEvent('Notify', source, 'denied', 'Você desativou as linhas do wall.', 10000, 'Wall Lines')
                end
            end
        elseif firstArgs == CONFIG.COMMAND.SHOW_WEAPONS then
            if usersInWall[source] then
                local status = apiClient.toogleWeapons(source)

                if status then
                    TriggerClientEvent('Notify', source, 'sucess', 'Você ativou as armas do wall.', 10000, 'Wall Weapons')
                else
                    TriggerClientEvent('Notify', source, 'denied', 'Você desativou as armas do wall.', 10000, 'Wall Weapons')
                end
            end
        elseif firstArgs == CONFIG.COMMAND.TOOGLE_DISTANCE then
            if usersInWall[source] then
                local secondArg = tonumber(args[2])
                
                if secondArg then
                    if secondArg < 5 then
                        secondArg = 5
                    end

                    apiClient.toogleDistance(source, secondArg)

                    TriggerClientEvent('Notify', source, 'sucess', 'Você alterou a distancia do wall para: '..tostring(secondArg), 10000, 'Wall Distance')
                end
            end
        else
            if usersInWall[source] then
                usersInWall[source] = nil

                local stateWall = GlobalState.UserWallInfos

                if stateWall[source].useWall then
                    stateWall[source].useWall = false

                    GlobalState.UserWallInfos = stateWall
                end

                TriggerClientEvent('Notify', source, 'denied', 'Você desativou o wall', 10000, 'Wall Deactive')
            else
                usersInWall[source] = true

                local stateWall = GlobalState.UserWallInfos

                if stateWall[source].useWall then
                    stateWall[source].useWall = true

                    GlobalState.UserWallInfos = stateWall
                end

                TriggerClientEvent('Notify', source, 'sucess', 'Você ativou o wall', 10000, 'Wall Active')
            end

            apiClient.toogleWall(source, usersInWall[source])
        end
    end
end)

AddEventHandler('vRP:playerSpawn',function(userId, source)
    local stateWall = GlobalState.UserWallInfos

    if not stateWall[source] then
        stateWall[source] = {
            userId = userId,
            userName = vRP.getUserName(userId),
            useWall = false
        }
        
        GlobalState.UserWallInfos = stateWall
    end
end)

AddEventHandler('playerDropped',function(reason)
    local source = source

    local stateWall = GlobalState.UserWallInfos

    if stateWall[source] then
        stateWall[source] = nil
        
        GlobalState.UserWallInfos = stateWall
    end
end)