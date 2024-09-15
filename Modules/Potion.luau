local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load

local Potion = {}

local sameUnqiue
local count = 0

local function equipPet()
    -- checks inventory for neon pet
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == selectedItem and v.id ~= "practice_dog" and v.properties.age ~= 6 and v.properties.neon and not v.properties.mega_neon then
            ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, { ["use_sound_delay"] = true })
            return true
        end
    end

    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == selectedItem and v.id ~= "practice_dog" and v.properties.age ~= 6 and not v.properties.mega_neon then
            ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, { ["use_sound_delay"] = true })
            return true
        end
    end
    return false
end

local function feedAgePotion()
    for _, v in
        pairs(require(ReplicatedStorage.ClientModules.Core.ClientData).get_data()[Player.Name].inventory.food)
    do
        if v.id == "pet_age_potion" then
            if sameUnqiue == v.unique then
                return true
            end -- means the same age potion is still in inventory
            sameUnqiue = v.unique
            ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(
                v.unique,
                Bypass("ClientData").get("pet_char_wrappers")[1].pet_unique
            )
            return true
        end
    end
    return false
end

while getgenv().feedAgeUpPotionToggle do
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
            getgenv().PotionToggle:Set(false)
            return
        end
    end

    local hasAgeUpPotion = feedAgePotion()
    if not hasAgeUpPotion then
        print("no more age up potions")
        getgenv().PotionToggle:Set(false)
        return
    end
    task.wait(1)
end

return Potion