local Players = game:GetService("Players")

local Keyboard = loadstring(game:HttpGet("https://raw.githubusercontent.com/Arroz-con/ShittyHub/main/Modules/Keyboard.luau"))()

local localPlayer = Players.LocalPlayer

local Ailments = {}

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
    Keyboard:PressEKey()
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
    Keyboard:PressEKey()
end


return Ailments