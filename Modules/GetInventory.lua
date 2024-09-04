local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local InventoryDB = Bypass("InventoryDB")

local Player = Players.LocalPlayer

local GetInventory = {}

function GetInventory:TabId(tabId: string)
    local inventoryTable = {}
    
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory[tabId] do
        if v.id == "practice_dog" then continue end
        if table.find(inventoryTable, v.id) then continue end
        table.insert(inventoryTable, v.id)
    end

    return inventoryTable
end


function GetInventory:PetRarityAndAge(rarity: string, age: number)
    local PetageCounter = age or 5
    local isNeon = true
    local petFound = false

    while not petFound do
        for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            for _, petDB in InventoryDB.pets do
                if rarity == petDB.rarity and pet.id == petDB.id and pet.id ~= "practice_dog" and pet.properties.age == PetageCounter and pet.properties.neon == isNeon then
                    ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(pet.unique, {})
                    -- getgenv().PetCurrentlyFarming = pet.unique
                    return true
                end
            end
        end

        PetageCounter -= 1
        if PetageCounter <= 0 and isNeon then
            PetageCounter = age or 5
            isNeon = nil   -- must to set to nil, false doesnt work

        elseif PetageCounter <= 0 and isNeon == nil then
            return false
        end

        task.wait()
    end
end

return GetInventory