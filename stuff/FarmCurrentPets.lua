getgenv().BUY_BEFORE_FARMING = {
	{NameId = "valentines_2025_love_bird", MaxAmount = 16}
}

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
-- 	"winter_2024_ice_tray"
-- }

getgenv().AGE_PETS_BEFORE_FARMING = {
	"valentines_2025_love_bird"
}

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

	PET_TO_BUY = "moon_2025_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 1,
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
		-- "moon_2025_moonpine",
		-- "moon_2025_hopbop",
		-- "moon_2025_snorgle",
		-- "moon_2025_zeopod",
		-- "moon_2025_starmite",
		-- "lunar_2025_blossom_snake",
		-- "lunar_2025_prism_snake",
		-- "lunar_2025_gilded_snake",
		-- "lunar_2025_nebula_snake",
		
		-- "winter_2024_ratatoskr",
		-- "winter_2024_bauble_buddies",
		-- "winter_2024_mistletroll",
		-- "winter_2024_ice_tray",
		-- "winter_2024_ice_cube",
		-- "winter_2024_cold_cube",
		-- "winter_2024_berry_cool_cube",
		-- "winter_2024_partridge",
		-- "winter_2024_great_pyrenees",
		-- "winter_2024_winter_fawn",
		-- "winter_2024_winter_doe",
		-- "winter_2024_winter_buck",
		-- "winter_2024_frostclaw",
		-- "winter_2024_frostbite_cub",
		-- "ddlm_2024_golden_jaguar",
		-- "halloween_2024_headless_horse",
		-- "ddlm_2024_grave_owl",
		-- "halloween_2024_scarebear",
		-- "halloween_2024_dracula_parrot",
		-- "summerfest_2024_cow_calf",
		-- "halloween_2024_pumpkin_friend",
		-- "halloween_2024_indian_flying_fox",
		-- "halloween_2024_sea_skeleton_panda",
		-- "halloween_2024_evil_chick",
		-- "halloween_2024_ghost_chick",
		-- "halloween_2024_zombie_chick",
		-- "halloween_2024_franken_feline",
		-- "halloween_2024_grim_dragon",
		-- "summerfest_2024_majestic_pony",
		-- "summerfest_2024_corn_doggo",
		-- "sunshine_2024_cheetah",
		-- "celestial_2024_glormy_hound",
		-- "celestial_2024_glormy_leo",
		-- "garden_2024_rosy_maple_moth",
		-- "garden_2024_mushroom_friend",
		-- "celestial_2024_moonlight_moth",
		-- "ocean_2024_kraken",
		-- "ocean_2024_sea_angel",
		-- "summerfest_2024_kid_goat",
		-- "summerfest_2024_punk_pony",
		-- "summerfest_2024_pretty_pony",

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

		-- "lures_2023_blazing_lion",
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
	HATCH_EGG_PRIORITY_NAMES = { "moon_2025_egg" },

	PET_ONLY_PRIORITY = false,
	PET_ONLY_PRIORITY_NAMES = {
		
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