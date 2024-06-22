local Player = game:GetService("Players").LocalPlayer

local minigameId
local bucketPosition = {}

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

local function pickUpBucketOrDrop(stable: number, whichSide: number)
    -- stable = 7 is faucet
    local args = {
        [1] = "showhorse::"..minigameId,
        [2] = "attempt_interact_with_dropoff_point",
        [3] = stable,
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
                for i, area in ipairs(showhorseFolder:FindFirstChild("DropoffAreas"):GetChildren()) do
                    if not area then continue end
                    if area:FindFirstChild("horse") then
                        local needs = area.horse:FindFirstChild("Needs", true)
                        if not needs then continue end
                        for _, template in needs:GetChildren() do
                            if template.Name == "HayTemplate" then
                                if not template:FindFirstChild("Complete") then continue end
                                if template.Complete.Visible then continue end
                
                                pickUpFoodForHorse("attempt_interact_with_hay_pile")
                                task.wait(.1)
                                feedHorse(i, 1)

                            elseif template.Name =="CarrotsTemplate" then
                                if not template:FindFirstChild("Complete") then continue end
                                if template.Complete.Visible then continue end
                           
                                pickUpFoodForHorse("attempt_interact_with_carrots_pile")
                                task.wait(.1)
                                feedHorse(i, 1)

                            elseif template.Name == "WaterTemplate" then
                                if not template:FindFirstChild("Complete") then continue end
                                if template.Complete.Visible then continue end
                           
                                if bucketPosition then
                                    pickUpBucketOrDrop(bucketPosition[1], bucketPosition[2])
                                    task.wait(1)
                                    pickUpBucketOrDrop(7, math.random(1, 2))
                                end

                                pickUpFoodForHorse("attempt_interact_with_faucet") -- turns on faucet to fill bucket
                                task.wait(1)
                                pickUpBucketOrDrop(7, math.random(1, 2))
                                task.wait(.1)
                                pickUpBucketOrDrop(i, 2)
                                bucketPosition = {i,2}
                                -- task.wait(1)
                                -- pickUpBucket(i, 2)
                                -- task.wait(.1)
                                -- feedHorse(7, 1)
                            end
                        end
                    end
                    task.wait(.1)
                end
                task.wait(.1)
            until not Player.PlayerGui.MinigameInGameApp.Enabled
            
        end
    end 
end)
