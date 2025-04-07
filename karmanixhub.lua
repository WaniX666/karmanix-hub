local selection = game.Selection:Get()[1]

local function serializeProperty(prop, value)
	if typeof(value) == "UDim2" then
		return string.format("UDim2.new(%s, %s, %s, %s)", value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset)
	elseif typeof(value) == "Color3" then
		return string.format("Color3.fromRGB(%d, %d, %d)", value.R * 255, value.G * 255, value.B * 255)
	elseif typeof(value) == "string" then
		return string.format("%q", value)
	elseif typeof(value) == "boolean" or typeof(value) == "number" then
		return tostring(value)
	else
		return nil
	end
end

local function exportInstance(inst, varName)
	local lines = {}
	table.insert(lines, string.format("local %s = Instance.new(%q)", varName, inst.ClassName))
	table.insert(lines, string.format("%s.Name = %q", varName, inst.Name))

	-- Экспорт свойств
	for _, prop in ipairs({"Text", "Size", "Position", "BackgroundColor3", "TextColor3", "TextSize", "AnchorPoint"}) do
		pcall(function()
			local val = inst[prop]
			local valStr = serializeProperty(prop, val)
			if valStr then
				table.insert(lines, string.format("%s.%s = %s", varName, prop, valStr))
			end
		end)
	end

	-- Экспорт скрипта (если Source доступен)
	if inst:IsA("LocalScript") or inst:IsA("Script") then
		local success, source = pcall(function() return inst.Source end)
		if success and source then
			table.insert(lines, string.format('%s.Source = %q', varName, source))
		end
	end

	-- Дети
	for i, child in ipairs(inst:GetChildren()) do
		local childVar = varName .. "_child" .. i
		local childCode = exportInstance(child, childVar)
		for _, line in ipairs(childCode) do
			table.insert(lines, line)
		end
		table.insert(lines, string.format("%s.Parent = %s", childVar, varName))
	end

	return lines
end

if not selection then
	warn("Выдели объект для экспорта!")
else
	local result = exportInstance(selection, "gui")
	table.insert(result, "gui.Parent = game.Players.LocalPlayer:WaitForChild(\"PlayerGui\")")
	table.insert(result, "return gui")
	print(table.concat(result, "\n"))
end
  -  Studio
  19:31:18.981  local gui = Instance.new("ScreenGui")
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
gui_child2.Size = UDim2.new(0.4115281403064728, 0, 0.4156206548213959, 0)
gui_child2.Position = UDim2.new(0.29356569051742554, 0, 0.2914923429489136, 0)
gui_child2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local gui_child2_child1 = Instance.new("UICorner")
gui_child2_child1.Name = "UICorner"
gui_child2_child1.Parent = gui_child2
local gui_child2_child2 = Instance.new("TextButton")
gui_child2_child2.Name = "TextButton"
gui_child2_child2.Text = "FLY"
gui_child2_child2.Size = UDim2.new(0.4918566644191742, 0, 0.16107381880283356, 0)
gui_child2_child2.Position = UDim2.new(0.5048859715461731, 0, 0.16107381880283356, 0)
gui_child2_child2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child2.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child2.TextSize = 14
local gui_child2_child2_child1 = Instance.new("LocalScript")
gui_child2_child2_child1.Name = "LocalScript"
gui_child2_child2_child1.Source = "local UserInputService = game:GetService(\"UserInputService\")\
local RunService = game:GetService(\"RunService\")\
local Players = game:GetService(\"Players\")\
\
local player = Players.LocalPlayer\
local character = player.Character or player.CharacterAdded:Wait()\
local humanoid = character:WaitForChild(\"Humanoid\")\
local rootPart = character:WaitForChild(\"HumanoidRootPart\")\
\
local flightEnabled = false\
local flySpeed = _G.flySpeed or 50\
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
	flySpeed = _G.flySpeed or flySpeed\
\
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
gui_child2_child2_child1.Parent = gui_child2_child2
local gui_child2_child2_child2 = Instance.new("TextBox")
gui_child2_child2_child2.Name = "FlySpeed"
gui_child2_child2_child2.Text = "Flyspeed"
gui_child2_child2_child2.Size = UDim2.new(1.0264900922775269, 0, 0.9791667461395264, 0)
gui_child2_child2_child2.Position = UDim2.new(-1.0305681228637695, 0, -0.00578180979937315, 0)
gui_child2_child2_child2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child2_child2.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child2_child2.TextSize = 14
local gui_child2_child2_child2_child1 = Instance.new("LocalScript")
gui_child2_child2_child2_child1.Name = "LocalScript"
gui_child2_child2_child2_child1.Source = "local speedBox = script.Parent\
\
-- Глобальный доступ к переменной flySpeed\
_G.flySpeed = _G.flySpeed or 50\
\
speedBox.FocusLost:Connect(function(enterPressed)\
	if enterPressed then\
		local newSpeed = tonumber(speedBox.Text)\
		if newSpeed then\
			_G.flySpeed = newSpeed\
			print(\"Fly speed set to:\", newSpeed)\
		end\
	end\
end)\
"
gui_child2_child2_child2_child1.Parent = gui_child2_child2_child2
local gui_child2_child2_child2_child2 = Instance.new("UICorner")
gui_child2_child2_child2_child2.Name = "UICorner"
gui_child2_child2_child2_child2.Parent = gui_child2_child2_child2
gui_child2_child2_child2.Parent = gui_child2_child2
local gui_child2_child2_child3 = Instance.new("UICorner")
gui_child2_child2_child3.Name = "UICorner"
gui_child2_child2_child3.Parent = gui_child2_child2
gui_child2_child2.Parent = gui_child2
local gui_child2_child3 = Instance.new("TextLabel")
gui_child2_child3.Name = "TextLabel"
gui_child2_child3.Text = "KARMANIX HUB"
gui_child2_child3.Size = UDim2.new(1, 0, 0.16107381880283356, 0)
gui_child2_child3.Position = UDim2.new(0, 0, 0, 0)
gui_child2_child3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child3.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child3.TextSize = 14
local gui_child2_child3_child1 = Instance.new("UICorner")
gui_child2_child3_child1.Name = "UICorner"
gui_child2_child3_child1.Parent = gui_child2_child3
gui_child2_child3.Parent = gui_child2
local gui_child2_child4 = Instance.new("TextButton")
gui_child2_child4.Name = "TextButton2"
gui_child2_child4.Text = "Apply speed"
gui_child2_child4.Size = UDim2.new(0.4918566644191742, 0, 0.16107381880283356, 0)
gui_child2_child4.Position = UDim2.new(0.5048859715461731, 0, 0.3187919557094574, 0)
gui_child2_child4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child4.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child4.TextSize = 14
local gui_child2_child4_child1 = Instance.new("LocalScript")
gui_child2_child4_child1.Name = "LocalScript"
gui_child2_child4_child1.Source = "local Players = game:GetService(\"Players\")\
local player = Players.LocalPlayer\
\
-- Ждём появления персонажа\
local function getHumanoid()\
	local character = player.Character or player.CharacterAdded:Wait()\
	return character:WaitForChild(\"Humanoid\")\
end\
\
local speedBox = script.Parent:FindFirstChild(\"SpeedBox\") -- находим текстбокс рядом\
local button = script.Parent\
\
button.MouseButton1Click:Connect(function()\
	local speed = tonumber(speedBox.Text)\
	if speed then\
		local humanoid = getHumanoid()\
		humanoid.WalkSpeed = speed\
	end\
end)\
"
gui_child2_child4_child1.Parent = gui_child2_child4
local gui_child2_child4_child2 = Instance.new("TextBox")
gui_child2_child4_child2.Name = "SpeedBox"
gui_child2_child4_child2.Text = "Walkspeed"
gui_child2_child4_child2.Size = UDim2.new(1.0264900922775269, 0, 0.9791667461395264, 0)
gui_child2_child4_child2.Position = UDim2.new(-1.0305681228637695, 0, 0.015051525086164474, 0)
gui_child2_child4_child2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
gui_child2_child4_child2.TextColor3 = Color3.fromRGB(255, 255, 255)
gui_child2_child4_child2.TextSize = 14
local gui_child2_child4_child2_child1 = Instance.new("LocalScript")
gui_child2_child4_child2_child1.Name = "LocalScript"
gui_child2_child4_child2_child1.Source = "local Players = game:GetService(\"Players\")\
local player = Players.LocalPlayer\
local character = player.Character or player.CharacterAdded:Wait()\
local humanoid = character:WaitForChild(\"Humanoid\")\
\
-- Ссылка на TextBox, который рядом с кнопкой\
local speedBox = script.Parent.Parent:WaitForChild(\"SpeedBox\")\
\
script.Parent.MouseButton1Click:Connect(function()\
	local speed = tonumber(speedBox.Text)\
	if speed then\
		humanoid.WalkSpeed = speed\
	end\
end)\
"
gui_child2_child4_child2_child1.Parent = gui_child2_child4_child2
local gui_child2_child4_child2_child2 = Instance.new("UICorner")
gui_child2_child4_child2_child2.Name = "UICorner"
gui_child2_child4_child2_child2.Parent = gui_child2_child4_child2
gui_child2_child4_child2.Parent = gui_child2_child4
local gui_child2_child4_child3 = Instance.new("UICorner")
gui_child2_child4_child3.Name = "UICorner"
gui_child2_child4_child3.Parent = gui_child2_child4
gui_child2_child4.Parent = gui_child2
gui_child2.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
return gui