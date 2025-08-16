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

RegisterNetEvent('mechanic:getGrade',
