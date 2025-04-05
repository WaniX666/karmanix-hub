 local gui = Instance.new("ScreenGui")
gui.Name = "PlayerGui"
local gui_child1 = Instance.new("LocalScript")
gui_child1.Name = "LocalScript"
gui_child1.Source = "-- Получаем необходимые сервисы\
local UserInputService = game:GetService(\"UserInputService\")\
local Players = game:GetService(\"Players\")\
local player = Players.LocalPlayer\
\
-- Ждём загрузки PlayerGui\
local playerGui = player:WaitForChild(\"PlayerGui\")\
\
-- Получаем наш GUI, который находится в StarterGui и копируется в PlayerGui\
local myGui = playerGui:WaitForChild(\"PlayerGui\")\
local frame = myGui:WaitForChild(\"Frame\")  -- получаем Frame\
\
-- Функция обработки нажатия клавиши\
local function onInputBegan(input, gameProcessedEvent)\
	if gameProcessedEvent then return end\
\
	-- При нажатии клавиши B переключаем видимость Frame\
	if input.KeyCode == Enum.KeyCode.B then\
		frame.Visible = not frame.Visible\
	end\
end\
\
-- Подписываемся на событие ввода\
UserInputService.InputBegan:Connect(onInputBegan)\
"
gui_child1.Parent = gui
local gui_child2 = Instance.new("Frame")
gui_child2.Name = "Frame"
gui_child2.Size = UDim2.new(0, 424, 0, 308)
gui_child2.Position = UDim2.new(0, 168, 0, 205)
gui_child2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local gui_child2_child1 = Instance.new("TextLabel")
gui_child2_child1.Name = "TextLabel"
gui_child2_child1.Text = "KARMANIX HUB"
gui_child2_child1.Size = UDim2.new(0, 425, 0, 50)
gui_child2_child1.Position = UDim2.new(-3.5903035211504175e-08, 0, 0, 0)
gui_child2_child1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child1.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child1.TextSize = 14
local gui_child2_child1_child1 = Instance.new("UICorner")
gui_child2_child1_child1.Name = "UICorner"
gui_child2_child1_child1.Parent = gui_child2_child1
gui_child2_child1.Parent = gui_child2
local gui_child2_child2 = Instance.new("UICorner")
gui_child2_child2.Name = "UICorner"
gui_child2_child2.Parent = gui_child2
local gui_child2_child3 = Instance.new("TextButton")
gui_child2_child3.Name = "TextButton"
gui_child2_child3.Text = "FLY"
gui_child2_child3.Size = UDim2.new(0, 200, 0, 50)
gui_child2_child3.Position = UDim2.new(0, 0, 0.18506494164466858, 0)
gui_child2_child3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child3.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child3.TextSize = 14
local gui_child2_child3_child1 = Instance.new("LocalScript")
gui_child2_child3_child1.Name = "LocalScript"
gui_child2_child3_child1.Source = "local UserInputService = game:GetService(\"UserInputService\")\
local RunService = game:GetService(\"RunService\")\
local Players = game:GetService(\"Players\")\
\
local player = Players.LocalPlayer\
local character = player.Character or player.CharacterAdded:Wait()\
local humanoid = character:WaitForChild(\"Humanoid\")\
local rootPart = character:WaitForChild(\"HumanoidRootPart\")\
\
local flightEnabled = false\
local flySpeed = 50\
\
local bodyGyro, bodyVelocity\
local flightConnection\
\
-- Кнопка, к которой прикреплён этот скрипт (TextButton)\
local TextButton = script.Parent\
\
-- Переменные для отслеживания нажатых клавиш\
local keys = {\
	W = false,\
	A = false,\
	S = false,\
	D = false,\
	Space = false,\
	LeftControl = false,\
}\
\
-- Функция обновления направления и скорости полёта\
local function updateFly()\
	local cam = workspace.CurrentCamera\
	local moveDirection = Vector3.new(0, 0, 0)\
\
	if keys.W then moveDirection = moveDirection + cam.CFrame.LookVector end\
	if keys.S then moveDirection = moveDirection - cam.CFrame.LookVector end\
	if keys.A then moveDirection = moveDirection - cam.CFrame.RightVector end\
	if keys.D then moveDirection = moveDirection + cam.CFrame.RightVector end\
	if keys.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end\
	if keys.LeftControl then moveDirection = moveDirection - Vector3.new(0, 1, 0) end\
\
	if moveDirection.Magnitude > 0 then\
		moveDirection = moveDirection.Unit * flySpeed\
	end\
\
	if bodyVelocity then\
		bodyVelocity.Velocity = moveDirection\
	end\
\
	if bodyGyro then\
		bodyGyro.CFrame = cam.CFrame\
	end\
end\
\
-- Обработка нажатия клавиш\
local function onInputBegan(input, gameProcessed)\
	if not flightEnabled then return end\
\
	if input.KeyCode == Enum.KeyCode.W then keys.W = true end\
	if input.KeyCode == Enum.KeyCode.A then keys.A = true end\
	if input.KeyCode == Enum.KeyCode.S then keys.S = true end\
	if input.KeyCode == Enum.KeyCode.D then keys.D = true end\
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end\
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = true end\
end\
\
local function onInputEnded(input, gameProcessed)\
	if not flightEnabled then return end\
\
	if input.KeyCode == Enum.KeyCode.W then keys.W = false end\
	if input.KeyCode == Enum.KeyCode.A then keys.A = false end\
	if input.KeyCode == Enum.KeyCode.S then keys.S = false end\
	if input.KeyCode == Enum.KeyCode.D then keys.D = false end\
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end\
	if input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = false end\
end\
\
UserInputService.InputBegan:Connect(onInputBegan)\
UserInputService.InputEnded:Connect(onInputEnded)\
\
-- Обработка нажатия на TextButton\
TextButton.MouseButton1Click:Connect(function()\
	flightEnabled = not flightEnabled\
\
	if flightEnabled then\
		-- Включаем режим полёта: отключаем физику персонажа и создаём BodyGyro и BodyVelocity\
		humanoid.PlatformStand = true\
\
		bodyGyro = Instance.new(\"BodyGyro\")\
		bodyGyro.P = 9e4\
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)\
		bodyGyro.Parent = rootPart\
\
		bodyVelocity = Instance.new(\"BodyVelocity\")\
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)\
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)\
		bodyVelocity.Parent = rootPart\
\
		flightConnection = RunService.RenderStepped:Connect(updateFly)\
	else\
		-- Выключаем режим полёта: возвращаем управление физикой и удаляем созданные объекты\
		humanoid.PlatformStand = false\
\
		if bodyGyro then\
			bodyGyro:Destroy()\
			bodyGyro = nil\
		end\
\
		if bodyVelocity then\
			bodyVelocity:Destroy()\
			bodyVelocity = nil\
		end\
\
		if flightConnection then\
			flightConnection:Disconnect()\
			flightConnection = nil\
		end\
	end\
end)\
"
gui_child2_child3_child1.Parent = gui_child2_child3
gui_child2_child3.Parent = gui_child2
gui_child2.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
return gui