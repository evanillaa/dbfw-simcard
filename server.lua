DBFW = nil
TriggerEvent('DBFW:GetObject', function(obj) DBFW = obj end)

RegisterServerEvent('dbfw-simcard:useSimCard')
AddEventHandler('dbfw-simcard:useSimCard', function(number)
    local src = source
    TriggerClientEvent('dbfw-simcard:startNumChange', src, number)     
end)

RegisterServerEvent('dbfw-simcard:changeNumber')
AddEventHandler('dbfw-simcard:changeNumber', function(newNum)
    TriggerClientEvent('dbfw-simcard:success', source, newNum)
end)

DBFW.Functions.CreateUseableItem("sim_card", function(source, item)
    local src = source
    local xPlayer = DBFW.Functions.GetPlayer(src)    
    TriggerClientEvent('dbfw-simcard:changeNumber', source, xPlayer)
end)

RegisterServerEvent('dbfw-simcard:changeNumber')
AddEventHandler('dbfw-simcard:changeNumber', function(MData)
    local xPlayer = DBFW.Functions.GetPlayer(source)
    DBFW.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
        local MetaData = json.decode(result[1].metadata)
        local Charinfo = json.decode(result[1].charinfo)
        MetaData.phone = MData
        Charinfo.phone = MData
        DBFW.Functions.ExecuteSql(false, "UPDATE `players` SET `metadata` = '"..json.encode(MetaData).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
        DBFW.Functions.ExecuteSql(false, "UPDATE `players` SET `charinfo` = '"..json.encode(Charinfo).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
    end)
    xPlayer.Functions.SetMetaData("phone", MData)
end)
