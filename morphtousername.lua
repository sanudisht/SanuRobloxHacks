local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UsernamePromptGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 1
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.ClipsDescendants = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 18)
uicorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Enter Username"
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -40, 0, 40)
textBox.Position = UDim2.new(0, 20, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
textBox.TextColor3 = Color3.fromRGB(240, 240, 240)
textBox.Font = Enum.Font.Gotham
textBox.PlaceholderText = "Target Username"
textBox.Text = ""
textBox.ClearTextOnFocus = false
textBox.TextSize = 20
textBox.AnchorPoint = Vector2.new(0, 0)
textBox.Parent = frame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 12)
textBoxCorner.Parent = textBox

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 120, 0, 35)
submitBtn.Position = UDim2.new(0.5, -60, 1, -45)
submitBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
submitBtn.Text = "Confirm"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 20
submitBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
submitBtn.AutoButtonColor = true
submitBtn.AnchorPoint = Vector2.new(0.5, 0)
submitBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 14)
btnCorner.Parent = submitBtn

local fadeIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0})
fadeIn:Play()

local function morphToUsername(username)
	if username == "" then
		warn("Username is empty")
		return
	end
	local function getUserId(name)
		local success, result = pcall(function()
			return Players:GetUserIdFromNameAsync(name)
		end)
		if success then return result end
		return nil
	end
	local userId = getUserId(username)
	if not userId then
		warn("User not found")
		return
	end
	local clonedChar = nil
	local success, err = pcall(function()
		clonedChar = Players:CreateHumanoidModelFromUserId(userId)
	end)
	if not success or not clonedChar then
		warn("Failed to clone character: " .. tostring(err))
		return
	end
	clonedChar.Name = lp.Name
	local root = clonedChar:FindFirstChild("HumanoidRootPart") or clonedChar.PrimaryPart
	if root then
		local currentChar = lp.Character
		if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
			clonedChar:PivotTo(currentChar.HumanoidRootPart.CFrame)
		end
	end
	if lp.Character then
		lp.Character:Destroy()
	end
	clonedChar.Parent = workspace
	lp.Character = clonedChar
end

local function closeGui()
	local fadeOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()
	screenGui:Destroy()
end

submitBtn.MouseButton1Click:Connect(function()
	local username = textBox.Text:match("%S+")
	if username and username ~= "" then
		morphToUsername(username)
		closeGui()
	else
		warn("Please enter a valid username.")
	end
end)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		submitBtn.MouseButton1Click:Fire()
	end
end)