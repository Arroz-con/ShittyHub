local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Fusion = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/Fusion.lua"))()
local ClientData = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Core"):WaitForChild("ClientData"))

local BulkPotions = {}

local sameUnqiue
local stopAging = false


local function isPetNormal(petName: string)
    for _, v in ClientData.get_data()[Player.Name].inventory.pets do
        if v.id == petName and v.id ~= "practice_dog" and v.properties.age ~= 6 and not v.properties.mega_neon then
            ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, { ["use_sound_delay"] = true })
            task.wait(1)
            return true
        end
    end
    return false
end

local function isPetNeon(petName: string)
    for _, v in ClientData.get_data()[Player.Name].inventory.pets do
        if v.id == petName and v.id ~= "practice_dog" and v.properties.age ~= 6 and v.properties.neon and not v.properties.mega_neon then
            ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(v.unique, { ["use_sound_delay"] = true })
            task.wait(1)
            return true
        end
    end

    if isPetNormal(petName) then
        return true
    else
        return false
    end
end

local function feedAgePotion()
    for _, v in ClientData.get_data()[Player.Name].inventory.food do
        if v.id == "pet_age_potion" then
            if sameUnqiue == v.unique then
                print("has same unqiue age up potion")
                break
            end -- means the same age potion is still in inventory
            sameUnqiue = v.unique
            ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(v.unique, ClientData.get("pet_char_wrappers")[1].pet_unique)
            break
        end
    end
end

local function hasAgeUpPotion()
    for _, v in ClientData.get_data()[Player.Name].inventory.food do
        if v.id == "pet_age_potion" then
            return true
        end
    end
    return false
end

local function ageAllPetsOfSameName(petId)

    Fusion:MakeMega(false) -- makes neon
    Fusion:MakeMega(true) -- makes mega

    -- equip the pet only if its neon or normal and age is less then 6
    local hasPet = isPetNeon(petId)
    if not hasPet then return print(`no {petId} so moving to next pet or stopping`) end
    
    while true do
        local age = ClientData.get("pet_char_wrappers")[1]["pet_progression"]["age"]
        if age >= 6 then print("pet's age is 6") break end

        local hasAgeUpPotion = hasAgeUpPotion()
        if not hasAgeUpPotion then
            stopAging = true
            print("no more age up potions")
            return
        end

        feedAgePotion()
        task.wait(1)
    end

    if stopAging then
        return
    end
    ageAllPetsOfSameName(petId)
end

function BulkPotions:StartAgingPets(petsTable: table)
    for _, petId in ipairs(petsTable) do
        if stopAging then print("stop aging is true, so stopped") return end
        ageAllPetsOfSameName(petId)
    end
end


-- if not ClientData.get("pet_char_wrappers")[1] 
--     or petName ~= ClientData.get("pet_char_wrappers")[1]["pet_id"] then
--     equipPet(petName)
--     task.wait(1)
-- end

return BulkPotions