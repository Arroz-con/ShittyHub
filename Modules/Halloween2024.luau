local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys", 600)).load
local Player = Players.LocalPlayer

local Halloween2024 = {}

local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/Teleport.lua"))()

-- "MainMap" "SkyCastle" "TileSkipMinigame" "Neighborhood"
function Halloween2024:GetPumpkins(mapName: string)
    if not workspace.Collectables then return end

    for _, id in workspace.Collectables:GetChildren() do
        if not id:IsA("Model") then continue end
        ReplicatedStorage.API["HalloweenAPI/PurplePumpkinCollected"]:FireServer(mapName, id.Name)
        task.wait(1)
        if not workspace.Collectables then return end
    end
end


function Halloween2024:GetAllPumpkins()
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.purple_pumpkins == 25 then return end
    
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.available_pumpkins.Neighborhood >= 1 then
        Teleport.Neighborhood()
        task.wait(5)
        Halloween2024:GetPumpkins("Neighborhood") 
    end
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.available_pumpkins.MainMap >= 1 then
        Teleport.MainMap()
        task.wait(5)
        Halloween2024:GetPumpkins("MainMap")
    end
    if Bypass("ClientData").get_data()[Player.Name].halloween_2024_purple_pumpkins.available_pumpkins.SkyCastle >= 1 then
        Teleport.SkyCastle()
        task.wait(5)
        Halloween2024:GetPumpkins("SkyCastle")
    end
end

function Halloween2024:FinishMiniGame()
    local args = {
        [1] = "tile_skip_minigame",
        [2] = "reached_goal"
    }

    game:GetService("ReplicatedStorage").API:FindFirstChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
end

function Halloween2024:BuyPet(petNameId: string)
    local hasMoney = game.ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("pets", petNameId, {})
    if hasMoney == "too little money" then
        return false
    end
    return true
end

function Halloween2024:Exchange(boxId)
    ReplicatedStorage.API["ShopAPI/BuyItem"]:InvokeServer("gifts", boxId, {})
    task.wait()
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.gifts do
        if v["id"] == boxId then
            ReplicatedStorage.API["LootBoxAPI/ExchangeItemForReward"]:InvokeServer(v["id"], v["unique"])
            return true
        end
    end
    return false
end

function Halloween2024:GetGravestones()
    for index, bool in Bypass("ClientData").get_data()[Player.Name].graveyard_manager.gravestones_pushed do
        if bool then continue end
        ReplicatedStorage.API["HalloweenAPI/PushGravestone"]:InvokeServer(index)
        task.wait(.1)
    end    
end


return Halloween2024
