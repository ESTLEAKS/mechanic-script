Config = {}

Config.Shops = {
    ['pillbox'] = {
        coords = vector3(117.0, -1300.0, 29.0),
        label = 'Pillbox Mechanic',
        uiLocation = vector3(117.0, -1300.0, 29.0),
    },
    ['sandy'] = {
        coords = vector3(1737.0, 3709.0, 34.0),
        label = 'Sandy Mechanic',
        uiLocation = vector3(1737.0, 3709.0, 34.0),
    }
}

Config.JobGrades = {
    ['boss'] = { label = 'Boss', canCustomize = true, canManage = true },
    ['supervisor'] = { label = 'Supervisor', canCustomize = true, canManage = false },
    ['mechanic'] = { label = 'Mechanic', canCustomize = false, canManage = false }
}

Config.Salary = {
    mechanic = 500,
    supervisor = 800,
    boss = 1200
}



