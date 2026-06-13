local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- States
local espEnabled = false
local aimbotEnabled = false
local fovEnabled = false

-- Create UI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 160)
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Text = "Snipe or Die - Revised Hub"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Buttons
local EspBtn = Instance.new("TextButton", Frame)
EspBtn.Size = UDim2.new(1, -20, 0, 30)
EspBtn.Position = UDim2.new(0, 10, 0, 40)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
EspBtn.TextColor3 = Color3.new(1, 1, 1)

local AimbotBtn = Instance.new("TextButton", Frame)
AimbotBtn.Size = UDim2.new(1, -20, 0, 30)
AimbotBtn.Position = UDim2.new(0, 10, 0, 80)
AimbotBtn.Text = "Aimbot: OFF"
AimbotBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimbotBtn.TextColor3 = Color3.new(1, 1, 1)

local FovBtn = Instance.new("TextButton", Frame)
FovBtn.Size = UDim2.new(1, -20, 0, 30)
FovBtn.Position = UDim2.new(0, 10, 0, 120)
FovBtn.Text = "FOV: OFF"
FovBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FovBtn.TextColor3 = Color3.new(1, 1, 1)

-- FOV Drawing (Only works in exploits supporting the Drawing API)
local fovCircle = nil
if Drawing then
    fovCircle = Drawing.new('Circle')
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = 90
    fovCircle.Filled = false
    fovCircle.Visible = false
end

-- Toggles
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
end)

AimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotBtn.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

FovBtn.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    FovBtn.Text = fovEnabled and "FOV: ON" or "FOV: OFF"
    if fovCircle then fovCircle.Visible = fovEnabled end
end)

-- Game Loop
RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if fovCircle and fovEnabled and camera then
        fovCircle.Position = camera.ViewportSize / 2
    end
    
    -- Actual ESP Logic would go here, looping through players properly:
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Render box/lines logic per player safely
            end
        end
    end
end)
