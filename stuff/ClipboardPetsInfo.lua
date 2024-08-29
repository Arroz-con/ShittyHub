local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local InventoryDB = Bypass("InventoryDB")
local Player = Players.LocalPlayer
local debounce = false

local Clipboard = {}

local megaPets = {}
local neonPets = {}
local normalPets = {}
local petList = ""


local function getPetInfoMega(title: string)
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        for _, v2 in InventoryDB.pets do
            if v.id == v2.id and v.properties.mega_neon then
                megaPets[title..v2.name] = (megaPets[title..v2.name] or 0) + 1
            end
        end
    end
    for i, v in megaPets do
        petList = petList..i.." x"..v.."\n"
    end
end

local function getPetInfoNeon(title: string)
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        for _, v2 in InventoryDB.pets do
            if v.id == v2.id and v.properties.neon then
                neonPets[title..v2.name] = (neonPets[title..v2.name] or 0) + 1
            end
        end
    end
    for i, v in neonPets do
        petList = petList..i.." x"..v.."\n"
    end
end

local function getPetInfoNormal(title: string)
    for _, v in pairs(Bypass("ClientData").get_data()[Player.Name].inventory.pets) do
        for _, v2 in InventoryDB.pets do
            if v.id == v2.id and not v.properties.neon and not v.properties.mega_neon then
                normalPets[title..v2.name] = (normalPets[title..v2.name] or 0) + 1
            end
        end
    end
    for i, v in normalPets do
        petList = petList..i.." x"..v.."\n"
    end
end

function Clipboard:CopyPetInfo()
    if debounce then return end
    debounce = true
    getPetInfoMega("[MEGA NEON] ")
    getPetInfoNeon("[NEON] ")
    getPetInfoNormal("[Normal] ")
    setclipboard(petList)
    petList = ""
    task.wait()
    debounce = false
end

return Clipboard

-- Pets = Pets.."\nYou have a total of: "..TotalPets.." pets"
