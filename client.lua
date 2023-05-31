local QBCore = exports['qb-core']:GetCoreObject()  

local satilanNpcler = {}
local rastgeleEsya, rastgeleEsyaAdi, rastgeleEsyaFiyati, miktar, npc, bolgeKordinat, bolgeAdi = nil, nil, nil, nil, nil, nil, nil
local koseTut, npcBulundu, npcAra, startCd = false, false, false, false, false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    firstLogin()
end)

function firstLogin()
    local PlayerData = QBCore.Functions.GetPlayerData()
end

RegisterCommand("köşetutiptal", function(source, args)
	if koseTut then
		startCd = true
		koseTutDurum(false)
		npcBulundu = false
		npcAra = false
		Citizen.Wait(300000)
		startCd = false
	end
end)

-- Test Blibi
local test = false
Citizen.CreateThread(function()
	if test then
		for kodadi, bolge in pairs(Config.bolge) do
			local kordinat = bolge.kordinat
			local blips = AddBlipForCoord(kordinat)
			SetBlipSprite(blips, 434)
			SetBlipColour(blips, 37)
			SetBlipScale(blips, 2.0)
			SetBlipAsShortRange(blips, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("?")
			EndTextCommandSetBlipName(blips)   
		end
	end
end)

local lastTime = 0
RegisterCommand("köşetut", function(source, args)
	if not startCd then
		if lastTime == 0 or GetGameTimer() > lastTime then
			lastTime = GetGameTimer() + 60000
			if not exports['obufl-base']:GetSecureStatus() then
				QBCore.Functions.TriggerCallback('obufl-base:polis-sayi', function(AktifPolis)
					if AktifPolis >= 1 then
						local playerPed = PlayerPedId()
						if not IsPedInAnyVehicle(playerPed) and not koseTut then
								
							miktar = 1
							if args[1] and tonumber(args[1]) < 2 then
									miktar = tonumber(args[1])
								end 

							koseTutDurum(true)
							npcBulundu = false
							npcAra = true
						elseif IsPedInAnyVehicle(playerPed) then
						exports['obu-notify']:SendAlert("Aracın içinde iken köşe tutamazsın")
						else
							exports['obu-notify']:SendAlert("Zaten Bir Köşe Tutuyorsun")
						end
					else
						exports['obu-notify']:SendAlert("Yeterli Sayıda Polis Yok!")
					end
				end)
			else
				exports['obu-notify']:SendAlert("1 Dakikada Bir Köşe Tutmayı Deneyebilirsin!", "error")
			end
		else
			exports['obu-notify']:SendAlert("Köşe Tutmayı Daha Yeni İptal Ettin 5 Dakika Sonra Tekrar Dene!", "error")
		end
	end
end)

local lastTime = 0
RegisterCommand("köşetut2", function(source, args)
	if not startCd then
		if lastTime == 0 or GetGameTimer() > lastTime then
			lastTime = GetGameTimer() + 60000
			if not exports['obufl-base']:GetSecureStatus() then
				QBCore.Functions.TriggerCallback('obufl:polis-sayi', function(AktifPolis)
					if AktifPolis >= 3 then
						local playerPed = PlayerPedId()
						if not IsPedInAnyVehicle(playerPed) and not koseTut then
								
							miktar = 2
							if args[1] and tonumber(args[1]) < 2 then
									miktar = tonumber(args[1])
								end 

							koseTutDurum(true)
							npcBulundu = false
							npcAra = true
						elseif IsPedInAnyVehicle(playerPed) then
						exports['obu-notify']:SendAlert("Aracın içinde iken köşe tutamazsın")
						else
							exports['obu-notify']:SendAlert("Zaten Bir Köşe Tutuyorsun")
						end
					else
						exports['obu-notify']:SendAlert("Yeterli Sayıda Polis Yok!")
					end
				end)
			else
				exports['obu-notify']:SendAlert("1 Dakikada Bir Köşe Tutmayı Deneyebilirsin!", "error")
			end
		else
			exports['obu-notify']:SendAlert("Köşe Tutmayı Daha Yeni İptal Ettin 5 Dakika Sonra Tekrar Dene!", "error")
		end
	end
end)

function DrawText3D(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.30, 0.30)

    SetTextFont(0)

    SetTextProportional(1)

    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")

    SetTextCentre(1)

    AddTextComponentString(text)

    DrawText(_x,_y)

    local factor = (string.len(text)) / 250

    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 140)

end

Citizen.CreateThread(function()
	while true do
		cd = 100
		if koseTut then
			if not npcBulundu and npcAra then
				cd = 5000
				local playerPed = PlayerPedId()
				local playerCoords = GetEntityCoords(playerPed)

				local bolgeBulundu = false
				for kodadi, bolge in pairs(Config.bolge) do
					local bolgeKordinat = bolge["kordinat"]
					if #(bolgeKordinat - playerCoords) < 35 then
						bolgeAdi = kodadi
						bolgeBulundu = true
						break
					end
				end

				if bolgeBulundu then
					exports['obu-notify']:SendAlert('Bu Köşeyi Tutmaya Devam Ediyorsun')
					Citizen.Wait(3000)
					npc = pedAra(playerPed)
				else
					koseTutDurum(false)
					npcAra = false
					npcBulundu = false
					exports['obu-notify']:SendAlert("Burada Köşe Tutamazsın", "error")
				end
			end

			if npcBulundu and not npcAra and not satilanNpcler[npc] then
				cd = 1
				local playerPed = PlayerPedId()
				local playerCoords = GetEntityCoords(playerPed)
				local npcCoords = GetEntityCoords(npc)
				local npcMesafe = #(npcCoords - playerCoords)

				if #(bolgeKordinat - playerCoords) < 100 then
					if npcMesafe < 50 then
						local npcArabada = IsPedInAnyVehicle(npc)
						if npcArabada then
							npcAraci = GetVehiclePedIsIn(npc, false)
						end

						DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z+1.05, "~g~[E] ~w~" .. miktar ..  " Adet " .. rastgeleEsyaAdi .." Sat / ".. rastgeleEsyaFiyati*miktar .."$ ~g~[H] ~w~Kov", 0.45)
						
						if HasEntityBeenDamagedByAnyPed(npc) then
							exports['obu-notify']:SendAlert("Alıcı Yaralandığı İçin Artık Bir Şey Almak İstemiyor!, Yeni Alıcı Aranıyor")
							tekrarNpcAra(true)
							exports['ps-dispatch']:kosetut()
							
						elseif npcMesafe <= 2.0 or npcArabada and npcMesafe < 15 then
							if npcArabada then
								FreezeEntityPosition(npcAraci, true)
							else
								FreezeEntityPosition(npc, true)
								QBCore.Shared.RequestAnimDict("anim@amb@clubhouse@mini@darts@", function()
									TaskPlayAnim(npc, "anim@amb@clubhouse@mini@darts@",  "wait_idle", 8.0, -8.0, -1, 0, 0, 0, 0, 0)
								end)
							end

							if npcMesafe <= 2.0 then
								if IsControlJustPressed(0, 51) then -- E
									satilanNpcler[npc] = true
									if math.random(1,100) < 80 then
										exports['ps-dispatch']:kosetut()
									end
									local durum = nil
									QBCore.Functions.TriggerCallback('obu-kosetut:satis-gerceklesti', function(durumx)
										durum = durumx
									end, rastgeleEsya, rastgeleEsyaFiyati, miktar, QBCore.Key)
									while durum == nil do Citizen.Wait(100) end
									if durum then
										animasyon(playerPed, "mp_common", "givetake1_a", false, npc)
										Citizen.Wait(350)
										tekrarNpcAra(false)
									else
										tekrarNpcAra(true)
									end
									Citizen.Wait(5000)
								elseif IsControlJustPressed(0, 304) then -- H
									exports['obu-notify']:SendAlert("Alıcıyı Kovdun")
									if math.random(1, 100) < 7 then
										TriggerEvent("tgiann-kosetut:async-polis-bildirim", "İllegal Şekilde ".. rastgeleEsyaAdi .." Satımı")
									end
									tekrarNpcAra(true)																
								end
							end
						else
							if npcArabada then
								FreezeEntityPosition(npcAraci, false)
							else
								FreezeEntityPosition(npc, false)
							end
						end
					else
						if math.random(1,100) < 7 then
							TriggerEvent("obu-kosetut:async-polis-bildirim", "Birisi İllegal Eşya Satmaya Çalışıyor!")
						end
						exports['obu-notify']:SendAlert("Alıcı Senden Çok Fazla Uzaklaştı")
						tekrarNpcAra(true)	
					end
				else
					exports['obu-notify']:SendAlert("Köşe Tutma Bölgesinden Çok Fazla Uzaklaştığın İçin Köşe Tutma İptal Oldu")
					if math.random(1,100) < 50 then
						TriggerEvent("obu-kosetut:async-polis-bildirim", "Birisi İllegal Eşya Satarken Kaçmaya Başladı!")
					end
					npcBulundu = false
					npcAra = false
					koseTutDurum(false)
				end
			end
		end
		Citizen.Wait(cd)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if npcBulundu and not IsPedInAnyVehicle(npc) then
			local playerPed = PlayerPedId()
	        local playerPos = GetEntityCoords(playerPed)
			TaskGoToCoordAnyMeans(npc, playerPos, 1.0, 0, 0, 786603, 0xbf800000)
		end	
	end
end)

RegisterNetEvent('obu-kosetut:async-polis-bildirim')
AddEventHandler('obu-kosetut:async-polis-bildirim', function(data)
    polisBildirim(data) 
end)

function animasyon(ped, ad, anim, npcArabada, npc)
	QBCore.Shared.RequestAnimDict(ad, function()
		if not npcArabada then
			TaskPlayAnim(npc, ad, anim, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
		end
		TaskPlayAnim(ped, ad, anim, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
	end)

	local time = 40000
	QBCore.Functions.Progressbar("satis", "Satış İşlemi Gerçekleşiyor", time, false, false, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = ad,
        anim = anim,
        flags = 49,
    }, {}, {}, function() -- Done
    end, function() -- Cancel
	end)
	Citizen.Wait(time)
end

function pedAra(playerPed)
	local playerCoords = GetEntityCoords(playerPed)
	local handle, ped = FindFirstPed()
	local success
	local rped = nil
	repeat
		local mesafe = #(playerCoords - GetEntityCoords(ped))
		if mesafe < 30.0 and not IsPedAPlayer(ped) and not satilanNpcler[ped] then
			rped = ped
			if not IsPedInAnyVehicle(rped) then
				exports['obu-notify']:SendAlert('Bir Alıcı Sana Doğru Geliyor')
			else
				exports['obu-notify']:SendAlert('Araç İçindeki Bir Alıcı Senden Bir Şey Almak İstiyor')
			end

			rastgeleEsyaSec = math.random(1, #Config.bolge[bolgeAdi]["esyalar"]) 
			rastgeleEsya = Config.bolge[bolgeAdi]["esyalar"][rastgeleEsyaSec]
			rastgeleEsyaAdi = QBCore.Shared.Items[rastgeleEsya].label
			rastgeleEsyaFiyati = math.random(exports["tgiann-base"]:KoseTut(rastgeleEsya).r1, exports["tgiann-base"]:KoseTut(rastgeleEsya).r2)
			bolgeKordinat = playerCoords
			satilanNpcler[rped] = false
			npcBulundu = true
			npcAra = false
			break
		end
		success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)
	return rped
end

function tekrarNpcAra(listeEkle)
	if listeEkle then
		satilanNpcler[npc] = true
	end
	Citizen.Wait(2000)
	if IsPedInAnyVehicle(npc) then
		local arac = GetVehiclePedIsIn(npc, false)
		TaskWanderStandard(arac, 10.0, 10)
		FreezeEntityPosition(arac, false)
	else
		TaskWanderStandard(npc, 10.0, 10)
		FreezeEntityPosition(npc, false)
		ClearPedTasks(npc)
	end
	ClearPedTasks(playerPed)
	Citizen.Wait(5000)
	npcBulundu = false
	npcAra = true
end

function koseTutDurum(data)
	koseTut = data
	TriggerEvent("obufl-base:kose-tut-vehicle", koseTut)
end