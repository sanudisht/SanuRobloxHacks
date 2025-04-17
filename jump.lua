local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ForceJumpGUI"
gui.ResetOnSpawn = false

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 75, 0, 75)
container.Position = UDim2.new(1, -85, 1, -85)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundTransparency = 1
container.Parent = gui

local scale = Instance.new("UIScale", container)
scale.Scale = 1

local button = Instance.new("TextButton", container)
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
button.BackgroundTransparency = 0.4
button.BorderSizePixel = 0
button.Text = ""
button.AutoButtonColor = false

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", button)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Transparency = 0.6

local icon = Instance.new("ImageLabel", button)
icon.Size = UDim2.new(0.5, 0, 0.5, 0)
icon.Position = UDim2.new(0.25, 0, 0.25, 0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6035047409"
icon.ImageTransparency = 0.1
icon.Rotation = 0

local tweenService = game:GetService("TweenService")

button.MouseButton1Click:Connect(function()
	local character = player.Character
	local humanoid = character and character:FindFirstChild("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

	if humanoid and hrp and humanoid.FloorMaterial ~= Enum.Material.Air then
		-- Press scale animation
		tweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.9}):Play()
		task.delay(0.08, function()
			tweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
		end)

		-- Smooth spin icon
		icon.Rotation = 0
		local spinTween = tweenService:Create(icon, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 360})
		spinTween:Play()
		spinTween.Completed:Connect(function()
			icon.Rotation = 0
		end)

		-- Manual jump velocity (matches Roblox jump height)
		local jumpVelocity = Vector3.new(0, 50, 0) -- tweak if needed
		hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z) + jumpVelocity
	end
end)

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	hum = c:WaitForChild("Humanoid")
end)