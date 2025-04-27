getgenv().BUY_BEFORE_FARMING = {
	{NameId = "spring_2025_kappakid", MaxAmount = 500},
}

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
-- 	"winter_2024_ice_tray"
-- }

getgenv().AGE_PETS_BEFORE_FARMING = {
	{NameId = "spring_2025_kappakid", MaxAmount = 99},
}


getgenv().SETTINGS = {
	-- WEBHOOK = {
	-- 	URL = "",
	-- 	USER_ID = "",
	-- 	VPS_NAME = "VPS"
	-- },

	EVENT = {
		DO_MINIGAME = true,
		IS_AUTO_BUY = false,
		BUY = "halloween_2024_chick_box"
	},

	PET_TO_BUY = "moon_2025_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = false, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 3,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
	TRADE_COLLECTOR_NAME = {"exp_potion", "Tiredbloxypets", "Chest19548", "Chest28745"},
	TRADE_LIST = {
		"moon_2025_royal_egg",

		"lures_2023_blazing_lion",
		"ice_dimension_2025_frostbite_bear",
		-- "winter_2024_frostbite_cub"
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "moon_2025_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		"spring_2025_kappakid",
		"spring_2025_mirai_moth",
		"spring_2025_kage_crow",
		"spring_2025_bakeneko",
		"moon_2025_puptune",
		"st_patricks_2025_clover_cow",
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()

--[[
local BulkPotions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/BulkPotions.luau"))()
local petsToAge = {
	"winter_2024_bauble_buddies"
}
BulkPotions:StartAgingPets(petsToAge)
--]]