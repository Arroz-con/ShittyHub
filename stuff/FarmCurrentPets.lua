getgenv().SETTINGS = {
	WEBHOOK = {
		URL = "",
		USER_ID = ""
	},

	EVENT = {
		DO_MINIGAME = true,
		IS_AUTO_BUY = false,
		BUY = "halloween_2024_indian_flying_fox"
	},

	PET_TO_BUY = "garden_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = false, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 1,
	PET_NEON_PRIORITY = true,
	PET_AUTO_FUSION = true,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
	TRADE_COLLECTOR_NAME = "candymine8", -- your account username (case sensitive) that will collect the pets.
	TRADE_LIST = {
		PET_WEAR_TABLE = {},

		VEHICLES_TABLE = {
			-- "lunar_2024_dragonster",
		},

		GIFTS_TABLE = {
			"rgb_reward_box",
			"halloween_2023_scarecrow_box",
			"halloween_2022_wolf_box",
			"summerfest_2023_hermit_crab_box",
			"winter_2021_walrus_box",
			"winter_2022_pony_box",
			"lny_2023_moon_bear_box",
			"springfest_2023_duckling_box",
			"lunar_2024_silk_bag",
			"lunar_2024_special_lunar_new_year_gift_box",
		},

		FOOD_TABLE = {
			-- "cure_all_potion",
		},

		TOYS_TABLE = {
			-- "paint_2023_colored_hair_spray_sealer",
		},

		-- the pets in here will be traded no matter what age they are
		PETS_TABLE = {
			"lures_2023_blazing_lion",
			-- "halloween_2024_pumpkin_friend",
			-- "celestial_2024_moonlight_moth",
			-- "celestial_2024_glormy_hound",
			-- "summerfest_2024_punk_pony",
			-- "summerfest_2024_pretty_pony",
			-- "summerfest_2024_majestic_pony"
		},
	},

	HATCH_EGG_PRIORITY = true,
	HATCH_EGG_PRIORITY_NAMES = { "garden_2024_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		"halloween_2024_scarebear",
		-- "halloween_2024_dracula_parrot",
		"halloween_2024_pumpkin_friend",
		"halloween_2024_indian_flying_fox",
		"halloween_2024_sea_skeleton_panda",
		"halloween_2024_evil_chick",
		"halloween_2024_ghost_chick",
		"halloween_2024_zombie_chick",
		"halloween_2024_franken_feline",
		-- "halloween_2024_grim_dragon",
		"summerfest_2024_majestic_pony",
		-- "summerfest_2024_corn_doggo",
		"sunshine_2024_cheetah",
		"celestial_2024_glormy_hound",
		"celestial_2024_glormy_leo",
		"garden_2024_rosy_maple_moth",
		"garden_2024_mushroom_friend",
		-- "celestial_2024_moonlight_moth",
		"ocean_2024_kraken",
		-- "ocean_2024_sea_angel",
		-- "ocean_2024_lionfish",
		-- "ocean_2024_dracula_fish",
		-- "ocean_2024_urchin",
		-- "garden_2024_praying_mantis",
		-- "garden_2024_skunk",
		-- "garden_2024_weevil",
		-- "garden_2024_blue_jay",
		-- "garden_2024_mole",
		"summerfest_2024_cow_calf",
		-- "summerfest_2024_kid_goat",
		"summerfest_2024_punk_pony",
		"summerfest_2024_pretty_pony",
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()


local BuyItems = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/BuyItems.luau"))()

local petsToBuy = {
    {NameId = "halloween_2024_franken_feline", MaxAmount = 48},
    {NameId = "halloween_2024_sea_skeleton_panda", MaxAmount = 48},
    {NameId = "halloween_2024_indian_flying_fox", MaxAmount = 80},
    {NameId = "halloween_2024_headless_horse", MaxAmount = 80},
    {NameId = "halloween_2024_marabou_stork", MaxAmount = 16},
    {NameId = "halloween_2024_scarebear", MaxAmount = 16}
}

BuyItems:BuyPets(petsToBuy)