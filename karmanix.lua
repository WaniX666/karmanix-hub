local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KarmanixHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 424, 0, 308)
frame.Position = UDim2.new(0, 168, 0, 205)
frame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
frame.Visible = false
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "KARMANIX HUB"
title.Size = UDim2.new(0, 425, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = title

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Text = "FLY"
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0, 0, 0.2, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14
flyButton.Parent = frame

-- Полёт
local flightEnabled = false
local bodyGyro, bodyVelocity
local flySpeed = 50
local keys = {
	W = false, A = false, S = false, D = false,
	Space = false, LeftControl = false
}

local function updateFly()
	if not flightEnabled then return end
	local character = player.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local cam = workspace.CurrentCamera
	local moveDirection = Vector3.new()

	if keys.W then moveDirection += cam.CFrame.LookVector end
	if keys.S then moveDirection -= cam.CFrame.LookVector end
	if keys.A then moveDirection -= cam.CFrame.RightVector end
	if keys.D then moveDirection += cam.CFrame.RightVector end
	if keys.Space then moveDirection += Vector3.new(0, 1, 0) end
	if keys.LeftControl then moveDirection -= Vector3.new(0, 1, 0) end

	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit * flySpeed
	end

	if bodyVelocity then bodyVelocity.Velocity = moveDirection end
	if bodyGyro then bodyGyro.CFrame = cam.CFrame end
end

RunService.RenderStepped:Connect(updateFly)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W then keys.W = true end
	if key == Enum.KeyCode.A then keys.A = true end
	if key == Enum.KeyCode.S then keys.S = true end
	if key == Enum.KeyCode.D then keys.D = true end
	if key == Enum.KeyCode.Space then keys.Space = true end
	if key == Enum.KeyCode.LeftControl then keys.LeftControl = true end
end)

UserInputService.InputEnded:Connect(function(input)
	local key = input.KeyCode
	if key == Enum.KeyCode.W then keys.W = false end
	if key == Enum.KeyCode.A then keys.A = false end
	if key == Enum.KeyCode.S then keys.S = false end
	if key == Enum.KeyCode.D then keys.D = false end
	if key == Enum.KeyCode.Space then keys.Space = false end
	if key == Enum.KeyCode.LeftControl then keys.LeftControl = false end
end)

flyButton.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then return end

	flightEnabled = not flightEnabled

	if flightEnabled then
		humanoid.PlatformStand = true

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.Parent = rootPart

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new()
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = rootPart
	else
		humanoid.PlatformStand = false
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	end
end)

-- Отображение GUI по клавише B
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.B then
		frame.Visible = not frame.Visible
	end
end)

gui.Parent = playerGui
