local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

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

local function pickUpBucket(whichSide: number)
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_dropoff_point",
        [3] = 7,
        [4] = whichSide
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
end

local function pickUpFoodForHorse(foodId)
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = foodId
    } 
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
end

local function feedHorse(stable: number, leftOrRight: number)
    -- left = 1, right = 2
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_dropoff_point",
        [3] = stable,
        [4] = leftOrRight
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("MinigameAPI/MessageServer"):FireServer(unpack(args))
    print("placed food on ground")
end


Player.PlayerGui.MinigameInGameApp:GetPropertyChangedSignal("Enabled"):Connect(function()
    if Player.PlayerGui.MinigameInGameApp.Enabled then
        Player.PlayerGui.MinigameInGameApp:WaitForChild("Body")
        Player.PlayerGui.MinigameInGameApp.Body:WaitForChild("Middle")
        Player.PlayerGui.MinigameInGameApp.Body.Middle:WaitForChild("Container")
        Player.PlayerGui.MinigameInGameApp.Body.Middle.Container:WaitForChild("TitleLabel")
        if Player.PlayerGui.MinigameInGameApp.Body.Middle.Container.TitleLabel.Text:match("SPEEDY STABLES") then
            minigameId = tostring(getId())

            repeat
                local showhorseFolder = workspace.Interiors:FindFirstChildWhichIsA("Model")
                if not showhorseFolder then
                    repeat
                        task.wait(1)
                        showhorseFolder = workspace.Interiors:FindFirstChildWhichIsA("Model")
                    until showhorseFolder
                end
                -- DropoffAreas.1.horse.PetModel.Head.ShowhorseMinigameNeedsGui.Container.Bubble.Needs.HayTemplate.Incomplete.Visible
                for i, area in ipairs(showhorseFolder:WaitForChild("DropoffAreas"):GetChildren()) do
                    if area:FindFirstChild("horse") then
                        local needs = area.horse:FindFirstChild("Needs", true)
                        print(area.Name)
                        for key, template in needs:GetChildren() do
                            if template.Name == "HayTemplate" then
                                if template:WaitForChild("Complete").Visible then continue end
                                print("doing hay task")
                                pickUpFoodForHorse("attempt_interact_with_hay_pile")
                                task.wait(1)
                                feedHorse(i, 1)

                            elseif template.Name =="CarrotsTemplate" then
                                if template:WaitForChild("Complete").Visible then continue end
                                print("doing carrot task")
                                pickUpFoodForHorse("attempt_interact_with_carrots_pile")
                                task.wait(1)
                                feedHorse(i, 1)

                            elseif template.Name == "WaterTemplate" then
                                if template:WaitForChild("Complete").Visible then continue end
                                print("doing water task")
                                pickUpFoodForHorse("attempt_interact_with_faucet") -- turns on faucet to fill bucket
                                task.wait(1)
                                pickUpBucket(1)
                                feedHorse(i, 2)
                            end
                        end
                    end
                    task.wait(1)
                end
                task.wait(1)
            until not Player.PlayerGui.MinigameInGameApp.Enabled
            
        end
    end 
end)


if hasStableToken() then
    -- bring up lobby popup window
    ReplicatedStorage.API["MinigameAPI/LobbyCreate"]:InvokeServer("showhorse")
    task.wait()

    -- start minigame
    ReplicatedStorage.API["MinigameAPI/LobbyStart"]:FireServer()
    task.wait()
    -- wait till minigame loads up
    

    -- repeat
    --     stuckTimer += 1
    --     task.wait(1) 
    -- until workspace.StaticMap["showhorse_minigame_state"]["is_game_active"].Value == true or stuckTimer >= 30
    
    -- print(stuckTimer)
    -- if stuckTimer >= 30 then
    --     print("player is stuck, teleporting to main map")
    -- end
end
