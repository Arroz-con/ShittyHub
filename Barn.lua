local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local function getId()
    local ModelName = tostring(workspace.Interiors:FindFirstChildWhichIsA("Model"))
    if not ModelName then
        repeat
            ModelName = tostring(workspace.Interiors:FindFirstChildWhichIsA("Model"))
            task.wait(1)
        until ModelName
    end

    print(ModelName:match("::(.+)"))
    return ModelName:match("::(.+)")
end

local function hasStableToken()
    for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.toys do
        if v.id == "summerfest_2024_stable_token" then
            return true
        end
    end
    return false
end

if hasStableToken() then
    local stuckTimer = 0
    -- bring up lobby popup window
    ReplicatedStorage.API["MinigameAPI/LobbyCreate"]:InvokeServer("showhorse")
    task.wait()

    -- start minigame
    ReplicatedStorage.API["MinigameAPI/LobbyStart"]:FireServer()
    task.wait()
    -- wait till minigame loads up

    repeat
        stuckTimer += 1
        task.wait(1) 
    until workspace.StaticMap["showhorse_minigame_state"]["is_game_active"].Value == true or stuckTimer >= 30
    
    print(stuckTimer)
    if stuckTimer >= 30 then
        print("player is stuck, teleporting to main map")
    end

    print("loaded in minigame")
    task.wait(5)
    local minigameId = tostring(getId())
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_hay_pile"
    } 
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
    task.wait()
    local function dropOff(num: number)
        local args = {
            [1] = "showhorse::"..minigameId,
            [2] = "attempt_interact_with_dropoff_point",
            [3] = num,
            [4] = 1
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
    end

    for i = 1, 10, 1 do
        dropOff(i)
        task.wait(1)
    end
end
