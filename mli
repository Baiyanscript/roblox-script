local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ==================== 1. 完全保留：你原本腳本的核心功能變數 ====================
local GodModeActive = false
local AntiTPActive = false
local AntiFallActive = false
local AntiFallTeleporting = false
local CurrentTheme = "Dark"
local GodmodeMethod = 1

local godmodeConnections = table.create(0)
local antiTPConnections = table.create(0)
local antiFallConnections = table.create(0)

local godmodeCooldown = false
local antiTPCooldown = false
local antiFallCooldown = false

-- ==================== 2. 全局 ESP 設定檔 (與 UI 切換同步) ====================
_G.Config = {
    BoxESP = false,
    SkeletonESP = false,
    NameESP = false,
    DistanceESP = false,
    HealthBarEnabled = false,
    ShowHealthText = false,
    ShowTracer = false,
    TeamCheck = true,

    ColorBox = Color3.fromRGB(255, 255, 255),
    ColorSkeleton = Color3.fromRGB(255, 255, 255),
    ColorShowName = Color3.fromRGB(255, 255, 255),
    ColorDistance = Color3.fromRGB(255, 255, 255),
    ColorShowHealthText = Color3.fromRGB(255, 255, 255),
    ColorShowTracer = Color3.fromRGB(255, 255, 255)
}

local buttonReferences = table.create(0)
local ActiveRegistry = table.create(0)

-- ESP 專用 GUI (核心修正：IgnoreGuiInset 解決手機端座標對不上問題)
local espGui = Instance.new("ScreenGui", CoreGui)
espGui.Name = "RayfieldEngine_MobileESP"
espGui.IgnoreGuiInset = true 
espGui.ResetOnSpawn = false

-- ==================== 3. 核心：高精度 2D 劃線與文字輔助 ====================
local function NewLine(thick, color)
    local l = Instance.new("Frame", espGui)
    l.BorderSizePixel = 0
    l.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    l.Visible = false
    l.AnchorPoint = Vector2.new(0, 0.5) -- 修正關鍵：旋轉中心點設為起點左側中點
    return l
end

local function NewText(size, bold)
    local t = Instance.new("TextLabel", espGui)
    t.BackgroundTransparency = 1
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize = size or 12
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextStrokeTransparency = 0.2
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.Visible = false
    return t
end

-- 精準 2D 劃線函數 (解決 Tracer 射線對不上、偏斜、錯位問題)
local function DrawLine2D(frame, from, to, thick, color)
    local direction = to - from
    local distance = direction.Magnitude
    local angle = math.atan2(direction.Y, direction.X)

    frame.Size = UDim2.new(0, distance, 0, thick or 1)
    frame.Position = UDim2.new(0, from.X, 0, from.Y)
    frame.Rotation = math.deg(angle)
    frame.BackgroundColor3 = color or frame.BackgroundColor3
    frame.Visible = true
end

local function getBones(char)
    if char:FindFirstChild("UpperTorso") then
        return {
            {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
            {"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},
            {"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},
            {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},
            {"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},
            {"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},
            {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},
        }
    else
        return {
            {"Head","Torso"},{"Torso","Left Arm"},
            {"Torso","Right Arm"},{"Torso","Left Leg"},
            {"Torso","Right Leg"},
        }
    end
end

-- ==================== 4. ESP 渲染引擎生命週期 ====================
local function DestroyESPInstance(plr)
    if ActiveRegistry[plr] then
        pcall(function()
            local ent = ActiveRegistry[plr]
            if ent.Box then for _, l in ipairs(ent.Box) do l:Destroy() end end
            if ent.Skeleton then for _, l in pairs(ent.Skeleton) do l:Destroy() end end
            if ent.Text then ent.Text:Destroy() end
            if ent.Distance then ent.Distance:Destroy() end
            if ent.HealthText then ent.HealthText:Destroy() end
            if ent.Tracer then ent.Tracer:Destroy() end
            if ent.HealthBG then ent.HealthBG:Destroy() end
            if ent.HealthBar then ent.HealthBar:Destroy() end
        end)
        ActiveRegistry[plr] = nil
    end
end

local function AllocateESPInstance(plr)
    if plr == player then return end
    DestroyESPInstance(plr)

    local boxes = table.create(8)
    for i = 1, 8 do table.insert(boxes, NewLine(2, _G.Config.ColorBox)) end

    ActiveRegistry[plr] = {
        Box = boxes,
        Skeleton = table.create(0),
        Text = NewText(12, true),
        Distance = NewText(11, false),
        HealthText = NewText(11, true),
        Tracer = NewLine(1, _G.Config.ColorShowTracer),
        HealthBG = NewLine(1, Color3.fromRGB(30, 30, 30)),
        HealthBar = NewLine(1, Color3.fromRGB(0, 255, 0))
    }
end

local function AttachToPlayer(plr)
    if plr == player then return end
    AllocateESPInstance(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        AllocateESPInstance(plr)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do AttachToPlayer(plr) end
Players.PlayerAdded:Connect(AttachToPlayer)
Players.PlayerRemoving:Connect(DestroyESPInstance)

-- ==================== 5. ESP 主渲染循環（每一幀執行） ====================
RunService.RenderStepped:Connect(function()
    for plr, entity do
        if not plr or not Players:FindFirstChild(plr.Name) then
            DestroyESPInstance(plr)
            continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local isActive = hrp and head and (hum == nil or hum.Health > 0)
        local isAlly = (plr.Team and player.Team and plr.Team == player.Team)
        local displayAllowed = isActive and (not _G.Config.TeamCheck or not isAlly)

        if displayAllowed then
            -- WorldToViewportPoint 配合 IgnoreGuiInset 提供完美的手機螢幕座標
            local rootScreenPos, inFrame = camera:WorldToViewportPoint(hrp.Position)

            if inFrame then
                local headOffset = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local footOffset = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.0, 0))
                
                local calculatedHeight = math.abs(footOffset.Y - headOffset.Y)
                local calculatedWidth = calculatedHeight / 2
                local root2D = Vector2.new(rootScreenPos.X, rootScreenPos.Y)

                -- 1. Corners Box ESP
                if _G.Config.BoxESP then
                    local x = headOffset.X - calculatedWidth / 2
                    local y = headOffset.Y
                    local w = calculatedWidth * 0.25
                    local h = calculatedHeight * 0.25

                    DrawLine2D(entity.Box[1], Vector2.new(x, y), Vector2.new(x + w, y), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[2], Vector2.new(x, y), Vector2.new(x, y + h), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[3], Vector2.new(x + calculatedWidth, y), Vector2.new(x + calculatedWidth - w, y), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[4], Vector2.new(x + calculatedWidth, y), Vector2.new(x + calculatedWidth, y + h), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[5], Vector2.new(x, y + calculatedHeight), Vector2.new(x + w, y + calculatedHeight), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[6], Vector2.new(x, y + calculatedHeight), Vector2.new(x, y + calculatedHeight - h), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[7], Vector2.new(x + calculatedWidth, y + calculatedHeight), Vector2.new(x + calculatedWidth - w, y + calculatedHeight), 2, _G.Config.ColorBox)
                    DrawLine2D(entity.Box[8], Vector2.new(x + calculatedWidth, y + calculatedHeight), Vector2.new(x + calculatedWidth, y + calculatedHeight - h), 2, _G.Config.ColorBox)
                else
                    for i = 1, 8 do entity.Box[i].Visible = false end
                end

                -- 2. Skeleton ESP
                if _G.Config.SkeletonESP then
                    local bones = getBones(char)
                    for i, bone in ipairs(bones) do
                        if not entity.Skeleton[i] then entity.Skeleton[i] = NewLine(1, _G.Config.ColorSkeleton) end
                        local a = char:FindFirstChild(bone[1])
                        local b = char:FindFirstChild(bone[2])
                        local line = entity.Skeleton[i]
                        if a and b then
                            local a2D, aOn = camera:WorldToViewportPoint(a.Position)
                            local b2D, bOn = camera:WorldToViewportPoint(b.Position)
                            if aOn and bOn then
                                DrawLine2D(line, Vector2.new(a2D.X, a2D.Y), Vector2.new(b2D.X, b2D.Y), 1, _G.Config.ColorSkeleton)
                            else line.Visible = false end
                        else line.Visible = false end
                    end
                else
                    for _, l in pairs(entity.Skeleton) do l.Visible = false end
                end

                -- 3. Name ESP
                if _G.Config.NameESP then
                    entity.Text.Text = plr.Name
                    entity.Text.TextColor3 = _G.Config.ColorShowName
                    entity.Text.Position = UDim2.new(0, headOffset.X - 100, 0, headOffset.Y - 16)
                    entity.Text.Size = UDim2.new(0, 200, 0, 14)
                    entity.Text.Visible = true
                else entity.Text.Visible = false end

                -- 4. Distance ESP
                if _G.Config.DistanceESP then
                    entity.Distance.Text = string.format("[%.1fm]", rootScreenPos.Z)
                    entity.Distance.TextColor3 = _G.Config.ColorDistance
                    entity.Distance.Position = UDim2.new(0, root2D.X - 100, 0, root2D.Y + 15)
                    entity.Distance.Size = UDim2.new(0, 200, 0, 14)
                    entity.Distance.Visible = true
                else entity.Distance.Visible = false end

                -- 5. Health Bar
                if _G.Config.HealthBarEnabled and hum then
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barWidth = 3
                    local x = headOffset.X - (calculatedWidth / 2) - 6
                    local y = headOffset.Y

                    entity.HealthBG.Position = UDim2.new(0, x, 0, y)
                    entity.HealthBG.Size = UDim2.new(0, barWidth, 0, calculatedHeight)
                    entity.HealthBG.Visible = true

                    entity.HealthBar.Position = UDim2.new(0, x, 0, y + (calculatedHeight - (calculatedHeight * hp)))
                    entity.HealthBar.Size = UDim2.new(0, barWidth, 0, calculatedHeight * hp)
                    entity.HealthBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
                    entity.HealthBar.Visible = true
                else
                    entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
                end

                -- 6. Health Percentage Text
                if _G.Config.ShowHealthText and hum then
                    entity.HealthText.Text = math.floor((hum.Health / hum.MaxHealth) * 100) .. "%"
                    entity.HealthText.TextColor3 = _G.Config.ColorShowHealthText
                    entity.HealthText.Position = UDim2.new(0, root2D.X - 100, 0, root2D.Y + 28)
                    entity.HealthText.Size = UDim2.new(0, 200, 0, 14)
                    entity.HealthText.Visible = true
                else entity.HealthText.Visible = false end

                -- 7. Tracers ESP (修正版射線計算：由螢幕正底端完全吻合連接到 HRP 2D位置)
                if _G.Config.ShowTracer then
                    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    DrawLine2D(entity.Tracer, screenBottomCenter, root2D, 1, _G.Config.ColorShowTracer)
                else 
                    entity.Tracer.Visible = false 
                end
            else
                -- 出現視野外，將全部 ESP 隱藏
                for i = 1, 8 do entity.Box[i].Visible = false end
                for _, l in pairs(entity.Skeleton) do l.Visible = false end
                entity.Text.Visible = false; entity.Distance.Visible = false
                entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
                entity.HealthText.Visible = false; entity.Tracer.Visible = false
            end
        else
            -- 死亡、陣營過濾或不滿足條件時隱藏
            for i = 1, 8 do entity.Box[i].Visible = false end
            for _, l in pairs(entity.Skeleton) do l.Visible = false end
            entity.Text.Visible = false; entity.Distance.Visible = false
            entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
            entity.HealthText.Visible = false; entity.Tracer.Visible = false
        end
    end
end)

-- ==================== 6. 完全保留：原腳本三大核心功能邏輯 ====================
local godmodeMethod1Connection
local function ApplyGodmodeMethod1()
    if godmodeMethod1Connection then godmodeMethod1Connection:Disconnect() end
    godmodeMethod1Connection = RunService.Stepped:Connect(function()
        if GodModeActive and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanTouch = true end
            end
        elseif not GodModeActive and godmodeMethod1Connection then
            godmodeMethod1Connection:Disconnect()
            godmodeMethod1Connection = nil
        end
    end)
end

local function EnableGodMode()
    if GodmodeMethod == 1 then
        ApplyGodmodeMethod1()
    elseif GodmodeMethod == 2 then
        local c = player.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                local con = hum.HealthChanged:Connect(function(health)
                    if GodModeActive and health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                end)
                table.insert(godmodeConnections, con)
            end
        end
    elseif GodmodeMethod == 3 then
        local con = RunService.Heartbeat:Connect(function()
            if GodModeActive and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = hum.MaxHealth end
            end
        end)
        table.insert(godmodeConnections, con)
    end
end

local function DisableGodMode()
    if godmodeMethod1Connection then godmodeMethod1Connection:Disconnect(); godmodeMethod1Connection = nil end
    for _, con in pairs(godmodeConnections) do if con then con:Disconnect() end end
    table.clear(godmodeConnections)
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    if GodModeActive then EnableGodMode() end
end)

-- ==================== 7. THEME UI 完美架構 (深度還原 240x250 行動端 UI) ====================
local Themes = {
    Dark = {
        Background = Color3.fromRGB(10, 10, 10), TitleBar = Color3.fromRGB(15, 15, 15),
        Button = Color3.fromRGB(25, 25, 25), ButtonHover = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(220, 220, 220), Border = Color3.fromRGB(60, 60, 60), TopButtons = Color3.fromRGB(40, 40, 40)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240), TitleBar = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(255, 255, 255), ButtonHover = Color3.fromRGB(230, 230, 230),
        Text = Color3.fromRGB(20, 20, 20), Border = Color3.fromRGB(180, 180, 180), TopButtons = Color3.fromRGB(200, 200, 200)
    }
}

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "RayfieldHybrid_MobileUI"
MainGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 240, 0, 250)
Frame.Position = UDim2.new(0.5, -120, 0.5, -125)
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

-- 頂部標題列
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
Title.Text = "HYBRID ESP ENGINE"
Title.TextColor3 = Themes.Dark.Text
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 行動端拖動支援
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
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

-- 右上角按鈕組
local SettingsBtn = Instance.new("TextButton", TitleBar)
SettingsBtn.Size = UDim2.new(0, 26, 0, 26)
SettingsBtn.Position = UDim2.new(1, -92, 0.5, -13)
SettingsBtn.BackgroundColor3 = Themes.Dark.TopButtons
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Themes.Dark.Text
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 14
SettingsBtn.BorderSizePixel = 0
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6)

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Themes.Dark.TopButtons
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Themes.Dark.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = Themes.Dark.TopButtons
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Themes.Dark.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- 滾動視窗內容
local ScrollContent = Instance.new("ScrollingFrame", Frame)
ScrollContent.Size = UDim2.new(1, -12, 1, -45)
ScrollContent.Position = UDim2.new(0, 6, 0, 40)
ScrollContent.BackgroundTransparency = 1
ScrollContent.BorderSizePixel = 0
ScrollContent.CanvasSize = UDim2.new(0, 0, 0, 450) -- 擴大滾動範圍以容納新增的按鈕
ScrollContent.ScrollBarThickness = 3
ScrollContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local UIListLayout = Instance.new("UIListLayout", ScrollContent)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- 動態創建按鈕輔助
local function CreateToggleBtn(text, configKey)
    local btn = Instance.new("TextButton", ScrollContent)
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = Themes[CurrentTheme].Button
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Themes[CurrentTheme].Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        _G.Config[configKey] = not _G.Config[configKey]
        btn.Text = text .. ": " .. (_G.Config[configKey] and "ON" or "OFF")
        btn.TextColor3 = _G.Config[configKey] and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
    end)
    table.insert(buttonReferences, btn)
end

-- 建立所有功能開關按鈕 (ESP 模組)
CreateToggleBtn("BOXES ESP", "BoxESP")
CreateToggleBtn("SKELETON ESP", "SkeletonESP")
CreateToggleBtn("SHOW NAMES", "NameESP")
CreateToggleBtn("SHOW DISTANCE", "DistanceESP")
CreateToggleBtn("HEALTH BAR", "HealthBarEnabled")
CreateToggleBtn("HEALTH PERCENT TEXT", "ShowHealthText")
CreateToggleBtn("TRACERS ESP", "ShowTracer")

-- 團隊過濾按鈕
local TeamToggle = Instance.new("TextButton", ScrollContent)
TeamToggle.Size = UDim2.new(1, -4, 0, 32)
TeamToggle.BackgroundColor3 = Themes[CurrentTheme].Button
TeamToggle.Text = "TEAM CHECK: ON"
TeamToggle.TextColor3 = Color3.fromRGB(100, 255, 150)
TeamToggle.Font = Enum.Font.GothamBold
TeamToggle.TextSize = 12
TeamToggle.BorderSizePixel = 0
Instance.new("UICorner", TeamToggle).CornerRadius = UDim.new(0, 8)
TeamToggle.MouseButton1Click:Connect(function()
    _G.Config.TeamCheck = not _G.Config.TeamCheck
    TeamToggle.Text = "TEAM CHECK: " .. (_G.Config.TeamCheck and "ON" or "OFF")
    TeamToggle.TextColor3 = _G.Config.TeamCheck and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
end)
table.insert(buttonReferences, TeamToggle)

-- ==================== 8. 完全保留：原創功能按鈕組 (含高精度冷卻機制) ====================
local GodmodeBtn = Instance.new("TextButton", ScrollContent)
GodmodeBtn.Size = UDim2.new(1, -4, 0, 32)
GodmodeBtn.BackgroundColor3 = Themes[CurrentTheme].Button
GodmodeBtn.Text = "GODMODE: OFF"
GodmodeBtn.TextColor3 = Themes[CurrentTheme].Text
GodmodeBtn.Font = Enum.Font.GothamBold
GodmodeBtn.TextSize = 12
Instance.new("UICorner", GodmodeBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, GodmodeBtn)

GodmodeBtn.MouseButton1Click:Connect(function()
    if godmodeCooldown then return end
    godmodeCooldown = true
    GodModeActive = not GodModeActive
    GodmodeBtn.Text = "GODMODE: " .. (GodModeActive and "ON" or "OFF")
    GodmodeBtn.TextColor3 = GodModeActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
    
    if GodModeActive then EnableGodMode() else DisableGodMode() end
    task.wait(0.1)
    godmodeCooldown = false
end)

local AntiTPBtn = Instance.new("TextButton", ScrollContent)
AntiTPBtn.Size = UDim2.new(1, -4, 0, 32)
AntiTPBtn.BackgroundColor3 = Themes[CurrentTheme].Button
AntiTPBtn.Text = "ANTI-TP: OFF"
AntiTPBtn.TextColor3 = Themes[CurrentTheme].Text
AntiTPBtn.Font = Enum.Font.GothamBold
AntiTPBtn.TextSize = 12
Instance.new("UICorner", AntiTPBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, AntiTPBtn)

AntiTPBtn.MouseButton1Click:Connect(function()
    if antiTPCooldown then return end
    antiTPCooldown = true
    AntiTPActive = not AntiTPActive
    AntiTPBtn.Text = "ANTI-TP: " .. (AntiTPActive and "ON" or "OFF")
    AntiTPBtn.TextColor3 = AntiTPActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
    task.wait(0.1)
    antiTPCooldown = false
end)

local AntiFallBtn = Instance.new("TextButton", ScrollContent)
AntiFallBtn.Size = UDim2.new(1, -4, 0, 32)
AntiFallBtn.BackgroundColor3 = Themes[CurrentTheme].Button
AntiFallBtn.Text = "ANTI-FALL: OFF"
AntiFallBtn.TextColor3 = Themes[CurrentTheme].Text
AntiFallBtn.Font = Enum.Font.GothamBold
AntiFallBtn.TextSize = 12
Instance.new("UICorner", AntiFallBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, AntiFallBtn)

AntiFallBtn.MouseButton1Click:Connect(function()
    if antiFallCooldown then return end
    antiFallCooldown = true
    AntiFallActive = not AntiFallActive
    AntiFallBtn.Text = "ANTI-FALL: " .. (AntiFallActive and "ON" or "OFF")
    AntiFallBtn.TextColor3 = AntiFallActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
    task.wait(0.1)
    antiFallCooldown = false
end)

-- ==================== 9. 主題設定與確認關閉視窗面板 ====================
local SettingsFrame = Instance.new("Frame", Frame)
SettingsFrame.Size = UDim2.new(1, 0, 1, 0); SettingsFrame.BackgroundColor3 = Themes.Dark.Background; SettingsFrame.Visible = false; SettingsFrame.ZIndex = 20
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 12)

local SettingsTitle = Instance.new("TextLabel", SettingsFrame)
SettingsTitle.Size = UDim2.new(1, 0, 0, 40); SettingsTitle.Position = UDim2.new(0, 0, 0, 10); SettingsTitle.Text = "THEME SETTINGS"; SettingsTitle.TextColor3 = Themes.Dark.Text; SettingsTitle.Font = Enum.Font.GothamBold; SettingsTitle.TextSize = 15; SettingsTitle.BackgroundTransparency = 1; SettingsTitle.ZIndex = 21

local DarkThemeBtn = Instance.new("TextButton", SettingsFrame)
DarkThemeBtn.Size = UDim2.new(0.43, 0, 0, 35); DarkThemeBtn.Position = UDim2.new(0.05, 0, 0, 80); DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100); DarkThemeBtn.Text = "DARK"; DarkThemeBtn.TextColor3 = Color3.new(1, 1, 1); DarkThemeBtn.Font = Enum.Font.GothamBold; DarkThemeBtn.TextSize = 13; DarkThemeBtn.ZIndex = 21; Instance.new("UICorner", DarkThemeBtn).CornerRadius = UDim.new(0, 8)

local LightThemeBtn = Instance.new("TextButton", SettingsFrame)
LightThemeBtn.Size = UDim2.new(0.43, 0, 0, 35); LightThemeBtn.Position = UDim2.new(0.52, 0, 0, 80); LightThemeBtn.BackgroundColor3 = Themes.Dark.Button; LightThemeBtn.Text = "LIGHT"; LightThemeBtn.TextColor3 = Themes.Dark.Text; LightThemeBtn.Font = Enum.Font.GothamBold; LightThemeBtn.TextSize = 13; LightThemeBtn.ZIndex = 21; Instance.new("UICorner", LightThemeBtn).CornerRadius = UDim.new(0, 8)

local BackBtn = Instance.new("TextButton", SettingsFrame)
BackBtn.Size = UDim2.new(0.9, 0, 0, 35); BackBtn.Position = UDim2.new(0.05, 0, 1, -50); BackBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80); BackBtn.Text = "BACK"; BackBtn.TextColor3 = Color3.new(1, 1, 1); BackBtn.Font = Enum.Font.GothamBold; BackBtn.TextSize = 14; BackBtn.ZIndex = 21; Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 8)

local ConfirmFrame = Instance.new("Frame", Frame)
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame)
local ConfirmText = Instance.new("TextLabel", ConfirmFrame)

local function ApplyTheme(theme)
    local colors = Themes[theme]
    CurrentTheme = theme
    Frame.BackgroundColor3 = colors.Background
    TitleBar.BackgroundColor3 = colors.TitleBar
    TitleFix.BackgroundColor3 = colors.TitleBar
    Title.TextColor3 = colors.Text
    FrameStroke.Color = colors.Border
    SettingsBtn.BackgroundColor3 = colors.TopButtons; SettingsBtn.TextColor3 = colors.Text
    MinimizeBtn.BackgroundColor3 = colors.TopButtons; MinimizeBtn.TextColor3 = colors.Text
    CloseBtn.BackgroundColor3= colors.TopButtons; CloseBtn.TextColor3 = colors.Text
    for _, btn in pairs(buttonReferences) do
        if not string.find(btn.Text, "ON") then btn.BackgroundColor3 = colors.Button; btn.TextColor3 = colors.Text end
    end
    SettingsFrame.BackgroundColor3 = colors.Background; SettingsTitle.TextColor3 = colors.Text
    ConfirmFrame.BackgroundColor3 = colors.Background; ConfirmStroke.Color = colors.Border; ConfirmText.TextColor3 = colors.Text
    if theme == "Dark" then
        DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100); DarkThemeBtn.TextColor3 = Color3.new(1, 1, 1)
        LightThemeBtn.BackgroundColor3 = colors.Button; LightThemeBtn.TextColor3 = colors.Text
    else
        LightThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100); LightThemeBtn.TextColor3 = Color3.new(1, 1, 1)
        DarkThemeBtn.BackgroundColor3 = colors.Button; DarkThemeBtn.TextColor3 = colors.Text
    end
end

ConfirmFrame.Size = UDim2.new(1, 0, 1, 0); ConfirmFrame.BackgroundColor3 = Themes.Dark.Background; ConfirmFrame.Visible = false; ConfirmFrame.ZIndex = 25; ConfirmFrame.BackgroundTransparency = 0.05
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 12)
ConfirmStroke.Thickness = 2; ConfirmStroke.Color = Themes.Dark.Border; ConfirmStroke.Parent = ConfirmFrame
ConfirmText.Size = UDim2.new(1, -20, 0, 60); ConfirmText.Position = UDim2.new(0, 10, 0, 70); ConfirmText.Text = "Are you sure you want\nto close the HUB?"; ConfirmText.TextColor3 = Themes.Dark.Text; ConfirmText.BackgroundTransparency = 1; ConfirmText.Font = Enum.Font.GothamBold; ConfirmText.TextSize = 14; ConfirmText.ZIndex = 26; ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 95, 0, 35); YesBtn.Position = UDim2.new(0, 15, 1, -50); YesBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100); YesBtn.Text = "YES"; YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255); YesBtn.Font = Enum.Font.GothamBold; YesBtn.TextSize = 14; YesBtn.ZIndex = 26; Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 9)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 95, 0, 35); NoBtn.Position = UDim2.new(1, -110, 1, -50); NoBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80); NoBtn.Text = "NO"; NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255); NoBtn.Font = Enum.Font.GothamBold; NoBtn.TextSize = 14; NoBtn.ZIndex = 26; Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 9)

local isMinimized, isClosing, settingsOpen, confirmDialogOpen = false, false, false, false

DarkThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Dark") end)
LightThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Light") end)
BackBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = false; settingsOpen = false end)

SettingsBtn.MouseButton1Click:Connect(function()
    if confirmDialogOpen then return end
    if isMinimized then
        isMinimized = false
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play()
        MinimizeBtn.Text = "−"
        task.wait(0.1)
    end
    SettingsFrame.Visible = not SettingsFrame.Visible; settingsOpen = SettingsFrame.Visible
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if confirmDialogOpen then return end
    if settingsOpen then SettingsFrame.Visible = false; settingsOpen = false end
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 35)}):Play()
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play()
        MinimizeBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    if isClosing or confirmDialogOpen then return end
    confirmDialogOpen = true
    if settingsOpen then SettingsFrame.Visible = false; settingsOpen = false end
    if isMinimized then
        isMinimized = false
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play()
        MinimizeBtn.Text = "−"
        task.wait(0.1)
    end
    ConfirmFrame.Visible = true
end)

local noCooldown = false
NoBtn.MouseButton1Click:Connect(function()
    if noCooldown then return end
    noCooldown = true
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    task.wait(0.1)
    ConfirmFrame.Visible = false
    confirmDialogOpen = false
    task.wait(0.1)
    noCooldown = false
end)

local yesCooldown = false
YesBtn.MouseButton1Click:Connect(function()
    if yesCooldown or isClosing then return end
    yesCooldown = true
    isClosing = true
    
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    task.wait(0.1)
    TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    
    task.wait(0.1)
    espGui:Destroy()
    MainGui:Destroy()
end)

-- 開場動畫
Frame.Size = UDim2.new(0, 0, 0, 0); Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250), Position = UDim2.new(0.5, -120, 0.5, -125)}):Play()
