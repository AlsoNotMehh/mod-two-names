--[[
    AzerothCore mod-two-names: Client-side Character Creation Random Name Generator
    Author: AlsoNotMehh
    Provides rich, race-and-gender appropriate 2-part fantasy names (First + Last name)
    when clicking the Randomize button on the Character Creation screen.
--]]

local TwoNames_Surnames = {
    -- Human / Generic Alliance
    Human = {
        "Proudmoore", "Fordragon", "Lothar", "Arator", "Blackwood", "Ravencrest", "Stone", "Smith",
        "White", "Dawn", "Storm", "Lightbringer", "Silverhand", "Ashford", "Westfall", "Redpath",
        "Kingsley", "Bridge", "Fairweather", "Goldshire", "Crown", "Shields", "Rivers", "Valiant"
    },
    -- Dwarf
    Dwarf = {
        "Bronzebeard", "Wildhammer", "Thundermar", "Stonehearth", "Ironbreaker", "Stormforge", "Goldhammer",
        "Deepdelver", "Coppervein", "Firebeard", "Mountainpeak", "Anvilmar", "Alewatcher", "Grimaxe",
        "Stouthorn", "Steelgrip", "Rockseeker", "Thunderbrew", "Heavyanvil", "Flintstrike"
    },
    -- Night Elf
    NightElf = {
        "Moonwhisper", "Shadowglen", "Staghelm", "Whisperwind", "Nightfall", "Feathermoon", "Starbreeze",
        "Silverleaf", "Moonglade", "Windrunner", "Oakenshield", "Sunshadow", "Darkbranch", "Starwatcher",
        "Duskstrider", "Mistwalker", "Dawnseeker", "Rainstrider", "Gleamwing", "Moonshadow"
    },
    -- Gnome
    Gnome = {
        "Fizzlebang", "Cogspinner", "Gearwrench", "Springsprocket", "Tinkerspark", "Copperbolt", "Steamvalve",
        "Shortfuse", "Wobblecog", "Quicklever", "Blastgauge", "Microswitch", "Overclock", "Boltspinner",
        "Gyroscope", "Tinkertoy", "Clickwheel", "Pistonarm", "Sprocket", "Gizmoblast"
    },
    -- Draenei
    Draenei = {
        "Lightforged", "Vindicator", "Anchorite", "Starseeker", "Crystalvein", "Aldor", "Sunseeker",
        "Auchenai", "Velenor", "Argunite", "Kharash", "Luminor", "Telaar", "Naaruleen",
        "Lightweaver", "Exodar", "Aegis", "Peacekeeper", "Oronaar", "Shattrath"
    },
    -- Orc
    Orc = {
        "Hellscream", "Doomhammer", "Deadeye", "Frostwolf", "Skullcrusher", "Warsong", "Bloodaxe", "Blackrock",
        "Shatteredhand", "Ironjaw", "Bonebreaker", "Thunderaxe", "Ragefist", "Grimblood", "Scarhide",
        "Gorehowl", "Stormreaver", "Warhowl", "Direfang", "Redtusk"
    },
    -- Undead / Scourge
    Scourge = {
        "Gravewalker", "Shadowbane", "Blightcaller", "Plaguetouch", "Rotwood", "Coldwhisper", "Black",
        "Soulreaper", "Deathveil", "Gloomveil", "Bonechill", "Grimshade", "Cryptstalker", "Darksorrow",
        "Corpseborn", "Tombwarden", "Nightshroud", "Gravemourn", "Bitterfrost", "Hauntwood"
    },
    -- Tauren
    Tauren = {
        "Thunderhorn", "Bloodhoof", "Runetotem", "Grimtotem", "Sunstrider", "Skychaser", "Earthstrider",
        "Stonehoof", "Plainsrunner", "Wildtotem", "Mistcaller", "Stormchaser", "Bravehorn", "Dawnstrider",
        "Ironhorn", "Highmountain", "Clouddancer", "Sunwalker", "Thunderhoof", "Peacechaser"
    },
    -- Troll
    Troll = {
        "Darkspear", "Zandalari", "Hexer", "Shadowhunter", "Witchdoctor", "Voodoo", "Skullmask",
        "Bloodscalp", "Skullsplitter", "Gurubashi", "Trollblood", "Venomfang", "Zuljin", "Senjin",
        "Hexweaver", "LoaCaller", "Junglefang", "Spiritwalker", "Darktide", "Spearthrower"
    },
    -- Blood Elf
    BloodElf = {
        "Sunstrider", "Dawnseeker", "Brightwing", "Bloodspear", "Solaris", "Flameweaver", "Silvermoon",
        "Firestrider", "Sunreaver", "Phoenix", "Spellweaver", "Bloodwatcher", "Goldensun", "Emberglow",
        "Duskseeker", "Sunblade", "Arcanist", "Starfall", "Sunwarden", "Crimsonleaf"
    }
}

local TwoNames_FirstNames = {
    Human_Male = {"James", "John", "Arthur", "William", "Marcus", "Edmund", "Richard", "Thomas", "Robert", "Henry", "Daniel", "David", "Lucas", "Alexander", "Nathan", "Gavin", "Victor", "Samuel", "Aaron", "Charles"},
    Human_Female = {"Mary", "Sarah", "Elena", "Clara", "Victoria", "Grace", "Rose", "Emma", "Diana", "Alice", "Hannah", "Julia", "Sophia", "Lucia", "Laura", "Amber", "Helen", "Beatrice", "Evelyn", "Charlotte"},
    
    Dwarf_Male = {"Thrain", "Bael", "Khar", "Doran", "Gimli", "Magni", "Muradin", "Brann", "Ulf", "Thorin", "Halgor", "Gloin", "Farin", "Krag", "Borin", "Grimm", "Boran", "Dwalin", "Gromm", "Harek"},
    Dwarf_Female = {"Mora", "Helga", "Greta", "Berna", "Brena", "Dora", "Hilda", "Vera", "Thora", "Ingrid", "Astrid", "Frida", "Dagmar", "Karna", "Sigrid", "Ragna", "Gerda", "Alva", "Erika", "Berta"},
    
    NightElf_Male = {"Illidan", "Malfurion", "Fandral", "Broll", "Kaldor", "Theron", "Jarod", "Dath", "Elion", "Shalas", "Aelin", "Valon", "Loreth", "Vael", "Kaelen", "Silas", "Doron", "Elandor", "Malor", "Vandus"},
    NightElf_Female = {"Tyrande", "Shandris", "Naisha", "Maiev", "Liadrin", "Alleria", "Vereesa", "Sylvanas", "Elune", "Lyria", "Kalia", "Sylva", "Aelira", "Vaelis", "Theris", "Ilyana", "Faela", "Nyssa", "Talia", "Alys"},
    
    Gnome_Male = {"Gelbin", "Mekkatorque", "Millhouse", "Fizzle", "Spike", "Cog", "Tinker", "Bink", "Kraz", "Pippin", "Fink", "Gim", "Zook", "Nib", "Bork", "Pox", "Trix", "Bip", "Kip", "Fiz"},
    Gnome_Female = {"Kinndy", "Milli", "Tink", "Binki", "Fizzi", "Spika", "Pip", "Kizzi", "Nixi", "Poxi", "Gimi", "Zuki", "Trixi", "Bipi", "Kipi", "Lulu", "Mimi", "Dot", "Fifi", "Gigi"},
    
    Draenei_Male = {"Velen", "Maraad", "Nobundo", "Akama", "Restalaan", "Tavaan", "Arka", "Boros", "Kuros", "Eredar", "Vindicator", "Kaelen", "Khaden", "Oronor", "Zalaan", "Kharas", "Valon", "Relan", "Doros", "Theron"},
    Draenei_Female = {"Yrel", "Ishana", "Khadja", "Aman", "Tala", "Lumin", "Elea", "Valaa", "Nara", "Sola", "Kalea", "Rala", "Mirei", "Talia", "Alara", "Isha", "Vela", "Shala", "Elen", "Aria"},
    
    Orc_Male = {"Thrall", "Grom", "Garrosh", "Durotan", "Orgrim", "Varok", "Eitrigg", "Nazgrel", "Drek", "Brox", "Kargath", "Kilrogg", "Mankrik", "Throm", "Gorg", "Krag", "Mok", "Zul", "Tor", "Gar"},
    Orc_Female = {"Draka", "Aggra", "Geya", "Zaela", "Kagra", "Mokra", "Gora", "Thraka", "Brakka", "Torga", "Galka", "Korna", "Zula", "Maza", "Roka", "Daka", "Barka", "Grima", "Shara", "Valka"},
    
    Scourge_Male = {"Nathanos", "Alexei", "Mikhail", "Demetri", "Grave", "Shadow", "Mort", "Corpse", "Kael", "Darius", "Edmund", "Victor", "Silas", "Cyrus", "Baleroc", "Lazarus", "Graves", "Malcor", "Valen", "Hector"},
    Scourge_Female = {"Helena", "Lydia", "Victoria", "Mortia", "Grave", "Shade", "Morrigan", "Raven", "Lenore", "Carmilla", "Eleanor", "Valeria", "Morgana", "Lucia", "Ophelia", "Beatrix", "Clarissa", "Evelyn", "Lilith", "Agatha"},
    
    Tauren_Male = {"Cairne", "Baine", "Hamuul", "Magatha", "Gorn", "Tarn", "Krag", "Brak", "Torm", "Bale", "Harn", "Mok", "Tor", "Kroll", "Brum", "Grimm", "Varn", "Tahno", "Mahn", "Rahk"},
    Tauren_Female = {"Tama", "Mona", "Karna", "Brena", "Tora", "Hala", "Maka", "Rana", "Bara", "Vara", "Tara", "Gara", "Shana", "Mina", "Kona", "Bina", "Rona", "Tana", "Dana", "Kana"},
    
    Troll_Male = {"Voljin", "Senjin", "Rokhan", "Zuljin", "Jammal", "Zuni", "Kaz", "Taz", "Bwonsam", "Bwemba", "Rastakhan", "Zul", "Mandokir", "Jeklik", "Marli", "Thekal", "Venoxis", "Ghaz", "Hex", "Vood"},
    Troll_Female = {"Zen", "Kala", "Tala", "Zula", "Maza", "Raza", "Vena", "Shaza", "Brena", "Hala", "Tazi", "Roki", "Zuni", "Jani", "Mani", "Kani", "Bani", "Sani", "Pani", "Lani"},
    
    BloodElf_Male = {"Kaelthas", "Anasterian", "Lorthermar", "Rommath", "Halduron", "Liadrin", "Aethas", "Astalor", "Kaelen", "Theron", "Solan", "Vaelen", "Daelin", "Elindor", "Lorand", "Valdor", "Karyon", "Sylas", "Balerion", "Alastor"},
    BloodElf_Female = {"Alleria", "Vereesa", "Liadrin", "Valeera", "Lorna", "Thera", "Aelira", "Vaelia", "Kalia", "Solana", "Elandra", "Lyria", "Silvia", "Dalia", "Ilyana", "Alysia", "Theresa", "Caelia", "Faelynn", "Nyssa"}
}

local function GetRaceKey(raceId)
    local races = {
        [1] = "Human",
        [2] = "Orc",
        [3] = "Dwarf",
        [4] = "NightElf",
        [5] = "Scourge",
        [6] = "Tauren",
        [7] = "Gnome",
        [8] = "Troll",
        [10] = "BloodElf",
        [11] = "Draenei"
    }
    return races[raceId] or "Human"
end

function TwoNames_GenerateRandomName()
    local raceId = GetSelectedRace() or 1
    local sexId = GetSelectedSex() or 0
    local isFemale = (sexId == 1 or sexId == 3)
    local raceKey = GetRaceKey(raceId)
    
    local genderStr = isFemale and "Female" or "Male"
    local listKey = raceKey .. "_" .. genderStr
    
    local firstNames = TwoNames_FirstNames[listKey] or TwoNames_FirstNames["Human_" .. genderStr]
    local surnames = TwoNames_Surnames[raceKey] or TwoNames_Surnames["Human"]
    
    local firstName = firstNames[math.random(1, #firstNames)]
    local surname = surnames[math.random(1, #surnames)]
    
    return firstName .. " " .. surname
end

-- Hook into Character Creation UI (Clean & Standard Dimensions)
local frame = CreateFrame("Frame")
frame:RegisterEvent("GLUE_UPDATE_VERSION")
frame:SetScript("OnUpdate", function(self, elapsed)
    if CharacterCreateNameEdit then
        if CharacterCreateNameEdit:GetMaxLetters() ~= 30 then
            CharacterCreateNameEdit:SetMaxLetters(30)
        end
    end
    
    if CharacterRenameEditBox then
        if CharacterRenameEditBox:GetMaxLetters() ~= 30 then
            CharacterRenameEditBox:SetMaxLetters(30)
        end
    end

    if CharacterCreateRandomName and not CharacterCreateRandomName.TwoNamesHooked then
        CharacterCreateRandomName.TwoNamesHooked = true
        CharacterCreateRandomName:SetScript("OnClick", function(self)
            local name = TwoNames_GenerateRandomName()
            if CharacterCreateNameEdit then
                CharacterCreateNameEdit:SetText(name)
            end
            PlaySound("gsCharacterCreationLook")
        end)
    end
    
    if CharCreateRandomizeButton and not CharCreateRandomizeButton.TwoNamesHooked then
        CharCreateRandomizeButton.TwoNamesHooked = true
        CharCreateRandomizeButton:SetScript("OnClick", function(self)
            local name = TwoNames_GenerateRandomName()
            if CharacterCreateNameEdit then
                CharacterCreateNameEdit:SetText(name)
            end
            PlaySound("gsCharacterCreationLook")
        end)
    end
end)
