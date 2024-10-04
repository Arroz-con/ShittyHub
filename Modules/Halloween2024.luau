local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Halloween2024 = {}

-- "MainMap"
function Halloween2024:GetPumpkins(mapName: string)
    if not workspace.Collectables then return end

    for _, id in workspace.Collectables:GetChildren() do
        if not id:IsA("Model") then continue end
        ReplicatedStorage.API["HalloweenAPI/PurplePumpkinCollected"]:FireServer(mapName, id.Name)
        task.wait()
    end
end

return Halloween2024
