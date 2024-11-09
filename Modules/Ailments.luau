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


return Ailments