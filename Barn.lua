local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local usingOwnToken = true
local minigameId

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

local function getFoodForHorse(foodId)
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_hay_pile"
    } 
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
    task.wait()
end

local function dropOff(stableNumber: number, leftOrRight: number)
    -- left = 1, right = 2
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_dropoff_point",
        [3] = stableNumber,
        [4] = leftOrRight
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
end

local function minigameLoop(foodId: string, leftOrRight: number)
    for i = 1, 6, 1 do
        getFoodForHorse(foodId)
        dropOff(i, leftOrRight)
        task.wait(1)
    end
end

Player.PlayerGui.MinigameInGameApp:GetPropertyChangedSignal("Enabled"):Connect(function()
    if Player.PlayerGui.MinigameInGameApp.Enabled then
        Player.PlayerGui.MinigameInGameApp:WaitForChild("Body")
        Player.PlayerGui.MinigameInGameApp.Body:WaitForChild("Middle")
        Player.PlayerGui.MinigameInGameApp.Body.Middle:WaitForChild("Container")
        Player.PlayerGui.MinigameInGameApp.Body.Middle.Container:WaitForChild("TitleLabel")
        if Player.PlayerGui.MinigameInGameApp.Body.Middle.Container.TitleLabel.Text:match("SPEEDY STABLES") then
            print("Loaded into minigame")
            minigameId = tostring(getId())
            
            repeat
                minigameLoop("attempt_interact_with_hay_pile", 1)
                minigameLoop("attempt_interact_with_carrots_pile", 2)
                minigameLoop("attempt_interact_with_faucet", 1)
                task.wait()
            until Player.PlayerGui.MinigameInGameApp.Enabled == false
            
        end
    end 
end)


if hasStableToken() or usingOwnToken then
    if usingOwnToken then
        -- bring up lobby popup window
        ReplicatedStorage.API["MinigameAPI/LobbyCreate"]:InvokeServer("showhorse")
        task.wait()

        -- start minigame
        ReplicatedStorage.API["MinigameAPI/LobbyStart"]:FireServer()
        task.wait()
        -- wait till minigame loads up
    end

    -- repeat
    --     stuckTimer += 1
    --     task.wait(1) 
    -- until workspace.StaticMap["showhorse_minigame_state"]["is_game_active"].Value == true or stuckTimer >= 30
    
    -- print(stuckTimer)
    -- if stuckTimer >= 30 then
    --     print("player is stuck, teleporting to main map")
    -- end
end
