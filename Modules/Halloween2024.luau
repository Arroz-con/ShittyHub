local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Halloween2024 = {}

-- "MainMap" "SkyCastle" "TileSkipMinigame"
function Halloween2024:GetPumpkins(mapName: string)
    if not workspace.Collectables then return end

    for _, id in workspace.Collectables:GetChildren() do
        if not id:IsA("Model") then continue end
        ReplicatedStorage.API["HalloweenAPI/PurplePumpkinCollected"]:FireServer(mapName, id.Name)
        task.wait()
    end
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
