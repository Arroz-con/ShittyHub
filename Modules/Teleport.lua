local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load

local Player = Players.LocalPlayer
local getconstants = getconstants or debug.getconstants
local getgc = getgc or get_gc_objects or debug.getgc
local get_thread_identity = get_thread_identity or gti or getthreadidentity or getidentity or syn.get_thread_identity or fluxus.get_thread_identity
local set_thread_identity = set_thread_context or sti or setthreadcontext or setidentity or syn.set_thread_identity or fluxus.set_thread_identity


local SetLocationTP

local Teleport = {}

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
    local k = get_thread_identity()
    set_thread_identity(2)
    SetLocationTP(a,b,c)
    set_thread_identity(k)
end

local function removeParts()
    local MainMap = workspace.Interiors:WaitForChild(tostring(workspace.Interiors:FindFirstChildWhichIsA("Model")))
    if not MainMap then print("not in mainmap") return end

    local Static = MainMap:FindFirstChild("StaticMap")
    if not Static then print("didnt find static") return end

    workspace:FindFirstChildWhichIsA("Terrain"):Clear()
    workspace:FindFirstChild("StaticMap"):FindFirstChild("Balloon"):Destroy()
    MainMap.Static:FindFirstChild("Campsite"):Destroy()
    MainMap.Static:FindFirstChild("Bridges"):Destroy()
    MainMap.Static:FindFirstChild("Boundaries"):Destroy()
    MainMap.Static:FindFirstChild("Props"):Destroy()
    MainMap.Static:FindFirstChild("Terrain"):FindFirstChild("Mountains"):Destroy()
    MainMap.Static:FindFirstChild("Terrain"):FindFirstChild("Road"):Destroy()        
    MainMap.Static:FindFirstChild("Terrain"):FindFirstChild("RiverEdge"):Destroy()   
    MainMap.Static:FindFirstChild("ThemeArea"):Destroy()
    MainMap.Static:FindFirstChild("Beach"):Destroy()
    MainMap:FindFirstChild("Park"):Destroy()
    MainMap:FindFirstChild("Buildings"):Destroy()
    MainMap:FindFirstChild("Event"):Destroy()
end


function Teleport.MainMap()
    local isAlreadyOnMainMap = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("center_map_plot", true)
    if isAlreadyOnMainMap then return end
    Bypass("CollisionsClient").set_collidable(false)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    SetLocationFunc("MainMap", "Neighborhood/MainDoor", {})
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))
    Player.Character.PrimaryPart.CFrame = game.Workspace.Interiors:FindFirstChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model"))).Static.Campsite.MarshmallowChair.VintageChair.Union.CFrame + Vector3.new(math.random(1, 10), 10, math.random(1, 10))
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
    removeParts()
    task.wait(2)
end

function Teleport.Nursery()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    SetLocationFunc("Nursery", "MainDoor", {})
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(workspace.Interiors:FindFirstChildWhichIsA("Model")))
    Player.Character.PrimaryPart.CFrame = workspace.Interiors.Nursery:WaitForChild("GumballMachine"):WaitForChild("Root").CFrame + Vector3.new(-8, 10, 0)
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
end

function Teleport.CampSite()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    local isAlreadyOnMainMap = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("center_map_plot", true)
    if not isAlreadyOnMainMap then
        SetLocationFunc("MainMap", "Neighborhood/MainDoor", {})
    end
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))
    Player.Character.PrimaryPart.CFrame = game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model"))).Static.Campsite.MarshmallowChair.VintageChair.Union.CFrame + Vector3.new(math.random(1, 20), 10, math.random(1, 20))
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
    removeParts()
end

function Teleport.BeachParty()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    local isAlreadyOnMainMap = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("center_map_plot", true)
    if not isAlreadyOnMainMap then
        SetLocationFunc("MainMap", "Neighborhood/MainDoor", {})
    end
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model"))) 
    Player.Character.PrimaryPart.CFrame = game:GetService("Workspace").StaticMap.Beach.BeachPartyAilmentTarget.CFrame + Vector3.new(math.random(1, 20), 10, math.random(1, 20))
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
    removeParts()
end

function Teleport.PlayGround()
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
    local isAlreadyOnMainMap = game.Workspace:FindFirstChild("Interiors"):FindFirstChild("center_map_plot", true)
    if not isAlreadyOnMainMap then
        SetLocationFunc("MainMap", "Neighborhood/MainDoor", {})
    end
    task.wait(1)
    game.Workspace.Interiors:WaitForChild(tostring(game.Workspace.Interiors:FindFirstChildWhichIsA("Model")))
    Player.Character.PrimaryPart.CFrame = game:GetService("Workspace").StaticMap.Park.Roundabout.SeatsSpinModel.Visual:FindFirstChildWhichIsA("Part").CFrame + Vector3.new(math.random(1, 20), 10, math.random(-20, -1))
    Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    Player.Character.Humanoid.WalkSpeed = 0
    removeParts()
end

return Teleport