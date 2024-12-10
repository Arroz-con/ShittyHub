local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ClientData = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("Core"):WaitForChild("ClientData"))

local localPlayer = Players.LocalPlayer

local StatsGuis2 = {}
StatsGuis2.__index = StatsGuis2


local function formatTime(currentTime)
	local hours = math.floor(currentTime / 3600)
	local minutes = math.floor((currentTime % 3600) / 60)
	local seconds = currentTime % 60
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function formatNumber(num)
	if num >= 1e6 then
		-- Millions
		return string.format("%.2fM", num / 1e6)
	elseif num >= 1e3 then
		-- Thousands
		return string.format("%.1fk", num / 1e3)
	else
		-- Less than a thousand
		return tostring(num)
	end
end

local function bucksAmount()
    return ClientData.get_data()[localPlayer.Name].money or 0
end

local function gingerbreadAmount()
    return ClientData.get_data()[localPlayer.Name].gingerbread_2024 or 0
end

local function agePotionCount()
    local count = 0
    for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
        if v.id == "pet_age_potion" then
            count += 1
        end
    end
    return count
end

function StatsGuis2.new(name)
	local self = setmetatable({}, StatsGuis2)
	self.label = Instance.new("TextLabel")
	self.UICorner = Instance.new("UICorner")
	
	self.label.Name = name
	self.label.BackgroundColor3 = Color3.fromRGB(250, 129, 47)
	self.label.BackgroundTransparency = 0.250
	self.label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	self.label.BorderSizePixel = 0
	self.label.Size = UDim2.new(0.330000013, 0, 0.486617982, 0)
	self.label.Font = Enum.Font.FredokaOne
	self.label.RichText = true
	self.label.Text = "label"
	self.label.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.label.TextScaled = true
	self.label.TextSize = 14.000
	self.label.TextStrokeTransparency = 0.000
	self.label.TextWrapped = true
	self.label.Parent = Players.LocalPlayer.PlayerGui.StatsGui.MainFrame.MiddleFrame

	self.UICorner.CornerRadius = UDim.new(0, 16)
	self.UICorner.Parent = self.label
	
	return self
end


function StatsGuis2.Setup()
	local StatsGui = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local TimeLabel = Instance.new("TextLabel")
	local UICorner = Instance.new("UICorner")
	local MiddleFrame = Instance.new("Frame")
	local UIGridLayout = Instance.new("UIGridLayout")
	
	local UICorner_2 = Instance.new("UICorner")
	local NameLabel = Instance.new("TextLabel")
	local UICorner_3 = Instance.new("UICorner")
	local TextButton = Instance.new("TextButton")

	StatsGui.Name = "StatsGui"
	StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	StatsGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 1.000
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.276041657, 0, 0.0577475652, 0)
	MainFrame.Size = UDim2.new(0.674468458, 0, 0.795313776, 0)
	MainFrame.Parent = StatsGui

	TimeLabel.Name = "TimeLabel"
	TimeLabel.BackgroundColor3 = Color3.fromRGB(250, 129, 47)
	TimeLabel.BackgroundTransparency = 0.250
	TimeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TimeLabel.BorderSizePixel = 0
	TimeLabel.Size = UDim2.new(1, 0, 0.200000018, 0)
	TimeLabel.Font = Enum.Font.FredokaOne
	TimeLabel.RichText = true
	TimeLabel.Text = "⏱️ time"
	TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TimeLabel.TextScaled = true
	TimeLabel.TextSize = 14.000
	TimeLabel.TextStrokeTransparency = 0.000
	TimeLabel.TextWrapped = true
	TimeLabel.Parent = MainFrame

	UICorner.CornerRadius = UDim.new(0, 16)
	UICorner.Parent = TimeLabel
	
	MiddleFrame.Name = "MiddleFrame"
	MiddleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MiddleFrame.BackgroundTransparency = 1.000
	MiddleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MiddleFrame.BorderSizePixel = 0
	MiddleFrame.Position = UDim2.new(0, 0, 0.219711155, 0)
	MiddleFrame.Size = UDim2.new(0.999243617, 0, 0.55549103, 0)
	MiddleFrame.Parent = MainFrame

	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.CellPadding = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
	UIGridLayout.CellSize = UDim2.new(0.326000005, 0, 0.5, 0)
	UIGridLayout.FillDirectionMaxCells = 3
	UIGridLayout.Parent = MiddleFrame

	NameLabel.Name = "NameLabel"
	NameLabel.BackgroundColor3 = Color3.fromRGB(250, 129, 47)
	NameLabel.BackgroundTransparency = 0.250
	NameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameLabel.BorderSizePixel = 0
	NameLabel.Position = UDim2.new(0, 0, 0.797292352, 0)
	NameLabel.Size = UDim2.new(1, 0, 0.200000018, 0)
	NameLabel.Font = Enum.Font.FredokaOne
	NameLabel.RichText = true
	NameLabel.Text = `🤖`
	NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.TextScaled = true
	NameLabel.TextSize = 14.000
	NameLabel.TextStrokeTransparency = 0.000
	NameLabel.TextWrapped = true
	NameLabel.Parent = MainFrame

	UICorner_3.CornerRadius = UDim.new(0, 16)
	UICorner_3.Parent = NameLabel

	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.BackgroundTransparency = 1.000
	TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.33, 0, 0.018, 0)
	TextButton.Size = UDim2.new(0.1, 0, 0.1, 0)
	TextButton.Font = Enum.Font.FredokaOne
	TextButton.Text = "🙈"
	TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.TextScaled = true
	TextButton.TextSize = 14.000
	TextButton.TextWrapped = true
	TextButton.TextXAlignment = Enum.TextXAlignment.Left
	TextButton.Parent = StatsGui
	
	NameLabel.MouseEnter:Connect(function()
		NameLabel.Text = `🤖 {localPlayer.Name}`
	end)
	
	NameLabel.MouseLeave:Connect(function()
		NameLabel.Text = `🤖`
	end)
	
	local isVisible = true
	TextButton.Activated:Connect(function()
		isVisible = not isVisible
		MainFrame.Visible = isVisible
	end)
end


function StatsGuis2:UpdateTextFor(labelName: string, amount: number?)
	if labelName == "TimeLabel" then
		local currentTime = DateTime.now().UnixTimestamp
		local timeElapsed = currentTime - amount
		Players.LocalPlayer.PlayerGui.StatsGui.MainFrame.TimeLabel.Text = `⏱️ {formatTime(timeElapsed)}`
	elseif labelName == "TempPotion" then
		self.label.Text = `🧪 {amount}`
	elseif labelName == "TempBucks" then
		self.label.Text = `💰 {amount}`
    elseif labelName == "TempGingerbread" then
        self.label.Text = `🍪 {amount}`
    elseif labelName == "TotalPotion" then
        self.label.Text = `🧪 {formatNumber(agePotionCount())}`
    elseif labelName == "TotalBucks" then
        self.label.Text = `💰 {formatNumber(bucksAmount())}`
    elseif labelName == "TotalGingerbread" then
        self.label.Text = `🍪 {formatNumber(gingerbreadAmount())}`
	end
end



return StatsGuis2