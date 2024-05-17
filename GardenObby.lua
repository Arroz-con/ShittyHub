local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local Bypass = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

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

local function TeleportGardenObby()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    local isAlreadyOnObby = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("FinishSpawn", true)
    if not isAlreadyOnObby then
        SetLocationFunc("Garden2024ChaseMap1", "MainDoor", {})
    end
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))                           -- game:GetService("Workspace").Interiors.Garden2024ChaseMap1.Programmed.Skip.FinishSpawn
    Player.Character.PrimaryPart.CFrame = game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model"))).Programmed.Skip.FinishSpawn.CFrame + Vector3.new(0, 10, 0)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
end

local function getSunDrops()
    local Sundrop = workspace:FindFirstChild("Collider", true)
    if not Sundrop then return false end

    firetouchinterest(Player.Character.HumanoidRootPart, Sundrop, 0)
    task.wait()
    firetouchinterest(Player.Character.HumanoidRootPart, Sundrop, 1)
    return true
end

TeleportGardenObby()

repeat
    local hasSunDrop = getSunDrops()
    task.wait(1)
until not hasSunDrop

print("done")
