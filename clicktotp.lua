-- Mobile Tap to Teleport Script (Delta Executor)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

print("Tap to teleport enabled (Mobile)")

UserInputService.TouchTap:Connect(function(touchPositions, _)
    local screenPos = touchPositions[1] -- Get the first touch point
    local unitRay = camera:ScreenPointToRay(screenPos.X, screenPos.Y)

    -- Raycast to get the position on the map
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)

    if rayResult and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local position = rayResult.Position + Vector3.new(0, 5, 0)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end)