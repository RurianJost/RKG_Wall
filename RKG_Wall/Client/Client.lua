local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local oRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),oRP)
local vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local players = {}
local wall = false
local lines = false
local weapon_status = false
local standard_distance = Config.DistanceWall

RegisterCommand(Config.Command.Wall,function(source,args,rawCommand)
    if vSERVER.getPermissao() then
		if args[1] == Config.Command.Weapon then
			if wall then
				if weapon_status then
					weapon_status = false
					vSERVER.reportWall("weapon",false)
					drawNotification(Config.Notify.WeaponsOFF)
				else
					weapon_status = true
					vSERVER.reportWall("weapon",true)
					drawNotification(Config.Notify.WeaponsON)
					PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)			
				end
			else
				drawNotification(Config.Notify.ActiceWall)
				PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)	
			end
		elseif args[1] == Config.Command.Lines then
			if wall then
				if lines then
					lines = false
					vSERVER.reportWall("lines",false)
					drawNotification(Config.Notify.LinesOFF)
				else
					lines = true
					vSERVER.reportWall("lines",true)
					drawNotification(Config.Notify.LinesON)
					PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)			
				end
			else
				drawNotification(Config.Notify.ActiceWall)
				PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)	
			end
		elseif args[1] == Config.Command.Distance and args[2] then
			if wall then
				standard_distance = tonumber(args[2])
				vSERVER.reportWall("distance",true,tonumber(args[2]))
				drawNotification(Config.Notify.Distance..tonumber(args[2]))
				PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
			else
				drawNotification(Config.Notify.ActiceWall)
				PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)	
			end
		else
			if wall then
				wall = false
				vSERVER.reportWall("wall",false)
				drawNotification(Config.Notify.WallOFF)
			else
				wall = true
				vSERVER.reportWall("wall",true)
				drawNotification(Config.Notify.WallON)
				PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local RKG = 2000
		if wall then
			for k,id in ipairs(GetActivePlayers()) do
				local pedId = GetPlayerPed(id)
				if NetworkIsPlayerActive(id) and pedId ~= ped then
					local x1, y1, z1 = table.unpack(GetEntityCoords(ped,true))
					local x2, y2, z2 = table.unpack(GetEntityCoords(pedId,true))
					local distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))	
					if ped ~= pedId then
						if pedId ~= -1 and players[id] ~= nil then
							local ped_name = GetPlayerName(id)
							local ped_health = (GetEntityHealth(pedId) - 100)
							local ped_weapon = GetSelectedPedWeapon(pedId)
							local ped_armour = GetPedArmour(pedId)
							local health_percent = ped_health / 3
							health_percent = math.floor(health_percent)

							if ped_name == nil or ped_name == "" or ped_name == -1 then
								ped_name = "STEAM OFF"
							end
							if ped_health == 1 then
								ped_health = 0
							end

							if distance <= standard_distance then
								if wall then
									RKG = 5
									if not weapon_status then
										DrawText3D(x2, y2, z2+1.3,"~b~["..distance.." m]~w~\n[ ~b~"..players[id].."~w~ ] "..ped_name.." [HP: ~b~"..health_percent.."~w~] [Colete: ~b~"..ped_armour.."~w~]")
									else
										DrawText3D(x2, y2, z2+1.3,"~b~["..distance.." m]~w~\n[ ~b~"..players[id].."~w~ ] "..ped_name.." [HP: ~b~"..health_percent.."~w~] [Colete: ~b~"..ped_armour.."~w~]\n~b~"..Config.Weapons[ped_weapon].."")
									end
								end
								if lines then
									RKG = 5
									if not IsEntityVisible(pedId) then
										DrawLine(x1, y1, z1, x2, y2, z2, 255, 0, 0, 255)
									else
										DrawLine(x1, y1, z1, x2, y2, z2, 255, 255, 255, 255)
									end
								end
							end
						end
					end
				end
			end
		end
		Citizen.Wait(RKG)
	end
end)

Citizen.CreateThread(function()
	while true do
        local RKG = 1000
	    for _, id in ipairs(GetActivePlayers()) do
			local pid = vSERVER.getId(GetPlayerServerId(id))
			if players[id] ~= pid or not players[id] then
				players[id] = pid
			end
		end
		Citizen.Wait(RKG)
	end
end)

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.25)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function drawNotification(string)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(string)
	DrawNotification(true, false)
end