-- getgenv().BUY_BEFORE_FARMING = {
-- 	{NameId = "st_patricks_2025_clover_cow", MaxAmount = 1000}
-- }

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
-- 	"winter_2024_ice_tray"
-- }

-- getgenv().AGE_PETS_BEFORE_FARMING = {
-- 	"st_patricks_2025_clover_cow"
-- }

getgenv().SETTINGS = {
	WEBHOOK = {
		URL = "",
		USER_ID = ""
	},

	EVENT = {
		DO_MINIGAME = true,
		IS_AUTO_BUY = false,
		BUY = "halloween_2024_chick_box"
	},

	PET_TO_BUY = "moon_2025_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 2,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
	TRADE_COLLECTOR_NAME = {"candymine8", "Tiredbloxypets"},
	TRADE_LIST = {
		"moon_2025_royal_egg",
		-- "moon_2025_dimension_drifter",
		-- "moon_2025_sunglider",
		-- "moon_2025_puptune",
		"lures_2023_blazing_lion",
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "garden_2024_egg" },

	PET_ONLY_PRIORITY = false,
	PET_ONLY_PRIORITY_NAMES = {
		
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()
