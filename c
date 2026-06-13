-- ==================== ULTIMATE EVENT-DRIVEN ARCHITECTURE ====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Master Memory State
_G.Config = {
    BoxESP = false,
    NameESP = false,
    TeamCheck = true,
    
    Aimbot = false,
    FOVCircle = true,
    FOVSize = 90,
    Sensitivity = 0.15, -- Refactored raw speed
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

local IsTrackingPressed = false
local RenderCache = {}

-- ==================== CENTRAL RETICLE DEFINITION ====================
local FieldOfViewRing = Drawing.new("Circle")
FieldOfViewRing.Visible = _G.Config.FOVCircle
FieldOfViewRing.Radius = _G.Config.FOVSize
FieldOfViewRing.Color = Color3.fromRGB(0, 255, 150) -- Premium green reticle
FieldOfViewRing.Thickness = 1.5
FieldOfViewRing.NumSides = 64

local function GetViewportCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- ==================== PERFORMANCE ESP ALLOCATOR ====================
local function WipePlayerGraphics(plr)
    if RenderCache[plr] then
        pcall(function() RenderCache[plr].Box:Remove() end)
        pcall(function() RenderCache[plr].Label:Remove() end)
        RenderCache[plr] = nil
    end
end

local function AllocatePlayerGraphics(plr)
    if plr == LocalPlayer then return end
    WipePlayerGraphics(plr)

    local BoxStructure = Drawing.new("Square")
    BoxStructure.Visible = false
    BoxStructure.Thickness = 1.5
    BoxStructure.Filled = false

    local LabelStructure = Drawing.new("Text")
    LabelStructure.Visible = false
    LabelStructure.Size = 13
    LabelStructure.Center = true
    LabelStructure.Outline = true

    RenderCache[plr] = { Box = BoxStructure, Label = LabelStructure }
end

-- Pure Event-Based Connection (Zero Dynamic Thread Leaks)
local function BindPlayerInstance(plr)
    if plr == LocalPlayer then return end
    AllocatePlayerGraphics(plr)
    
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        AllocatePlayerGraphics(plr)
    end)
    
    plr.CharacterRemoving:Connect(function()
        WipePlayerGraphics(plr)
    end)
end

-- Stream-line existing/incoming roster
for _, player in ipairs(Players:GetPlayers()) do BindPlayerInstance(player) end
Players.PlayerAdded:Connect(BindPlayerInstance)
Players.PlayerRemoving:Connect(WipePlayerGraphics)

-- ==================== MATHEMATICAL POLAR AIM SYSTEM ====================
local function EvaluateMathematicalTarget()
    local focalCenter = GetViewportCenter()
    local bestMatch = nil
    local minimumDelta = _G.Config.FOVSize

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            if _G.Config.TeamCheck and targetPlayer.Team == LocalPlayer.Team then continue end

            local characterInstance = targetPlayer.Character
            local rootNode = characterInstance and characterInstance:FindFirstChild("HumanoidRootPart")
            local healthNode = characterInstance and characterInstance:FindFirstChildOfClass("Humanoid")
            
            if rootNode and healthNode and healthNode.Health > 0 then
                local vectorPoint, isVisibleOnScreen = Camera:WorldToScreenPoint(rootNode.Position)
                
                if isVisibleOnScreen then
                    local polarMagnitude = (Vector2.new(vectorPoint.X, vectorPoint.Y) - focalCenter).Magnitude
                    if polarMagnitude < minimumDelta then
                        minimumDelta = polarMagnitude
                        bestMatch = targetPlayer
                    end
                end
            end
        end
    end
    return bestMatch
end

-- ==================== HIGH-SPEED RENDER STEP PROCESSING ====================
RunService.RenderStepped:Connect(function()
    -- Lock Ring Geometry to Exact Viewport Configuration
    local exactCenter = GetViewportCenter()
    FieldOfViewRing.Position = exactCenter
    FieldOfViewRing.Radius = _G.Config.FOVSize
    FieldOfViewRing.Visible = _G.Config.FOVCircle

    -- Compute Graphics Transformations
    for playerInstance, asset in pairs(RenderCache) do
        if not playerInstance or not Players:FindFirstChild(playerInstance.Name) then
            WipePlayerGraphics(playerInstance)
            continue
        end

        local char = playerInstance.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local entityValid = hrp and (hum == nil or hum.Health > 0)
        local isTeammate = (playerInstance.Team and LocalPlayer.Team and playerInstance.Team == LocalPlayer.Team)
        local accessAuthorized = entityValid and (not _G.Config.TeamCheck or not isTeammate)

        if accessAuthorized then
            local midProjection, insideViewFrame = Camera:WorldToViewportPoint(hrp.Position)

            if insideViewFrame then
                -- Precise matrix box delta mapping
                local upperScaleBound = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.35, 0))
                local lowerScaleBound = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.05, 0))
                
                local computedHeight = math.abs(lowerScaleBound.Y - upperScaleBound.Y)
                local computedWidth = computedHeight / 1.65
                local activeColor = playerInstance.TeamColor.Color

                -- Isolated Graphic Matrix Updates
                if _G.Config.BoxESP then
                    asset.Box.Size = Vector2.new(computedWidth, computedHeight)
                    asset.Box.Position = Vector2.new(midProjection.X - (computedWidth / 2), upperScaleBound.Y)
                    asset.Box.Color = activeColor
                    asset.Box.Visible = true
                else
                    asset.Box.Visible = false
                end

                if _G.Config.NameESP then
                    local calculatedRange = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    asset.Label.Position = Vector2.new(midProjection.X, upperScaleBound.Y - 16)
                    asset.Label.Color = activeColor
                    asset.Label.Text = playerInstance.Name .. " [" .. calculatedRange .. "m]"
                    asset.Label.Visible = true
                else
                    asset.Label.Visible = false
                end
            else
                asset.Box.Visible = false
                asset.Label.Visible = false
            end
        else
            asset.Box.Visible = false
            asset.Label.Visible = false
        end
    end

    -- Smooth View Matrix Interpolator
    if IsTrackingPressed and _G.Config.Aimbot then
        local trackingTarget = EvaluateMathematicalTarget()
        if trackingTarget and trackingTarget.Character then
            local targetComponent = trackingTarget.Character:FindFirstChild(_G.Config.AimPart)
            if targetComponent then
                local lookupCFrame = CFrame.new(Camera.CFrame.Position, targetComponent.Position)
                Camera.CFrame = Camera.CFrame:Lerp(lookupCFrame, _G.Config.Sensitivity)
            end
        end
    end
end)

-- ==================== PERIPHERAL CAPTURE HOOKS ====================
UserInputService.InputBegan:Connect(function(input, interactionCaptured)
    if interactionCaptured then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then IsTrackingPressed = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then IsTrackingPressed = false end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Config.InfiniteJump then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==================== MUTATOR PARALLEL COROUTINES ====================
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
        local sharedSpace = game:GetService("ReplicatedStorage")
        local weaponRacks = sharedSpace:FindFirstChild("Weapons")
        
        if weaponRacks then
            for _, field in ipairs(weaponRacks:GetDescendants()) do
                if field:IsA("ValueBase") then
                    if _G.Config.FireRateMod then
                        if field.Name == "Auto" then field.Value = true
                        elseif field.Name == "FireRate" then field.Value = 0.02 end
                    end
                    if _G.Config.RecoilMod and (field.Name == "RecoilControl" or field.Name == "MaxSpread") then
                        field.Value = 0
                    end
                end
            end
        end
        
        if _G.Config.InfAmmo then
            local ui = LocalPlayer:FindFirstChild("PlayerGui")
            local values = ui and ui:FindFirstChild("GUI") and ui.GUI:FindFirstChild("Client") and ui.GUI.Client:FindFirstChild("Variables")
            if values then
                local p, s = values:FindFirstChild("ammocount"), values:FindFirstChild("ammocount2")
                if p then p.Value = 999 end
                if s then s.Value = 999 end
            end
        end
    end
end)

local velocityConnection = nil
local function OverwritePhysicVelocity(enabled)
    if velocityConnection then velocityConnection:Disconnect() end
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if enabled then
            humanoid.WalkSpeed = _G.Config.WalkSpeed
            velocityConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if _G.Config.SpeedHack and humanoid and humanoid.Parent then
                    humanoid.WalkSpeed = _G.Config.WalkSpeed
                end
            end)
        else
            humanoid.WalkSpeed = 16
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    if _G.Config.SpeedHack then OverwritePhysicVelocity(true) end
end)

-- ==================== CONTROLLER PANEL ENGINE ====================
local Window = Rayfield:CreateWindow({
    Name = "Quotas Generation 7",
    LoadingTitle = "Building Clean Matrix Interface...",
    LoadingSubtitle = "by Quotas",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local WeaponsTab = Window:CreateTab("Weapons", nil)

-- Combat Array Matrix Setup
CombatTab:CreateToggle({ Name = "Enable Box ESP", CurrentValue = _G.Config.BoxESP, Callback = function(s) _G.Config.BoxESP = s end })
CombatTab:CreateToggle({ Name = "Enable Name & Dist ESP", CurrentValue = _G.Config.NameESP, Callback = function(s) _G.Config.NameESP = s end })
CombatTab:CreateToggle({ Name = "Ignore Friendly Roster", CurrentValue = _G.Config.TeamCheck, Callback = function(s) _G.Config.TeamCheck = s end })

CombatTab:CreateToggle({ Name = "Active Aim Assistance", CurrentValue = _G.Config.Aimbot, Callback = function(s) _G.Config.Aimbot = s end })
CombatTab:CreateToggle({ Name = "Render Central Reticle", CurrentValue = _G.Config.FOVCircle, Callback = function(s) _G.Config.FOVCircle = s end })

CombatTab:CreateSlider({ Name = "Reticle Dimension Limit", Range = {30, 400}, Increment = 5, CurrentValue = _G.Config.FOVSize, Callback = function(v) 
    _G.Config.FOVSize = type(v) == "table" and v[1] or v 
end })

CombatTab:CreateSlider({ Name = "Interpolation Drag Speed (1-10)", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(v) 
    local raw = type(v) == "table" and v[1] or v
    _G.Config.Sensitivity = raw * 0.038 -- Scaled response calculation
end })

CombatTab:CreateDropdown({ Name = "Target tracking Mesh Node", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {_G.Config.AimPart}, Callback = function(v) 
    _G.Config.AimPart = type(v) == "table" and v[1] or v 
end })

CombatTab:CreateToggle({ Name = "Volumetric Hitboxes", CurrentValue = _G.Config.SilentAim, Callback = function(s) _G.Config.SilentAim = s end })

-- Physics Configuration Interface
MovementTab:CreateToggle({ Name = "De-activate Gravitational Bounds", CurrentValue = _G.Config.InfiniteJump, Callback = function(s) _G.Config.InfiniteJump = s end })
MovementTab:CreateToggle({ Name = "Enable Target Velocity", CurrentValue = _G.Config.SpeedHack, Callback = function(s) _G.Config.SpeedHack = s OverwritePhysicVelocity(s) end })
MovementTab:CreateSlider({ Name = "Velocity Absolute Value", Range = {16, 200}, Increment = 2, CurrentValue = _G.Config.WalkSpeed, Callback = function(v) 
    _G.Config.WalkSpeed = type(v) == "table" and v[1] or v
    if _G.Config.SpeedHack then OverwritePhysicVelocity(true) end 
end })

-- Modification Elements Interface
WeaponsTab:CreateToggle({ Name = "Prevent Munition Depletion", CurrentValue = _G.Config.InfAmmo, Callback = function(s) _G.Config.InfAmmo = s end })
WeaponsTab:CreateToggle({ Name = "Overclock Fire Engine Cycles", CurrentValue = _G.Config.FireRateMod, Callback = function(s) _G.Config.FireRateMod = s end })
WeaponsTab:CreateToggle({ Name = "Suppress Kinetic Dispersion", CurrentValue = _G.Config.RecoilMod, Callback = function(s) _G.Config.RecoilMod = s end })

Rayfield:Notify({ Title = "Quotas G7 Configured", Content = "Script initialized cleanly.", Duration = 4 })
