local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP")

local oRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),oRP)
local vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

function oRP.getId(sourceplayer)
    local sourceplayer = sourceplayer
	if sourceplayer ~= nil and sourceplayer ~= 0 then
		local user_id = vRP.getUserId(sourceplayer)
		if user_id then
			return user_id
		end
	end
end

function oRP.getPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,Config.PermissaoWall) then
        return true
    else
        return false
    end
end

function oRP.reportWall(toogle,report,numDistance)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if toogle == "wall" then
        if report then
            PerformHttpRequest(Config.Webhook.Wall, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Wall\n"
                            },
                            { 
                                name = "Status:",
                                value = "**✅ Ativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 5763719 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        else
            PerformHttpRequest(Config.Webhook.Wall, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Wall\n"
                            },
                            { 
                                name = "Status:",
                                value = "**❌ Desativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 15158332 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end
    elseif toogle == "lines" then
        if report then
            PerformHttpRequest(Config.Webhook.Lines, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Lines\n"
                            },
                            { 
                                name = "Status:",
                                value = "**✅ Ativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 5763719 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        else
            PerformHttpRequest(Config.Webhook.Lines, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Lines\n"
                            },
                            { 
                                name = "Status:",
                                value = "**❌ Desativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 15158332 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end
    elseif toogle == "weapon" then
        if report then
            PerformHttpRequest(Config.Webhook.Weapon, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Weapon\n"
                            },
                            { 
                                name = "Status:",
                                value = "**✅ Ativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 5763719 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        else
            PerformHttpRequest(Config.Webhook.Weapon, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Weapon\n"
                            },
                            { 
                                name = "Status:",
                                value = "**❌ Desativado**\n"
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 15158332 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end
    elseif toogle == "distance" then
        if report then
            PerformHttpRequest(Config.Webhook.Distance, function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {
                        title = "Report Wall                                               \n⠀",
                        thumbnail = { 
                            url = "https://i.imgur.com/0g5Jaic.png" 
                        }, 
                        fields = {
                            { 
                                name = "Report:",
                                value = "Distance\n"
                            },
                            { 
                                name = "Distancia:",
                                value = ""..numDistance..""
                            },
                            { 
                                name = "Administrador:",
                                value = "Nome: "..identity.name.." "..identity.firstname.." ID: **"..user_id.."**\n "
                            },
                        }, 
                        footer = { 
                            text = "By RKG Store - "..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/0g5Jaic.png" 
                        },
                        color = 3447003 
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end
    end
end