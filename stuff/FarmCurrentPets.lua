-- getgenv().BUY_BEFORE_FARMING = {
--     {NameId = "camping_2025_muskrat", MaxAmount = 100},
-- }

-- getgenv().OPEN_ITEMS_BEFORE_FARMING = {
--     "halloween_2024_chick_box"
-- }

-- getgenv().AGE_PETS_BEFORE_FARMING = {
-- 	{NameId = "butterfly_2025_seafoam_butterfly", MaxAmount = 99},
-- }


getgenv().SETTINGS = {
	-- WEBHOOK = {
	-- 	URL = "",
	-- 	USER_ID = "",
	-- 	VPS_NAME = "VPS"
	-- },

	EVENT = {
		DO_MINIGAME = true,
		-- DONT_OPEN_FLOWER = true,
		IS_AUTO_BUY = false,
		BUY = "halloween_2024_chick_box"
	},

	PET_TO_BUY = "moon_2025_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 3,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = false,
	TRADE_COLLECTOR_NAME = {
		"exp_potion", 
		"Tiredbloxypets", 
		"Chest19548", 
		"Chest28745",
		"Chesty15242",
	},

	TRADE_LIST = {
		"butterfly_2025_moonbeam_butterfly",
		"butterfly_2025_prismatic_butterfly",
		"butterfly_2025_seafoam_butterfly",
		"butterfly_2025_snapdragon_flower",
		"moon_2025_royal_egg",
		"lures_2023_blazing_lion",
		"ice_dimension_2025_frostbite_bear",
		-- "winter_2024_frostbite_cub"

		-- "urban_2023_fly",
		-- "urban_2023_cockroach",
		-- "urban_2023_seagull",
		-- "urban_2023_black_kite",
		-- "urban_2023_tawny_frogmouth",
		-- "desert_2024_rattlesnake",
		-- "desert_2024_thorny_devil",
		-- "desert_2024_vulture",
		-- "desert_2024_gila_monster",
		-- "desert_2024_deathstalker_scorpion",
		-- "desert_2024_oryx",
		-- "moon_2025_hopbop",
		-- "desert_2024_sandfish",
		-- "garden_2024_garden_snake",
		-- "moon_2025_zeopod",
		-- "garden_2024_weevil",
		-- "ocean_2024_lionfish",
		-- "moon_2025_starmite",
		-- "capuchin_2024_capuchin_monkey",
		-- "raw_bone",
		-- "capuchin_2024_seal_pogo",
		-- "capuchin_2024_peanut_balloon",
		-- "capuchin_2024_tophat_flying_disc",
		-- "capuchin_2024_fire_ring_propeller",
		-- "capuchin_2024_peanut_friend_chew_toy",
		-- "halloween_2024_franken_feline",
		-- "capuchin_2024_whip_grappling_hook",
		-- "lunar_2024_doltokki_kite",
		-- "lunar_2024_jegi_throw_toy",
		-- "lunar_2024_diamond_fanghorn_kite",
		-- "lunar_2024_rainbow_dragon_kite",
		-- "lunar_2024_lunar_moon_throw_toy",
		-- "lunar_2024_midnight_dragon_kite",
		-- "lunar_2024_fanghorn_kite",
		-- "lunar_2024_rice_cake_rabbit_kite",
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "moon_2025_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		-- "spring_2025_kage_crow",
		-- "spring_2025_bakeneko",
		-- "moon_2025_puptune",
		-- "st_patricks_2025_clover_cow",

		"gibbon_2025_influencer_gibbon",
		"gibbon_2025_villain_gibbon",
		"gibbon_2025_hero_gibbon",
		"gibbon_2025_ringmaster_gibbon",
		"gibbon_2025_firefighter_gibbon",
		"gibbon_2025_officer_gibbon",
		"moon_2025_glormy_dolphin",
		"spring_2025_mirai_moth",
		"spring_2025_kappakid",
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