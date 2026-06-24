workspace.FallenPartsDestroyHeight = 0/0
pcall(function()
    game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local localPlayer = Players.LocalPlayer

-- 原 Antifling2 功能變數
local flingActive = false
local hiddenfling = false
local AntiFlingEnabled = false
local AntiKillPartsEnabled = false
local processedPlayers = {}
local currentInput = ""
local SteppedConnection = nil
local isNoclipEnabled = false
local flingMode = 1
local currentPhase = 1

-- 原 Phase 2 & 3 功能變數
local isStrengthened = false
local strengthConnections = {}
local originalProperties = {}
local spawnpointActive = false
local savedPosition = nil
local antiSlapActive = false
local XenoAntiFlingEnabled = false
local XenoAntiFlingConnection = nil
local infinitePositionEnabled = false
local savedInfinitePosition = nil
local infinitePositionConnection = nil
local positionTolerance = 0.1
local afdEnabled = false
local afdConnections = {}
local noSitEnabled = false
local freeCamEnabled = false
local movePart = nil
local currentPos = Vector3.new()
local joystickGui = nil
local invisibilityEnabled = false
local invisibleParts = {}
local invisibilityConnection = nil
local invisibilityCooldown = false
local antiRagdollEnabled = false
local antiRagdollDisconnectFunc = nil

-- UI 主題設定 (承襲自 God Mode)
local CurrentTheme = "Dark"
local Themes = {
    Dark = {
        Background = Color3.fromRGB(10, 10, 10),
        TitleBar = Color3.fromRGB(15, 15, 15),
        Button = Color3.fromRGB(25, 25, 25),
        ButtonHover = Color3.fromRGB(35, 35, 35),
        ButtonActive = Color3.fromRGB(80, 20, 20),
        Text = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(60, 60, 60),
        TopButtons = Color3.fromRGB(40, 40, 40)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        TitleBar = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(255, 255, 255),
        ButtonHover = Color3.fromRGB(230, 230, 230),
        ButtonActive = Color3.fromRGB(180, 50, 50),
        Text = Color3.fromRGB(20, 20, 20),
        Border = Color3.fromRGB(180, 180, 180),
        TopButtons = Color3.fromRGB(200, 200, 200)
    }
}

-- 建立 ScreenGui
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "ModernFlingGUI"
MainGui.ResetOnSpawn = false

-- 主框架
local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 250, 0, 360)
Frame.Position = UDim2.new(0.5, -125, 0.5, -180)
Frame.BackgroundColor3 = Themes.Dark.Background
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 12)

local FrameStroke = Instance.new("UIStroke", Frame)
FrameStroke.Thickness = 2
FrameStroke.Color = Themes.Dark.Border
FrameStroke.Transparency = 0.2

-- 標題列
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Themes.Dark.TitleBar
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)

local TitleFix = Instance.new("Frame", TitleBar)
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Themes.Dark.TitleBar
TitleFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "FLING GUI MOD"
Title.TextColor3 = Themes.Dark.Text
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 拖曳功能
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 右上角控制按鈕
local SettingsBtn = Instance.new("TextButton", TitleBar)
SettingsBtn.Size = UDim2.new(0, 28, 0, 28)
SettingsBtn.Position = UDim2.new(1, -92, 0.5, -14)
SettingsBtn.BackgroundColor3 = Themes.Dark.TopButtons
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Themes.Dark.Text
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 16
SettingsBtn.BorderSizePixel = 0
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 8)

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Themes.Dark.TopButtons
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Themes.Dark.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
CloseBtn.BackgroundColor3 = Themes.Dark.TopButtons
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Themes.Dark.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- 主要分頁容器
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, -14, 1, -75)
Content.Position = UDim2.new(0, 7, 0, 41)
Content.BackgroundTransparency = 1

-- 分頁下拉選單
local PhaseMenuBtn = Instance.new("TextButton", Content)
PhaseMenuBtn.Size = UDim2.new(1, 0, 0, 30)
PhaseMenuBtn.Position = UDim2.new(0, 0, 0, 0)
PhaseMenuBtn.BackgroundColor3 = Themes.Dark.Button
PhaseMenuBtn.Text = "PAGE: 1 (MAIN FLING)"
PhaseMenuBtn.TextColor3 = Themes.Dark.Text
PhaseMenuBtn.Font = Enum.Font.GothamBold
PhaseMenuBtn.TextSize = 11
Instance.new("UICorner", PhaseMenuBtn).CornerRadius = UDim.new(0, 9)

local PhaseFrame = Instance.new("Frame", Content)
PhaseFrame.Size = UDim2.new(1, 0, 0, 105)
PhaseFrame.Position = UDim2.new(0, 0, 0, 35)
PhaseFrame.BackgroundColor3 = Themes.Dark.Background
PhaseFrame.BorderSizePixel = 0
PhaseFrame.Visible = false
PhaseFrame.ZIndex = 15
Instance.new("UICorner", PhaseFrame).CornerRadius = UDim.new(0, 9)
local PhaseFrameStroke = Instance.new("UIStroke", PhaseFrame)
PhaseFrameStroke.Thickness = 2
PhaseFrameStroke.Color = Themes.Dark.Border

-- 滾動容器 (容納各分頁元件)
local PagesContainer = Instance.new("Frame", Content)
PagesContainer.Size = UDim2.new(1, 0, 1, -35)
PagesContainer.Position = UDim2.new(0, 0, 0, 35)
PagesContainer.BackgroundTransparency = 1

local Phase1Container = Instance.new("ScrollingFrame", PagesContainer)
Phase1Container.Size = UDim2.new(1, 0, 1, 0)
Phase1Container.BackgroundTransparency = 1
Phase1Container.ScrollBarThickness = 2
Phase1Container.CanvasSize = UDim2.new(0, 0, 0, 270)

local Phase2Container = Instance.new("ScrollingFrame", PagesContainer)
Phase2Container.Size = UDim2.new(1, 0, 1, 0)
Phase2Container.BackgroundTransparency = 1
Phase2Container.Visible = false
Phase2Container.ScrollBarThickness = 2
Phase2Container.CanvasSize = UDim2.new(0, 0, 0, 260)

local Phase3Container = Instance.new("ScrollingFrame", PagesContainer)
Phase3Container.Size = UDim2.new(1, 0, 1, 0)
Phase3Container.BackgroundTransparency = 1
Phase3Container.Visible = false
Phase3Container.ScrollBarThickness = 2
Phase3Container.CanvasSize = UDim2.new(0, 0, 0, 260)

-- 狀態欄與作者標籤
local StatusLabel = Instance.new("TextLabel", Frame)
StatusLabel.Size = UDim2.new(0.5, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 1, -22)
StatusLabel.Text = "Status: Waiting..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local Credit = Instance.new("TextLabel", Frame)
Credit.Size = UDim2.new(0.5, 0, 0, 20)
Credit.Position = UDim2.new(0.5, -10, 1, -22)
Credit.Text = "by: romokaso & Mod"
Credit.TextColor3 = Color3.fromRGB(120, 120, 120)
Credit.BackgroundTransparency = 1
Credit.Font = Enum.Font.GothamBold
Credit.TextSize = 10
Credit.TextXAlignment = Enum.TextXAlignment.Right

-- 輸入框 (Phase 1)
local InputBox = Instance.new("TextBox", Phase1Container)
InputBox.Size = UDim2.new(1, 0, 0, 32)
InputBox.Position = UDim2.new(0, 0, 0, 5)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.PlaceholderText = "Target: nickname, all, nonfriends"
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
InputBox.Font = Enum.Font.Code
InputBox.TextSize = 12
InputBox.Text = ""
InputBox.ClearTextOnFocus = false
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

-- 共用按鈕樣式生成器
local buttonReferences = {}
local function CreateStyledButton(text, position, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = position
    btn.BackgroundColor3 = Themes[CurrentTheme].Button
    btn.Text = text
    btn.TextColor3 = Themes[CurrentTheme].Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.ClipsDescendants = true

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local glow = Instance.new("UIStroke", btn)
    glow.Thickness = 0
    glow.Color = Color3.fromRGB(100, 100, 100)
    glow.Transparency = 1

    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Themes[CurrentTheme].ButtonActive then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Themes[CurrentTheme].ButtonHover}):Play()
        end
        TweenService:Create(glow, TweenInfo.new(0.1), {Thickness = 2, Transparency = 0.5}):Play()
    end)

    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Themes[CurrentTheme].ButtonActive then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Themes[CurrentTheme].Button}):Play()
        end
        TweenService:Create(glow, TweenInfo.new(0.1), {Thickness = 0, Transparency = 1}):Play()
    end)

    btn.MouseButton1Click:Connect(function() callback(btn) end)
    table.insert(buttonReferences, btn)
    return btn
end

-- ==========================================
-- 原 Antifling2 功能核心邏輯整理與綁定
-- ==========================================

-- 1. Fling 模式與核心邏輯
local function sortPlayersAlphabetically(players)
    table.sort(players, function(a, b) return string.lower(a.Name) < string.lower(b.Name) end)
    return players
end

local function SkidFling(TargetPlayer, duration)
    local Character = localPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")

    if Character and Humanoid and RootPart and TCharacter and TCharacter:FindFirstChildWhichIsA("BasePart") then
        if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
        if THead then workspace.CurrentCamera.CameraSubject = THead end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = duration or 2
            local Time = tick()
            local Angle = 0
            repeat
                if RootPart and THumanoid then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                    task.wait()
                else break end
            until not flingActive or BasePart.Parent ~= TargetPlayer.Character or tick() > Time + TimeToWait
        end
        
        local oldHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        local BV = Instance.new("BodyVelocity", RootPart)
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        if TRootPart then SFBasePart(TRootPart) end
        BV:Destroy()
        workspace.CurrentCamera.CameraSubject = Humanoid
        workspace.FallenPartsDestroyHeight = oldHeight
    end
end

local function shhhlol(TargetPlayer)
    local Character = localPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local TCharacter = TargetPlayer.Character
    local TRootPart = TCharacter and TCharacter:FindFirstChild("HumanoidRootPart")
    if RootPart and TRootPart then
        if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
        local oldHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        local BV = Instance.new("BodyVelocity", RootPart)
        BV.Velocity = Vector3.new(-9e99, 9e99, -9e99)
        BV.MaxForce = Vector3.new(-9e9, 9e9, -9e9)
        
        local Time = tick()
        repeat
            RootPart.CFrame = TRootPart.CFrame * CFrame.new(0, 1.5, 0)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            task.wait()
        until tick() > Time + 0.15 or not flingActive
        BV:Destroy()
        workspace.FallenPartsDestroyHeight = oldHeight
    end
end

local function yeet(targetPlayer)
    local Character = localPlayer.Character
    local TCharacter = targetPlayer.Character
    if Character and TCharacter and TCharacter:FindFirstChild("HumanoidRootPart") then
        if Character.HumanoidRootPart.Velocity.Magnitude < 50 then getgenv().OldPos = Character.HumanoidRootPart.CFrame end
        local Thrust = Instance.new('BodyThrust', Character.HumanoidRootPart)
        Thrust.Force = Vector3.new(9999, 9999, 9999)
        local oldHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        
        local Time = tick()
        repeat
            Character.HumanoidRootPart.CFrame = TCharacter.HumanoidRootPart.CFrame
            task.wait()
        until tick() > Time + 1.5 or not flingActive
        Thrust:Destroy()
        workspace.FallenPartsDestroyHeight = oldHeight
    end
end

local function getPlayers(input)
    local players = {}
    input = string.lower(input or "")
    if input == "all" then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= localPlayer then table.insert(players, p) end end
    elseif input == "nonfriends" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then
                local s, f = pcall(function() return p:IsFriendsWith(localPlayer.UserId) end)
                if not (s and f) then table.insert(players, p) end
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and (string.find(string.lower(p.Name), input) or string.find(string.lower(p.DisplayName or ""), input)) then
                table.insert(players, p)
            end
        end
    end
    return sortPlayersAlphabetically(players)
end

local function runFlingLoop()
    while flingActive do
        local targets = getPlayers(currentInput)
        if #targets == 0 then 
            StatusLabel.Text = "Status: Target not found"
            task.wait(0.5)
        else
            for _, p in ipairs(targets) do
                if not flingActive then break end
                StatusLabel.Text = "Status: Flinging " .. p.Name
                if flingMode == 1 then SkidFling(p, 1.5)
                elseif flingMode == 2 then shhhlol(p)
                elseif flingMode == 3 then yeet(p) end
            end
        end
        task.wait(0.1)
    end
    StatusLabel.Text = "Status: Idle"
end

-- InputBox 數據連動
InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentInput = InputBox.Text
end)

-- Phase 1 按鈕配置
local ModeBtn = CreateStyledButton("FLING MODE: 1", UDim2.new(0, 0, 0, 45), Phase1Container, function(btn)
    flingMode = flingMode >= 3 and 1 or flingMode + 1
    btn.Text = "FLING MODE: " .. flingMode
end)

local MainFlingBtn = CreateStyledButton("FLING PLAYERS: OFF", UDim2.new(0, 0, 0, 85), Phase1Container, function(btn)
    flingActive = not flingActive
    if flingActive then
        btn.Text = "FLING PLAYERS: ON"
        btn.BackgroundColor3 = Themes[CurrentTheme].ButtonActive
        task.spawn(runFlingLoop)
    else
        btn.Text = "FLING PLAYERS: OFF"
        btn.BackgroundColor3 = Themes[CurrentTheme].Button
    end
end)

local TouchFlingBtn = CreateStyledButton("TOUCH FLING: OFF", UDim2.new(0, 0, 0, 125), Phase1Container, function(btn)
    hiddenfling = not hiddenfling
    if hiddenfling then
        btn.Text = "TOUCH FLING: ON"
        btn.BackgroundColor3 = Themes[CurrentTheme].ButtonActive
        task.spawn(function()
            while hiddenfling do
                RunService.Heartbeat:Wait()
                local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = vel * 1e35 + Vector3.new(0, 1e35, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = vel
                end
            end
        end)
    else
        btn.Text = "TOUCH FLING: OFF"
        btn.BackgroundColor3 = Themes[CurrentTheme].Button
    end
end)

local function setCanCollideOfModelDescendants(model, bval)
    if not model then return end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = bval end
    end
end

local AntiFlingBtn = CreateStyledButton("ANTI FLING: OFF", UDim2.new(0, 0, 0, 165), Phase1Container, function(btn)
    AntiFlingEnabled = not AntiFlingEnabled
    if AntiFlingEnabled then
        btn.Text = "ANTI FLING: ON"
        btn.BackgroundColor3 = Themes[CurrentTheme].ButtonActive
    else
        btn.Text = "ANTI FLING: OFF"
        btn.BackgroundColor3 = Themes[CurrentTheme].Button
        for _, v in pairs(Players:GetPlayers()) do if v ~= localPlayer and v.Character then setCanCollideOfModelDescendants(v.Character, true) end end
    end
end)

RunService.Stepped:Connect(function()
    if AntiFlingEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= localPlayer and v.Character then setCanCollideOfModelDescendants(v.Character, false) end
        end
    end
end)

local AntiKillBtn = CreateStyledButton("ANTI KILL PARTS: OFF", UDim2.new(0, 0, 0, 205), Phase1Container, function(btn)
    AntiKillPartsEnabled = not AntiKillPartsEnabled
    if AntiKillPartsEnabled then
        btn.Text = "ANTI KILL PARTS: ON"
        btn.BackgroundColor3 = Themes[CurrentTheme].ButtonActive
        task.spawn(function()
            while AntiKillPartsEnabled do
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local parts = workspace:GetPartBoundsInRadius(localPlayer.Character.HumanoidRootPart.Position, 10)
                    for _, p in ipairs(parts) do p.CanTouch = false end
                end
                task.wait()
            end
        end)
    else
        btn.Text = "ANTI KILL PARTS: OFF"
        btn.BackgroundColor3 = Themes[CurrentTheme].Button
    end
end)

local NoclipBtn = CreateStyledButton("NOCLIP: OFF", UDim2.new(0, 0, 0, 245), Phase1Container, function(btn)
    isNoclipEnabled = not isNoclipEnabled
    if isNoclipEnabled then
        btn.Text = "NOCLIP: ON"
        btn.BackgroundColor3 = Themes[CurrentTheme].ButtonActive
        SteppedConnection = RunService.Stepped:Connect(function()
            if localPlayer.Character then
                for _, v in pairs(localPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end)
    else
        btn.Text = "NOCLIP: OFF"
        btn.BackgroundColor3 = Themes[CurrentTheme].Button
        if SteppedConnection then SteppedConnection:Disconnect() SteppedConnection = nil end
    end
end)

-- Phase 2 按鈕配置
local StrengthBtn = CreateStyledButton("STRENGTH: OFF", UDim2.new(0, 0, 0, 5), Phase2Container, function(btn)
    isStrengthened = not isStrengthened
    btn.Text = "STRENGTH: " .. (isStrengthened and "ON" or "OFF")
    btn.BackgroundColor3 = isStrengthened and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
    if localPlayer.Character then
        for _, p in pairs(localPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CustomPhysicalProperties = isStrengthened and PhysicalProperties.new(100, 0.3, 0.5) or nil end
        end
    end
end)

local SpawnBtn = CreateStyledButton("SPAWNPOINT: OFF", UDim2.new(0, 0, 0, 45), Phase2Container, function(btn)
    spawnpointActive = not spawnpointActive
    btn.Text = "SPAWNPOINT: " .. (spawnpointActive and "ON" or "OFF")
    btn.BackgroundColor3 = spawnpointActive and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
    if spawnpointActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = localPlayer.Character.HumanoidRootPart.CFrame
    else savedPosition = nil end
end)

localPlayer.CharacterAdded:Connect(function(char)
    if spawnpointActive and savedPosition then
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then task.wait(0.05) hrp.CFrame = savedPosition end
    end
end)

local AntiSlapBtn = CreateStyledButton("ANTI SLAP: OFF", UDim2.new(0, 0, 0, 85), Phase2Container, function(btn)
    antiSlapActive = not antiSlapActive
    btn.Text = "ANTI SLAP: " .. (antiSlapActive and "ON" or "OFF")
    btn.BackgroundColor3 = antiSlapActive and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
end)

local XenoAntiBtn = CreateStyledButton("XENO ANTIFLING: OFF", UDim2.new(0, 0, 0, 125), Phase2Container, function(btn)
    XenoAntiFlingEnabled = not XenoAntiFlingEnabled
    btn.Text = "XENO ANTIFLING: " .. (XenoAntiFlingEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = XenoAntiFlingEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
    if XenoAntiFlingEnabled then
        XenoAntiFlingConnection = RunService.Stepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    for _, v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.Velocity = Vector3.zero v.RotVelocity = Vector3.zero end
                    end
                end
            end
        end)
    else
        if XenoAntiFlingConnection then XenoAntiFlingConnection:Disconnect() end
    end
end)

local InfPosBtn = CreateStyledButton("INFINITE POSITION: OFF", UDim2.new(0, 0, 0, 165), Phase2Container, function(btn)
    infinitePositionEnabled = not infinitePositionEnabled
    btn.Text = "INFINITE POSITION: " .. (infinitePositionEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = infinitePositionEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
    if infinitePositionEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedInfinitePosition = localPlayer.Character.HumanoidRootPart.CFrame
    else savedInfinitePosition = nil end
end)

RunService.Heartbeat:Connect(function()
    if infinitePositionEnabled and savedInfinitePosition and not flingActive and localPlayer.Character then
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - savedInfinitePosition.Position).Magnitude > positionTolerance then
            hrp.CFrame = savedInfinitePosition
            hrp.Velocity = Vector3.zero
        end
    end
end)

local NDSAntiBtn = CreateStyledButton("NDS FALL DAMAGE: OFF", UDim2.new(0, 0, 0, 205), Phase2Container, function(btn)
    afdEnabled = not afdEnabled
    btn.Text = "NDS FALL DAMAGE: " .. (afdEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = afdEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
end)

-- Phase 3 按鈕配置
local AntiSitBtn = CreateStyledButton("ANTI SIT: OFF", UDim2.new(0, 0, 0, 5), Phase3Container, function(btn)
    noSitEnabled = not noSitEnabled
    btn.Text = "ANTI SIT: " .. (noSitEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = noSitEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
    if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
    end
end)

local FirePartsBtn = CreateStyledButton("FIRE PARTS TOOL", UDim2.new(0, 0, 0, 45), Phase3Container, function(btn)
    loadstring(game:HttpGet("https://glot.io/snippets/h9wgykubaz/raw/FireParts.lua"))()
end)

local FreeCamBtn = CreateStyledButton("FREECAM: OFF", UDim2.new(0, 0, 0, 85), Phase3Container, function(btn)
    freeCamEnabled = not freeCamEnabled
    btn.Text = "FREECAM: " .. (freeCamEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = freeCamEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
end)

local InvisBtn = CreateStyledButton("INVIS: OFF", UDim2.new(0, 0, 0, 125), Phase3Container, function(btn)
    invisibilityEnabled = not invisibilityEnabled
    btn.Text = "INVIS: " .. (invisibilityEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = invisibilityEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
end)

local RagdollBtn = CreateStyledButton("ANTI RAGDOLL: OFF", UDim2.new(0, 0, 0, 165), Phase3Container, function(btn)
    antiRagdollEnabled = not antiRagdollEnabled
    btn.Text = "ANTI RAGDOLL: " .. (antiRagdollEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = antiRagdollEnabled and Themes[CurrentTheme].ButtonActive or Themes[CurrentTheme].Button
end)

local PunchBtn = CreateStyledButton("PUNCH FLING", UDim2.new(0, 0, 0, 205), Phase3Container, function(btn)
    loadstring(game:HttpGet("https://glot.io/snippets/hfk7jcu7mz/raw/punch.lua"))()
end)

-- ==========================================
-- 下拉式選單分頁控制動畫 (承襲自 God Mode)
-- ==========================================
local function CreatePhaseMenuButton(text, index, yPos)
    local pBtn = Instance.new("TextButton", PhaseFrame)
    pBtn.Size = UDim2.new(1, -10, 0, 28)
    pBtn.Position = UDim2.new(0, 5, 0, yPos)
    pBtn.BackgroundColor3 = Themes.Dark.Button
    pBtn.Text = text
    pBtn.TextColor3 = Themes.Dark.Text
    pBtn.Font = Enum.Font.GothamBold
    pBtn.TextSize = 10
    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 7)
    pBtn.ZIndex = 16

    pBtn.MouseButton1Click:Connect(function()
        currentPhase = index
        PhaseMenuBtn.Text = "PAGE: " .. text
        PhaseFrame.Visible = false
        Phase1Container.Visible = (index == 1)
        Phase2Container.Visible = (index == 2)
        Phase3Container.Visible = (index == 3)
    end)
end

CreatePhaseMenuButton("1 (MAIN FLING)", 1, 5)
CreatePhaseMenuButton("2 (ADDITIONAL)", 2, 38)
CreatePhaseMenuButton("3 (MORE CHEATS)", 3, 71)

PhaseMenuBtn.MouseButton1Click:Connect(function()
    PhaseFrame.Visible = not PhaseFrame.Visible
end)

-- ==========================================
-- 設定功能、縮小、關閉視窗與雙重確認 (承襲自 God Mode)
-- ==========================================
local SettingsFrame = Instance.new("Frame", Frame)
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
SettingsFrame.BackgroundColor3 = Themes.Dark.Background
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Visible = false
SettingsFrame.ZIndex = 20
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 12)

local SettingsTitle = Instance.new("TextLabel", SettingsFrame)
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.Position = UDim2.new(0, 0, 0, 10)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = Themes.Dark.Text
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 16
SettingsTitle.ZIndex = 21

local ThemeLabel = Instance.new("TextLabel", SettingsFrame)
ThemeLabel.Size = UDim2.new(1, -20, 0, 25)
ThemeLabel.Position = UDim2.new(0, 10, 0, 60)
ThemeLabel.Text = "THEME:"
ThemeLabel.TextColor3 = Themes.Dark.Text
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextSize = 13
ThemeLabel.ZIndex = 21

local DarkThemeBtn = Instance.new("TextButton", SettingsFrame)
DarkThemeBtn.Size = UDim2.new(0.45, -5, 0, 35)
DarkThemeBtn.Position = UDim2.new(0, 10, 0, 90)
DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
DarkThemeBtn.Text = "DARK"
DarkThemeBtn.TextColor3 = Color3.new(1, 1, 1)
DarkThemeBtn.Font = Enum.Font.GothamBold
DarkThemeBtn.TextSize = 13
DarkThemeBtn.ZIndex = 21
Instance.new("UICorner", DarkThemeBtn).CornerRadius = UDim.new(0, 9)

local LightThemeBtn = Instance.new("TextButton", SettingsFrame)
LightThemeBtn.Size = UDim2.new(0.45, -5, 0, 35)
LightThemeBtn.Position = UDim2.new(0.55, 0, 0, 90)
LightThemeBtn.BackgroundColor3 = Themes.Dark.Button
LightThemeBtn.Text = "LIGHT"
LightThemeBtn.TextColor3 = Themes.Dark.Text
LightThemeBtn.Font = Enum.Font.GothamBold
LightThemeBtn.TextSize = 13
LightThemeBtn.ZIndex = 21
Instance.new("UICorner", LightThemeBtn).CornerRadius = UDim.new(0, 9)

local BackBtn = Instance.new("TextButton", SettingsFrame)
BackBtn.Size = UDim2.new(0.9, 0, 0, 35)
BackBtn.Position = UDim2.new(0.05, 0, 1, -50)
BackBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
BackBtn.Text = "BACK"
BackBtn.TextColor3 = Color3.new(1, 1, 1)
BackBtn.Font = Enum.Font.GothamBold
BackBtn.TextSize = 14
BackBtn.ZIndex = 21
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 9)

local ConfirmFrame = Instance.new("Frame", Frame)
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Themes.Dark.Background
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 25
ConfirmFrame.BackgroundTransparency = 0.05
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 12)
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame)
ConfirmStroke.Thickness = 3
ConfirmStroke.Color = Themes.Dark.Border

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, -20, 0, 60)
ConfirmText.Position = UDim2.new(0, 10, 0, 70)
ConfirmText.Text = "Are you sure you want\nto close the GUI?"
ConfirmText.TextColor3 = Themes.Dark.Text
ConfirmText.BackgroundTransparency = 1
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 26

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 95, 0, 35)
YesBtn.Position = UDim2.new(0, 15, 1, -50)
YesBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
YesBtn.Text = "YES"
YesBtn.TextColor3 = Color3.new(1, 1, 1)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 14
YesBtn.ZIndex = 26
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 9)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 95, 0, 35)
NoBtn.Position = UDim2.new(1, -110, 1, -50)
NoBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
NoBtn.Text = "NO"
NoBtn.TextColor3 = Color3.new(1, 1, 1)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 14
NoBtn.ZIndex = 26
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 9)

local function ApplyTheme(theme)
    local colors = Themes[theme]
    CurrentTheme = theme
    Frame.BackgroundColor3 = colors.Background
    TitleBar.BackgroundColor3 = colors.TitleBar
    TitleFix.BackgroundColor3 = colors.TitleBar
    Title.TextColor3 = colors.Text
    FrameStroke.Color = colors.Border
    SettingsBtn.BackgroundColor3 = colors.TopButtons
    SettingsBtn.TextColor3 = colors.Text
    MinimizeBtn.BackgroundColor3 = colors.TopButtons
    MinimizeBtn.TextColor3 = colors.Text
    CloseBtn.BackgroundColor3 = colors.TopButtons
    CloseBtn.TextColor3 = colors.Text
    PhaseMenuBtn.BackgroundColor3 = colors.Button
    PhaseMenuBtn.TextColor3 = colors.Text
    PhaseFrame.BackgroundColor3 = colors.Background
    PhaseFrameStroke.Color = colors.Border
    for _, btn in pairs(buttonReferences) do
        if btn.BackgroundColor3 ~= Themes.Dark.ButtonActive and btn.BackgroundColor3 ~= Themes.Light.ButtonActive then
            btn.BackgroundColor3 = colors.Button
        end
        btn.TextColor3 = colors.Text
    end
    SettingsFrame.BackgroundColor3 = colors.Background
    SettingsTitle.TextColor3 = colors.Text
    ThemeLabel.TextColor3 = colors.Text
    ConfirmFrame.BackgroundColor3 = colors.Background
    ConfirmStroke.Color = colors.Border
    ConfirmText.TextColor3 = colors.Text
    if theme == "Dark" then
        DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
        LightThemeBtn.BackgroundColor3 = colors.Button
    else
        LightThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
        DarkThemeBtn.BackgroundColor3 = colors.Button
    end
end

DarkThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Dark") end)
LightThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Light") end)
SettingsBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = not SettingsFrame.Visible end)
BackBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = false end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 250, 0, 35) or UDim2.new(0, 250, 0, 360)
    MinimizeBtn.Text = isMinimized and "+" or "−"
    TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
YesBtn.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)

-- 初始化載入與彈出效果
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 250, 0, 360),
    Position = UDim2.new(0.5, -125, 0.5, -180)
}):Play()
