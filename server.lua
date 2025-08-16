local employeeData = {}

RegisterNetEvent('mechanic:getGrade', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    local grade = employeeData[identifier] and employeeData[identifier].grade or 'mechanic'
    TriggerClientEvent('mechanic:openMenu', src, grade)
end)

RegisterNetEvent('mechanic:hire', function(targetId)
    local identifier = GetPlayerIdentifier(targetId)
    employeeData[identifier] = { grade = 'mechanic', clockedIn = true }
end)

RegisterNetEvent('mechanic:fire', function(targetId)
    local identifier = GetPlayerIdentifier(targetId)
    employeeData[identifier] = nil
end)

RegisterNetEvent('mechanic:manageRoles', function(targetId, newGrade)
    local identifier = GetPlayerIdentifier(targetId)
    if employeeData[identifier] then
        employeeData[identifier].grade = newGrade
    end
end)

RegisterNetEvent('mechanic:clocked', function()
    local list = {}
    for id, data in pairs(employeeData) do
        if data.clockedIn then
            table.insert(list, { id = id, grade = Config.JobGrades[data.grade].label })
        end
    end
    TriggerClientEvent('ox_lib:notify', source, { type = 'info', description = json.encode(list) })
end)

RegisterNetEvent('mechanic:salary', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    local grade = employeeData[identifier] and employeeData[identifier].grade or 'mechanic'
    local salary = Config.Salary[grade]
    TriggerClientEvent('ox_lib:notify', src, { type = 'info', description = 'Your salary: $' .. salary })
end)
