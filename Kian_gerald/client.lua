Active = false
PackagedCreated = false
LamarStatus = 0
TalkedToLamar = false
blip2 = nil
PackageActive = false
Cooldown = 0

Location = nil

local jacket_var = 0
local shirt_var = 0
local arms_var =  0
local pants_var =  0
local feet_var = 0
local mask_var = 0
local vest_var = 0
local hair_var = 0
local hair_var = 0
local hat_prop = 0
local glass_prop = 0

local tjekket = false
local HasItem = false
local Doneit = false


function Notify(titel, msg, tid, type)
    exports['okokNotify']:Alert(titel, msg, tonumber(tid), type)
end

CreateThread(function()
    while true do
        Wait(0)
        if not PackageActive then
            if LamarStatus > 0 then
                Location = math.random(1, #Config.Locations)
                distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -59.568,-1530.278,34.235, false)
                if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    if distance < 50.0 then
                            if not tjekket then
                                tjekket = true
                                ItemCheck()
                                Wait(5000)
                            else
                                if not HasItem then
                                    if LamarStatus == 2 then
                                        if distance <= 10.0 and distance >= 2.0 then
                                            DrawMarker(20, -59.568,-1530.278,34.235, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 52, 103, 235, 100, false, true, 2, false, false, false, false)
                                            elseif distance <= 2.0 then
                                            if Cooldown == 0 then 
                                                DrawText3D(-59.568,-1530.278,34.235, Lang['talk_gerald'])
                                                if IsControlJustPressed(0, 38) then
                                                    Notify('Gerald', Lang['hent_pakke'], 10000, 'info')
                                                    CreatePackage(Config.Locations[Location].x, Config.Locations[Location].y, Config.Locations[Location].z)
                                                    tjekket = false
                                                end
                                            else
                                                DrawText3D(-59.568,-1530.278,34.235, Lang['cooldown']..' ~w~('..Cooldown..' min)')
                                            end
                                        end
                                    end
                                else
                                    if distance <= 10.0 and distance >= 2.0 then
                                        DrawMarker(20, -59.568,-1530.278,34.235, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 52, 103, 235, 100, false, true, 2, false, false, false, false)
                                        elseif distance <= 2.0 then
                                            DrawText3D(-59.568,-1530.278,34.235, Lang['aflever_talk_gerald'])
                                        if IsControlJustPressed(0, 38) then
                                            TriggerServerEvent('Kian_gerald:GivePackage')
                                            TriggerEvent('Kian_gerald:startAfleverCutscene')
                                            RemoveBlip(blip2)
                                            tjekket = false
                                        end
                                    end
                                end
                            end
                        end
                elseif distance > 50.0 and distance < 100.0 then
                    tjekket = false
                end
            end
        end
    end
end)


CreateThread(function()
    while not TalkedToLamar do
        Wait(0)
        Location = math.random(1, #Config.Locations)
        distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 370.66,278.74,103.18, false)
        if LamarStatus == 0 then
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if distance <= 10.0 and distance >= 2.0 then
                    DrawMarker(20, 370.66,278.74,103.18, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 52, 103, 235, 100, false, true, 2, false, false, false, false)
                    elseif distance <= 2.0 then
                        DrawText3D(370.66,278.74,103.18, Lang['talk_lamar'])
                    if IsControlJustPressed(0, 38) then
                        PlayCutscene('mp_intro_mcs_8_a1')
                        CreatePackage(Config.Locations[Location].x, Config.Locations[Location].y, Config.Locations[Location].z)
                        Notify('Lamar', Lang['hent_pakke'], 10000, 'info')
                        TriggerServerEvent('Kian_gerald:SetLamarStatus', 1)
                        TalkedToLamar = true
                    end
                end
            end
        end
    end
end)

function CreatePackage(x,y,z)
    local blip = CreateJobBlip(x, y, z)
    local pakke = CreateObject(-1964997422, x,y,z - 1, true, true, 1)
    SetEntityAsMissionEntity(pakke, 1, 1)
    PackagedCreated = true
    PackageActive = true
    
    CreateThread(function()
        while PackagedCreated do
            Wait(0)
    		distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x,y,z, false)
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if distance <= 10.0 and distance >= 2.0 then
                    DrawMarker(20, x,y,z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 52, 103, 235, 100, false, true, 2, false, false, false, false)
                    elseif distance <= 2.0 then
                        DrawText3D(x,y,z, Lang['pickup_package'])
                    if IsControlJustPressed(0, 38) then
                        RemoveBlip(blip)
                        PackagedCreated = false
                        pickupPackage()
                        Wait(600)
                        DeleteEntity(pakke)
                        PackageActive = false
                        Active = false
                        blip2 = CreateJobBlip(-59.568,-1530.278,34.235)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent('Kian_gerald:startAfleverCutscene', function()
    local ped = PlayerPedId()

    if LamarStatus == 2 then
        TriggerServerCallback('Kian_gerald:antalcheck', function(cb)
            if cb then
                DoneIt = true
            else
                DoneIt = false
            end
    
            if DoneIt then
                PlayCutscene('mp_intro_mcs_10_a5')
                TriggerServerEvent('Kian_gerald:Reward')
                Cooldown = Config.Cooldown
            else
                PlayCutscene('mp_intro_mcs_10_a3')
                CreatePackage(Config.Locations[Location].x, Config.Locations[Location].y, Config.Locations[Location].z)
                Notify('Gerald', Lang['hent_pakke'], 5000, 'info')
            end
        end)
    else
        Cooldown = Config.Cooldown/2
        TriggerServerEvent('Kian_gerald:StartReward')
        PlayCutscene('mp_intro_mcs_10_a1')
        TriggerServerEvent('Kian_gerald:SetLamarStatus', 2)
    end
end)

function pickupPackage()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'pickup_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    exports['progressBars']:startUI(1000, Lang['progressbar'])
    Wait(1000)
    TriggerServerEvent('Kian_gerald:RecivePackage')
    Notify('Gerald', Lang['deliver_gerald'], 5000, 'info')
    ClearPedSecondaryTask(PlayerPedId())
    tjekket = false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

RegisterNetEvent('Kian_gerald:save_clothes', function()
    local ped = GetPlayerPed(-1)

    jacket_var = GetPedDrawableVariation(ped, 11)
    shirt_var = GetPedDrawableVariation(ped, 8)
    arms_var = GetPedDrawableVariation(ped, 3)
    pants_var = GetPedDrawableVariation(ped, 4)
    feet_var = GetPedDrawableVariation(ped, 6)
    mask_var = GetPedDrawableVariation(ped, 1)
    vest_var = GetPedDrawableVariation(ped, 9)
    hair_var = GetPedDrawableVariation(ped, 2)
    hat_prop = GetPedPropIndex(ped, 0)
    glass_prop = GetPedPropIndex(ped, 1)

    
    jacket_tex = GetPedTextureVariation(ped, 11)
    shirt_tex = GetPedTextureVariation(ped, 8)
    arms_tex = GetPedTextureVariation(ped, 3)
    pants_tex = GetPedTextureVariation(ped, 4)
    feet_tex = GetPedTextureVariation(ped, 6)
    mask_tex = GetPedTextureVariation(ped, 1)
    vest_tex = GetPedTextureVariation(ped, 9)
    hair_tex = GetPedTextureVariation(ped, 2)
    hat_tex = GetPedPropTextureIndex(ped, 0)
    glass_tex = GetPedPropTextureIndex(ped, 1)

    
    jacket_pal = GetPedPaletteVariation(ped, 11)
    shirt_pal = GetPedPaletteVariation(ped, 8)
    arms_pal = GetPedPaletteVariation(ped, 3)
    pants_pal = GetPedPaletteVariation(ped, 4)
    feet_pal = GetPedPaletteVariation(ped, 6)
    mask_pal = GetPedPaletteVariation(ped, 1)
    vest_pal = GetPedPaletteVariation(ped, 9)
    hair_pal = GetPedPaletteVariation(ped, 2)
end)

function PlayCutscene(cutscene)
    local ped = GetPlayerPed(-1)

    TriggerEvent('Kian_gerald:save_clothes')
    RequestCutscene(cutscene, 8)

    while not (HasCutsceneLoaded()) do
        Wait(0)
        RequestCutscene(cutscene, 8)
    end

    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(PlayerPedId(-1), 'MP_1', 0, 0, 64)
    SetCutsceneEntityStreamingFlags('MP_2',0,1)
    SetCutsceneEntityStreamingFlags('MP_3',0,1)
    SetCutsceneEntityStreamingFlags('MP_4',0,1)
    RegisterEntityForCutscene(0, 'MP_2', 3, GetHashKey('mp_f_freemode_01'), 0)
    RegisterEntityForCutscene(0, 'MP_3', 3, GetHashKey('mp_f_freemode_01'), 0)
    RegisterEntityForCutscene(0, 'MP_4', 3, GetHashKey('mp_f_freemode_01'), 0)

    StartCutscene(0)
    DoScreenFadeIn(0)

    while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
    end

    SetCutscenePedComponentVariationFromPed(PlayerPedId(), ped, GetHashKey('mp_m_freemode_01'))
    SetPedComponentVariation(ped, 11, jacket_var, jacket_tex, jacket_pal)
    SetPedComponentVariation(ped, 8, shirt_var, shirt_tex, shirt_pal)
    SetPedComponentVariation(ped, 3, arms_var, arms_tex, arms_pal)
    SetPedComponentVariation(ped, 4, pants_var, pants_tex,pants_pal)
    SetPedComponentVariation(ped, 6, feet_var, feet_tex,feet_pal)
    SetPedComponentVariation(ped, 1, mask_var, mask_tex,mask_pal)
    SetPedComponentVariation(ped, 9, vest_var, vest_tex,vest_pal)
    SetPedComponentVariation(ped, 2, hair_var, hair_tex,hair_pal)
    SetPedPropIndex(ped, 2, hair_var,  hair_tex, hair_pal)
    SetPedPropIndex(ped, 0, hat_prop, hat_tex, 0)
    SetPedPropIndex(ped, 1, glass_prop, glass_tex, 0)

    while not (HasCutsceneFinished()) do
        Wait(0)
    end
    tjekket = false
end


CreateThread(function()
    while true do
        Wait(Config.Interval)
            TriggerServerCallback('Kian_gerald:LamarCheck', function(cb)
            LamarStatus = tonumber(cb)
        end)
    end
end)

function AntalCheck()
    TriggerServerCallback('Kian_gerald:antalcheck', function(cb)
        if cb then
            DoneIt = true
        else
            DoneIt = false
        end
    end)
end

function ItemCheck()
    TriggerServerCallback('Kian_gerald:itemcheck', function(cb)
        if cb then
            HasItem = true
        else
            HasItem = false
        end
    end)
end

function CreateJobBlip(x,y,z)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', "Hent Pakke")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.75)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end


CreateThread(function()
    while true do
       Wait(60000)
       if Cooldown >= 1 then
        Cooldown = Cooldown - 1
       end
    end
end)
 