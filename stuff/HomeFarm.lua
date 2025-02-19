-- getgenv().BUY_BEFORE_FARMING = {
-- 	{NameId = "valentines_2025_love_bird", MaxAmount = 16}
-- }

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
-- 	"winter_2024_ice_tray"
-- }

-- getgenv().AGE_PETS_BEFORE_FARMING = {
-- 	"valentines_2025_love_bird"
-- }

getgenv().SETTINGS = {
	WEBHOOK = {
		URL = "",
		USER_ID = ""
	},

	EVENT = {
		DO_FROSTCLAW_MINIGAME = false,
		DO_MINIGAME = false,
		IS_AUTO_BUY = false,
		BUY = "halloween_2024_chick_box"
	},

	PET_TO_BUY = "garden_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 1,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = false,
	TRADE_COLLECTOR_NAME = {"candymine8", "Tiredbloxypets"},
	TRADE_LIST = {
		"moon_2025_royal_egg",
		"moon_2025_dimension_drifter",
		"moon_2025_sunglider",
		"moon_2025_puptune",

		-- "rgb_reward_box",
		-- "halloween_2023_scarecrow_box",
		-- "halloween_2022_wolf_box",
		-- "summerfest_2023_hermit_crab_box",
		-- "winter_2021_walrus_box",
		-- "winter_2022_pony_box",
		-- "lny_2023_moon_bear_box",
		-- "springfest_2023_duckling_box",
		-- "lunar_2024_silk_bag",
		-- "lunar_2024_special_lunar_new_year_gift_box",

		"lures_2023_blazing_lion",
		-- "winter_2024_bauble_buddies",
		-- "winter_2024_berry_cool_cube",
		-- "halloween_2024_pumpkin_friend",
		-- "celestial_2024_moonlight_moth",
		-- "celestial_2024_glormy_hound",
		-- "summerfest_2024_punk_pony",
		-- "summerfest_2024_pretty_pony",
		-- "summerfest_2024_majestic_pony",
		-- "garden_2024_mushroom_friend",
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "garden_2024_egg" },

	PET_ONLY_PRIORITY = false,
	PET_ONLY_PRIORITY_NAMES = {
		
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()
