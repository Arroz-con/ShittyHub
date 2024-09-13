local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

-- local coinsFolder = workspace.StaticMap.OceanMinigameInteriorStatic.Spawns.SelectedSpawns
local CrazySea = {}

function CrazySea.GetChest()
	for _, v in workspace.Interiors.OceanMinigameInterior.GameObjects:GetDescendants() do
		if not workspace.Interiors:FindFirstChild("OceanMinigameInterior") then
			break
		end
		if v.Name == "Ocean2024ChestLegendary" or v.Name == "Ocean2024ChestStandard" then
			if not v:FindFirstChild("Root") then
				continue
			end
			Player.Character.HumanoidRootPart.CFrame = v.Root.CFrame
			task.wait(0.50)
		end
	end
end

function CrazySea.GetCoins()
	for _, v in workspace.Interiors.OceanMinigameInterior.GameObjects:GetDescendants() do
		if not workspace.Interiors:FindFirstChild("OceanMinigameInterior") then
			break
		end
		if v.Name == "Ocean2024Coin" then
			if not v:FindFirstChild("Root") then
				continue
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Root.CFrame
			task.wait(0.25)
		end
	end
end

return CrazySea
