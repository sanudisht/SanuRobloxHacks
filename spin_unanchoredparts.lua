local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local radius = 10
local spinSpeed = 2
local floorCheckDistance = 6

local function getGround()
	local origin = hrp.Position
	local direction = Vector3.new(0, -10, 0)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	local result = workspace:Raycast(origin, direction, params)
	return result and result.Instance
end

local ground = getGround()
local spinningParts = {}

for _, part in ipairs(workspace:GetDescendants()) do
	if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(char) then
		local distanceBelow = hrp.Position.Y - part.Position.Y
		if part ~= ground and distanceBelow > floorCheckDistance then
			table.insert(spinningParts, {
				part = part,
				angle = math.random() * math.pi * 2,
				heightOffset = math.random(-3, 3)
			})
		end
	end
end

RunService.RenderStepped:Connect(function(dt)
	for _, data in ipairs(spinningParts) do
		data.angle += spinSpeed * dt
		local offset = Vector3.new(
			math.cos(data.angle) * radius,
			data.heightOffset,
			math.sin(data.angle) * radius
		)

		local targetPos = hrp.Position + offset
		data.part.CFrame = CFrame.new(targetPos)
		data.part.Velocity = Vector3.zero
		data.part.RotVelocity = Vector3.zero
	end
end)