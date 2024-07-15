getgenv().SETTINGS = {
    PET_TO_BUY = "garden_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

    FOCUS_FARM_AGE_POTION = false,  -- if true, this will only farm 1 pet an keep aging to get aging potions

    ENABLE_AUTO_FARM = true,
    SET_FPS = 1,
    PET_NEON_PRIORITY = true,
    PET_AUTO_FUSION = true,

    ENABLE_TRADE_COLLECTOR = true,
    TRADE_ONLY_LUMINOUS_MEGA = true,
    TRADE_COLLECTOR_NAME = "notdudemyblox", -- your account username (case sensitive) that will collect the pets.
    TRADE_LIST = {
        PET_WEAR_TABLE = {

        },

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
            -- "summerfest_2024_punk_pony",
            -- "summerfest_2024_pretty_pony",
            -- "summerfest_2024_majestic_pony"
        },
    },

    HATCH_EGG_PRIORITY = true,
    HATCH_EGG_PRIORITY_NAMES = {"garden_2024_egg"},
    
    PET_ONLY_PRIORITY = true,
    PET_ONLY_PRIORITY_NAMES = {
        "garden_2024_rosy_maple_moth",
        "garden_2024_mushroom_friend",
        "garden_2024_praying_mantis",
        "garden_2024_skunk",
        "garden_2024_weevil",
        "garden_2024_blue_jay",
        "garden_2024_mole",
        -- "summerfest_2024_cow_calf",
        -- "lures_2023_blazing_lion",
        "summerfest_2024_punk_pony",
        "summerfest_2024_pretty_pony",
        "summerfest_2024_majestic_pony"
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()

--[[
local function buyPet(petNameId: string, howManyToBuy: number)
    for i = 1, howManyToBuy do
        local hasMoney = game.ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", petNameId, {})
        if hasMoney == "too little money" then
            break
        end
        task.wait(.1)
    end
end

buyPet("summerfest_2024_corn_doggo", 100)
buyPet("summerfest_2024_cow_calf", 100)
buyPet("summerfest_2024_kid_goat", 100)

--]]