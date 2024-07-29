local Player = game:GetService("Players").LocalPlayer

local minigameId
-- sunshine_2024_sunshine_token

local function getId()
    local ModelName = tostring(workspace.Interiors:FindFirstChildWhichIsA("Model"))
    if not ModelName then
        repeat
            ModelName = tostring(workspace.Interiors:FindFirstChildWhichIsA("Model"))
            task.wait(1)
        until ModelName
    end

    return ModelName:match("::(.+)")
end


local function SetPointsEarned(minigame: string, points: number)
    local args = {
        [1] = "sunshine::"..minigameId,
        [2] = "activity_points_earned",
        [3] = minigame,
        [4] = points
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))

end

local function exitEvent()
    local args = {
        [1] = "sunshine::"..minigameId,
        [2] = false
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/AttemptJoin"):FireServer(unpack(args))
    
end


Player.PlayerGui.MinigameInGameApp:GetPropertyChangedSignal("Enabled"):Connect(function()
    if Player.PlayerGui.MinigameInGameApp.Enabled then
        Player.PlayerGui.MinigameInGameApp:WaitForChild("Body")
        Player.PlayerGui.MinigameInGameApp.Body:WaitForChild("Middle")
        Player.PlayerGui.MinigameInGameApp.Body.Middle:WaitForChild("Container")
        Player.PlayerGui.MinigameInGameApp.Body.Middle.Container:WaitForChild("TitleLabel")
        if Player.PlayerGui.MinigameInGameApp.Body.Middle.Container.TitleLabel.Text:match("SUNSHINE GAMES") then
            minigameId = tostring(getId())
            task.wait(10)
            SetPointsEarned("RockThrow", 100)
            task.wait()
            SetPointsEarned("Trampoline", 100)
            task.wait()
            SetPointsEarned("Tennis", 100)
            task.wait(5)
            exitEvent()
            -- task.wait(10)
            -- if Player.PlayerGui.MinigameInGameApp.Enabled then
            --     exitEvent()
            -- end

        end
    end 
end)
