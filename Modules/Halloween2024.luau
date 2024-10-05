local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys", 600)).load
local Player = Players.LocalPlayer

local Halloween2024 = {}

local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/Teleport.lua"))()

-- "MainMap" "SkyCastle" "TileSkipMinigame" "Neighborhood"
function Halloween2024:GetPumpkins(mapName: string)
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.available_pumpkins[mapName] == 0 then return end
    print(Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.available_pumpkins[mapName])
    if not workspace.Collectables then return end

    for _, id in workspace.Collectables:GetChildren() do
        if not id:IsA("Model") then continue end
        ReplicatedStorage.API["HalloweenAPI/PurplePumpkinCollected"]:FireServer(mapName, id.Name)
        task.wait(1)
    end
end

function Halloween2024:GetAllPumpkins()
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.purple_pumpkins == 25 then return end
    Teleport.Neighborhood()
    task.wait(5)
    Halloween2024:GetPumpkins("Neighborhood")
    task.wait(1)
    Teleport.MainMap()
    task.wait(5)
    Halloween2024:GetPumpkins("MainMap")
    task.wait(1)
    Teleport.SkyCastle()
    task.wait(5)
    Halloween2024:GetPumpkins("SkyCastle")
    task.wait(1)
end

function Halloween2024:FinishMiniGame()
    local args = {
        [1] = "tile_skip_minigame",
        [2] = "reached_goal"
    }

    game:GetService("ReplicatedStorage").API:FindFirstChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
end

function Halloween2024:BuyPet(petNameId: string, howManyToBuy: number)
    for _ = 1, howManyToBuy do
        local hasMoney = game.ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", petNameId, {})
        if hasMoney == "too little money" then
            return
        end
        task.wait(.1)
    end
end

return Halloween2024
