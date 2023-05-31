local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('tgiann-kosetut:satis-gerceklesti', function(source, cb, RastgeleEsya, fiyat, miktar, key)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveItem(RastgeleEsya, miktar, xPlayer.Functions.GetItemByName(RastgeleEsya).slot) then
        xPlayer.Functions.AddMoney('cash', fiyat*miktar)
        TriggerClientEvent('obu:notify', source, miktar ..' Adet '.. QBCore.Shared.Items[RastgeleEsya].label ..' '.. fiyat*miktar ..'$ Karşılığında Satıldı')
        cb(true)
    else
        TriggerClientEvent('obu:notify', source, "Alıcı Üstündeki Hiç Bir Eşyayı Almak İstemiyor")
        cb(false)
    end
end)
