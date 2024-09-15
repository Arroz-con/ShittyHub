getgenv().SETTINGS = {
	WEBHOOK = {
		URL = "",
		USER_ID = "",
	},

	OCEAN_EVENT = {
		EXCHANGE = true,
		WISH = "ocean_2024_big_wish",
	},
	
	PET_TO_BUY = "garden_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

	FOCUS_FARM_AGE_POTION = true, -- if true, this will only farm 1 pet an keep aging to get aging potions

	ENABLE_AUTO_FARM = true,
	SET_FPS = 1,
	PET_NEON_PRIORITY = false,
	PET_AUTO_FUSION = false,

	ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = false,
	TRADE_COLLECTOR_NAME = "donutboy_92", -- your account username (case sensitive) that will collect the pets.
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
			"golden_egg",
			"diamond_egg",
			"lures_2023_magma_moose",
			"lures_2023_flaming_zebra",
			"lures_2023_toasty_red_panda",
			"lures_2023_ash_zebra",
			"lures_2023_magma_snail",
			"fire_dimension_2024_volcanic_rhino",
			"fire_dimension_2024_flaming_fox",
			"fire_dimension_2024_burning_bunny",
			"fire_dimension_2024_wildfire_hawk",
			"summerfest_2024_kid_goat",
			"summerfest_2024_cow_calf",
			"summerfest_2024_orange_betta_fish",
			"summerfest_2024_pink_betta_fish",
			"summerfest_2024_blue_betta_fish",
			"summerfest_2024_show_pony",
			"summerfest_2024_punk_pony",
			"summerfest_2024_pretty_pony",
			"summerfest_2024_majestic_pony",
			"summerfest_2024_corn_doggo",
			"summerfest_2024_bull",
			"garden_2024_rosy_maple_moth",
			"garden_2024_mushroom_friend",
		},
	},

	HATCH_EGG_PRIORITY = false,
	HATCH_EGG_PRIORITY_NAMES = { "garden_2024_egg" },

	PET_ONLY_PRIORITY = true,
	PET_ONLY_PRIORITY_NAMES = {
		"starter_egg",
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

-- buyPet("celestial_2024_glormy_hound", 2)
buyPet("celestial_2024_glormy_leo", 20)
--]]

--[[
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys", 600)).load
local Player = game:GetService("Players").LocalPlayer
local selectedItem = "celestial_2024_moonlight_moth"
local sameUnqiue


local function equipPet()
    -- checks inventory for neon pet
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == selectedItem and v.id ~= "practice_dog" and v.properties.age ~= 6 and v.properties.neon and not v.properties.mega_neon then
            game.ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, {["use_sound_delay"] = true})
            return true
        end
    end

    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == selectedItem and v.id ~= "practice_dog" and v.properties.age ~= 6 and not v.properties.mega_neon then
            game.ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, {["use_sound_delay"] = true})
            return true
        end
    end
    return false
end

local function feedAgePotion()
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.food do
        if v.id == "pet_age_potion" then
            if sameUnqiue == v.unique then return true end
            sameUnqiue = v.unique
            game.ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(v.unique, Bypass("ClientData").get("pet_char_wrappers")[1].pet_unique)
            return true
        end
    end
    return false
end

while true do
    getgenv().feedAgeUpPotionToggle = true
    local hasPetEquipped = Bypass("ClientData").get("pet_char_wrappers")[1]
    if not hasPetEquipped then
        equipPet()
        task.wait(1)
    end

    if selectedItem ~= Bypass("ClientData").get("pet_char_wrappers")[1]["pet_id"] then
        equipPet()
        task.wait(1)
    end

    local age = Bypass("ClientData").get("pet_char_wrappers")[1]["pet_progression"]["age"]
    if age >= 6 then
        local hasPet = equipPet()
        task.wait(1) -- wait for pet to equip
        if not hasPet then
            getgenv().feedAgeUpPotionToggle = false
            print("no more pet available")
            return
        end
    end

    local hasAgeUpPotion = feedAgePotion()
    if not hasAgeUpPotion then
        getgenv().feedAgeUpPotionToggle = false
        print("no more age up potions")
        return
    end
    task.wait(1)
end

--]]
