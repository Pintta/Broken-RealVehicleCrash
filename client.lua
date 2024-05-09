RegisterNetEvent('vehiclecrashmode', function(countDown, accidentLevel)
    local effectActive = false
    local blackOutActive = false
    local currAccidentLevel = 0
    local disableControls = false
    if not effectActive or (accidentLevel > currAccidentLevel) then
        currAccidentLevel = accidentLevel
        disableControls = true
        effectActive = true
        blackOutActive = true
	DoScreenFadeOut(100)
	Wait(1000)
        DoScreenFadeIn(250)
        blackOutActive = false
        StartScreenEffect('PeyoteEndOut', 0, true)
        StartScreenEffect('Dont_tazeme_bro', 0, true)
        StartScreenEffect('MP_race_crash', 0, true)
        while countDown > 0 do
            if countDown > (3.5*accidentLevel)   then 
                ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", (accidentLevel * 0.1))
            end 
            Wait(750)
            countDown = countDown - 1
            if countDown < 10 and disableControls then
                disableControls = false
            end
            if countDown <= 1 then
                StopScreenEffect('PeyoteEndOut')
                StopScreenEffect('Dont_tazeme_bro')
                StopScreenEffect('MP_race_crash')
            end
        end
        currAccidentLevel = 0
        effectActive = false
    end
end)

CreateThread(function()
	while true do
        Wait(50)
            local IsCar = function(veh)
                local vc = GetVehicleClass(veh)
                return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
            end
            local oldSpeed = 0.0
            local currentDamage = 0.0
            local oldBodyDamage = 0.0
            local currentSpeed = 0.0
            local wasInCar = false
            local disableControls = false
            vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)
            if DoesEntityExist(vehicle) and (wasInCar or IsCar(vehicle)) then
                wasInCar = true
                oldSpeed = currentSpeed
                oldBodyDamage = currentDamage
                currentDamage = GetVehicleBodyHealth(vehicle)
                currentSpeed = GetEntitySpeed(vehicle) * 2.23
                if currentDamage ~= oldBodyDamage then
                    if not effect and currentDamage < oldBodyDamage then
                        if (oldBodyDamage - currentDamage) >= 300 or (oldSpeed - currentSpeed)  >= 130 then
                            oldBodyDamage = currentDamage
                            TriggerEvent('vehiclecrashmode', 33, 5)
                        elseif (oldBodyDamage - currentDamage) >= 65 or (oldSpeed - currentSpeed)  >= 95 then
                            TriggerEvent('vehiclecrashmode', 25, 4)
                            oldBodyDamage = currentDamage
                        elseif (oldBodyDamage - currentDamage) >= 45 or (oldSpeed - currentSpeed)  >= 65 then   
                            oldBodyDamage = currentDamage
                            TriggerEvent('vehiclecrashmode', 19, 3)
                        elseif (oldBodyDamage - currentDamage) >= 25 or (oldSpeed - currentSpeed)  >= 45 then
                            oldBodyDamage = currentDamage
                            TriggerEvent('vehiclecrashmode', 13, 2)
                        elseif (oldBodyDamage - currentDamage) >= 15 or (oldSpeed - currentSpeed)  >= 20 then
                            oldBodyDamage = currentDamage
                            TriggerEvent('vehiclecrashmode', 9, 1)
                        end
                    end
                end
            elseif wasInCar then
                wasInCar = false
                beltOn = false
                currentDamage = 0
                oldBodyDamage = 0
                currentSpeed = 0
                oldSpeed = 0
            end
            local totta = true
        if disableControls and totta then
			DisableControlAction(0,71,true)
			DisableControlAction(0,72,true)
			DisableControlAction(0,63,true)
			DisableControlAction(0,64,true)
			DisableControlAction(0,75,true)
		end
	end
end)
