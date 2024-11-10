local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local Ailments = {}

local function openGuiOfTasks()
    for _, v in game:GetService("Players").LocalPlayer.PlayerGui.InteractionsApp.BasicSelects:GetChildren() do
        if v.Name == "Template" and v.Visible then
            firesignal(v.TapButton.MouseButton1Click)
            break
        end
    end
end

local function pressBackButton()
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
    openGuiOfTasks()
    task.wait(2)
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