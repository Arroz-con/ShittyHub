local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local howManyToBuy = 10    -- change to however many you want
local hasMoney = true  -- DONT CHANGE!

local function buyAndOpen()
    local canBuy = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", "capuchin_2024_standard_box", {})
    task.wait(.1)
    if canBuy == "too little money" then return false end
    
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.gifts do
        if v["id"] == "capuchin_2024_standard_box" then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("LootBoxAPI/ExchangeItemForReward"):InvokeServer(v["id"], v["unique"])
            task.wait(.1)
            break
        end
    end
    return true
end

local function ExchangeCapuchin(items, Capuchin, tab)
    local Counter = 0

    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory[tab] do
        if v.id == items then
            Counter = Counter + 1
        end
    end

    if Counter == 0 then return end

    local HowManyToDo = math.abs(Counter / 3)

    for i = 1, HowManyToDo do
        local canBuy = ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", "capuchin_2024_capuchin_monkey", {})
        task.wait(.1)
        if canBuy == "too little money" then return false end

        for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            if v.id == "capuchin_2024_capuchin_monkey" then
                ReplicatedStorage.API["EventAPI/TransformCapuchin"]:InvokeServer(v.unique, Capuchin)
                task.wait(1)
                break
            end
        end
    end
end

for i = 1, howManyToBuy do
    if not buyAndOpen() then 
        hasMoney = false
        break
    end
    task.wait()
end

for i = 1, howManyToBuy do
    if not hasMoney then break end
    ExchangeCapuchin("capuchin_2024_handcuffs", "capuchin_2024_inmate_capuchin_monkey", "toys")
    ExchangeCapuchin("capuchin_2024_cool_sunglasses", "capuchin_2024_preppy_capuchin_monkey", "pet_accessories")
    ExchangeCapuchin("capuchin_2024_tutu", "capuchin_2024_princess_capuchin_monkey", "pet_accessories")
    ExchangeCapuchin("capuchin_2024_compass", "capuchin_2024_pirate_ghost_capuchin_monkey", "toys")
    ExchangeCapuchin("capuchin_2024_royal_capuchin_crown", "capuchin_2024_royal_capuchin_monkey", "pet_accessories")
    task.wait()
end

