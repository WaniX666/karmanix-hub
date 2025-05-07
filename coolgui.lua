-- CoolKid GUI - Client Side Effects Only
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

-- Create GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CoolKidGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.5, -110, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiList = Instance.new("UIListLayout", frame)
uiList.Padding = UDim.new(0, 6)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder

-- Button helper
local function createButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 30)
	button.Position = UDim2.new(0, 10, 0, 0)
	button.Text = text
	button.TextColor3 = Color3.new(1,1,1)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.BorderSizePixel = 0
	button.Parent = frame

	button.MouseButton1Click:Connect(callback)
end

-- Effects
local flying = false
local speedEnabled = false
local rainbow = false
local godmode = false

createButton("🕊️ Fly", function()
	flying = not flying
	if flying then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local bv = Instance.new("BodyVelocity", hrp)
			bv.Name = "CoolFly"
			bv.MaxForce = Vector3.new(1,1,1) * 999999
			bv.Velocity = Vector3.new(0, 50, 0)
			task.delay(3, function()
				if bv and bv.Parent then
					bv:Destroy()
				end
			end)
		end
	end
end)

createButton("🏃 Speed", function()
	speedEnabled = not speedEnabled
	local hum = char:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = speedEnabled and 64 or 16
	end
end)

createButton("🔄 Reset", function()
	local hum = char:FindFirstChild("Humanoid")
	if hum then
		hum.Health = 0
	end
end)

createButton("🧼 Clear Decals", function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Decal") then
			v:Destroy()
		end
	end
end)

createButton("🌈 Rainbow Character", function()
	rainbow = not rainbow
end)

createButton("🎥 TP to Random Player", function()
	local others = {}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, p)
		end
	end
	if #others > 0 then
		local target = others[math.random(1, #others)]
		workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
	end
end)

createButton("🎭 Fake Godmode", function()
	godmode = not godmode
end)

createButton("🌀 Spin Head", function()
	local head = char:FindFirstChild("Head")
	if head then
		runService.RenderStepped:Connect(function()
			head.CFrame *= CFrame.Angles(0, math.rad(5), 0)
		end)
	end
end)

-- Toggle GUI
local open = true
local function toggleGUI()
	open = not open
	frame.Visible = open
end

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.B then
		toggleGUI()
	end
end)

-- Rainbow loop
runService.RenderStepped:Connect(function()
	if rainbow and char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Color = Color3.fromHSV(tick()%5/5,1,1)
			end
		end
	end
	if godmode and char:FindFirstChild("Humanoid") then
		char.Humanoid.Health = char.Humanoid.MaxHealth
	end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(newChar)
	char = newChar
end)
