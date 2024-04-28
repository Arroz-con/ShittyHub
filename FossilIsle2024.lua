local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local VI = game:GetService("VirtualInputManager")
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
            Player.Character.HumanoidRootPart.Anchored = true
            Player.Character.HumanoidRootPart.CFrame = block.MiningBlockRoot.CFrame + Vector3.new(0, 7, 0)
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


Player.Character.ChildAdded:Connect(function(child)
    if child.Name == "FossilMiningPickaxe" then
        child:WaitForChild("ModelHandle")
        pickupPickaxe()
    end
end)


task.wait(3)
findButton("Auto Mine: Off")

print("mining dirt")
mineBlock("Dirt")
print("finished mining dirt")

print("mining stone")
mineBlock("Stone")
print("finished mining stone")

print("has Granite pcikaxe")
print("mining granite")
mineBlock("Granite")

findButton("Auto Mine: On")
print("Finished")
