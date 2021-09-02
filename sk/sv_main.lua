ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local huumepaikat = {
    koksukerays = {
        pos = vector3(1409.64, -625.18, 76.28),
        nimi = "Kokaiini",
        tyyppi = "kerays",
        keraysitem = "coke",
        pussitusitem = "coke_pooch"
    },
    koksupussitus = {
        pos = vector3(1411.85, -620.88, 76.28),
        nimi = "Kokaiini",
        tyyppi = "pussitus",
        keraysitem = "coke",
        pussitusitem = "coke_pooch"
    },
    metakerays = {
        pos = vector3(0, 0, 0), --vaihda ite coords
        nimi = "Metamfetamiini",
        tyyppi = "kerays",
        keraysitem = "meth",
        pussitusitem = "meth_pooch"
    },
    metapussitus = {
        pos = vector3(0, 0, 0), --vaihda ite coords
        nimi = "Metamfetamiini",
        tyyppi = "pussitus",
        keraysitem = "meth",
        pussitusitem = "meth_pooch"
    }
}

RegisterNetEvent("karpo_huumeet:itemi")
AddEventHandler("karpo_huumeet:itemi", function(paikka) --spagettikoodia ei kiinnosta vittu
    local xPlayer = ESX.GetPlayerFromId(source)
    if huumepaikat[paikka].tyyppi == "pussitus" then
        local huumemaara = xPlayer.getInventoryItem(huumepaikat[paikka].keraysitem).count
        local huumenimi = xPlayer.getInventoryItem(huumepaikat[paikka].keraysitem).label
        if huumemaara >= 5 then
            local omistan = xPlayer.getInventoryItem(huumepaikat[paikka].pussitusitem)
			if omistan.count <= 50 then --kuin mont max
                xPlayer.removeInventoryItem(huumepaikat[paikka].keraysitem, 5)
                xPlayer.addInventoryItem(huumepaikat[paikka].pussitusitem, 1)
                TriggerClientEvent("karpo_huumeet:jokupaska", source, false, true)
            else
                TriggerClientEvent("karpo_huumeet:jokupaska", source, true, false)
                TriggerClientEvent("karpo_huumeet:notifi", source, "Reppusi on täynnä!")
            end
        else
            TriggerClientEvent("karpo_huumeet:jokupaska", source, true, false)
            TriggerClientEvent("karpo_huumeet:notifi", source, "Tarvitset: " ..huumenimi)
        end
    else
        local omistan22 = xPlayer.getInventoryItem(huumepaikat[paikka].keraysitem)
        if omistan22.count <= 250 then
            xPlayer.addInventoryItem(huumepaikat[paikka].keraysitem, 1)
            TriggerClientEvent("karpo_huumeet:jokupaska", source, false, true)
        else
            TriggerClientEvent("karpo_huumeet:jokupaska", source, true, false)
            TriggerClientEvent("karpo_huumeet:notifi", source, "Reppusi on täynnä!")
        end
    end
end)

ESX.RegisterServerCallback("karpo_huumeet:boliseja",function(source, cb)
    local bolis = 0
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
      local _source = xPlayers[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
      if xPlayer.job.name == 'police' then
        bolis = bolis + 1
      end
    end
    cb(bolis)
end)

ESX.RegisterServerCallback("karpo_huumeet:otapaikat",function(source, cb)
    cb(huumepaikat)
end)
