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
        { title = 'Claim Salary', event = 'mechanic:claimSalary' },
        { title = 'Customize Vehicle', event = 'mechanic:customizeVehicle' }
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
