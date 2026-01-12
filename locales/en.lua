local Translations = {
    -- Menu principal
    menu_title = "👮‍♂️ LSPD",
    take_service = "✅ Prendre son service",
    end_service = "⏹️ Terminer son service",
    armory = "🧰 Armurerie",
    vehicles = "🚗 Véhicules",
    personal_stash = "🗄️ Casier perso",
    boss_office = "👔 Bureau du chef",
    change_uniform = "👔 Changer d'uniforme",

    -- Notifications
    on_duty = "Tu es en service.",
    off_duty = "Tu as quitté ton service.",
    no_access = "Accès refusé.",
    no_player_nearby = "Aucun joueur à proximité.",
    player_cuffed = "Joueur menotté.",
    player_uncuffed = "Joueur libéré.",
    search_result = "🔍 Fouille : %s",
    nothing_found = "Rien trouvé.",
    fine_issued = "Amende appliquée.",
    fine_received = "Amende de $%s pour : %s",
    not_enough_money = "Le joueur n'a pas assez d'argent.",
    jail_started = "Dépôt en garde à vue (%s min).",
    jail_released = "Vous avez été libéré(e).",
    in_jail = "Vous êtes en garde à vue. Attendez...",
    radar_activated = "Radar activé",
    radar_deactivated = "Radar désactivé",
    speeding_alert = "🚨 %s à %s km/h !",
    photo_taken = "📸 Photo envoyée au central",
    bodycam_on = "🎥 Bodycam ACTIVÉE",
    bodycam_off = "⏹️ Bodycam DÉSACTIVÉE",
    bodycam_timeout = "⚠️ Enregistrement auto-stop (30 min)",
    radio_sent = "Message radio envoyé.",
    patrol_on = "Patrouille activée",
    patrol_off = "Patrouille désactivée",
    patrol_warning = "⚠️ Vous devez patrouiller dans une zone autorisée ! (Dernière: %s)",
    patrol_success = "✅ Patrouille active dans %s",
    license_suspended = "⚠️ Votre permis est suspendu pour 10 minutes !",
    grade_too_low = "Grade insuffisant.",
    k9_deployed = "K9 déployé",
    k9_target = "🚨 K9 LÂCHÉ ! Obéissez immédiatement !",
    swat_launched = "Opération SWAT lancée",
    swat_warning = "⚠️ SWAT EN APPROCHE – COUCHEZ-VOUS !",
    action_completed = "Action effectuée.",
    player_not_found = "Joueur introuvable.",

    -- Boss actions
    hire_player = "Embaucher",
    fire_player = "Renvoyer",
    promote_player = "Promouvoir",
    demote_player = "Rétrograder",
    citizenid_prompt = "CitizenID ou ID Steam",
    action_prompt = "Action",

    -- Vehicle names
    police_cruiser = "Police Cruiser",
    police_buffalo = "Police Buffalo",
    swat_van = "SWAT Van",
    police_maverick = "Police Maverick",

    -- Fines
    fine_speeding = "Excès de vitesse",
    fine_weapon = "Arme illégale",
    fine_drugs = "Possession de drogue",
    fine_stolen = "Véhicule volé",

    -- 10-Codes
    ten_4 = "10-4 (Reçu)",
    ten_7 = "10-7 (Hors service)",
    ten_8 = "10-8 (En service)",
    ten_20 = "10-20 (Position?)",
    ten_33 = "10-33 (Urgence!)",
    ten_99 = "10-99 (Crime en cours)",

    -- Uniforms
    uniform_recruit = "Recrue",
    uniform_officer = "Officier",
    uniform_sergeant = "Sergent",
    uniform_lieutenant = "Lieutenant",
    uniform_boss = "Chef"
}

Lang = Lang or {}
Lang.en = Lang.en or {}
Lang.en.police = Translations

    -- Walkie
    walkie_on = "📻 Talkie activé",
    walkie_off = "📴 Talkie désactivé",
    walkie_no_channel = "Aucun canal sélectionné",
    walkie_police_only = "Réservé à la police",
    walkie_message = "📻 [%s] %s"