function Notify(titel, msg, tid, type)
    TriggerClientEvent('okokNotify:Alert', source, titel, msg, tonumber(tid), type)
end

if Config.Framework == 'VRP' then
    local Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")

    times = 0


    RegisterNetEvent('Kian_gerald:Reward', function()
        local user_id = vRP.getUserId({source})
        reward = Config.MoneyReward

        if user_id ~= nil then
            if Config.RewardType == 'money' then
                if Config.Dirtymoney then
                    vRP.giveInventoryItem({user_id, Config.DirtyItem, tonumber(reward), false})
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                else
                    vRP.giveMoney({user_id, reward})
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                end
            else
                local Item = Config.ItemReward[math.random(1,#Config.ItemReward)]
                vRP.giveInventoryItem({user_id,Item.navn, Item.antal, false})
                Log('ID: '..user_id..' modtog '..Item.navn ..' x'..Item.antal)
                Notify('Gerald', 'Du modtog '..Item.navn ..' x'..Item.antal, 5000, 'success')
                ResetTimes(source)
            end
        end
    end)


    RegisterNetEvent('Kian_gerald:StartReward', function()
        local user_id = vRP.getUserId({source})
        reward = math.floor(Config.MoneyReward/4)

        if user_id ~= nil then
            if Config.RewardType == 'money' then
                if Config.Dirtymoney then
                    vRP.giveInventoryItem({user_id, Config.DirtyItem, tonumber(reward), false})
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                else
                    vRP.giveMoney({user_id, reward})
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                end
            else
                local Item = Config.ItemReward[math.random(1,#Config.ItemReward)]
                vRP.giveInventoryItem({user_id,Item.navn, Item.antal, false})
                Log('ID: '..user_id..' modtog '..Item.navn ..' x'..Item.antal..'')
                Notify('Gerald', 'Du modtog '..Item.navn ..' x'..Item.antal, 5000, 'success')
                ResetTimes(source)
            end
        end
    end)


    RegisterNetEvent('Kian_gerald:RecivePackage', function()
        local user_id = vRP.getUserId({source})

        if user_id ~= nil then
            vRP.giveInventoryItem({user_id, Config.Item, 1})
        end
    end)

    RegisterNetEvent('Kian_gerald:GivePackage', function()
        local user_id = vRP.getUserId({source})
        local result = MySQL.Sync.fetchAll("SELECT * FROM Kian_gerald WHERE user_id = @user_id", {user_id = user_id})
        local times = result[1].times + 1

        if user_id ~= nil then
            vRP.tryGetInventoryItem({user_id, Config.Item, 1})
            MySQL.Async.execute("UPDATE Kian_gerald SET times = @times WHERE user_id = @user_id", {user_id = user_id, times = times})
        end
    end)

    RegisterNetEvent('Kian_gerald:SetLamarStatus', function(status)
        local user_id = vRP.getUserId({source})
        local result = MySQL.Sync.fetchAll("SELECT * FROM Kian_gerald WHERE user_id = @user_id", {user_id = user_id})

        if user_id ~= nil then
            if #result > 0 then
                MySQL.Async.execute("UPDATE Kian_gerald SET lamar = @lamar WHERE user_id = @user_id", {user_id = user_id, lamar = status})
            else
                MySQL.Async.execute("INSERT INTO Kian_gerald (user_id, lamar) VALUES(@user_id, @lamar)", {user_id = user_id, lamar = status})
            end
        end
    end)

    RegisterServerCallback('Kian_gerald:antalcheck',function(source, cb)
        local user_id = vRP.getUserId({source})

        if user_id ~= nil then
            MySQL.Async.fetchAll('SELECT * FROM kian_gerald WHERE user_id = @user_id', {user_id = user_id}, function(result)
                if #result > 0 then
                    if result[1].times >= Config.Runs then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            end)
        end
    end)

    RegisterServerCallback('Kian_gerald:itemcheck',function(source, cb)
        local user_id = vRP.getUserId({source})

        if user_id ~= nil then
            if vRP.hasInventoryItem({user_id, Config.Item, 1}) then
                cb(true)
            else
                cb(false)
            end
        end
    end)

    RegisterServerCallback('Kian_gerald:LamarCheck',function(source, cb)
        local user_id = vRP.getUserId({source})

        if user_id ~= nil then
            MySQL.Async.fetchAll('SELECT * FROM kian_gerald WHERE user_id = @user_id', {user_id = user_id}, function(result)
                if #result > 0 then
                    cb(result[1].lamar)
                end
            end)
        end
    end)

    function ResetTimes(source)
        local user_id = vRP.getUserId({source})
        MySQL.Async.execute("UPDATE Kian_gerald SET times = @times WHERE user_id = @user_id", {user_id = user_id, times = 0})
    end
        --------------
else    -- ESX KODE --
        --------------
    ESX = nil

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    RegisterNetEvent('Kian_gerald:Reward', function()
        local user_id = ESX.GetPlayerFromId(source)
        reward = Config.MoneyReward

        if user_id ~= nil then
            if Config.RewardType == 'money' then
                if Config.Dirtymoney then
                    user_id.addInventoryItem(Config.DirtyItem, tonumber(reward))
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                else
                    user_id.addMoney(reward)
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                end
            else
                local Item = Config.ItemReward[math.random(1,#Config.ItemReward)]
                user_id.addInventoryItem(Item.navn, Item.antal)
                Log('ID: '..user_id..' modtog '..Item.navn ..' x'..Item.antal)
                Notify('Gerald', 'Du modtog '..Item.navn ..' x'..Item.antal, 5000, 'success')
                ResetTimes(source)
            end
        end
    end)


    RegisterNetEvent('Kian_gerald:StartReward', function()
        local user_id = ESX.GetPlayerFromId(source)
        reward = math.floor(Config.MoneyReward/4)

        if user_id ~= nil then
            if Config.RewardType == 'money' then
                if Config.Dirtymoney then
                    user_id.addInventoryItem(Config.DirtyItem, tonumber(reward))
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                else
                    user_id.addMoney(reward)
                    Log('ID: '..user_id..' modtog '..reward..' DKK')
                    Notify('Gerald', 'Du modtog '..reward..' DKK', 5000, 'success')
                    ResetTimes(source)
                end
            else
                local Item = Config.ItemReward[math.random(1,#Config.ItemReward)]
                user_id.addInventoryItem(Item.navn, Item.antal)
                Log('ID: '..user_id..' modtog '..Item.navn ..' x'..Item.antal)
                Notify('Gerald', 'Du modtog '..Item.navn ..' x'..Item.antal, 5000, 'success')
                ResetTimes(source)
            end
        end
    end)


    RegisterNetEvent('Kian_gerald:RecivePackage', function()
        local user_id = ESX.GetPlayerFromId(source)

        if user_id ~= nil then
            user_id.addInventoryItem(Config.Item, 1)
        end
    end)

    RegisterNetEvent('Kian_gerald:GivePackage', function()
        local user_id = ESX.GetPlayerFromId(source)
        local identifier = GetPlayerIdentifiers(source)[1]
        local result = MySQL.Sync.fetchAll("SELECT * FROM Kian_gerald WHERE user_id = @user_id", {user_id = identifier})
        local times = result[1].times + 1

        if user_id ~= nil then
            user_id.removeInventoryItem(Config.Item, 1)
            MySQL.Async.execute("UPDATE Kian_gerald SET times = @times WHERE user_id = @user_id", {user_id = identifier, times = times})
        end
    end)

    RegisterNetEvent('Kian_gerald:SetLamarStatus', function(status)
        local user_id = ESX.GetPlayerFromId(source)
        local identifier = GetPlayerIdentifiers(source)[1]
        local result = MySQL.Sync.fetchAll("SELECT * FROM Kian_gerald WHERE user_id = @user_id", {user_id = identifier})

        if user_id ~= nil then
            if #result > 0 then
                MySQL.Async.execute("UPDATE Kian_gerald SET lamar = @lamar WHERE user_id = @user_id", {user_id = identifier, lamar = status})
            else
                MySQL.Async.execute("INSERT INTO Kian_gerald (user_id, lamar) VALUES(@user_id, @lamar)", {user_id = identifier, lamar = status})
            end
        end
    end)

    RegisterServerCallback('Kian_gerald:antalcheck',function(source, cb)
        local user_id = ESX.GetPlayerFromId(source)
        local identifier = GetPlayerIdentifiers(source)[1]

        if user_id ~= nil then
            MySQL.Async.fetchAll('SELECT * FROM kian_gerald WHERE user_id = @user_id', {user_id = identifier}, function(result)
                if #result > 0 then
                    if result[1].times >= Config.Runs then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            end)
        end
    end)

    RegisterServerCallback('Kian_gerald:itemcheck',function(source, cb)
        local user_id = ESX.GetPlayerFromId(source)

        if user_id ~= nil then
            if user_id.getInventoryItem(Config.Item).count > 0 then
                cb(true)
            else
                cb(false)
            end
        end
    end)

    RegisterServerCallback('Kian_gerald:LamarCheck',function(source, cb)
        local user_id = ESX.GetPlayerFromId(source)
        local identifier = GetPlayerIdentifiers(source)[1]

        if user_id ~= nil then
            MySQL.Async.fetchAll('SELECT * FROM kian_gerald WHERE user_id = @user_id', {user_id = identifier}, function(result)
                cb(result[1].lamar)
            end)
        end
    end)

    function ResetTimes(source)
        local identifier = GetPlayerIdentifiers(source)[1]
        MySQL.Async.execute("UPDATE Kian_gerald SET times = @times WHERE user_id = @user_id", {user_id = identifier, times = 0})
    end
end

    
-- Discord log system
function Log(besked)
	local embeds = {
		  {
			  ["color"] = "8663711",
			  ["title"] = "Gerald Tasks",
			  ["description"] = besked,
			  ["footer"] = {
				["text"] = "Kian_gerald",
			},
	  	}
	}
	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.Name, embeds = embeds, avatar_url = Config.Img}), { ['Content-Type'] = 'application/json' })
end
