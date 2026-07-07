--!strict

type PetType = {
    id: string,
    unique: string,
    name: string,
    properties: {
        age: number,
        neon: boolean,
        mega_neon: boolean,
    },
}

type PetDictType = {
    {
        ["name"]: string,
        ["id"]: string,
        ["rarity"]: string,
        ["type"]: string,
        ["age"]: string,
        ["amount"]: number,
        ["image"]: string,
    }
}


-----------------------------
-- SERVICES --
-----------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace") :: any
local Players = game:GetService("Players")

-----------------------------
-- DEPENDENCIES --
-----------------------------
local PetPotionEffectsDB = require(ReplicatedStorage:WaitForChild("ClientDB"):WaitForChild("PetPotionEffectsDB")) :: any
local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load :: any
local ClientData = Bypass("ClientData")
local RouterClient = Bypass("RouterClient")
local InventoryDB = Bypass("InventoryDB")
local Fusion = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/Fusion.lua"))() :: any

-----------------------------
-- VARIABLES --
-----------------------------
local BulkPotion = {}

local localPlayer = Players.LocalPlayer

BulkPotion.SameUnqiue = {}
BulkPotion.EggList = {}
BulkPotion.SameUnqiueCount = 0
BulkPotion.StopAging = false
BulkPotion.PetAge = 0
BulkPotion.PetUniqueId = ""

-----------------------------
-- PRIVATE FUNCTIONS --
-----------------------------
local function getPetEggs()
    table.clear(BulkPotion.EggList)
    for _, v in InventoryDB.pets do
        if v.is_egg then
            table.insert(BulkPotion.EggList, v.id)
        end
    end
end

local function waitForPetToEquip()
    local startTime = DateTime.now().UnixTimestamp
    local isStuck = false
    repeat
        task.wait()
        local isEquipped = ClientData.get("pet_char_wrappers")[1]
        local currentTime = DateTime.now().UnixTimestamp
        if currentTime - startTime >= 10 then
            isStuck = true
        end
    until isEquipped or isStuck

    if isStuck then
        return false
    end
    return true
end

local function getMaxMega(petId: string): number
    local count = 0
    for _, v: PetType in ClientData.get_data()[localPlayer.Name].inventory.pets do
        if v.id == petId and v.properties.mega_neon then
            count += 1
        end
    end
    return count
end

-- local function agePotionCount(nameId: string): number
--     local count = 0
--     for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
--         if v.id == nameId then
--             count += 1
--         end
--     end
--     return count
-- end

local function consumeItem(potionName: string)
    local agePotion = Workspace.PetObjects:WaitForChild(potionName, 15)
    if not agePotion then
        return
    end

    RouterClient.get("PetAPI/ConsumeFoodObject"):FireServer(agePotion, ClientData.get("pet_char_wrappers")[1].pet_unique)
end

local function getPotionUniques(nameId: string): { string }
    local potions = {}
    local amountNeeded = PetPotionEffectsDB[nameId].multi_use_count(
        ClientData.get("pet_char_wrappers")[1],
        ClientData.get_data()[localPlayer.Name].inventory.pets[ClientData.get("pet_char_wrappers")[1].pet_unique]
    )

    if amountNeeded <= 0 then
        return potions
    end

    for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
        if v.id == nameId then
            table.insert(potions, v.unique)
            amountNeeded -= 1
            if amountNeeded <= 0 then
                break
            end
        end
    end
    return potions
end

local function createPotionObject(potionTable): boolean
    local petIndex = ClientData.get("pet_char_wrappers")[1]
    local petUnique: string? = if petIndex then petIndex.pet_unique else nil
    if not petUnique then
        return false
    end
    if #potionTable == 1 then
        return RouterClient.get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_2", {
            ["pet_unique"] = petUnique,
            ["unique_id"] = potionTable[1],
        })
    elseif #potionTable >= 2 then
        local newpotionTable = table.clone(potionTable)
        table.remove(newpotionTable, 1)
        return RouterClient.get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_2", {
            ["pet_unique"] = petUnique,
            ["unique_id"] = potionTable[1],
            ["additional_consume_uniques"] = newpotionTable,
        })
    end

    return false
end

local function hasAgeUpPotion(): boolean
    for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
        if v.id == "pet_age_potion" or v.id == "tiny_pet_age_potion" then
            return true
        end
    end
    return false
end

local function formatTableToDict(tableToFormat: { string }): { { NameId: string, MaxAmount: number } }
    local mytable = {}
    for _, v in tableToFormat do
        table.insert(mytable, {
            NameId = v,
            MaxAmount = 999,
        })
    end
    return mytable
end

-----------------------------
-- PUBLIC FUNCTIONS --
-----------------------------
function BulkPotion.IsPetNormal(petName: string): boolean
    BulkPotion.PetAge = 0
    BulkPotion.PetUniqueId = ""

    for _, v: PetType in ClientData.get_data()[localPlayer.Name].inventory.pets do
        if v.id == petName and v.id ~= "practice_dog" and v.properties.age ~= 6 and not v.properties.mega_neon then
            if BulkPotion.PetAge < v.properties.age then
                BulkPotion.PetAge = v.properties.age
                BulkPotion.PetUniqueId = v.unique
            end
        end
    end

    if BulkPotion.PetUniqueId ~= "" then
        RouterClient.get("ToolAPI/Unequip"):InvokeServer(BulkPotion.PetUniqueId, { ["use_sound_delay"] = true })
        task.wait(1)
        RouterClient.get("ToolAPI/Equip"):InvokeServer(BulkPotion.PetUniqueId, { ["use_sound_delay"] = true })
        waitForPetToEquip()
        return true
    end

    return false
end

function BulkPotion.IsPetNeon(petName: string): boolean
    BulkPotion.PetAge = 0
    BulkPotion.PetUniqueId = ""

    for _, v: PetType in ClientData.get_data()[localPlayer.Name].inventory.pets do
        if
            v.id == petName
            and v.id ~= "practice_dog"
            and v.properties.age ~= 6
            and v.properties.neon
            and not v.properties.mega_neon
        then
            if BulkPotion.PetAge < v.properties.age then
                BulkPotion.PetAge = v.properties.age
                BulkPotion.PetUniqueId = v.unique
            end
        end
    end

    if BulkPotion.PetUniqueId ~= "" then
        RouterClient.get("ToolAPI/Unequip"):InvokeServer(BulkPotion.PetUniqueId, { ["use_sound_delay"] = true })
        task.wait(1)
        RouterClient.get("ToolAPI/Equip"):InvokeServer(BulkPotion.PetUniqueId, { ["use_sound_delay"] = true })
        waitForPetToEquip()
        return true
    end

    if BulkPotion.IsPetNormal(petName) then
        return true
    else
        return false
    end
end

function BulkPotion.IsSameUnique(): boolean
    for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
        if v.id == "pet_age_potion" or v.id == "tiny_pet_age_potion" then
            if table.find(BulkPotion.SameUnqiue, v.unique) then
                BulkPotion.SameUnqiueCount += 1
                if BulkPotion.SameUnqiueCount >= 15 then
                    BulkPotion.SameUnqiueCount = 0
                    BulkPotion.SameUnqiue = {}
                end
                task.wait(1)
                return true
            end
        end
    end

    BulkPotion.SameUnqiueCount = 0
    BulkPotion.SameUnqiue = {}
    return false
end

function BulkPotion.IsEgg(): boolean
    local EquipTimeout = 0
    local hasPetChar = false
    repeat
        task.wait(1)
        hasPetChar = if ClientData.get("pet_char_wrappers")[1] and ClientData.get("pet_char_wrappers")[1]["char"]
            then true
            else false
        EquipTimeout += 1
    until hasPetChar or EquipTimeout >= 30
    if EquipTimeout >= 30 then
        BulkPotion.StopAging = true
        return true
    end
    local isEgg = if table.find(BulkPotion.EggList, ClientData.get("pet_char_wrappers")[1]["pet_id"])
        then true
        else false
    return isEgg
end

function BulkPotion.FeedAgePotion(): ()
    if BulkPotion.IsEgg() then
        return
    end
    if BulkPotion.IsSameUnique() then
        return
    end

    BulkPotion.SameUnqiueCount = 0

    local potionUniques
    potionUniques = getPotionUniques("pet_age_potion")
    if #potionUniques <= 0 then
        table.clear(potionUniques)
        potionUniques = getPotionUniques("tiny_pet_age_potion")
    end

    if #potionUniques <= 0 then
        return
    end

    BulkPotion.SameUnqiue = potionUniques :: any
    print(`USING POTIONS: {#potionUniques}`)
    print(createPotionObject(potionUniques))
    task.wait(1)
    consumeItem("AgePotion")
    -- local mainFrame = gethui()["StatsGui"]:WaitForChild("MainFrame") :: Frame
    -- local TotalPotions = mainFrame:WaitForChild("MiddleFrame"):WaitForChild("TotalPotions") :: TextLabel
    -- local TotalTinyPotions = mainFrame:WaitForChild("MiddleFrame"):WaitForChild("TotalTinyPotions") :: TextLabel

    -- local UpdateTextEvent = ReplicatedStorage:WaitForChild("UpdateTextEvent") :: BindableEvent
    -- UpdateTextEvent:Fire()
    return
end

function BulkPotion.AgeAllPetsOfSameName(petId: string, maxAmount: number): boolean
    Fusion.MakeMega(false) -- makes neon
    task.wait(1)
    Fusion.MakeMega(true) -- makes mega
    task.wait(1)
    
    local result = getMaxMega(petId)
    if result >= maxAmount then
        return false
    end

    -- equip the pet only if its neon or normal and age is less then 6
    local hasPet = BulkPotion.IsPetNeon(petId)
    if not hasPet then
        return false
    end

    while true do
        if BulkPotion.IsEgg() then
            return false
        end

        if ClientData.get("pet_char_wrappers")[1]["pet_progression"]["age"] >= 6 then
            break
        end

        if not hasAgeUpPotion() then
            BulkPotion.StopAging = true
            return false
        end

        BulkPotion.FeedAgePotion()
        task.wait()
    end

    if BulkPotion.StopAging then
        return false
    end

    BulkPotion.AgeAllPetsOfSameName(petId, maxAmount)
    return false
end

function BulkPotion.StartAgingPets(petsTable: { { NameId: string, MaxAmount: number } }): ()
    assert(typeof(petsTable) == "table", "is not a table")

    -- if typeof(petsTable[1]) ~= "table" then
    --     petsTable = formatTableToDict(petsTable)
    -- end
    getPetEggs()
    for _, value in ipairs(petsTable) do
        if BulkPotion.StopAging then
            return
        end

        local result = getMaxMega(value.NameId)
        if not value.MaxAmount then
            value.MaxAmount = 999
        end
        if result >= value.MaxAmount then
            return
        end
        BulkPotion.AgeAllPetsOfSameName(value.NameId, value.MaxAmount)
    end
    return
end

export type BulkPotion = typeof(BulkPotion)
-----------------------------
-- MAIN --
-----------------------------
return BulkPotion
