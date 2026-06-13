-- ==================== MOBILE GEN 12: RAYFIELD WIREFRAME AUTO-LOCK ====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 全域組態設定（手機硬體優化預設值）
_G.Config = {
    BoxESP = false,
    NameESP = false,
    TeamCheck = true,
    
    Aimbot = false,
    FOVCircle = true,
    FOVSize = 135,
    Sensitivity = 0.22,  -- 手機最穩防震自瞄平滑度 (0.1 ~ 0.3 最舒適)
    AimPart = "Head",
    SilentAim = false,
    HitboxSize = 12,
    
    InfiniteJump = false,
    SpeedHack = false,
    WalkSpeed = 100,
    InfAmmo = false,
    FireRateMod = false,
    RecoilMod = false
}

local RenderRegistry = {}

-- ==================== SCREEN HARDWARE MATRICES (⚠️ 強制空心圓框) ====================
local HardwareCenterCircle = Drawing.new("Circle")
HardwareCenterCircle.Visible = _G.Config.FOVCircle
HardwareCenterCircle.Radius = _G.Config.FOVSize
HardwareCenterCircle.Color = Color3.fromRGB(0, 240, 255) -- 動態冰藍色
HardwareCenterCircle.Thickness = 2                         -- 外框粗細

-- 【核心修復】防止手機端執行器渲染成實心藍色
HardwareCenterCircle.Filled = false                        
HardwareCenterCircle.Transparency = 1                      

local function ComputeAbsoluteCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- ==================== PERFORMANCE LIFE-CYCLE MANAGEMENT ====================
local function DestroyEntityAssets(plr)
    if RenderRegistry[plr] then
        pcall(function() RenderRegistry[plr].Box:Remove() end)
        pcall(function() RenderRegistry[plr].Label:Remove() end)
        RenderRegistry[plr] = nil
    end
end

local function BuildEntityAssets(plr)
    if plr == LocalPlayer then return end
    DestroyEntityAssets(plr)

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Thickness = 1.5
    Box.Filled = false

    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Size = 13
    Text.Center = true
    Text.Outline = true

    RenderRegistry[plr] = { Box = Box, Label = Text }
end

local function SyncPlayerSession(plr)
    if plr == LocalPlayer then return end
    BuildEntityAssets(plr)
    
    plr.CharacterAdded:Connect(function()
        task.wait(0.3)
        BuildEntityAssets(plr)
    end)
    plr.CharacterRemoving:Connect(function()
        DestroyEntityAssets(plr)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do SyncPlayerSession(player) end
Players.PlayerAdded:Connect(SyncPlayerSession)
Players.PlayerRemoving:Connect(DestroyEntityAssets)

-- ==================== SCREEN SPACE SEARCH ENGINE (MOBILE PURE VECTOR) ====================
local function EvaluateScreenSpaceTargets()
    local displayPivot = ComputeAbsoluteCenter()
    local focalChampion = nil
    local boundaryDelta = _G.Config.FOVSize

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer and targetPlayer.Character then
            local rootChar = targetPlayer.Character
            local structuralRoot = rootChar:FindFirstChild("HumanoidRootPart")
            local mechanicalHum = rootChar:FindFirstChildOfClass("Humanoid")
            local objectiveBone = rootChar:FindFirstChild(_G.Config.AimPart)
            
            if structuralRoot and mechanicalHum and mechanicalHum.Health > 0 and objectiveBone then
                if not _G.Config.TeamCheck or (targetPlayer.Team ~= LocalPlayer.Team) then
                    
                    -- 改用 WorldToScreenPoint 完美避開手機 UI 像素干擾
                    local calculatedVector, isRenderedOnDisplay = Camera:WorldToScreenPoint(objectiveBone.Position)
                    
                    if isRenderedOnDisplay then
                        -- 計算「玩家」到「螢幕絕對中心點」的純二維距離
                        local linearMagnitude = (displayPivot - Vector2.new(calculatedVector.X, calculatedVector.Y)).Magnitude
                        
                        if linearMagnitude < boundaryDelta then
                            boundaryDelta = linearMagnitude
                            focalChampion = rootChar
                        end
                    end
                end
            end
        end
    end
    return focalChampion
end

-- ==================== RENDERING & PURE AUTO LOCK COMPOSITOR ====================
RunService.RenderStepped:Connect(function()
    -- 每幀在螢幕中心重畫空心圓框，防止部分手機執行器將其自動重置為實心
    local structuralCenter = ComputeAbsoluteCenter()
    HardwareCenterCircle.Position = structuralCenter
    HardwareCenterCircle.Radius = _G.Config.FOVSize
    HardwareCenterCircle.Visible = _G.Config.FOVCircle
    HardwareCenterCircle.Filled = false 
    HardwareCenterCircle.Transparency = 1

    -- ESP 二維轉換渲染
    for playerKey, assetGroup in pairs(RenderRegistry) do
        if not playerKey or not Players:FindFirstChild(playerKey.Name) then
            DestroyEntityAssets(playerKey)
            continue
        end

        local avatar = playerKey.Character
        local rootNode = avatar and avatar:FindFirstChild("HumanoidRootPart")
        local healthNode = avatar and avatar:FindFirstChildOfClass("Humanoid")

        local operational = rootNode and (healthNode == nil or healthNode.Health > 0)
        local isAlliedUnit = (playerKey.Team and LocalPlayer.Team and playerKey.Team == LocalPlayer.Team)
        local clearancePassed = operational and (not _G.Config.TeamCheck or not isAlliedUnit)

        if clearancePassed then
            local translation2D, onscreenFrame = Camera:WorldToScreenPoint(rootNode.Position)

            if onscreenFrame then
                local headTrace = Camera:WorldToScreenPoint(rootNode.Position + Vector3.new(0, 2.4, 0))
                local footTrace = Camera:WorldToScreenPoint(rootNode.Position - Vector3.new(0, 3.1, 0))
                
                local dynamicallyComputedHeight = math.abs(footTrace.Y - headTrace.Y)
                local dynamicallyComputedWidth = dynamicallyComputedHeight / 1.6
                local dynamicHexColor = playerKey.TeamColor.Color

                if _G.Config.BoxESP then
                    assetGroup.Box.Size = Vector2.new(dynamicallyComputedWidth, dynamicallyComputedHeight)
                    assetGroup.Box.Position = Vector2.new(translation2D.X - (dynamicallyComputedWidth / 2), headTrace.Y)
                    assetGroup.Box.Color = dynamicHexColor
                    assetGroup.Box.Visible = true
                else
                    assetGroup.Box.Visible = false
                end

                if _G.Config.NameESP then
                    local physicalRange = math.floor((Camera.CFrame.Position - rootNode.Position).Magnitude)
                    assetGroup.Label.Position = Vector2.new(translation2D.X, headTrace.Y - 16)
                    assetGroup.Label.Color = dynamicHexColor
                    assetGroup.Label.Text = playerKey.Name .. " [" .. physicalRange .. "m]"
                    assetGroup.Label.Visible = true
                else
                    assetGroup.Label.Visible = false
                end
            else
                assetGroup.Box.Visible = false
                assetGroup.Label.Visible = false
            end
        else
            assetGroup.Box.Visible = false
            assetGroup.Label.Visible = false
        end
    end

    -- ==================== 全自動死區追蹤自瞄核心 ====================
    if _G.Config.Aimbot then
        local validTargetInstance = EvaluateScreenSpaceTargets()
        
        if validTargetInstance then
            -- 視覺反饋：敵人進到空心圈圈裡時，圓框瞬間變成暖橘色
            HardwareCenterCircle.Color = Color3.fromRGB(255, 120, 0)
            
            local explicitMeshPart = validTargetInstance:FindFirstChild(_G.Config.AimPart)
            if explicitMeshPart then
                -- 引入平滑阻尼，防止手機觸控時畫面因微小指尖顫抖而劇烈晃動
                local targetingMatrix = CFrame.new(Camera.CFrame.Position, explicitMeshPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetingMatrix, _G.Config.Sensitivity)
            end
        else
            -- 圈圈內沒人時，恢復原本的冰藍色
            HardwareCenterCircle.Color = Color3.fromRGB(0, 240, 255)
        end
    else
        HardwareCenterCircle.Color = Color3.fromRGB(0, 240, 255)
    end
end)

-- ==================== PHYSICS COROUTINES & SYSTEM FORKS ====================
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.Config.InfiniteJump then
        local localHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if localHumanoid then localHumanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if _G.Config.SilentAim then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if _G.Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end
                    local r = plr.Character:FindFirstChild("HumanoidRootPart")
                    local h = plr.Character:FindFirstChild("Head")
                    if r then r.Size = Vector3.new(_G.Config.HitboxSize, _G.Config.HitboxSize, _G.Config.HitboxSize) r.CanCollide = false end
                    if h then h.Size = Vector3.new(_G.Config.HitboxSize, _G.Config.HitboxSize, _G.Config.HitboxSize) h.CanCollide = false end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        local cacheStorage = game:GetService("ReplicatedStorage")
        local weaponRegister = cacheStorage:FindFirstChild("Weapons")
        
        if weaponRegister then
            for _, assetNode in ipairs(weaponRegister:GetDescendants()) do
                if assetNode:IsA("ValueBase") then
                    if _G.Config.FireRateMod then
                        if assetNode.Name == "Auto" then assetNode.Value = true
                        elseif assetNode.Name == "FireRate" then assetNode.Value = 0.02 end
                    end
                    if _G.Config.RecoilMod and (assetNode.Name == "RecoilControl" or assetNode.Name == "MaxSpread") then
                        assetNode.Value = 0
                    end
                end
            end
        end
        
        if _G.Config.InfAmmo then
            local ui = LocalPlayer:FindFirstChild("PlayerGui")
            local stats = ui and ui:FindFirstChild("GUI") and ui.GUI:FindFirstChild("Client") and ui.GUI.Client:FindFirstChild("Variables")
            if stats then
                local am1, am2 = stats:FindFirstChild("ammocount"), stats:FindFirstChild("ammocount2")
                if am1 then am1.Value = 999 end
                if am2 then am2.Value = 999 end
            end
        end
    end
end)

local linearSpeedConnection = nil
local function SyncHardwareWalkSpeed(state)
    if linearSpeedConnection then linearSpeedConnection:Disconnect() end
    local biologicalHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if biologicalHumanoid then
        if state then
            biologicalHumanoid.WalkSpeed = _G.Config.WalkSpeed
            linearSpeedConnection = biologicalHumanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if _G.Config.SpeedHack and biologicalHumanoid and biologicalHumanoid.Parent then
                    biologicalHumanoid.WalkSpeed = _G.Config.WalkSpeed
                end
            end)
        else
            biologicalHumanoid.WalkSpeed = 16
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    if _G.Config.SpeedHack then SyncHardwareWalkSpeed(true) end
end)

-- ==================== RAYFIELD CONTROLLER PANEL INTERFACE ====================
local Window = Rayfield:CreateWindow({
    Name = "Quotas Mobile G12 (Rayfield Fix)",
    LoadingTitle = "Assembling Screen Center Auto-Locks...",
    LoadingSubtitle = "by Quotas",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local WeaponsTab = Window:CreateTab("Weapons", nil)

-- Combat UI Config
CombatTab:CreateToggle({ Name = "Enable Box ESP", CurrentValue = _G.Config.BoxESP, Callback = function(s) _G.Config.BoxESP = s end })
CombatTab:CreateToggle({ Name = "Enable Name & Dist ESP", CurrentValue = _G.Config.NameESP, Callback = function(s) _G.Config.NameESP = s end })
CombatTab:CreateToggle({ Name = "Ignore Friendly Team", CurrentValue = _G.Config.TeamCheck, Callback = function(s) _G.Config.TeamCheck = s end })

CombatTab:CreateSection("— Mobile Aimbot Engine —")
CombatTab:CreateToggle({ Name = "Active Aim Assistance (Aimbot)", CurrentValue = _G.Config.Aimbot, Callback = function(s) _G.Config.Aimbot = s end })
CombatTab:CreateToggle({ Name = "Render Central FOV Wireframe", CurrentValue = _G.Config.FOVCircle, Callback = function(s) _G.Config.FOVCircle = s end })

CombatTab:CreateSlider({ Name = "Center FOV Radius", Range = {40, 500}, Increment = 5, CurrentValue = _G.Config.FOVSize, Callback = function(v) 
    _G.Config.FOVSize = type(v) == "table" and v[1] or v 
end })

CombatTab:CreateSlider({ Name = "Smoothing Speed (Low = Anti-Shake)", Range = {1, 10}, Increment = 1, CurrentValue = 3, Callback = function(v) 
    local raw = type(v) == "table" and v[1] or v
    -- 分率阻尼換算，數字越低鎖得越滑順，可有效防震顫
    _G.Config.Sensitivity = raw * 0.075
end })

CombatTab:CreateDropdown({ Name = "Target tracking Mesh Node", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {_G.Config.AimPart}, Callback = function(v) 
    _G.Config.AimPart = type(v) == "table" and v[1] or v 
end })

CombatTab:CreateToggle({ Name = "Volumetric Hitboxes", CurrentValue = _G.Config.SilentAim, Callback = function(s) _G.Config.SilentAim = s end })

-- Movement UI Config
MovementTab:CreateToggle({ Name = "De-activate Gravitational Bounds", CurrentValue = _G.Config.InfiniteJump, Callback = function(s) _G.Config.InfiniteJump = s end })
MovementTab:CreateToggle({ Name = "Enable Target Velocity", CurrentValue = _G.Config.SpeedHack, Callback = function(s) _G.Config.SpeedHack = s SyncHardwareWalkSpeed(s) end })
MovementTab:CreateSlider({ Name = "Velocity Absolute Value", Range = {16, 200}, Increment = 2, CurrentValue = _G.Config.WalkSpeed, Callback = function(v) 
    _G.Config.WalkSpeed = type(v) == "table" and v[1] or v
    if _G.Config.SpeedHack then SyncHardwareWalkSpeed(true) end 
end })

-- Weapon UI Config
WeaponsTab:CreateToggle({ Name = "Prevent Munition Depletion", CurrentValue = _G.Config.InfAmmo, Callback = function(s) _G.Config.InfAmmo = s end })
WeaponsTab:CreateToggle({ Name = "Overclock Fire Engine Cycles", CurrentValue = _G.Config.FireRateMod, Callback = function(s) _G.Config.FireRateMod = s end })
WeaponsTab:CreateToggle({ Name = "Suppress Kinetic Dispersion", CurrentValue = _G.Config.RecoilMod, Callback = function(s) _G.Config.RecoilMod = s end })

Rayfield:Notify({ Title = "Mobile Fix Ready", Content = "Wireframe Center-FOV pipeline activated.", Duration = 4 })
