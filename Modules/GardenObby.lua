local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

local get_thread_identity = get_thread_identity or gti or getthreadidentity or getidentity or syn.get_thread_identity or fluxus.get_thread_identity
local set_thread_identity = set_thread_context or sti or setthreadcontext or setidentity or syn.set_thread_identity or fluxus.set_thread_identity

local SetLocationTP
--//grab teleportation function
for _, v in pairs(getgc()) do 
    if type(v) == "function" then
        if getfenv(v).script == game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then 
            if table.find(getconstants(v), "LocationAPI/SetLocation") then 
                SetLocationTP = v 
                break
            end 
        end 
    end 
end

local function SetLocationFunc(a, b, c)
    local k = get_thread_identity() --syn.get_thread_identity
    set_thread_identity(2)
    SetLocationTP(a,b,c)
    set_thread_identity(k)
end

local function TeleportGardenObby(name)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    SetLocationFunc(name, "MainDoor", {})
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))                           -- game:GetService("Workspace").Interiors.Garden2024ChaseMap1.Programmed.Skip.FinishSpawn
    Player.Character.PrimaryPart.CFrame = game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model"))).Programmed.Skip.FinishSpawn.CFrame + Vector3.new(0, 10, 0)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
end

local function TeleportMainObby()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    local isAlreadyOnObby = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("Obbies", true)
    if not isAlreadyOnObby then
        SetLocationFunc("Obbies", "Garden2024ChaseMap1", {})
    end
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))                           -- game:GetService("Workspace").HouseInteriors.furniture["nil/nil/Obbies/false/f-1"].Garden2024Sunflower.CollectionZone
    Player.Character.PrimaryPart.CFrame = game.Workspace.HouseInteriors:FindFirstChild("CollectionZone", true).CFrame + Vector3.new(0, 5, 0)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
end

local function findFurniture()
    for _, v in pairs(game:GetService("Workspace").HouseInteriors.furniture:GetDescendants()) do
        if v.Name == "BasicCrib" then
            Bed = v.Parent.Name:match("%a+-%d+")

        elseif v.Name == "StylishShower" or v.Name == "ModernShower" then
            Shower = v.Parent.Name:match("%a+-%d+")

        elseif v.Name == "Piano" then
            Piano = v.Parent.Name:match("%a+-%d+")

        elseif v.Name == "Lures2023NormalLure" then
            normalLure = v.Parent.Name:match("%a+-%d+")

        end
    end
end

local function ObbyNextStage()
    local door = workspace.HouseInteriors.furniture:FindFirstChild("Door", true)
    local counter = 0

    firetouchinterest(Player.Character.HumanoidRootPart, door, 0)

    repeat
        counter += 1
        task.wait(1)
    until workspace:FindFirstChild("SundropPickup") or counter == 10

    if counter == 10 then
        TeleportMainObby()
    end
end

local function ClaimSundrops()
    local args = {
        [1] = "f-1",
        [2] = "UseBlock",
        [3] = true,
        [4] = Player.Character
    }

    ReplicatedStorage.API["HousingAPI/ActivateInteriorFurniture"]:InvokeServer(unpack(args))
end

local function getSunDrops()
    local Sundrop = workspace:FindFirstChild("SundropPickup")
    if not Sundrop then return false end
    Sundrop:WaitForChild("Collider", 6)

    firetouchinterest(Player.Character.HumanoidRootPart, Sundrop.Collider, 0)

    return true
end

for i = 1, 8, 1 do
    game.ReplicatedStorage.API["EventAPI/ClaimObbyReward"]:InvokeServer(i)
    task.wait(.5)
end

while true do
    TeleportGardenObby("Garden2024ChaseMap7")

    repeat
        local hasSunDrop = getSunDrops()
        task.wait(.1)
    until not hasSunDrop

    -- for _ = 2, 7, 1 do
    --     ObbyNextStage()
    --     repeat
    --         local hasSunDrop = getSunDrops()
    --         task.wait(.1)
    --     until not hasSunDrop
    -- end

    TeleportMainObby()
    task.wait(6)
    ClaimSundrops()
    task.wait(1)
end
