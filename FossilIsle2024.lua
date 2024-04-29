local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local VI = game:GetService("VirtualInputManager")
local camera = workspace.CurrentCamera
local viewportSize = camera.ViewportSize
local middleScreen = viewportSize / 2

local ExposedBlocks = game:GetService("Workspace").Interiors.FossilIsleInterior.ExposedBlocks

local function findButton(onOrOff)
    for i, v in Player.PlayerGui.ExtraButtonsApp.Frame:GetDescendants() do
        if v.Name == "TextLabel" then
            if v.Text == onOrOff then
                task.wait()
                VI:SendMouseButtonEvent(v.Parent.Parent.AbsolutePosition.X + 60, v.Parent.Parent.AbsolutePosition.Y + 60, 0, true, game, 1)
                task.wait()
                VI:SendMouseButtonEvent(v.Parent.Parent.AbsolutePosition.X + 60, v.Parent.Parent.AbsolutePosition.Y + 60, 0, false, game, 1)
            end
        end
    end
end

local function findBlock(blockType)
    for _, v in ExposedBlocks:GetChildren() do
        if v.Name == blockType then
            local hits = v:GetAttribute("hits")
            return v, hits
        end
    end
    return false, 99
end

local function checkOre(ore)
    return Bypass("ClientData").get_data()[Player.Name].fossil_2024_mine_manager[ore]
end


local function upgradePickaxe(pickaxeId)
    ReplicatedStorage.API["MiningAPI/StartMachineAction"]:InvokeServer("Pickaxe", pickaxeId)
end

local function pickupPickaxe()
    ReplicatedStorage.API["MiningAPI/ClaimMachineAction"]:InvokeServer("Pickaxe")
end

local function mineBlock(blockType)
    repeat
        local block, hits = findBlock(blockType)
        if block then
            VI:SendMouseButtonEvent(middleScreen.X, middleScreen.Y + 80, 0, true, game, 1)
            task.wait()
            VI:SendMouseButtonEvent(middleScreen.X, middleScreen.Y + 80, 0, false, game, 1)
            Player.Character.HumanoidRootPart.Anchored = true
            local root = block:FindFirstChild("MiningBlockRoot")
            if not root then continue end
            Player.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 5, 0)
        end

        if checkOre("iron_ore") == 10 then
            upgradePickaxe("fossil_2024_iron_pickaxe")
        end

        if checkOre("diamond_ore") == 20 then
            upgradePickaxe("fossil_2024_diamond_pickaxe")
        end

        task.wait(1)

    until not block
end

Player.PlayerGui.HintApp.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if Player.PlayerGui.HintApp.TextLabel.Text:match("pickaxe") then
        pickupPickaxe()
    end
end)


task.wait(5)
findButton("Auto Mine: Off")

print("mining dirt")
mineBlock("Dirt")
print("finished mining dirt")
pickupPickaxe()

print("mining stone")
mineBlock("Stone")
print("finished mining stone")
pickupPickaxe()

print("mining granite")
mineBlock("Granite")

findButton("Auto Mine: On")
Player.Character.HumanoidRootPart.Anchored = false
print("Finished")
