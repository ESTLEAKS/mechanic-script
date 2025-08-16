Config = {}

Config.Shops = {
    ['pillbox'] = {
        coords = vector3(117.0, -1300.0, 29.0),
        label = 'Pillbox Mechanic',
        uiLocation = vector3(117.0, -1300.0, 29.0),
    }
}

Config.JobGrades = {
    ['boss'] = { label = 'Boss', canCustomize = true, canManage = true },
    ['supervisor'] = { label = 'Supervisor', canCustomize = true, canManage = false },
    ['mechanic'] = { label = 'Mechanic', canCustomize = true, canManage = false }
}

Config.Salary = {
    mechanic = 500,
    supervisor = 800,
    boss = 1200
}

Config.RequiredHours = 6 * 60 * 60 -- 6 hours in seconds
Config.SafeAmount = 100000 -- Starting safe balance
