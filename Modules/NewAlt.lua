if not game:IsLoaded() then
	game.Loaded:Wait()
end

if game.PlaceId ~= 920587237 then
	return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local LegacyTutorial = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Game"):WaitForChild("Tutorial"):WaitForChild("LegacyTutorial"))
local ClientData = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Core"):WaitForChild("ClientData"))
local RouterClient = require(ReplicatedStorage.ClientModules:WaitForChild("Core"):WaitForChild("RouterClient"):WaitForChild("RouterClient"))

local pickColorConn

local localPlayer = Players.LocalPlayer

local function fireButton(button)
	print(`fire button: {button}`)
	local success, errorMessage = pcall(function()
		firesignal(button.MouseButton1Down)
		firesignal(button.MouseButton1Click)
		firesignal(button.MouseButton1Up)
	end)
	print(button, success, errorMessage)
end

local function pickColorTutorial()
	local colorButton = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog
		:WaitForChild("Info")
		:WaitForChild("Response")
		:WaitForChild("ColorTemplate")

	if not colorButton then return end
	fireButton(colorButton)
	task.wait(5)

	local doneButton = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog
		:WaitForChild("Buttons")
		:WaitForChild("ButtonTemplate")

	if not doneButton then return end
	fireButton(doneButton)
	-- clickGuiButton(colorButton)
	-- clickGuiButton(doneButton)
end

pickColorConn = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog:GetPropertyChangedSignal("Visible"):Connect(function()
	if localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Visible then
		print("picking color")
		pickColorTutorial()
		if pickColorConn then
			pickColorConn:Disconnect()
			pickColorConn = nil
		end
	end
end)

repeat
	task.wait(5)
until localPlayer.PlayerGui.NewsApp.Enabled or localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Visible

UserGameSettings.GraphicsQualityLevel = 1
UserGameSettings.MasterVolume = 0

for i, v in debug.getupvalue(RouterClient.init, 7) do
	v.Name = i
end

if localPlayer.PlayerGui.NewsApp.Enabled then
	local AbsPlay = localPlayer.PlayerGui.NewsApp
		:WaitForChild("EnclosingFrame")
		:WaitForChild("MainFrame")
		:WaitForChild("Contents")
		:WaitForChild("PlayButton")
	-- clickGuiButton(AbsPlay)
	fireButton(AbsPlay)
	-- NewsAppConnection:Disconnect()
end

task.wait(10)
print("START DOING TUTORIAL")
LegacyTutorial.cancel_tutorial()
task.wait(10)
ReplicatedStorage.API["LegacyTutorialAPI/MarkTutorialCompleted"]:FireServer()
print("MarkTutorialCompleted")
-- Bypass("TutorialClient").cancel()
task.wait(10)
ReplicatedStorage.API["LegacyTutorialAPI/EquipTutorialEgg"]:FireServer()
print("EquipTutorialEgg")
task.wait(10)
ReplicatedStorage.API["LegacyTutorialAPI/AddTutorialQuest"]:FireServer()
print("AddTutorialQuest")
task.wait(10)
ReplicatedStorage.API["LegacyTutorialAPI/AddHungryAilmentToTutorialEgg"]:FireServer()
print("AddHungryAilmentToTutorialEgg")
task.wait(1)

local function feedStartEgg(SandwichPassOn)
    local Foodid2
    for _, v in pairs(ClientData.get_data()[localPlayer.Name].inventory.food) do
        if v.id == SandwichPassOn then
            Foodid2 = v.unique
            break
        end
    end

    ReplicatedStorage.API["ToolAPI/Equip"]:InvokeServer(Foodid2, { ["use_sound_delay"] = true })
    task.wait(1)
    -- ReplicatedStorage.API["PetAPI/ConsumeFoodItem"]:FireServer(Foodid2, ClientData.get("pet_char_wrappers")[1].pet_unique)
    local args = {
        [1] = "__Enum_PetObjectCreatorType_2",
        [2] = {
            ["pet_unique"] = ClientData.get("pet_char_wrappers")[1].pet_unique,
            ["unique_id"] = Foodid2
        }
    }
    
    ReplicatedStorage.API["PetObjectAPI/CreatePetObject"]:InvokeServer(unpack(args))
end

feedStartEgg("sandwich-default")


