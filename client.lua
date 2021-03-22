DBFW = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if DBFW == nil then
            TriggerEvent('DBFW:GetObject', function(obj) DBFW = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('dbfw-simcard:changeNumber')
AddEventHandler('dbfw-simcard:changeNumber', function(xPlayer) 
    DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
    local input = true
    Citizen.CreateThread(function()
        while input do
            if input == true then
                HideHudAndRadarThisFrame()
                if UpdateOnscreenKeyboard() == 3 then
                    input = false
                elseif UpdateOnscreenKeyboard() == 1 then
                    local inputText = GetOnscreenKeyboardResult()
                    local isValid = tonumber(inputText) ~= nil
                    if isValid then
                        if string.len(inputText) == 10 then
                            local rawNumber = number
                                TriggerServerEvent('dbfw-simcard:useSimCard', inputText)        
                                input = false
                            else
                            DBFW.Functions.Notify("Phone numbers need to be 10 digits!", "error")
                            DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
                        end
                    else
                        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 20)
                        DBFW.Functions.Notify("Phone numbers must only contain digits!", "error")
                    end   
                elseif UpdateOnscreenKeyboard() == 2 then
                    input = false
                end
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('dbfw-simcard:startNumChange')
AddEventHandler('dbfw-simcard:startNumChange', function(newNum)

    DBFW.Functions.Progressbar("number_change", "Changing Phone Number", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@business@bgen@bgen_no_work@",
        anim = "sit_phone_idle_01_nowork" ,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        DBFW.Functions.Notify("Phone number updated to " .. newNum)
        TriggerServerEvent('dbfw-simcard:changeNumber', newNum)        
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@amb@business@bgen@bgen_no_work@", "sit_phone_idle_01_nowork", 1.0)
        DBFW.Functions.Notify("Failed!", "error")
    end)
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end