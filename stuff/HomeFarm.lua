getgenv().BUY_BEFORE_FARMING = {
	{NameId = "spring_2025_mirai_moth", MaxAmount = 300},
}

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
-- 	"winter_2024_ice_tray"
-- }

getgenv().AGE_PETS_BEFORE_FARMING = {
	{NameId = "spring_2025_mirai_moth", MaxAmount = 300},
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
	SET_FPS = 2,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
	TRADE_COLLECTOR_NAME = {"exp_potion", "Tiredbloxypets", "Chest19548", "Chest28745"},
	TRADE_LIST = {
		"moon_2025_royal_egg",
		-- "moon_2025_dimension_drifter",
		-- "moon_2025_sunglider",
		-- "moon_2025_puptune",
		"lures_2023_blazing_lion",
		"ice_dimension_2025_frostbite_bear",
		-- "ice_dimension_2025_shiver_wolf",
		-- "ice_dimension_2025_subzero_scorpion",
		-- "ice_dimension_2025_snowy_mammoth",
		-- "ice_dimension_2025_chilly_penguin",
		-- "ice_dimension_2025_icy_porcupine",
		-- "winter_2024_frostbite_cub"
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "moon_2025_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		"spring_2025_mirai_moth",
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()
