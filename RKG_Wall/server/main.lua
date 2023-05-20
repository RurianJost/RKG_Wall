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

        if firstArgs == CONFIG.COMMAND.ARGS.SHOW_LINES and usersInWall[source] then
            local status = apiClient.toogleLines(source)

            CONFIG.NOTIFY(source, CONFIG.LANGUAGE[status])
        elseif firstArgs == CONFIG.COMMAND.ARGS.SHOW_WEAPONS and usersInWall[source] then
            local status = apiClient.toogleWeapons(source)

            CONFIG.NOTIFY(source, CONFIG.LANGUAGE[status])
        elseif firstArgs == CONFIG.COMMAND.ARGS.TOOGLE_DISTANCE and usersInWall[source] then
            local secondArg = tonumber(args[2])
            
            if secondArg then
                if secondArg < 5 then
                    CONFIG.NOTIFY(source, CONFIG.LANGUAGE.MINIMUM_DISTANCE, 10000)

                    return
                end

                apiClient.toogleDistance(source, secondArg)

                CONFIG.NOTIFY(source, string.format(CONFIG.LANGUAGE.TOOGLE_DISTANCE, tostring(secondArg)), 10000)
            else
                CONFIG.NOTIFY(source, CONFIG.LANGUAGE.UNDEFINED_DISTANCE, 10000)
            end
        elseif not firstArgs then
            if usersInWall[source] then
                usersInWall[source] = nil

                local stateWall = GlobalState.UserWallInfos

                if stateWall[source] and stateWall[source].useWall then
                    stateWall[source].useWall = false

                    GlobalState.UserWallInfos = stateWall
                end

                CONFIG.NOTIFY(source, CONFIG.LANGUAGE.DEACTIVE_WALL, 10000)
            else
                usersInWall[source] = true

                local stateWall = GlobalState.UserWallInfos

                if stateWall[source] and not stateWall[source].useWall then
                    stateWall[source].useWall = true

                    GlobalState.UserWallInfos = stateWall
                end

                CONFIG.NOTIFY(source, CONFIG.LANGUAGE.ACTIVE_WALL, 10000)
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
            userName = vRP.getUserName(userId)
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

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	local _playerList = vRP.getUsers()

	for userId, userSource in pairs(_playerList) do
        local stateWall = GlobalState.UserWallInfos

        if not stateWall[userSource] then
            stateWall[userSource] = {
                userId = userId,
                userName = vRP.getUserName(userId)
            }
            
            GlobalState.UserWallInfos = stateWall
        end

        Wait(10)
	end
end)