Config = {}

-- Grades + uniformes (tenues via qb-clothing ou esx_skin)
Config.Ranks = {
    [0] = { name = "recruit", label = "Recrue", payment = 100, outfit = "police_recruit" },
    [1] = { name = "officer", label = "Officier", payment = 150, outfit = "police_officer" },
    [2] = { name = "sergeant", label = "Sergent", payment = 200, outfit = "police_sergeant" },
    [3] = { name = "lieutenant", label = "Lieutenant", payment = 250, outfit = "police_lieutenant" },
    [4] = { name = "boss", label = "Chef", payment = 300, outfit = "police_boss" }
}

-- Lieux
Config.Locations = {
    station = vector4(425.13, -979.38, 30.71, 206.0),
    armory = vector3(452.83, -983.51, 30.69),
    vehicle = vector4(460.0, -1015.0, 28.5, 90.0),
    stash = vector3(457.0, -980.0, 30.7),
    boss = vector3(432.0, -982.0, 30.7),
    jail = vector3(453.0, -1017.0, 28.0),
    helicopter = vector4(402.0, -950.0, 40.0, 0.0)
}

-- Véhicules
Config.Vehicles = {
    ["police"] = "Police Cruiser",
    ["police2"] = "Police Buffalo",
    ["riot"] = "SWAT Van"
}
Config.Helicopter = "polmav"

-- Amendes
Config.Fines = {
    speeding = { label = "Excès de vitesse", base = 150 },
    weapon = { label = "Arme illégale", base = 500 },
    drugs = { label = "Drogue", base = 1000 },
    stolen = { label = "Véhicule volé", base = 2000 }
}

-- Permis
Config.License = {
    maxPoints = 12,
    pointsPerFine = { speeding = 1, weapon = 3, drugs = 4, stolen = 6 },
    suspensionDuration = 600000
}

-- Zones patrouille
Config.PatrolZones = {
    { name = "Downtown", min = vector3(200.0, -1000.0, 0.0), max = vector3(600.0, -600.0, 100.0) },
    { name = "Vinewood", min = vector3(-1000.0, -1000.0, 0.0), max = vector3(-500.0, -500.0, 100.0) }
}

-- 10-Codes
Config.TenCodes = {
    "10-4 (Reçu)",
    "10-7 (Hors service)",
    "10-8 (En service)",
    "10-20 (Position?)",
    "10-33 (Urgence!)",
    "10-99 (Crime en cours)"
}

-- Bodycam
Config.Bodycam = {
    durationLimit = 1800000 -- 30 minutes max d'enregistrement
}