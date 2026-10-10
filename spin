local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local spinning = false
local spinSpeed = 15 -- 預設旋轉速度

local characterAddedConn -- 用於儲存角色重生的連線，方便後續中斷

local function createSpinGui()
    local existingGui = localPlayer.PlayerGui:FindFirstChild("AdvancedSpinGui")
    if existingGui then existingGui:Destroy() end

    -- 主容器
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedSpinGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer.PlayerGui

    -- 主視窗框架
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 160)
    mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = mainFrame

    -- 標題列 (可用於拖動)
    local titleBar = Instance.new("TextLabel")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.Text = "  旋轉控制面板"
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 14
    titleBar.Parent = mainFrame

    -- 關閉按鈕 (×)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    -- 縮小按鈕 (—)
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.TextSize = 16
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = titleBar

    -- 內容容器 (縮放時隱藏)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- 旋轉開關按鈕
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 180, 0, 40)
    toggleBtn.Position = UDim2.new(0.5, -90, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleBtn.Text = "旋轉: 關閉"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 15
    toggleBtn.Parent = contentFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn

    -- 速度顯示標籤
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 180, 0, 20)
    speedLabel.Position = UDim2.new(0.5, -90, 0, 60)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "目前速度: " .. spinSpeed
    speedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 14
    speedLabel.Parent = contentFrame

    -- 速度調整按鈕 (減少/增加)
    local speedDownBtn = Instance.new("TextButton")
    speedDownBtn.Size = UDim2.new(0, 85, 0, 30)
    speedDownBtn.Position = UDim2.new(0.5, -90, 0, 85)
    speedDownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedDownBtn.Text = "速度 -5"
    speedDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownBtn.Font = Enum.Font.Gotham
    speedDownBtn.TextSize = 13
    speedDownBtn.Parent = contentFrame

    local speedUpBtn = Instance.new("TextButton")
    speedUpBtn.Size = UDim2.new(0, 85, 0, 30)
    speedUpBtn.Position = UDim2.new(0.5, 5, 0, 85)
    speedUpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedUpBtn.Text = "速度 +5"
    speedUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUpBtn.Font = Enum.Font.Gotham
    speedUpBtn.TextSize = 13
    speedUpBtn.Parent = contentFrame

    Instance.new("UICorner", speedDownBtn).CornerRadius = UDim.new(0, 5)
    Instance.new("UICorner", speedUpBtn).CornerRadius = UDim.new(0, 5)

    --------------------------------------------------------
    -- 功能邏輯 (事件監聽)
    --------------------------------------------------------

    -- 1. 開關旋轉
    toggleBtn.MouseButton1Click:Connect(function()
        spinning = not spinning
        if spinning then
            toggleBtn.Text = "旋轉: 開啟"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
        else
            toggleBtn.Text = "旋轉: 關閉"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)

    -- 2. 調整速度
    speedDownBtn.MouseButton1Click:Connect(function()
        spinSpeed = math.max(5, spinSpeed - 5)
        speedLabel.Text = "目前速度: " .. spinSpeed
    end)

    speedUpBtn.MouseButton1Click:Connect(function()
        spinSpeed = math.min(100, spinSpeed + 5)
        speedLabel.Text = "目前速度: " .. spinSpeed
    end)

    -- 3. 視窗縮小與展開
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 220, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
            minimizeBtn.Text = "+"
            contentFrame.Visible = false
        else
            mainFrame:TweenSize(UDim2.new(0, 220, 0, 160), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
            minimizeBtn.Text = "—"
            contentFrame.Visible = true
        end
    end)

    -- 4. 關閉面板功能
    closeBtn.MouseButton1Click:Connect(function()
        spinning = false
        if characterAddedConn then
            characterAddedConn:Disconnect()
        end
        screenGui:Destroy()
    end)

    -- 5. 拖動視窗邏輯
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- 初始化 GUI
createSpinGui()

-- 重生後重新建立 GUI
characterAddedConn = localPlayer.CharacterAdded:Connect(function()
    spinning = false
    createSpinGui()
end)

-- 執行旋轉
RunService.RenderStepped:Connect(function()
    if spinning and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = localPlayer.Character.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)
