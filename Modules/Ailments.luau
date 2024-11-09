local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local Ailments = {}

local function endpressEKey()
    keypress(0x45)
    task.wait()
    keyrelease(0x45)
end

local function findMysteryIcon()
    local questionMarkIcon = "rbxassetid://18939211149"
    local ailments = localPlayer.PlayerGui:WaitForChild("FocusPetApp"):WaitForChild("Frame"):WaitForChild("Ailments")

    for _, v in ailments:GetDescendants() do
        if v:IsA("ImageLabel") and v.Image == questionMarkIcon then
            print(v.Parent.Parent)
            firesignal(v.Parent.Parent.MouseButton1Click)
            return
        end
    end
end

function Ailments:ClickMysteryAilment()
    endpressEKey()
    task.wait(1)
    findMysteryIcon()
    task.wait(1)

    local chooseAilments = localPlayer.PlayerGui.FocusPetApp:WaitForChild("ChooseAilment").Choices:GetChildren()
    for _, v in chooseAilments do
        if v:IsA("ImageButton") then
            firesignal(v.MouseButton1Click)
            return
        end
    end
    
    task.wait(1)
    endpressEKey()
end

-- step 1
-- press E


-- step 2
-- check icon to see thats it a ? (mystery)
-- End is the imageButton


-- firesignal(game:GetService("Players").LocalPlayer.PlayerGui.FocusPetApp.Frame.Ailments:GetChildren()[3].End.Background.Icon)

-- game:GetService("Players").LocalPlayer.PlayerGui.FocusPetApp.Frame.Tooltip.AilmentCard

-- mystery clicked choices
task.wait(1)
-- firesignal(game:GetService("Players").LocalPlayer.PlayerGui.FocusPetApp.ChooseAilment.Choices:GetChildren()[math.random(1, 3)].MouseButton1Click)


keypress(0x45)
task.wait()
keyrelease(0x45)

return Ailments