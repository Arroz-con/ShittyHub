local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer
local ClientData = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Core"):WaitForChild("ClientData"))

local Christmas2024 = {}

local function createLobby()
    print(ReplicatedStorage.API["MinigameAPI/LobbyCreate"]:InvokeServer("frostclaws_revenge"))
end

local function startLobby()
    ReplicatedStorage.API["MinigameAPI/LobbyStart"]:FireServer()
end

local function getMinigameId()
    local folderName = workspace.Minigames:FindFirstChildWhichIsA("Folder")
    if not folderName then
        local count = 0
        repeat
            task.wait(1)
            count += 1
            folderName = workspace.Minigames:FindFirstChildWhichIsA("Folder")
        until folderName  or count > 60
        if count > 60 then
            print("wouldnt get minigame id")
            return nil
        end
    end

    return folderName.Name:split("::")[2]
end

local function hitEnemy(name, gameId)
    local args = {
        [1] = "frostclaws_revenge::"..gameId,
        [2] = "hit_enemies",
        [3] = {
            [1] = name
        },
        [4] = "sword_slash"
    }

    ReplicatedStorage.API["MinigameAPI/MessageServer"]:FireServer(unpack(args))
end

function Christmas2024.StartGame()
    createLobby()
    startLobby()

    local minigameId = getMinigameId()
    if not minigameId then return end

    local isGameActive = true

    while isGameActive do
        for _, v in workspace.Minigames[`FrostclawsRevengeInterior::{minigameId}`]:WaitForChild("FrostclawsRevengeEnemies"):GetChildren() do
            hitEnemy(v.Name, minigameId)
        end
        
        local minigameStateFolder = workspace.StaticMap:FindFirstChild(`frostclaws_revenge::{minigameId}_minigame_state`)
        if not minigameStateFolder then print("game over or no folder") break end
        isGameActive = minigameStateFolder:WaitForChild("is_game_active").Value
        task.wait(1)
    end
end

function Christmas2024.getGingerbread()
    local GingerbreadMarkers = ReplicatedStorage.Resources.IceSkating.GingerbreadMarkers
    for _, v in GingerbreadMarkers:GetChildren() do
        if v:IsA("BasePart") and not ClientData.get_data()[localPlayer.Name].winter_2024_gingerbread_captured_list[v.Name] then
            ReplicatedStorage.API:FindFirstChild("WinterEventAPI/PickUpGingerbread"):InvokeServer(v.Name)
        end
    end
    ReplicatedStorage.API:FindFirstChild("WinterEventAPI/RedeemPendingGingerbread"):FireServer()
end

function Christmas2024.init()
    localPlayer.PlayerGui.FrostclawsRevengeUpgradeApp.Background.Upgrades.ChildAdded:Connect(function(child)
        if child.Name ~= "Upgrade1" then return end
        child:WaitForChild("Icon")
        child.Icon:WaitForChild("Container")
        child.Icon.Container:WaitForChild("Button")
        print(child.Icon.Container.Button)
        task.wait(5)
        firesignal(child.Icon.Container.Button.Activated)
    end)
end

return Christmas2024