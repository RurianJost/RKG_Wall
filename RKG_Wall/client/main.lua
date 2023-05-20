local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

api = {}
Tunnel.bindInterface('RKG_Wall', api)
apiServer = Tunnel.getInterface('RKG_Wall')

local inWall = false
local wallDistance = 250.0

local linesActivated = false
local showWeaponsActivated = false

function api.toogleWall(status)
    inWall = status

    if inWall then
        createWallThread()
    end
end

function api.toogleLines()
    linesActivated = not linesActivated

    return linesActivated and 'ACTIVE_LINES' or 'DEACTIVE_LINES'
end

function api.toogleWeapons()
    showWeaponsActivated = not showWeaponsActivated

    return showWeaponsActivated and 'ACTIVE_WEAPONS' or 'DEACTIVE_WEAPONS'
end

function api.toogleDistance(distance)
    wallDistance = distance
end

function createWallThread()
    CreateThread(function()
        while inWall do
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
    
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() and NetworkIsPlayerActive(playerId) then
                    local otherPed = GetPlayerPed(playerId)
    
                    if DoesEntityExist(otherPed) and IsPedAPlayer(otherPed) then
                        local otherPedCoords = GetEntityCoords(otherPed)
                        
                        local distance = #(pedCoords - otherPedCoords)
    
                        if distance <= wallDistance then
                            if linesActivated then
                                if not IsEntityVisible(otherPed) then
                                    DrawLine(pedCoords.x, pedCoords.y, pedCoords.z, otherPedCoords.x, otherPedCoords.y, otherPedCoords.z, 255, 0, 0, 255)
                                else
                                    DrawLine(pedCoords.x, pedCoords.y, pedCoords.z, otherPedCoords.x, otherPedCoords.y, otherPedCoords.z, 255, 255, 255, 255)
                                end
                            end
    
                            if inWall then
                                local playerServerId = GetPlayerServerId(playerId)
                    
                                if GlobalState.UserWallInfos[playerServerId] then
                                    local otherPlayerInfos = GlobalState.UserWallInfos[playerServerId]

                                    local otherPedHealth = math.floor((GetEntityHealth(otherPed)) - 101)
                                    local otherPedArmour = GetPedArmour(otherPed)
        
                                    local otherPedCurrentWeapon = ({GetCurrentPedWeapon(otherPed)})[2]
                                    local otherPedWeapon = CONFIG.WEAPON_LIST[otherPedCurrentWeapon]
        
                                    local text = '~b~['..mathLength(distance)..' m]~w~\n~b~#'..otherPlayerInfos.userId..'~w~ '..otherPlayerInfos.userName..' [HP: ~b~'..otherPedHealth..'~w~]'
                                    
                                    if otherPedArmour > 0 then
                                        text = text..' [Colete: ~b~'..otherPedArmour..'~w~]'
                                    end
        
                                    if otherPlayerInfos.useWall then
                                        text = text..'\n~w~[~g~WALL ON~w~]'
                                    end

                                    if showWeaponsActivated and otherPedWeapon then
                                        text = text..'\n~b~'..otherPedWeapon..'~w~'
                                    end

                                    DrawText3D(otherPedCoords.x, otherPedCoords.y, otherPedCoords.z + 1.3, text)
                                end
                            end
                        end
                    end
                end
            end
    
            Wait(0)
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.4, 0.4)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function mathLength(n)
	return math.ceil(n * 100) / 100
end