local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateAdminGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-------------------
-- MAIN FRAME UI --
-------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 220)
mainFrame.Position = UDim2.new(0, 10, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Ultimate Admin GUI (v1)"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Button Factory
local function createButton(name, text, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, 45 + (order - 1) * 40)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.Font = Enum.Font.FredokaOne
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Text = text
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	return btn
end

-- Buttons
local flyButton = createButton("FlyButton", "Fly", 1)
local speedButton = createButton("SpeedButton", "Speed", 2)
local toolsButton = createButton("ToolsButton", "Tools", 3)
local minimizeButton = createButton("MinimizeButton", "Minimize", 4)

-------------------------
-- MINIMIZED BAR UI --
-------------------------
local miniFrame = Instance.new("Frame")
miniFrame.Name = "MiniFrame"
miniFrame.Size = UDim2.new(0, 250, 0, 60)
miniFrame.Position = UDim2.new(0, 10, 1, -70)
miniFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.Parent = screenGui

Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 20)

-- Minimized Label
local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(0.6, 0, 1, 0)
miniLabel.Position = UDim2.new(0, 0, 0, 0)
miniLabel.Text = "Ultimate Admin GUI (v1)"
miniLabel.Font = Enum.Font.FredokaOne
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.TextScaled = true
miniLabel.BackgroundTransparency = 1
miniLabel.Parent = miniFrame

-- Open Button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0.2, 0, 0.5, 0)
openButton.Position = UDim2.new(0.65, 0, 0, 0)
openButton.Text = "Open"
openButton.Font = Enum.Font.FredokaOne
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
openButton.Parent = miniFrame
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 10)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.2, 0, 0.5, 0)
closeButton.Position = UDim2.new(0.65, 0, 0.5, 0)
closeButton.Text = "Close"
closeButton.Font = Enum.Font.FredokaOne
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeButton.Parent = miniFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 10)

-- Toggle visibility
minimizeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniFrame.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	miniFrame.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

---------------------------
-- BUTTON FUNCTIONALITY --
---------------------------

-- Fly
local flying = false
local flyConnection

local function toggleFly()
	local hrp = character:WaitForChild("HumanoidRootPart")
	if flying then
		if flyConnection then flyConnection:Disconnect() end
		hrp.Anchored = false
	else
		flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
			hrp.Velocity = Vector3.new(0, 50, 0)
		end)
	end
	flying = not flying
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Speed
local boosted = false
speedButton.MouseButton1Click:Connect(function()
	if humanoid then
		boosted = not boosted
		humanoid.WalkSpeed = boosted and 80 or 16
	end
end)

-- Tools
toolsButton.MouseButton1Click:Connect(function()
	for _, toolName in pairs({"Clone", "Resize", "Move", "Delete", "Hammer"}) do
		local tool = Instance.new("HopperBin")
		tool.BinType = Enum.BinType[toolName]
		tool.Name = toolName
		tool.Parent = player.Backpack
	end
end)