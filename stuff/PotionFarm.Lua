---[[
getgenv().BUY_BEFORE_FARMING = {
    {NameId = "aztec_egg_2025_aztec_egg", MaxAmount = 20},
}
--]]

--[[
getgenv().OPEN_ITEMS_BEFORE_FARMING = {
    "butterfly_2025_snapdragon_flower"
}
--]]

--[[
getgenv().AGE_PETS_BEFORE_FARMING = {
    "st_patricks_2025_clover_cow",
}
--]]


getgenv().SETTINGS = {
    ENABLE_AUTO_FARM = true,
    SET_FPS = 3,

    FOCUS_FARM_AGE_POTION = true,

    PETS_TO_AGE_IN_PEN = {
        "pet_recycler_2025_basic_egg",
        "aztec_egg_2025_tegu",
        "aztec_egg_2025_jungle_frog",
        "aztec_egg_2025_ahuizotl",
        "aztec_egg_2025_xiucohtl",
        "aztec_egg_2025_ehecatl"
    },
    
    ENABLE_RELEASE_PETS = true, -- if true it will use the pets in PETS_TO_AGE_IN_PEN to RELEASE

    PET_AUTO_FUSION = true,
    DEBUG_MODE = true,
    POTATO_MODE = false,

    HATCH_EGG_PRIORITY = false,
    HATCH_EGG_PRIORITY_NAMES = {
        "aztec_egg_2025_aztec_egg", 
    },

    PET_ONLY_PRIORITY = false,
    PET_ONLY_PRIORITY_NAMES = {
        "moon_2025_glormy_dolphin",
    },

    ENABLE_TRADE_COLLECTOR = true,
    TRADE_ONLY_NEON_LUMINOUS_AND_MEGA = true,
    TRADE_COLLECTOR_NAME = {
        "Chesty15242",
        "Chest19548",
        "Chest28745",
        "grabmanypets84",
        "growaplant916",
        "SoaveCorsa099",
    },

    TRADE_LIST = {
        "pet_recycler_2025_giant_panda",
        "pet_recycler_2025_emberlight",
        "moon_2025_sunglider",
        "summerfest_2024_corn_doggo",
        "ice_dimension_2025_frostbite_bear",
        -- "aztec_egg_2025_temple_friend",
        "butterfly_2025_moonbeam_butterfly",
        --"house_pets_2025_french_bulldog",
        "summer_2025_priceless_shrimp",
        "summerfest_2025_coconut_friend",
        "house_pets_2025_siamese_cat",
        "house_pets_2025_mini_schnauzer",
        --"house_pets_2025_munchkin_cat",
    },

    ENABLE_TRASH_COLLECTOR = false, -- it has its own list of trash pets
    TRASH_COLLECTOR_NAMES = {"Levi_FUSI0N2003YT"},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()

