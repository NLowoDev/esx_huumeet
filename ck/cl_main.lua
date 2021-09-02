ESX = nil
local taynna = false
local teksti22
local huumepaikat = {
    --vituttaako kun et saanu dumpattua?
}

--made by karpo#1943

CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    ESX.TriggerServerCallback("karpo_huumeet:otapaikat", function(umad)
        huumepaikat = umad
    end)
    Wait(300) --venataan et saadaan servun puolelta huumeet
    while true do
        local wait = 1000
        local coords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(huumepaikat) do
            local x, y, z = huumepaikat[k].pos.x, huumepaikat[k].pos.y, huumepaikat[k].pos.z
            local huumepaikka = #(huumepaikat[k].pos - coords) --OMG MATEMATIIKKA OLI YHDEKSÄN OMFGFOGMFGMFG
            if huumepaikka < 2.9 then 
                wait = 5
                if not keraamassa or taynna then
                    if huumepaikat[k].tyyppi == "kerays" then
                        teksti(x, y, z, tostring("~w~Paina ~g~E ~w~ kerätäksesi: " ..huumepaikat[k].nimi))
                    else 
                        teksti(x, y, z, tostring("~w~Paina ~g~E ~w~ pussittaaksesi: " ..huumepaikat[k].nimi))
                    end
                    if IsControlJustPressed(0, 38) then
                        keraa(k)
                    end
                else
                    teksti(x, y, z, tostring("~w~Paina ~r~DELETE ~w~ lopettaaksesi!"))
                end
                if keraamassa and not taynna then
                    if not IsPedUsingAnyScenario(PlayerPedId()) then
                        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                    end
                    if IsControlJustPressed(0, 178) then
                        keraamassa = false 
                        ClearPedTasks(PlayerPedId())
                    end
                end
            end
        end
        Wait(wait)
    end
end)

function keraa(paikka)
    if huumepaikat[paikka].tyyppi == "kerays" then
        teksti22 = "Kerätään"
    else
        teksti22 = "Pussitetaan"
    end
    ESX.TriggerServerCallback("karpo_huumeet:boliseja", function(bolis)
        if bolis >= Config.poliiseja then
            if not taynna then
                keraamassa = true
                Wait(200)
                if keraamassa then
                        TriggerEvent("mythic_progbar:client:progress", {
                        name = "huume",
                        duration = Config.kuinusein* 1000,
                        label = teksti22,
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }
                    }, function(canceled)
                        if not canceled then
                            TriggerServerEvent("karpo_huumeet:itemi", paikka)
                            keraa(paikka)
                        else
                            ClearPedTasks(PlayerPedId())
                            keraamassa = false
                        end
                    end)
                end
            else
                ClearPedTasks(PlayerPedId())
            end
        end
    end)
end

function teksti(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local kx, ky, kz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(kx, ky, kz, x,y,z, 1)
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = 1.0
   
    if onScreen then
        SetTextScale(0.0*scale, 0.25*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(0, 0, 0, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
    	DrawRect(_x,_y+0.0125, 0.013+ factor, 0.03, 0, 0, 0, 68)
    end
end

RegisterNetEvent("karpo_huumeet:jokupaska")
AddEventHandler("karpo_huumeet:jokupaska", function(lol,lol2)
    taynna = lol
    keraamassa = lol2
    Wait(2000)
    taynna = false
end)

RegisterNetEvent("karpo_huumeet:notifi")
AddEventHandler("karpo_huumeet:notifi", function(msg)
    ESX.ShowAdvancedNotification('Huumeet', msg, '', "CHAR_LESTER_DEATHWISH", 1)
end)
