local currentShop = nil

CreateThread(function()
    while true do
        Wait(0)
        for shop, data in pairs(Config.Shops) do
            local dist = #(GetEntityCoords(PlayerPedId()) - data.coords)
            if dist < 2.0 then
                DrawMarker(2, data.coords.x, data.coords.y, data.coords.z + 1.0, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, true)
                if dist < 1.0 then
                    currentShop = shop
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('mechanic:getGrade')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('mechanic:openMenu', function(grade)
    local options = {
        { title = 'Clock In', event = 'mechanic:clockIn' },
        { title = 'Clock Out', event = 'mechanic:clockOut' },
        { title = 'Claim Salary', event = 'mechanic:claimSalary' }
    }

    if Config.JobGrades[grade].canManage then
        table.insert(options, { title = 'Hire Employee', event = 'mechanic:hire' })
        table.insert(options, { title = 'Fire Employee', event = 'mechanic:fire' })
        table.insert(options, { title = 'Promote/Demote', event = 'mechanic:manageRoles' })
        table.insert(options, { title = 'Check Safe Balance', event = 'mechanic:checkSafe' })
        table.insert(options, { title = 'Pay Employee', event = 'mechanic:payEmployee' })
        table.insert(options, { title = 'Relocate Shop', event = 'mechanic:relocate' })
    end

    lib.registerContext({
        id = 'mechanic_menu',
        title = Config.Shops[currentShop].label,
        options = options
    })

    lib.showContext('mechanic_menu')
end)

RegisterNetEvent('mechanic:notify', function(msg, type)
    exports['okokNotify']:Alert("Mechanic", msg, 5000, type)
end)

RegisterCommand('customize', function()
    TriggerServerEvent('mechanic:openCustomizationMenu')
end, false)

RegisterNetEvent('mechanic:showCustomizationMenu', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        TriggerEvent('mechanic:notify', 'You are not in a vehicle.', 'error')
        return
    end

    lib.registerContext({
        id = 'customization_menu',
        title = 'Vehicle Customization',
        options = {
            { title = 'Primary Color', event = 'mechanic:setColor', args = { type = 'primary', color = 12 } },
            { title = 'Secondary Color', event = 'mechanic:setColor', args = { type = 'secondary', color = 5 } },
            { title = 'Pearlescent', event = 'mechanic:setPearlescent', args = { color = 3 } },
            { title = 'Tire Smoke', event = 'mechanic:setSmoke' },
            { title = 'Window Tint', event = 'mechanic:setTint', args = { tint = 3 } },
            { title = 'Wheels & Rims', event = 'mechanic:setWheels', args = { type = 7, style = 10 } },
            { title = 'Turbo & Engine', event = 'mechanic:setPerformance' },
            { title = 'Nitrous Boost', event = 'mechanic:setNitrous' }
        }
    })

    lib.showContext('customization_menu')
end)

RegisterNetEvent('mechanic:setColor', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleModKit(vehicle, 0)
    local r, g = GetVehicleColours(vehicle)
    if data.type == 'primary' then
        SetVehicleColours(vehicle, data.color, g)
    elseif data.type == 'secondary' then
        SetVehicleColours(vehicle, r, data.color)
    end
    TriggerEvent('mechanic:notify', 'Color updated!', 'success')
end)

RegisterNetEvent('mechanic:setPearlescent', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleExtraColours(vehicle, data.color, 0)
    TriggerEvent('mechanic:notify', 'Pearlescent applied!', 'success')
end)

RegisterNetEvent('mechanic:setSmoke', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    ToggleVehicleMod(vehicle, 20, true)
    SetVehicleTyreSmokeColor(vehicle, 255, 0, 0)
    TriggerEvent('mechanic:notify', 'Tire smoke added!', 'success')
end)

RegisterNetEvent('mechanic:setTint', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleWindowTint(vehicle, data.tint)
    TriggerEvent('mechanic:notify', 'Window tint applied!', 'success')
end)

RegisterNetEvent('mechanic:setWheels', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleWheelType(vehicle, data.type)
    SetVehicleMod(vehicle, 23, data.style, false)
    TriggerEvent('mechanic:notify', 'Wheels updated!', 'success')
end)

RegisterNetEvent('mechanic:setPerformance', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 11, 3, false)
    SetVehicleMod(vehicle, 12, 2, false)
    SetVehicleMod(vehicle, 13, 2, false)
    ToggleVehicleMod(vehicle, 18, true)
    TriggerEvent('mechanic:notify', 'Performance upgraded!', 'success')
end)

RegisterNetEvent('mechanic:setNitrous', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    ToggleVehicleMod(vehicle, 20, true)
    TriggerEvent('mechanic:notify', 'Nitrous installed!', 'success')
end)
