local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local Ailments = {}


local function pressBackButton()
    if not localPlayer.PlayerGui.FocusPetApp then return end
    if not localPlayer.PlayerGui.FocusPetApp.BackButton then return end
    firesignal(localPlayer.PlayerGui.FocusPetApp.BackButton.MouseButton1Click)
end

local function findMysteryIcon()
    local questionMarkIcon = "rbxassetid://18939211149"
    local ailments = localPlayer.PlayerGui:WaitForChild("FocusPetApp"):WaitForChild("Frame"):WaitForChild("Ailments")

    for _, v in ailments:GetDescendants() do
        if v:IsA("ImageLabel") and v.Image == questionMarkIcon then
            firesignal(v.Parent.Parent.MouseButton1Click)
            return
        end
    end
end

function Ailments:ClickMysteryAilment()
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
    pressBackButton()
end


return Ailments