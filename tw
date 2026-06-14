local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PPS = game:GetService("ProximityPromptService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local isGodmode = false
local ghostClone, connection, noclipConn, deathConn = nil, nil, nil, nil
local lastPromptUpdate = 0

local geniusSpeed = 70 
local instantTakeEnabled = false

local gui = Instance.new("ScreenGui")
gui.Name = "DohzLagger_Ultimate"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 160, 0, 280)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BorderSizePixel = 0
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
frame.Active = true

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 0, 0))
}
mainGradient.Rotation = 90
mainGradient.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Parent = frame
stroke.Thickness = 2.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(120, 125, 135)

local topBar = Instance.new("Frame")
topBar.Name = "HeaderBar"
topBar.Parent = frame
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBar.BackgroundTransparency = 0.4
topBar.BorderSizePixel = 0

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 10)
barCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "ETFB SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

task.spawn(function()
    local colors = {Color3.fromRGB(180, 185, 200), Color3.fromRGB(50, 90, 220), Color3.fromRGB(200, 130, 40), Color3.fromRGB(220, 20, 20)}
    local i = 1
    while true do
        TweenService:Create(stroke, TweenInfo.new(0.65, Enum.EasingStyle.Linear), {Color = colors[i]}):Play()
        task.wait(0.65)
        i = (i % #colors) + 1
    end
end)

local function cleanup()
    isGodmode = false
    if connection then connection:Disconnect() connection = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if deathConn then deathConn:Disconnect() deathConn = nil end
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and ghostClone then root.CFrame = ghostClone.HumanoidRootPart.CFrame end
        if char:FindFirstChild("Humanoid") then 
            char.Humanoid.PlatformStand = false 
            camera.CameraSubject = char.Humanoid 
        end
    end
    if ghostClone then ghostClone:Destroy() ghostClone = nil end
end

local function enableGodmode()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    cleanup()
    isGodmode = true
    char.Archivable = true
    ghostClone = char:Clone()
    ghostClone.Name = "GhostDecoy"
    ghostClone.Parent = workspace
    char.Archivable = false
    for _, v in pairs(ghostClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = (v.Name:lower():find("root") or v.Name:lower():find("collision")) and 0.5 or 0
            v.CanCollide = true
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
    end
    if char:FindFirstChild("Animate") then char.Animate:Clone().Parent = ghostClone end
    char.Humanoid.PlatformStand = true
    camera.CameraSubject = ghostClone.Humanoid
    noclipConn = RunService.Stepped:Connect(function()
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    connection = RunService.Heartbeat:Connect(function()
        if ghostClone and char and char:FindFirstChild("HumanoidRootPart") then
            local moveDir = char.Humanoid.MoveDirection
            ghostClone.Humanoid:Move(moveDir, false)
            ghostClone.Humanoid.Jump = char.Humanoid.Jump
            if moveDir.Magnitude > 0 then
                local targetRot = CFrame.lookAt(ghostClone.HumanoidRootPart.Position, ghostClone.HumanoidRootPart.Position + moveDir)
                ghostClone.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame:Lerp(targetRot, 0.25)
            end
            if tick() - lastPromptUpdate > 0.5 then
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") then
                        p.MaxActivationDistance = 25
                        p.RequiresLineOfSight = false
                    end
                end
                lastPromptUpdate = tick()
            end
            char.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
        else cleanup() end
    end)
    deathConn = char.Humanoid.Died:Connect(cleanup)
end

player.CharacterAdded:Connect(function()
    if isGodmode then task.wait(0.5) enableGodmode() end
end)

PPS.PromptButtonHoldBegan:Connect(function(p)
    if instantTakeEnabled then
        fireproximityprompt(p)
    end
end)

local function CreateBtn(name, pos, originalText, isToggle, callback)
    local btn = Instance.new("TextButton")
    local toggled = false
    local upperText = originalText:upper()
    
    btn.Name = name
    btn.Parent = frame
    btn.Size = UDim2.new(0, 145, 0, 42)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(0.5, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.93
    btn.Text = upperText
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10 
    btn.AutoButtonColor = false
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    
    local bs = Instance.new("UIStroke")
    bs.Thickness = 1.2
    bs.Color = Color3.fromRGB(255, 255, 255)
    bs.Transparency = 0.8
    bs.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            btn.Text = toggled and (upperText .. ": ON") or upperText
            
            local targetColor = toggled and Color3.fromRGB(160, 0, 0) or Color3.fromRGB(255, 255, 255)
            local targetTrans = toggled and 0.3 or 0.93
            local strokeColor = toggled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)

            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor, BackgroundTransparency = targetTrans}):Play()
            TweenService:Create(bs, TweenInfo.new(0.3), {Color = strokeColor}):Play()
            if callback then callback(toggled) end
        else
            -- One-click animation
            local oldColor = btn.BackgroundColor3
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(160,0,0)}):Play()
            task.delay(0.1, function()
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.93, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)
            if callback then callback() end
        end
    end)
    return btn
end

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedInput"
speedBox.Parent = frame
speedBox.Size = UDim2.new(0, 145, 0, 30)
speedBox.Position = UDim2.new(0.5, 0, 0.84, 0)
speedBox.AnchorPoint = Vector2.new(0.5, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedBox.BackgroundTransparency = 0.5
speedBox.Text = tostring(geniusSpeed)
speedBox.PlaceholderText = "SPEED 1-1000"
speedBox.Font = Enum.Font.GothamBold
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 11

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = speedBox

local boxStroke = Instance.new("UIStroke")
boxStroke.Thickness = 1
boxStroke.Color = Color3.fromRGB(255, 255, 255)
boxStroke.Transparency = 0.8
boxStroke.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        val = math.clamp(val, 1, 1000)
        speedBox.Text = tostring(val)
        geniusSpeed = val
    else
        speedBox.Text = tostring(geniusSpeed)
    end
end)

CreateBtn("GodModeBtn", UDim2.new(0.5, 0, 0.18, 0), "God Mode", true, function(s)
    if s then enableGodmode() else cleanup() end
end)

CreateBtn("InstantTakeBtn", UDim2.new(0.5, 0, 0.40, 0), "Instant Take", true, function(s)
    instantTakeEnabled = s
end)

CreateBtn("SpeedBtn", UDim2.new(0.5, 0, 0.62, 0), "Speed Changer", false, function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player:SetAttribute("CurrentSpeed", geniusSpeed)
    end
end)
