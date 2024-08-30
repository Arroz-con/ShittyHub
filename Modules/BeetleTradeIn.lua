local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local moles = {}

local function getMoleKeys()
    table.clear(moles)
    local count = 0
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == "garden_2024_mole" and not v.properties.neon and not v.properties.mega_neon then
            table.insert(moles, v.unique)
            count += 1
            if count >= 6 then return true end
        end
    end
    return false
end

local function getMolePet()
    local args = {
        [1] = "f-2",
        [2] = "UseBlock",
        [3] = {
            ["r_1"] = moles[1],
            ["r_3"] = moles[2],
            ["r_2"] = moles[3],
            ["r_4"] = moles[4],
            ["r_5"] = moles[5],
            ["r_6"] = moles[6]
        },
        [4] = Player.Character
    }

    ReplicatedStorage.API["HousingAPI/ActivateInteriorFurniture"]:InvokeServer(unpack(args))
end

ReplicatedStorage.API["LocationAPI/SetLocation"]:FireServer("Garden2024SecretGarden")

repeat
    local hasKeys = getMoleKeys()
    if hasKeys then
        getMolePet()
    end
    task.wait(1)
until not hasKeys