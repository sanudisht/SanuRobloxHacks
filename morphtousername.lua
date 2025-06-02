local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.6, 0, 0, 100)
frame.Position = UDim2.new(0.2, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ClipsDescendants = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Enter Username"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.65, 0, 0, 36)
textBox.Position = UDim2.new(0.025, 0, 0.5, -18)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.PlaceholderText = "Username"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Text = ""
textBox.TextSize = 18
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = textBox

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.275, 0, 0, 36)
confirmBtn.Position = UDim2.new(0.7, 0, 0.5, -18)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
confirmBtn.Text = "Confirm"
confirmBtn.TextSize = 18
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.AutoButtonColor = true
confirmBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = confirmBtn

local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function morphToUsername(username)
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)
	if not success then return end

	local clone = Players:CreateHumanoidModelFromUserId(userId)
	if not clone then return end

	clone.Name = lp.Name
	local root = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart
	local curRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

	if curRoot and root then
		clone:PivotTo(curRoot.CFrame)
	end

	if lp.Character then
		lp.Character:Destroy()
	end

	clone.Parent = workspace
	lp.Character = clone

	task.wait(0.1)
	local cam = workspace.CurrentCamera
	local hum = clone:FindFirstChildOfClass("Humanoid")
	if hum then
		cam.CameraSubject = hum
		cam.CameraType = Enum.CameraType.Custom
	end
end

confirmBtn.MouseButton1Click:Connect(function()
	local user = textBox.Text:match("^%s*(.-)%s*$")
	if user ~= "" then
		morphToUsername(user)
		screenGui:Destroy()
	end
end)