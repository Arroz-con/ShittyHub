local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

if SETTINGS.FOCUS_FARM_AGE_POTION then return end

local function checkInventory()
    local count = 0
    for i, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == "capuchin_2024_capuchin_monkey" then
            count += 1
        end
    end
    return count
end

local function buyAndOpen()
    local canBuy = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", "capuchin_2024_standard_box", {})
    task.wait(.1)
    if canBuy == "too little money" then return false end
    
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.gifts do
        if v["id"] == "capuchin_2024_standard_box" then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LootBoxAPI/ExchangeItemForReward"):InvokeServer(v["id"], v["unique"])
            task.wait()
            break
        end
    end
    return true
end

local function hasPetInInventory()
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == "capuchin_2024_capuchin_monkey" then return true end
    end
    return false
end

local function ExchangeCapuchin(items, Capuchin, tab)
    local Counter = 0

    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory[tab] do
        if v.id == items then
            Counter = Counter + 1
            if Counter == 3 then break end
        end
    end

    if Counter <= 2 then return false end

    if hasPetInInventory() then
        for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            if v.id == "capuchin_2024_capuchin_monkey" then
                ReplicatedStorage.API["EventAPI/TransformCapuchin"]:InvokeServer(v.unique, Capuchin)
                task.wait(.1)
                break
            end
        end

    else
        local canBuy = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", "capuchin_2024_capuchin_monkey", {})
        task.wait(.1)
        if canBuy == "too little money" then return false end
    end
    
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/TakeOffEverything"):InvokeServer("pet")

    return true
end

local howMany = checkInventory()

if howMany <= 100 and howMany >= 0 then
    local count = 100 - howMany
    for i = 1, count do
        local hasMoney = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", "capuchin_2024_capuchin_monkey", {})
        if hasMoney == "too little money" then
            break
        end
        task.wait(.1)
    end
end

for i = 1, howManyToBuy do
    if not buyAndOpen() then break end
    task.wait()
end

if SETTINGS["DONT_TRANSFORM_CAPUCHIN"] then return print("not transforming") end

repeat
    local hasMore = ExchangeCapuchin("capuchin_2024_handcuffs", "capuchin_2024_inmate_capuchin_monkey", "toys")
    task.wait()
until not hasMore

repeat
    local hasMore = ExchangeCapuchin("capuchin_2024_cool_sunglasses", "capuchin_2024_preppy_capuchin_monkey", "pet_accessories")
    task.wait()
until not hasMore

repeat
    local hasMore = ExchangeCapuchin("capuchin_2024_tutu", "capuchin_2024_princess_capuchin_monkey", "pet_accessories")
    task.wait()
until not hasMore

repeat
    local hasMore = ExchangeCapuchin("capuchin_2024_compass", "capuchin_2024_pirate_ghost_capuchin_monkey", "toys")
    task.wait()
until not hasMore
