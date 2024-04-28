local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local VI = game:GetService("VirtualInputManager")
local ExposedBlocks = game:GetService("Workspace").Interiors.FossilIsleInterior.ExposedBlocks

local function findButton()
    for i, v in Player.PlayerGui.ExtraButtonsApp.Frame:GetDescendants() do
        if v.Name == "TextLabel" then
            if v.Text == "Auto Mine: Off" then
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

local function checkIron()
    return Bypass("ClientData").get_data()[Player.Name].fossil_2024_mine_manager.iron_ore
end

local function upgradePickaxe()
    ReplicatedStorage.API["MiningAPI/StartMachineAction"]:InvokeServer("Pickaxe", "fossil_2024_iron_pickaxe")
end

local function pickupPickaxe()
    ReplicatedStorage.API["MiningAPI/ClaimMachineAction"]:InvokeServer("Pickaxe")
end

local function mineBlock(blockType)
    repeat
        local block, hits = findBlock(blockType)
        print(block, hits)
        if block then
            Player.Character.HumanoidRootPart.CFrame = block.MiningBlockRoot.CFrame + Vector3.new(0, 5, 0)
        end

        if checkIron() == 10 then
            upgradePickaxe()
        end

        task.wait(1)

    until not block
end

local function waitingForPickaxe(pickaxeName)
    if not Player.Character.FossilMiningPickaxe.ModelHandle[pickaxeName] then
        local count = 0
        repeat
            pickupPickaxe()
            count += 1
            print("Waiting for Pickaxe")
            task.wait(60)
        until Player.Character.FossilMiningPickaxe.ModelHandle[pickaxeName] or count == 420
    end
end

task.wait(3)
findButton()

mineBlock("Dirt")
print("finished mining dirt")
waitingForPickaxe("PickaxeTrail_Iron")
print("has iron pcikaxe")
mineBlock("Stone")
print("finished mining stone")
print("ran")
