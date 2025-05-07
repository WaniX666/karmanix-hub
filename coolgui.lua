-- Advanced CoolKid GUI - Client Side Only
-- Features: ESP, Tracers, Spinbot, Chat Spoof, Local Explosions, KillAura

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CoolKidAdvancedGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 320)
frame.Position = UDim2.new(0.5, -120, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "CoolKid GUI 🌀"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
title.LayoutOrder = 0

-- Utility
local function createButton(text, order, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.MouseButton1Click:Connect(callback)
end

-- Features
gui.Enabled = true
local showESP, spinbot, showTracers, killAura, chatSpoof, explosions = false, false, false, false, false, false

createButton("ESP Toggle", 1, function()
    showESP = not showESP
end)

createButton("Tracer Toggle", 2, function()
    showTracers = not showTracers
end)

createButton("Spinbot", 3, function()
    spinbot = not spinbot
end)

createButton("KillAura (Visual)", 4, function()
    killAura = not killAura
end)

createButton("Chat Spoof", 5, function()
    chatSpoof = not chatSpoof
    if chatSpoof then
        local msg = Instance.new("TextLabel", gui)
        msg.Size = UDim2.new(0, 300, 0, 20)
        msg.Position = UDim2.new(0.5, -150, 0, 100)
        msg.Text = "[Admin]: You have been granted godmode."
        msg.TextColor3 = Color3.new(0,1,0)
        msg.BackgroundTransparency = 1
        task.delay(3, function() msg:Destroy() end)
    end
end)

createButton("Explode Locally", 6, function()
    explosions = true
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local explosion = Instance.new("Explosion")
            explosion.Position = p.Character.HumanoidRootPart.Position
            explosion.BlastPressure = 0
            explosion.BlastRadius = 0
            explosion.Parent = workspace
        end
    end
end)

-- Visual loops
rs.RenderStepped:Connect(function()
    if spinbot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(10), 0)
    end
end)

-- Drawing ESP/Tracers
local function drawESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local headPos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local esp = Drawing.new("Text")
                esp.Text = p.Name
                esp.Position = Vector2.new(headPos.X, headPos.Y)
                esp.Size = 14
                esp.Color = Color3.new(1,1,1)
                esp.Center = true
                esp.Outline = true
                esp.Visible = true
                task.delay(0.03, function() esp:Remove() end)
            end
            if showTracers then
                local line = Drawing.new("Line")
                line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                line.To = Vector2.new(headPos.X, headPos.Y)
                line.Color = Color3.new(1,0,0)
                line.Thickness = 1
                line.Transparency = 0.6
                line.Visible = true
                task.delay(0.03, function() line:Remove() end)
            end
        end
    end
end

rs.RenderStepped:Connect(function()
    if showESP or showTracers then
        pcall(drawESP)
    end
end)

-- Toggle GUI with B
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then
        gui.Enabled = not gui.Enabled
    end
end)

-- KillAura (visual only)
rs.RenderStepped:Connect(function()
    if killAura and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                if (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    p.Character.Humanoid:TakeDamage(0) -- visual flick
                end
            end
        end
    end
end)

-- Character update\player.CharacterAdded:Connect(function(c)
    char = c
end)
