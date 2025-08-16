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
                        openMechanicMenu(shop)
                    end
                end
            end
        end
    end
end)

function openMechanicMenu(shop)
    lib.registerContext({
        id = 'mechanic_menu',
        title = Config.Shops[shop].label,
        options = {
            { title = 'Customize Vehicle', event = 'mechanic:customize' },
            { title = 'Hire Employee', event = 'mechanic:hire' },
            { title = 'Fire Employee', event = 'mechanic:fire' },
            { title = 'Check Salaries', event = 'mechanic:salary' },
            { title = 'Clocked In Status', event = 'mechanic:clocked' },
            { title = 'Relocate Shop', event = 'mechanic:relocate' },
        }
    })
    lib.showContext('mechanic_menu')
end
