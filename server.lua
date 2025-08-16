local employeeData = {}
local jsonFile = 'data.json'
local safeBalance = Config.SafeAmount

local function loadData()
    local file = LoadResourceFile(GetCurrentResourceName(), jsonFile)
    if file then employeeData = json.decode(file) or {} end
end

local function saveData()
    SaveResourceFile(GetCurrentResourceName(), jsonFile, json.encode(employeeData), -1)
end

loadData()

RegisterNetEvent('mechanic:getGrade', function()
    local src = source
    local id = GetPlayerIdentifier(src)
    local grade = employeeData[id] and employeeData[id].grade or 'mechanic'
    TriggerClientEvent('mechanic:openMenu', src, grade)
end)

RegisterNetEvent('mechanic:clockIn', function()
    local src = source
    local id = GetPlayerIdentifier(src)
    employeeData[id] = employeeData[id] or { grade = 'mechanic', clockedIn = false, time = 0 }
    employeeData[id].clockedIn = true
    employeeData[id].startTime = os.time()
    saveData()
    TriggerClientEvent('mechanic:notify', src, 'Clocked in!', 'success')
end)

RegisterNetEvent('mechanic:clockOut', function()
    local src = source
    local id = GetPlayerIdentifier(src)
    if employeeData[id] and employeeData[id].clockedIn then
        local session = os.time() - (employeeData[id].startTime or os.time())
        employeeData[id].time = (employeeData[id].time or 0) + session
        employeeData[id].clockedIn = false
        saveData()
        TriggerClientEvent('mechanic:notify', src, 'Clocked out!', 'info')
    end
end)

RegisterNetEvent('mechanic:claimSalary', function()
    local src = source
    local id = GetPlayerIdentifier(src)
    local data = employeeData[id]
    if data and data.time >= Config.RequiredHours then
        local salary = Config.Salary[data.grade]
        TriggerClientEvent('mechanic:notify', src, 'Salary claimed: $' .. salary, 'success')
        data.time = 0
        saveData()
    else
        TriggerClientEvent('mechanic:notify', src, 'You need 6 hours of work to claim salary.', 'error')
    end
end)

RegisterNetEvent('mechanic:hire', function(targetId)
    local id = GetPlayerIdentifier(targetId)
    employeeData[id] = { grade = 'mechanic', clockedIn = false, time = 0 }
    saveData()
end)

RegisterNetEvent('mechanic:fire', function(targetId)
    local id = GetPlayerIdentifier(targetId)
    employeeData[id] = nil
    saveData()
end)

RegisterNetEvent('mechanic:manageRoles', function(targetId, newGrade)
    local id = GetPlayerIdentifier(targetId)
    if employeeData[id] then
        employeeData[id].grade = newGrade
        saveData()
    end
end)

RegisterNetEvent('mechanic:checkSafe', function()
    local src = source
    TriggerClientEvent('mechanic:notify', src, 'Safe Balance: $' .. safeBalance, 'info')
end)

RegisterNetEvent('mechanic:payEmployee', function(targetId, amount)
    local src = source
    if safeBalance >= amount then
        safeBalance = safeBalance - amount
        TriggerClientEvent('mechanic:notify', src, 'Paid employee $' .. amount, 'success')
        save
