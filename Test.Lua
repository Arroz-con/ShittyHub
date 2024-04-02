getgenv().SETTINGS = {
    PET_TO_BUY = "desert_2024_egg", -- add pet or egg to buy when bot has no pets/egg left to level

    FOCUS_FARM_AGE_POTION = false,  -- if true, this will only farm 1 pet an keep aging to get aging potions

    ENABLE_AUTO_FARM = true,
    SET_FPS = 3,
    PET_NEON_PRIORITY = true,
    PET_AUTO_FUSION = true,

    ENABLE_TRADE_COLLECTOR = true,
	TRADE_ONLY_LUMINOUS_MEGA = true,
    TRADE_COLLECTOR_NAME = "dudemyblox", -- your account username (case sensitive) that will collect the pets.
    TRADE_LIST = {
        GIFTS_TABLE = {
            -- "rgb_reward_box",
            -- "halloween_2023_scarecrow_box",
            -- "halloween_2022_wolf_box",
            -- "summerfest_2023_hermit_crab_box",
            -- "winter_2021_walrus_box",
            -- "winter_2022_pony_box",
            -- "lny_2023_moon_bear_box",
            -- "springfest_2023_duckling_box",
			-- "lunar_2024_silk_bag"
        },
    
        TOYS_TABLE = {
        --    "paint_2023_colored_hair_spray_sealer",
        },

        -- the pets in here will be traded no matter what age they are
        PETS_TABLE = { 
            "lures_2023_blazing_lion",
            "golden_egg",
            "diamond_egg",
            "mythic_egg",
            "seasia_2023_egg",
            "urban_2023_egg",
            "japan_2022_egg",
            "woodland_2022_woodland_egg",
            "danger_2023_egg",
            "ocean_egg",
            "fossil_egg",
            "april_fools_2023_fool_egg",
        },
    },

    HATCH_EGG_PRIORITY = true,
    HATCH_EGG_PRIORITY_NAMES = {"desert_2024_egg"},
    
    PET_ONLY_PRIORITY = true,
    PET_ONLY_PRIORITY_NAMES = {
        "desert_2024_sandfish",
        "desert_2024_armadillo",
        "desert_2024_coyote",
        "desert_2024_gila_monster",
        "desert_2024_rattlesnake",
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Adoptme_Script"))()

--[[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local giftID = "lunar_2024_special_lunar_new_year_gift_box"
local howMany = 50
local Counter = 0  -- Dont Change, keep at 0

local function runTask()
    for i = 1, howMany do
        ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", giftID, {})
        for i, v in pairs(require(ReplicatedStorage.ClientModules.Core.ClientData).get_data()[player.Name].inventory.gifts) do
            if v["id"] == giftID then
                local hasMoney = ReplicatedStorage.API["LootBoxAPI/ExchangeItemForReward"]:InvokeServer(v["id"], v["unique"])
                Counter += 1
                if hasMoney == "too little money" then return end
                if Counter == howMany then return end
            end
        end
        task.wait(.1)
    end
end
   
runTask()

--]]

---[[
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local howManyToBuy = 100  -- change the number to how many to buy
local petNameId = "easter_2024_eggy_box" -- change the nameId to the pet/egg you wanna buy

for i = 1, howManyToBuy do
    local hasMoney = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", petNameId, {})
    if hasMoney == "too little money" then
        break
    end
    task.wait()
end
--]]
