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

local godmodeConnections = {}
local antiTPConnections = {}
local antiFallConnections = {}

local godmodeCooldown = false
local antiTPCooldown = false
local antiFallCooldown = false

local godmodeMethod1Connection

-- ==================== 2. 全局 ESP 設定檔 (與 UI 開關連動) ====================
_G.Config = {
    BoxESP = false,
    SkeletonESP = false,
    NameESP = false,
    DistanceESP = false,
    HealthBarEnabled = false,
    ShowHealthText = false,
    ShowTracer = false,
    TeamCheck = true,

    ColorBox = Color3.fromRGB(255, 50, 50),
    ColorSkeleton = Color3.fromRGB(255, 255, 255),
    ColorShowName = Color3.fromRGB(255, 255, 255),
    ColorDistance = Color3.fromRGB(200, 200, 200),
    ColorShowHealthText = Color3.fromRGB(100, 255, 100),
    ColorShowTracer = Color3.fromRGB(255, 255, 50)
}

local buttonReferences = {}
local ActiveRegistry = {}

-- ESP 專用 GUI (核心修正：IgnoreGuiInset 解決手機端座標偏移問題)
local espGui = Instance.new("ScreenGui", CoreGui)
espGui.Name = "RayfieldEngine_MobileESP"
espGui.IgnoreGuiInset = true 
espGui.ResetOnSpawn = false

-- ==================== 3. ESP 高精度 2D 劃線與文字輔助函數 ====================
local function NewLine(thick, color)
    local l = Instance.new("Frame", espGui)
    l.BorderSizePixel = 0
    l.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    l.Visible = false
    l.AnchorPoint = Vector2.new(0, 0.5) -- 旋轉中心點設為左側中點，確保 2D 線條完全對齊
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

-- 高精度 2D 劃線公式
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
            {"LeftLowerLeg","LeftFoot"},{"RightUpperLeg","RightFoot"},
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

    local boxes = {}
    for i = 1, 8 do table.insert(boxes, NewLine(2, _G.Config.ColorBox)) end

    ActiveRegistry[plr] = {
        Box = boxes,
        Skeleton = {},
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
        task.wait(0.3)
        AllocateESPInstance(plr)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do AttachToPlayer(plr) end
Players.PlayerAdded:Connect(AttachToPlayer)
Players.PlayerRemoving:Connect(DestroyESPInstance)

-- ==================== 5. ESP 畫面主渲染循環（每幀精準對齊） ====================
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
            local rootScreenPos, inFrame = camera:WorldToViewportPoint(hrp.Position)

            if inFrame then
                local headOffset = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local footOffset = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.3, 0))
                
                local calculatedHeight = math.abs(footOffset.Y - headOffset.Y)
                local calculatedWidth = calculatedHeight / 1.6
                local root2D = Vector2.new(rootScreenPos.X, rootScreenPos.Y)

                -- 1. Corners Box ESP (角落方框)
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

                -- 2. Skeleton ESP (骨骼透視)
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

                -- 3. Name ESP (顯示名字)
                if _G.Config.NameESP then
                    entity.Text.Text = plr.Name
                    entity.Text.TextColor3 = _G.Config.ColorShowName
                    entity.Text.Position = UDim2.new(0, headOffset.X - 100, 0, headOffset.Y - 16)
                    entity.Text.Size = UDim2.new(0, 200, 0, 14)
                    entity.Text.Visible = true
                else entity.Text.Visible = false end

                -- 4. Distance ESP (顯示距離)
                if _G.Config.DistanceESP then
                    entity.Distance.Text = string.format("[%.1fm]", rootScreenPos.Z)
                    entity.Distance.TextColor3 = _G.Config.ColorDistance
                    entity.Distance.Position = UDim2.new(0, root2D.X - 100, 0, root2D.Y + 15)
                    entity.Distance.Size = UDim2.new(0, 200, 0, 14)
                    entity.Distance.Visible = true
                else entity.Distance.Visible = false end

                -- 5. Health Bar (動態血條)
                if _G.Config.HealthBarEnabled and hum then
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barWidth = 3
                    local x = headOffset.X - (calculatedWidth / 2) - 7
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

                -- 6. Health Percent Text (血量百分比)
                if _G.Config.ShowHealthText and hum then
                    entity.HealthText.Text = math.floor((hum.Health / hum.MaxHealth) * 100) .. "%"
                    entity.HealthText.TextColor3 = _G.Config.ColorShowHealthText
                    entity.HealthText.Position = UDim2.new(0, root2D.X - 100, 0, root2D.Y + 28)
                    entity.HealthText.Size = UDim2.new(0, 200, 0, 14)
                    entity.HealthText.Visible = true
                else entity.HealthText.Visible = false end

                -- 7. Tracers ESP (精準對齊螢幕底端中點的追蹤射線)
                if _G.Config.ShowTracer then
                    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    DrawLine2D(entity.Tracer, screenBottomCenter, root2D, 1, _G.Config.ColorShowTracer)
                else 
                    entity.Tracer.Visible = false 
                end
            else
                -- 出現視野外，隱藏此人所有 ESP 元件
                for i = 1, 8 do entity.Box[i].Visible = false end
                for _, l in pairs(entity.Skeleton) do l.Visible = false end
                entity.Text.Visible = false; entity.Distance.Visible = false
                entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
                entity.HealthText.Visible = false; entity.Tracer.Visible = false
            end
        else
            -- 不符合過濾條件時隱藏
            for i = 1, 8 do entity.Box[i].Visible = false end
            for _, l in pairs(entity.Skeleton) do l.Visible = false end
            entity.Text.Visible = false; entity.Distance.Visible = false
            entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
            entity.HealthText.Visible = false; entity.Tracer.Visible = false
        end
    end
end)

-- ==================== 6. 完全保留：你原本腳本的所有核心功能邏輯 ====================
function ApplyGodmodeMethod1() [cite: 1]
    if godmodeMethod1Connection then godmodeMethod1Connection:Disconnect() end [cite: 1]
    
    godmodeMethod1Connection = RunService.Stepped:Connect(function() [cite: 1]
        if GodModeActive and player.Character then [cite: 1]
            local hum = player.Character:FindFirstChildOfClass("Humanoid") [cite: 1, 2]
            if hum then [cite: 2]
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) [cite: 2]
                if hum.Health < hum.MaxHealth then [cite: 2]
                    hum.Health = hum.MaxHealth [cite: 2]
                end [cite: 2]
            end [cite: 3]
            for _, v in pairs(player.Character:GetDescendants()) do [cite: 3]
                if v:IsA("BasePart") then [cite: 3]
                    v.CanTouch = true [cite: 3]
                end [cite: 3]
            end [cite: 3]
        elseif not GodModeActive and player.Character then [cite: 3, 4]
            for _, v in pairs(player.Character:GetDescendants()) do [cite: 4]
                if v:IsA("BasePart") then [cite: 4]
                    v.CanTouch = true [cite: 4]
                end [cite: 4]
            end [cite: 4]
        end [cite: 4]
    end) [cite: 4]
end [cite: 4]

local function startGodmode() [cite: 4, 5]
    for _, conn in pairs(godmodeConnections) do [cite: 5]
        if conn then conn:Disconnect() end [cite: 5]
    end [cite: 5]
    godmodeConnections = {} [cite: 5]

    local character = player.Character [cite: 5]
    if not character then return end [cite: 5]

    local humanoid = character:FindFirstChild("Humanoid") [cite: 5]
    if not humanoid then return end [cite: 5]

    task.wait(0.1) [cite: 5]

    godmodeConnections[1] = humanoid.HealthChanged:Connect(function(health) [cite: 5]
        if health < humanoid.MaxHealth and health > 0 then [cite: 5]
             humanoid.Health = humanoid.MaxHealth [cite: 5, 6]
        end [cite: 6]
    end) [cite: 6]

    godmodeConnections[2] = RunService.Stepped:Connect(function() [cite: 6]
        if humanoid.Health > 0 then [cite: 6]
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) [cite: 6]

            for _, v in pairs(character:GetDescendants()) do [cite: 6]
                if v:IsA("BasePart") then [cite: 6]
                     v.CanTouch = true [cite: 6, 7]
                end [cite: 7]
            end [cite: 7]
        end [cite: 7]
    end) [cite: 7]

    humanoid.Died:Connect(function() [cite: 7]
        for _, conn in pairs(godmodeConnections) do [cite: 7]
            if conn then conn:Disconnect() end [cite: 7]
        end [cite: 7]
        godmodeConnections = {} [cite: 7]
    end) [cite: 7]
end [cite: 7]

local function stopGodmode() [cite: 7, 8]
    for _, conn in pairs(godmodeConnections) do [cite: 8]
        if conn then conn:Disconnect() end [cite: 8]
    end [cite: 8]
    godmodeConnections = {} [cite: 8]
    
    if godmodeMethod1Connection then [cite: 8]
        godmodeMethod1Connection:Disconnect() [cite: 8]
    end [cite: 8]

    if player.Character then [cite: 8]
        for _, v in pairs(player.Character:GetDescendants()) do [cite: 8]
            if v:IsA("BasePart") then [cite: 8]
               v.CanTouch = true [cite: 8, 9]
            end [cite: 9]
        end [cite: 9]
    end [cite: 9]
end [cite: 9]

local function startAntiTP() [cite: 9]
    for _, conn in pairs(antiTPConnections) do [cite: 9]
        if conn then conn:Disconnect() end [cite: 9]
    end [cite: 9]
    antiTPConnections = {} [cite: 9]

    local character = player.Character [cite: 9]
    if not character then return end [cite: 9]

    local hrp = character:FindFirstChild("HumanoidRootPart") [cite: 9]
    local humanoid = character:FindFirstChild("Humanoid") [cite: 9]
    if not hrp or not humanoid then return end [cite: 9, 10]

    task.wait(0.1) [cite: 10]
    local safePosition = hrp.CFrame [cite: 10]

    antiTPConnections[1] = RunService.Stepped:Connect(function() [cite: 10]
        if humanoid.Health > 0 then [cite: 10]
            local dist = (hrp.CFrame.Position - safePosition.Position).Magnitude [cite: 10]
            if dist > 10 and not AntiFallTeleporting then [cite: 10]
                hrp.CFrame = safePosition [cite: 10]
                hrp.AssemblyLinearVelocity = Vector3.zero [cite: 11]
                hrp.AssemblyAngularVelocity = Vector3.zero [cite: 11]
            else [cite: 11]
                safePosition = hrp.CFrame [cite: 11]
            end [cite: 11]
        end [cite: 11]
    end) [cite: 11]

    antiTPConnections[2] = RunService.Heartbeat:Connect(function() [cite: 11]
        if humanoid.Health > 0 then [cite: 11]
             local dist = (hrp.CFrame.Position - safePosition.Position).Magnitude [cite: 12]
            if dist > 10 and not AntiFallTeleporting then [cite: 12]
                hrp.CFrame = safePosition [cite: 12]
            end [cite: 12]
        end [cite: 12]
    end) [cite: 12]

    humanoid.Died:Connect(function() [cite: 12]
        for _, conn in pairs(antiTPConnections) do [cite: 12]
             if conn then conn:Disconnect() end [cite: 13]
        end [cite: 13]
        antiTPConnections = {} [cite: 13]
    end) [cite: 13]
end [cite: 13]

local function stopAntiTP() [cite: 13]
    for _, conn in pairs(antiTPConnections) do [cite: 13]
        if conn then conn:Disconnect() end [cite: 13]
    end [cite: 13]
    antiTPConnections = {} [cite: 13]
end [cite: 13]

local function startAntiFall() [cite: 13]
    for _, conn in pairs(antiFallConnections) do [cite: 13]
        if conn then conn:Disconnect() end [cite: 13]
    end [cite: 13]
    antiFallConnections = {} [cite: 13]

    local character = player.Character [cite: 13, 14]
    if not character then return end [cite: 14]

    local hrp = character:FindFirstChild("HumanoidRootPart") [cite: 14]
    local humanoid = character:FindFirstChild("Humanoid") [cite: 14]
    if not hrp or not humanoid then return end [cite: 14]

    task.wait(0.1) [cite: 14]
    local lastGroundPosition = hrp.CFrame [cite: 14]
    local lastGroundY = hrp.Position.Y [cite: 14]

    antiFallConnections[1] = RunService.Heartbeat:Connect(function() [cite: 14]
        if humanoid.Health > 0 then [cite: 14]
            local currentY = hrp.Position.Y [cite: 14]

            if humanoid.FloorMaterial ~= Enum.Material.Air then [cite: 14, 15]
                lastGroundPosition = hrp.CFrame [cite: 15]
                lastGroundY = currentY [cite: 15]
            end [cite: 15]

            if lastGroundY - currentY > 15 then [cite: 15]
                AntiFallTeleporting = true [cite: 15]

                hrp.CFrame = lastGroundPosition [cite: 16]
                hrp.AssemblyLinearVelocity = Vector3.zero [cite: 16]

                task.delay(0.1, function() [cite: 16]
                    AntiFallTeleporting = false [cite: 16]
                end) [cite: 16]
            end [cite: 16]
        end [cite: 16]
    end) [cite: 17]

    humanoid.Died:Connect(function() [cite: 17]
        for _, conn in pairs(antiFallConnections) do [cite: 17]
            if conn then conn:Disconnect() end [cite: 17]
        end [cite: 17]
        antiFallConnections = {} [cite: 17]
    end) [cite: 17]
end [cite: 17]

local function stopAntiFall() [cite: 17]
    for _, conn in pairs(antiFallConnections) do [cite: 17]
        if conn then conn:Disconnect() end [cite: 17]
    end [cite: 17]
    antiFallConnections = {} [cite: 17]
end [cite: 17]

-- ==================== 7. THEME UI 完美架構 (完全適配行動端滾動佈局) ====================
local Themes = {
    Dark = { [cite: 18]
        Background = Color3.fromRGB(10, 10, 10), [cite: 18]
        TitleBar = Color3.fromRGB(15, 15, 15), [cite: 18]
        Button = Color3.fromRGB(25, 25, 25), [cite: 18]
        ButtonHover = Color3.fromRGB(35, 35, 35), [cite: 18]
        Text = Color3.fromRGB(220, 220, 220), [cite: 18]
        Border = Color3.fromRGB(60, 60, 60), [cite: 18]
        TopButtons = Color3.fromRGB(40, 40, 40) [cite: 18]
    },
    Light = { [cite: 18]
        Background = Color3.fromRGB(240, 240, 240), [cite: 19]
        TitleBar = Color3.fromRGB(220, 220, 220), [cite: 19]
        Button = Color3.fromRGB(255, 255, 255), [cite: 19]
        ButtonHover = Color3.fromRGB(230, 230, 230), [cite: 19]
        Text = Color3.fromRGB(20, 20, 20), [cite: 19]
        Border = Color3.fromRGB(180, 180, 180), [cite: 19]
        TopButtons = Color3.fromRGB(200, 200, 200) [cite: 19]
    }
}

local MainGui = Instance.new("ScreenGui", CoreGui) [cite: 19]
MainGui.Name = "GodModeAndMore" [cite: 19]
MainGui.ResetOnSpawn = false [cite: 19]

local Frame = Instance.new("Frame", MainGui) [cite: 19]
Frame.Size = UDim2.new(0, 240, 0, 250) [cite: 19]
Frame.Position = UDim2.new(0.5, -120, 0.5, -125) [cite: 19, 20]
Frame.BackgroundColor3 = Themes.Dark.Background [cite: 20]
Frame.BorderSizePixel = 0 [cite: 20]
Frame.Active = true [cite: 20]
Frame.ClipsDescendants = true [cite: 20]

local FrameCorner = Instance.new("UICorner", Frame) [cite: 20]
FrameCorner.CornerRadius = UDim.new(0, 12) [cite: 20]

local FrameStroke = Instance.new("UIStroke", Frame) [cite: 20]
FrameStroke.Thickness = 2 [cite: 20]
FrameStroke.Color = Themes.Dark.Border [cite: 20]
FrameStroke.Transparency = 0.2 [cite: 20]

local TitleBar = Instance.new("Frame", Frame) [cite: 20]
TitleBar.Size = UDim2.new(1, 0, 0, 35) [cite: 20]
TitleBar.BackgroundColor3 = Themes.Dark.TitleBar [cite: 20]
TitleBar.BorderSizePixel = 0 [cite: 20]

local TitleCorner = Instance.new("UICorner", TitleBar) [cite: 20]
TitleCorner.CornerRadius = UDim.new(0, 12) [cite: 20]

local TitleFix = Instance.new("Frame", TitleBar) [cite: 20]
TitleFix.Size = UDim2.new(1, 0, 0, 15) [cite: 20]
TitleFix.Position = UDim2.new(0, 0, 1, -15) [cite: 20]
TitleFix.BackgroundColor3 = Themes.Dark.TitleBar [cite: 20]
TitleFix.BorderSizePixel = 0 [cite: 20]

local Title = Instance.new("TextLabel", TitleBar) [cite: 20]
Title.Size = UDim2.new(1, -100, 1, 0) [cite: 20, 21]
Title.Position = UDim2.new(0, 10, 0, 0) [cite: 21]
Title.Text = "HYBRID ESP ENGINE" [cite: 21]
Title.TextColor3 = Themes.Dark.Text [cite: 21]
Title.BackgroundTransparency = 1 [cite: 21]
Title.Font = Enum.Font.GothamBold [cite: 21]
Title.TextSize = 13 [cite: 21]
Title.TextXAlignment = Enum.TextXAlignment.Left [cite: 21]

-- 行動端拖拽支援邏輯
local dragging = false [cite: 21]
local dragInput [cite: 21]
local dragStart [cite: 21]
local startPos [cite: 21]

TitleBar.InputBegan:Connect(function(input) [cite: 21]
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then [cite: 21]
        dragging = true [cite: 21]
        dragStart = input.Position [cite: 21]
        startPos = Frame.Position [cite: 21]

        input.Changed:Connect(function() [cite: 21]
            if input.UserInputState == Enum.UserInputState.End then [cite: 21]
                 dragging = false [cite: 22]
            end [cite: 22]
        end) [cite: 22]
    end [cite: 22]
end) [cite: 22]

TitleBar.InputChanged:Connect(function(input) [cite: 22]
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then [cite: 22]
        dragInput = input [cite: 22]
    end [cite: 22]
end) [cite: 22]

UserInputService.InputChanged:Connect(function(input) [cite: 22]
    if input == dragInput and dragging then [cite: 22]
        local delta = input.Position - dragStart [cite: 22]
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) [cite: 23]
    end [cite: 23]
end) [cite: 23]

-- 頂部功能鈕群組
local SettingsBtn = Instance.new("TextButton", TitleBar) [cite: 23]
SettingsBtn.Size = UDim2.new(0, 26, 0, 26) [cite: 23]
SettingsBtn.Position = UDim2.new(1, -92, 0.5, -13) [cite: 23]
SettingsBtn.BackgroundColor3 = Themes.Dark.TopButtons [cite: 23]
SettingsBtn.Text = "⚙" [cite: 23]
SettingsBtn.TextColor3 = Themes.Dark.Text [cite: 23]
SettingsBtn.Font = Enum.Font.GothamBold [cite: 23]
SettingsBtn.TextSize = 14 [cite: 23]
SettingsBtn.BorderSizePixel = 0 [cite: 23]
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6) [cite: 23]

local MinimizeBtn = Instance.new("TextButton", TitleBar) [cite: 23]
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26) [cite: 23]
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -13) [cite: 23]
MinimizeBtn.BackgroundColor3 = Themes.Dark.TopButtons [cite: 23]
MinimizeBtn.Text = "−" [cite: 23]
MinimizeBtn.TextColor3 = Themes.Dark.Text [cite: 23]
MinimizeBtn.Font = Enum.Font.GothamBold [cite: 23]
MinimizeBtn.TextSize = 14 [cite: 23]
MinimizeBtn.BorderSizePixel = 0 [cite: 23]
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6) [cite: 23]

local CloseBtn = Instance.new("TextButton", TitleBar) [cite: 23]
CloseBtn.Size = UDim2.new(0, 26, 0, 26) [cite: 23]
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13) [cite: 23]
CloseBtn.BackgroundColor3 = Themes.Dark.TopButtons [cite: 23]
CloseBtn.Text = "×" [cite: 23]
CloseBtn.TextColor3 = Themes.Dark.Text [cite: 23]
CloseBtn.Font = Enum.Font.GothamBold [cite: 23]
CloseBtn.TextSize = 18 [cite: 23]
CloseBtn.BorderSizePixel = 0 [cite: 23]
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6) [cite: 24]

-- 升級為 ScrollingFrame 滾動容器，容納大量的功能開關
local ScrollContent = Instance.new("ScrollingFrame", Frame)
ScrollContent.Size = UDim2.new(1, -12, 1, -45)
ScrollContent.Position = UDim2.new(0, 6, 0, 40)
ScrollContent.BackgroundTransparency = 1
ScrollContent.BorderSizePixel = 0
ScrollContent.CanvasSize = UDim2.new(0, 0, 0, 480) -- 保留足夠滾動空間
ScrollContent.ScrollBarThickness = 3
ScrollContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local UIListLayout = Instance.new("UIListLayout", ScrollContent)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- 動態開關按鈕生成模組
local function CreateToggleBtn(text, configKey)
    local btn = Instance.new("TextButton", ScrollContent)
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = Themes[CurrentTheme].Button [cite: 26]
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Themes[CurrentTheme].Text [cite: 26]
    btn.Font = Enum.Font.GothamBold [cite: 26]
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        _G.Config[configKey] = not _G.Config[configKey]
        btn.Text = text .. ": " .. (_G.Config[configKey] and "ON" or "OFF")
        btn.TextColor3 = _G.Config[configKey] and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
    end)
    table.insert(buttonReferences, btn) [cite: 27]
end

-- 創建所有的 ESP 功能按鈕
CreateToggleBtn("BOXES ESP", "BoxESP")
CreateToggleBtn("SKELETON ESP", "SkeletonESP")
CreateToggleBtn("SHOW NAMES", "NameESP")
CreateToggleBtn("SHOW DISTANCE", "DistanceESP")
CreateToggleBtn("HEALTH BAR", "HealthBarEnabled")
CreateToggleBtn("HEALTH PERCENT TEXT", "ShowHealthText")
CreateToggleBtn("TRACERS ESP", "ShowTracer")

-- 團隊檢查開關
local TeamToggle = Instance.new("TextButton", ScrollContent)
TeamToggle.Size = UDim2.new(1, -4, 0, 32)
TeamToggle.BackgroundColor3 = Themes[CurrentTheme].Button [cite: 26]
TeamToggle.Text = "TEAM CHECK: ON"
TeamToggle.TextColor3 = Color3.fromRGB(100, 255, 150)
TeamToggle.Font = Enum.Font.GothamBold [cite: 26]
TeamToggle.TextSize = 12
TeamToggle.BorderSizePixel = 0
Instance.new("UICorner", TeamToggle).CornerRadius = UDim.new(0, 8)
TeamToggle.MouseButton1Click:Connect(function()
    _G.Config.TeamCheck = not _G.Config.TeamCheck
    TeamToggle.Text = "TEAM CHECK: " .. (_G.Config.TeamCheck and "ON" or "OFF")
    TeamToggle.TextColor3 = _G.Config.TeamCheck and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text
end)
table.insert(buttonReferences, TeamToggle) [cite: 27]

-- ==================== 8. 完全保留並重構：原腳本功能按鈕組 ====================
-- Method 切換按鈕
local MethodBtn = Instance.new("TextButton", ScrollContent)
MethodBtn.Size = UDim2.new(1, -4, 0, 32)
MethodBtn.BackgroundColor3 = Themes.Dark.Button [cite: 24]
MethodBtn.Text = "METHOD: 1 (MAXHEALTH)" [cite: 24]
MethodBtn.TextColor3 = Themes.Dark.Text [cite: 24]
MethodBtn.Font = Enum.Font.GothamBold [cite: 24]
MethodBtn.TextSize = 11 [cite: 24]
MethodBtn.BorderSizePixel = 0 [cite: 24]
Instance.new("UICorner", MethodBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, MethodBtn)

local MethodFrame = Instance.new("Frame", Frame) [cite: 24]
MethodFrame.Size = UDim2.new(0, 224, 0, 75)
MethodFrame.Position = UDim2.new(0, 8, 0, 75)
MethodFrame.BackgroundColor3 = Themes.Dark.Background [cite: 24]
MethodFrame.BorderSizePixel = 0 [cite: 24]
MethodFrame.Visible = false [cite: 24]
MethodFrame.ZIndex = 15 [cite: 24]
Instance.new("UICorner", MethodFrame).CornerRadius = UDim.new(0, 9) [cite: 24]

local MethodFrameStroke = Instance.new("UIStroke", MethodFrame) [cite: 24]
MethodFrameStroke.Thickness = 2 [cite: 24]
MethodFrameStroke.Color = Themes.Dark.Border [cite: 24]
MethodFrameStroke.Transparency = 0.2 [cite: 24]

local Method1Btn = Instance.new("TextButton", MethodFrame) [cite: 24]
Method1Btn.Size = UDim2.new(1, -10, 0, 30) [cite: 25]
Method1Btn.Position = UDim2.new(0, 5, 0, 5) [cite: 25]
Method1Btn.BackgroundColor3 = Themes.Dark.Button [cite: 25]
Method1Btn.Text = "METHOD 1: MAXHEALTH" [cite: 25]
Method1Btn.TextColor3 = Themes.Dark.Text [cite: 25]
Method1Btn.Font = Enum.Font.GothamBold [cite: 25]
Method1Btn.TextSize = 10 [cite: 25]
Method1Btn.ZIndex = 16 [cite: 25]
Instance.new("UICorner", Method1Btn).CornerRadius = UDim.new(0, 7) [cite: 25]

local Method2Btn = Instance.new("TextButton", MethodFrame) [cite: 25]
Method2Btn.Size = UDim2.new(1, -10, 0, 30) [cite: 25]
Method2Btn.Position = UDim2.new(0, 5, 0, 40) [cite: 25]
Method2Btn.BackgroundColor3 = Themes.Dark.Button [cite: 25]
Method2Btn.Text = "METHOD 2: HEALTH CHANGER" [cite: 25]
Method2Btn.TextColor3 = Themes.Dark.Text [cite: 25]
Method2Btn.Font = Enum.Font.GothamBold [cite: 25]
Method2Btn.TextSize = 10 [cite: 25]
Method2Btn.ZIndex = 16 [cite: 25]
Instance.new("UICorner", Method2Btn).CornerRadius = UDim.new(0, 7) [cite: 25]

MethodBtn.MouseButton1Click:Connect(function() [cite: 40]
    MethodFrame.Visible = not MethodFrame.Visible [cite: 40]
end) [cite: 40]

Method1Btn.MouseButton1Click:Connect(function() [cite: 40]
    GodmodeMethod = 1 [cite: 40]
    MethodBtn.Text = "METHOD: 1 (MAXHEALTH)" [cite: 40]
    MethodFrame.Visible = false [cite: 40]
    if GodModeActive then [cite: 40]
        stopGodmode() [cite: 40]
        task.wait(0.1) [cite: 40]
        ApplyGodmodeMethod1() [cite: 40]
    end [cite: 40]
end) [cite: 40]

Method2Btn.MouseButton1Click:Connect(function() [cite: 40]
    GodmodeMethod = 2 [cite: 40]
    MethodBtn.Text = "METHOD: 2 (HEALTH CHANGER)" [cite: 40]
    MethodFrame.Visible = false [cite: 40]
    if GodModeActive then [cite: 40, 41]
        if godmodeMethod1Connection then godmodeMethod1Connection:Disconnect() end [cite: 41]
        task.wait(0.1) [cite: 41]
        startGodmode() [cite: 41]
    end [cite: 41]
end) [cite: 41]

-- GODMODE 按鈕
local GodmodeBtn = Instance.new("TextButton", ScrollContent)
GodmodeBtn.Size = UDim2.new(1, -4, 0, 32)
GodmodeBtn.BackgroundColor3 = Themes[CurrentTheme].Button [cite: 26]
GodmodeBtn.Text = "GODMODE: OFF"
GodmodeBtn.TextColor3 = Themes[CurrentTheme].Text [cite: 26]
GodmodeBtn.Font = Enum.Font.GothamBold [cite: 26]
GodmodeBtn.TextSize = 12
Instance.new("UICorner", GodmodeBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, GodmodeBtn)

GodmodeBtn.MouseButton1Click:Connect(function()
    if godmodeCooldown then return end [cite: 28]
    godmodeCooldown = true [cite: 28]
    GodModeActive = not GodModeActive [cite: 28]
    GodmodeBtn.Text = "GODMODE: " .. (GodModeActive and "ON" or "OFF") [cite: 28]
    GodmodeBtn.TextColor3 = GodModeActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text

    if GodModeActive then [cite: 28]
        if GodmodeMethod == 1 then ApplyGodmodeMethod1() else startGodmode() end [cite: 28, 29]
    else [cite: 29]
        stopGodmode() [cite: 29]
    end [cite: 29]
    task.wait(0.1) [cite: 29]
    godmodeCooldown = false [cite: 29, 30]
end)

-- ANTI-TP 按鈕
local AntiTPBtn = Instance.new("TextButton", ScrollContent)
AntiTPBtn.Size = UDim2.new(1, -4, 0, 32)
AntiTPBtn.BackgroundColor3 = Themes[CurrentTheme].Button [cite: 26]
AntiTPBtn.Text = "ANTI-TP: OFF"
AntiTPBtn.TextColor3 = Themes[CurrentTheme].Text [cite: 26]
AntiTPBtn.Font = Enum.Font.GothamBold [cite: 26]
AntiTPBtn.TextSize = 12
Instance.new("UICorner", AntiTPBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, AntiTPBtn)

AntiTPBtn.MouseButton1Click:Connect(function()
    if antiTPCooldown then return end [cite: 30]
    antiTPCooldown = true [cite: 30]
    AntiTPActive = not AntiTPActive [cite: 30]
    AntiTPBtn.Text = "ANTI-TP: " .. (AntiTPActive and "ON" or "OFF") [cite: 30]
    AntiTPBtn.TextColor3 = AntiTPActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text

    if AntiTPActive then startAntiTP() else stopAntiTP() end [cite: 30, 31]
    task.wait(0.1) [cite: 31]
    antiTPCooldown = false [cite: 31]
end)

-- ANTI-FALL 按鈕
local AntiFallBtn = Instance.new("TextButton", ScrollContent)
AntiFallBtn.Size = UDim2.new(1, -4, 0, 32)
AntiFallBtn.BackgroundColor3 = Themes[CurrentTheme].Button [cite: 26]
AntiFallBtn.Text = "ANTI-FALL (BETA): OFF" [cite: 32]
AntiFallBtn.TextColor3 = Themes[CurrentTheme].Text [cite: 26]
AntiFallBtn.Font = Enum.Font.GothamBold [cite: 26]
AntiFallBtn.TextSize = 12
Instance.new("UICorner", AntiFallBtn).CornerRadius = UDim.new(0, 8)
table.insert(buttonReferences, AntiFallBtn)

AntiFallBtn.MouseButton1Click:Connect(function()
    if antiFallCooldown then return end [cite: 31]
    antiFallCooldown = true [cite: 31]
    AntiFallActive = not AntiFallActive [cite: 31]
    AntiFallBtn.Text = "ANTI-FALL (BETA): " .. (AntiFallActive and "ON" or "OFF") [cite: 32]
    AntiFallBtn.TextColor3 = AntiFallActive and Color3.fromRGB(100, 255, 150) or Themes[CurrentTheme].Text

    if AntiFallActive then startAntiFall() else stopAntiFall() end [cite: 32]
    task.wait(0.1) [cite: 32]
    antiFallCooldown = false [cite: 32]
end)

-- 底部製作者標籤
local Credit = Instance.new("TextLabel", ScrollContent)
Credit.Size = UDim2.new(1, 0, 0, 25)
Credit.Text = "by: romokaso & ESP Engine" [cite: 33]
Credit.TextColor3 = Color3.fromRGB(120, 120, 120) [cite: 33]
Credit.BackgroundTransparency = 1 [cite: 33]
Credit.Font = Enum.Font.GothamBold [cite: 33]
Credit.TextSize = 10 [cite: 33]

-- ==================== 9. 主題設定與確認關閉面板 ====================
local SettingsFrame = Instance.new("Frame", Frame) [cite: 33]
SettingsFrame.Size = UDim2.new(1, 0, 1, 0) [cite: 33]
SettingsFrame.BackgroundColor3 = Themes.Dark.Background [cite: 33]
SettingsFrame.BorderSizePixel = 0 [cite: 33]
SettingsFrame.Visible = false [cite: 33]
SettingsFrame.ZIndex = 20 [cite: 33]
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 12) [cite: 33]

local SettingsTitle = Instance.new("TextLabel", SettingsFrame) [cite: 33]
SettingsTitle.Size = UDim2.new(1, 0, 0, 40) [cite: 33]
SettingsTitle.Position = UDim2.new(0, 0, 0, 10) [cite: 33]
SettingsTitle.Text = "SETTINGS" [cite: 33]
SettingsTitle.TextColor3 = Themes.Dark.Text [cite: 33]
SettingsTitle.BackgroundTransparency = 1 [cite: 33]
SettingsTitle.Font = Enum.Font.GothamBold [cite: 33]
SettingsTitle.TextSize = 16 [cite: 33]
SettingsTitle.ZIndex = 21 [cite: 33]

local DarkThemeBtn = Instance.new("TextButton", SettingsFrame) [cite: 33, 34]
DarkThemeBtn.Size = UDim2.new(0.43, 0, 0, 35) [cite: 34]
DarkThemeBtn.Position = UDim2.new(0.05, 0, 0, 80)
DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100) [cite: 34]
DarkThemeBtn.Text = "DARK" [cite: 34]
DarkThemeBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 34]
DarkThemeBtn.Font = Enum.Font.GothamBold [cite: 34]
DarkThemeBtn.TextSize = 13 [cite: 34]
DarkThemeBtn.ZIndex = 21 [cite: 34]
Instance.new("UICorner", DarkThemeBtn).CornerRadius = UDim.new(0, 8)

local LightThemeBtn = Instance.new("TextButton", SettingsFrame) [cite: 34]
LightThemeBtn.Size = UDim2.new(0.43, 0, 0, 35) [cite: 34]
LightThemeBtn.Position = UDim2.new(0.52, 0, 0, 80)
LightThemeBtn.BackgroundColor3 = Themes.Dark.Button [cite: 34]
LightThemeBtn.Text = "LIGHT" [cite: 34]
LightThemeBtn.TextColor3 = Themes.Dark.Text [cite: 34]
LightThemeBtn.Font = Enum.Font.GothamBold [cite: 34]
LightThemeBtn.TextSize = 13 [cite: 34]
LightThemeBtn.ZIndex = 21 [cite: 34]
Instance.new("UICorner", LightThemeBtn).CornerRadius = UDim.new(0, 8)

local BackBtn = Instance.new("TextButton", SettingsFrame) [cite: 34]
BackBtn.Size = UDim2.new(0.9, 0, 0, 35) [cite: 34]
BackBtn.Position = UDim2.new(0.05, 0, 1, -50) [cite: 34]
BackBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80) [cite: 34]
BackBtn.Text = "BACK" [cite: 34]
BackBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 34]
BackBtn.Font = Enum.Font.GothamBold [cite: 34]
BackBtn.TextSize = 14 [cite: 34, 35]
BackBtn.ZIndex = 21 [cite: 34]
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 8)

local ConfirmFrame = Instance.new("Frame", Frame) [cite: 38]
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame) [cite: 38, 39]
local ConfirmText = Instance.new("TextLabel", ConfirmFrame) [cite: 38, 39]

local function ApplyTheme(theme) [cite: 35]
    local colors = Themes[theme] [cite: 35]
    CurrentTheme = theme [cite: 35]
    Frame.BackgroundColor3 = colors.Background [cite: 35]
    TitleBar.BackgroundColor3 = colors.TitleBar [cite: 35]
    TitleFix.BackgroundColor3 = colors.TitleBar [cite: 35]
    Title.TextColor3 = colors.Text [cite: 35]
    FrameStroke.Color = colors.Border [cite: 35]
    SettingsBtn.BackgroundColor3 = colors.TopButtons [cite: 35]
    SettingsBtn.TextColor3 = colors.Text [cite: 35]
    MinimizeBtn.BackgroundColor3 = colors.TopButtons [cite: 35]
    MinimizeBtn.TextColor3 = colors.Text [cite: 35]
    CloseBtn.BackgroundColor3= colors.TopButtons [cite: 35]
    CloseBtn.TextColor3 = colors.Text [cite: 35]
    MethodBtn.BackgroundColor3 = colors.Button [cite: 35]
    MethodBtn.TextColor3 = colors.Text [cite: 36]
    MethodFrame.BackgroundColor3 = colors.Background [cite: 36]
    MethodFrameStroke.Color = colors.Border [cite: 36]
    Method1Btn.BackgroundColor3 = colors.Button [cite: 36]
    Method1Btn.TextColor3 = colors.Text [cite: 36]
    Method2Btn.BackgroundColor3 = colors.Button [cite: 36]
    Method2Btn.TextColor3 = colors.Text [cite: 36]

    for _, btn in pairs(buttonReferences) do [cite: 36]
        if not string.find(btn.Text, "ON") then
            btn.BackgroundColor3 = colors.Button [cite: 36]
            btn.TextColor3 = colors.Text [cite: 36]
        end
    end

    SettingsFrame.BackgroundColor3 = colors.Background [cite: 36]
    SettingsTitle.TextColor3 = colors.Text [cite: 36]
    ConfirmFrame.BackgroundColor3 = colors.Background [cite: 36]
    ConfirmStroke.Color = colors.Border [cite: 37]
    ConfirmText.TextColor3 = colors.Text [cite: 37]

    if theme == "Dark" then [cite: 37]
        DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100) [cite: 37]
        DarkThemeBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 37]
        LightThemeBtn.BackgroundColor3 = colors.Button [cite: 37]
        LightThemeBtn.TextColor3 = colors.Text [cite: 37]
    else [cite: 37]
        LightThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100) [cite: 37]
        LightThemeBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 37]
        DarkThemeBtn.BackgroundColor3 = colors.Button [cite: 37]
        DarkThemeBtn.TextColor3 = colors.Text [cite: 38]
    end
end [cite: 38]

ConfirmFrame.Size = UDim2.new(1, 0, 1, 0) [cite: 38]
ConfirmFrame.BackgroundColor3 = Themes.Dark.Background [cite: 38]
ConfirmFrame.Visible = false [cite: 38]
ConfirmFrame.ZIndex = 25 [cite: 38]
ConfirmFrame.BackgroundTransparency = 0.05 [cite: 38]
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 12) [cite: 38]
ConfirmStroke.Thickness = 3 [cite: 38]
ConfirmStroke.Color = Themes.Dark.Border [cite: 38]
ConfirmText.Size = UDim2.new(1, -20, 0, 60) [cite: 38, 39]
ConfirmText.Position = UDim2.new(0, 10, 0, 70) [cite: 39]
ConfirmText.Text = "Are you sure you want\nto close the HUB?" [cite: 39]
ConfirmText.TextColor3 = Themes.Dark.Text [cite: 39]
ConfirmText.BackgroundTransparency = 1 [cite: 39]
ConfirmText.Font = Enum.Font.GothamBold [cite: 39]
ConfirmText.TextSize = 14 [cite: 39]
ConfirmText.ZIndex = 26 [cite: 39]

local YesBtn = Instance.new("TextButton", ConfirmFrame) [cite: 39]
YesBtn.Size = UDim2.new(0, 95, 0, 35) [cite: 39]
YesBtn.Position = UDim2.new(0, 15, 1, -50) [cite: 39]
YesBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100) [cite: 39]
YesBtn.Text = "YES" [cite: 39]
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 39]
YesBtn.Font = Enum.Font.GothamBold [cite: 39]
YesBtn.TextSize = 14 [cite: 39]
YesBtn.ZIndex = 26 [cite: 39]
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 9) [cite: 39]

local NoBtn = Instance.new("TextButton", ConfirmFrame) [cite: 39]
NoBtn.Size = UDim2.new(0, 95, 0, 35) [cite: 39]
NoBtn.Position = UDim2.new(1, -110, 1, -50) [cite: 39]
NoBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80) [cite: 39]
NoBtn.Text = "NO" [cite: 39]
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 39]
NoBtn.Font = Enum.Font.GothamBold [cite: 39]
NoBtn.TextSize = 14 [cite: 39]
NoBtn.ZIndex = 26 [cite: 39]
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 9) [cite: 39]

local isMinimized, isClosing, minimizeCooldown, closeCooldown, confirmDialogOpen, settingsOpen = false, false, false, false, false, false [cite: 39, 40]

DarkThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Dark") end) [cite: 41]
LightThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Light") end) [cite: 41]
BackBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = false; settingsOpen = false end) [cite: 41]

SettingsBtn.MouseButton1Click:Connect(function() [cite: 41]
    if confirmDialogOpen then return end [cite: 41]
    if isMinimized then [cite: 41]
        isMinimized = false [cite: 42]
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play() [cite: 42]
        MinimizeBtn.Text = "−" [cite: 42]
        task.wait(0.1) [cite: 42]
    end [cite: 42]
    SettingsFrame.Visible = not SettingsFrame.Visible [cite: 42]
    settingsOpen = SettingsFrame.Visible [cite: 42]
end) [cite: 42]

MinimizeBtn.MouseButton1Click:Connect(function() [cite: 42]
    if minimizeCooldown or confirmDialogOpen then return end [cite: 42, 43]
    minimizeCooldown = true [cite: 43]
    if settingsOpen then SettingsFrame.Visible = false; settingsOpen = false end [cite: 43]
    isMinimized = not isMinimized [cite: 43]
    
    if isMinimized then [cite: 43]
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 35)}):Play() [cite: 43]
        MinimizeBtn.Text = "+" [cite: 43]
    else [cite: 43, 44]
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play() [cite: 44]
        MinimizeBtn.Text = "−" [cite: 44]
    end [cite: 44]
    task.wait(0.1) [cite: 44]
    minimizeCooldown = false [cite: 44]
end) [cite: 44]

CloseBtn.MouseButton1Click:Connect(function() [cite: 44]
    if closeCooldown or isClosing or confirmDialogOpen then return end [cite: 44]
    closeCooldown = true [cite: 44]
    confirmDialogOpen = true [cite: 44]
    if settingsOpen then SettingsFrame.Visible = false; settingsOpen = false end [cite: 44, 45]
    
    if isMinimized then [cite: 45]
        isMinimized = false [cite: 45]
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250)}):Play() [cite: 45]
        MinimizeBtn.Text = "−" [cite: 45]
        task.wait(0.1) [cite: 45]
    end [cite: 46]
    
    local confirmColors = Themes[CurrentTheme] [cite: 46]
    ConfirmFrame.BackgroundColor3 = confirmColors.Background [cite: 46]
    ConfirmStroke.Color = confirmColors.Border [cite: 46]
    ConfirmText.TextColor3 = confirmColors.Text [cite: 46]
    ConfirmFrame.Visible = true [cite: 46]
    ConfirmFrame.BackgroundTransparency = 1 [cite: 46]
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play() [cite: 46]
    task.wait(0.1) [cite: 46]
    closeCooldown = false [cite: 46]
end) [cite: 46]

local noCooldown = false [cite: 46]
NoBtn.MouseButton1Click:Connect(function() [cite: 46]
    if noCooldown then return end [cite: 46]
    noCooldown = true [cite: 46, 47]
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play() [cite: 47]
    task.wait(0.1) [cite: 47]
    ConfirmFrame.Visible = false [cite: 47]
    confirmDialogOpen = false [cite: 47]
    task.wait(0.1) [cite: 47]
    noCooldown = false [cite: 47]
end) [cite: 47]

local yesCooldown = false [cite: 47]
YesBtn.MouseButton1Click:Connect(function() [cite: 47]
    if yesCooldown or isClosing then return end [cite: 47]
    yesCooldown = true [cite: 47]
    isClosing = true [cite: 47]
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play() [cite: 47, 48]
    task.wait(0.1) [cite: 48]
    TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play() [cite: 48]
    task.wait(0.1) [cite: 48]
    espGui:Destroy() -- 清理 ESP 的 GUI 資源
    MainGui:Destroy() [cite: 48]
end) [cite: 48]

-- ==================== 10. 初始化開場與角色重生綁定 ====================
Frame.Size = UDim2.new(0, 0, 0, 0) [cite: 48]
Frame.Position = UDim2.new(0.5, 0, 0.5, 0) [cite: 48]
TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 250), Position = UDim2.new(0.5, -120, 0.5, -125)}):Play() [cite: 48, 49]

player.CharacterAdded:Connect(function() [cite: 49]
    task.wait(0.3)
    if GodModeActive then [cite: 49]
        if GodmodeMethod == 1 then ApplyGodmodeMethod1() else startGodmode() end [cite: 49]
    end [cite: 49]
    if AntiTPActive then startAntiTP() end [cite: 49]
    if AntiFallActive then startAntiFall() end [cite: 49, 50]
end) [cite: 50]
