local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Создаём или находим RemoteEvent
local remote = ReplicatedStorage:FindFirstChild("AdminCommandEvent")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "AdminCommandEvent"
    remote.Parent = ReplicatedStorage
end

-- Проверка: не дублируем GUI
if player.PlayerGui:FindFirstChild("CoolKidGui") then
	player.PlayerGui:FindFirstChild("CoolKidGui"):Destroy()
end

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolKidGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.BackgroundTransparency = 1
frame.Parent = screenGui

local function toggleGUI()
	if frame.Visible then
		TweenService:Create(frame, TweenInfo.new(0.3), {
			BackgroundTransparency = 1;
			Size = UDim2.new(0, 220, 0, 0);
		}):Play()
		task.wait(0.3)
		frame.Visible = false
	else
		frame.Visible = true
		frame.Size = UDim2.new(0, 220, 0, 0)
		frame.BackgroundTransparency = 1
		TweenService:Create(frame, TweenInfo.new(0.3), {
			BackgroundTransparency = 0;
			Size = UDim2.new(0, 220, 0, 300);
		}):Play()
	end
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "COOL KID GUI"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 22
title.Font = Enum.Font.GothamBlack
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = frame
closeButton.MouseButton1Click:Connect(toggleGUI)

local function createButton(text, posY, command)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, posY)
	button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	button.TextColor3 = Color3.fromRGB(0, 255, 0)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.Text = text
	button.BorderSizePixel = 1
	button.BorderColor3 = Color3.fromRGB(0, 255, 0)
	button.Parent = frame

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(60, 0, 0)
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		remote:FireServer(command)
	end)
end

-- Кнопки
createButton("Kill All", 50, "KillAll")
createButton("Fly", 100, "Fly")
createButton("Godmode", 150, "Godmode")

-- Кнопка B открывает/закрывает GUI
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
		toggleGUI()
	end
end)

-- Сохраняем GUI при возрождении
player.CharacterAdded:Connect(function()
	wait(1)
	screenGui.Parent = player:WaitForChild("PlayerGui")
end)
