local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local snakes = {}

local function getSnakeUnique()
    table.clear(snakes)
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if v.id == "garden_2024_garden_snake" and v.properties.neon and not v.properties.mega_neon then
            table.insert(snakes, v.unique)
            return true
        end
    end
    return false
end

local function turnInPet()
    local args = {
        [1] = "f-1",
        [2] = "UseBlock",
        [3] = {
            ["r_1"] = snakes[1],
        },
        [4] = Player.Character
    }

    ReplicatedStorage.API["HousingAPI/ActivateInteriorFurniture"]:InvokeServer(unpack(args))
end

-- ReplicatedStorage.API["LocationAPI/SetLocation"]:FireServer("Garden2024SecretGarden")

-- repeat
--     local hasUnique = getSnakeUnique()
--     if hasUnique then
--         turnInPet()
--     end
--     task.wait(1)
-- until not hasUnique

local hasUnique = getSnakeUnique()
if hasUnique then
    turnInPet()
end
task.wait(1)