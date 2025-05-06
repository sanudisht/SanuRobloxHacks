local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TapToTPGui"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 140, 0, 50)
toggleButton.Position = UDim2.new(0.5, -70, 0.9, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Disable TP"
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0

local teleportEnabled = true

toggleButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    toggleButton.Text = teleportEnabled and "Disable TP" or "Enable TP"
end)

UserInputService.TouchTap:Connect(function(touchPositions, _)
    if not teleportEnabled then return end

    local screenPos = touchPositions[1]
    local unitRay = camera:ScreenPointToRay(screenPos.X, screenPos.Y)

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)

    if rayResult and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local position = rayResult.Position + Vector3.new(0, 5, 0)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end)