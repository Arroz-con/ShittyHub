getgenv().SETTINGS = {
	PET_TO_BUY = "garden_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 1,
	PET_NEON_PRIORITY = false,
	PET_AUTO_FUSION = false,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
	TRADE_COLLECTOR_NAME = "notdudemyblox", -- your account username (case sensitive) that will collect the pets.
	TRADE_LIST = {
		PET_WEAR_TABLE = {},

		VEHICLES_TABLE = {},

		GIFTS_TABLE = {
			"halloween_2023_scarecrow_box",
			"halloween_2022_wolf_box",
			"summerfest_2023_hermit_crab_box",
			"winter_2021_walrus_box",
			"winter_2022_pony_box",
			"lny_2023_moon_bear_box",
			"springfest_2023_duckling_box",
			"lunar_2024_special_lunar_new_year_gift_box",
			"easter_2024_eggy_box",
		},

		TOYS_TABLE = {},

		FOOD_TABLE = {},

		-- the pets in here will be traded no matter what age they are
		PETS_TABLE = {
			"lures_2023_blazing_lion",
			"sunshine_2024_cheetah",
			-- "golden_egg",
			-- "diamond_egg",
			-- "lures_2023_magma_moose",
			-- "lures_2023_flaming_zebra",
			-- "lures_2023_toasty_red_panda",
			-- "lures_2023_ash_zebra",
			-- "lures_2023_magma_snail",
			-- "fire_dimension_2024_volcanic_rhino",
			-- "fire_dimension_2024_flaming_fox",
			-- "fire_dimension_2024_burning_bunny",
			-- "fire_dimension_2024_wildfire_hawk",
			-- "summerfest_2024_kid_goat",
			-- "summerfest_2024_cow_calf",
			-- "summerfest_2024_orange_betta_fish",
			-- "summerfest_2024_pink_betta_fish",
			-- "summerfest_2024_blue_betta_fish",
			-- "summerfest_2024_show_pony",
			-- "summerfest_2024_punk_pony",
			-- "summerfest_2024_pretty_pony",
			-- "summerfest_2024_majestic_pony",
			-- "summerfest_2024_corn_doggo",
			-- "summerfest_2024_bull"
		},
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "garden_2024_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		"dog",
		"cat",
	},
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()

--[[
local function buyPet(petNameId: string, howManyToBuy: number)
	for _ = 1, howManyToBuy do
		local hasMoney = game.ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", petNameId, {})
		if hasMoney == "too little money" then
			return
		end
		task.wait(0.1)
	end
end

buyPet("celestial_2024_glormy_hound", 2)
buyPet("celestial_2024_glormy_leo", 2)
--]]
