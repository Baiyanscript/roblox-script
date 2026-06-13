-- ==================== SYSTEM CORE ARCHITECTURE ====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Global Memory Profile
_G.Config = {
    BoxESP = false,
    NameESP = false,
    TeamCheck = true,
    
    Aimbot = false,
    FOVCircle = true,
    FOVSize = 90,
    Sensitivity = 0.05,
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

local TargetHolding = false
local ActiveRegistry = {}

-- ==================== SCREEN ORIENTED FOV SYSTEM ====================
local ScreenFOV = Drawing.new("Circle")
ScreenFOV.Visible = _G.Config.FOVCircle
ScreenFOV.Radius = _G.Config.FOVSize
ScreenFOV.Color = Color3.fromRGB(235, 60, 60)
ScreenFOV.Thickness = 1.5
ScreenFOV.Filled = false
ScreenFOV.NumSides = 64

local function FetchViewportCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- ==================== LIGHTWEIGHT ESP CONSTRUCTOR ====================
local function DestroyESPInstance(plr)
    if ActiveRegistry[plr] then
        pcall(function() ActiveRegistry[plr].Box:Remove() end)
        pcall(function() ActiveRegistry[plr].Text:Remove() end)
        ActiveRegistry[plr] = nil
    end
end

local function AllocateESPInstance(plr)
    if plr == LocalPlayer then return end
    DestroyESPInstance(plr)

    local SquareObject = Drawing.new("Square")
    SquareObject.Visible = false
    SquareObject.Color = Color3.fromRGB(255, 255, 255)
    SquareObject.Thickness = 1.5
    SquareObject.Filled = false

    local TextObject = Drawing.new("Text")
    TextObject.Visible = false
    TextObject.Color = Color3.fromRGB(255, 255, 255)
    TextObject.Size = 13
    TextObject.Center = true
    TextObject.Outline = true

    ActiveRegistry[plr] = { Box = SquareObject, Text = TextObject }
end

local function AttachToPlayer(plr)
    if plr == LocalPlayer then return end
    AllocateESPInstance(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        AllocateESPInstance(plr)
    end)
end

-- Monitor Network Environment
for _, plr in ipairs(Players:GetPlayers()) do AttachToPlayer(plr) end
Players.PlayerAdded:Connect(AttachToPlayer)
Players.PlayerRemoving:Connect(DestroyESPInstance)

-- Dynamic Background Garbage Collection Sweep
task.spawn(function()
    while true do
        task.wait(1.5)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not ActiveRegistry[plr] then
                AttachToPlayer(plr)
            end
        end
    end
end)

-- ==================== LOCK ACQUISITION CALCULATIONS ====================
local function SeekOptimalTarget()
    local focalPoint = FetchViewportCenter()
    local nearestCandidate = nil
    local thresholdRadius = _G.Config.FOVSize

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if _G.Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end

            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then continue end

            local viewportPosition, isRendered = Camera:WorldToScreenPoint(hrp.Position)
            if not isRendered then continue end

            local radialDistance = (Vector2.new(viewportPosition.X, viewportPosition.Y) - focalPoint).Magnitude
            if radialDistance < thresholdRadius then
                thresholdRadius = radialDistance
                nearestCandidate = plr
            end
        end
    end
    return nearestCandidate
end

-- ==================== GRAPHICS & AIM PIPELINE ====================
RunService.RenderStepped:Connect(function()
    -- Sync Screen Geometry for FOV Ring
    local currentCenter = FetchViewportCenter()
    ScreenFOV.Position = currentCenter
    ScreenFOV.Radius = _G.Config.FOVSize
    ScreenFOV.Visible = _G.Config.FOVCircle

    -- Compute Screen Elements Map
    for plr, entity in pairs(ActiveRegistry) do
        if not plr or not Players:FindFirstChild(plr.Name) then
            DestroyESPInstance(plr)
            continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local isActive = hrp and (hum == nil or hum.Health > 0)
        local isAlly = (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team)
        local displayAllowed = isActive and (not _G.Config.TeamCheck or not isAlly)

        if displayAllowed then
            local rootScreenPos, inFrame = Camera:WorldToViewportPoint(hrp.Position)

            if inFrame then
                local headOffset = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.4, 0))
                local footOffset = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.0, 0))
                
                local calculatedHeight = math.abs(footOffset.Y - headOffset.Y)
                local calculatedWidth = calculatedHeight / 1.6
                local dynamicColor = plr.TeamColor.Color

                -- Separated Box Allocation Logic
                if _G.Config.BoxESP then
                    entity.Box.Size = Vector2.new(calculatedWidth, calculatedHeight)
                    entity.Box.Position = Vector2.new(rootScreenPos.X - (calculatedWidth / 2), headOffset.Y)
                    entity.Box.Color = dynamicColor
                    entity.Box.Visible = true
                else
                    entity.Box.Visible = false
                end

                -- Separated Label Allocation Logic
                if _G.Config.NameESP then
                    local linearDistance = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    entity.Text.Position = Vector2.new(rootScreenPos.X, headOffset.Y - 16)
                    entity.Text.Color = dynamicColor
                    entity.Text.Text = plr.Name .. " [" .. linearDistance .. "m]"
                    entity.Text.Visible = true
                else
                    entity.Text.Visible = false
                end
            else
                entity.Box.Visible = false
                entity.Text.Visible = false
            end
        else
            entity.Box.Visible = false
            entity.Text.Visible = false
        end
    end

    -- Camera Trajectory Vector Interpolation
    if TargetHolding and _G.Config.Aimbot then
        local primaryTarget = SeekOptimalTarget()
        local node = primaryTarget and primaryTarget.Character and primaryTarget.Character:FindFirstChild(_G.Config.AimPart)
        if node then
            local alignedMatrix = CFrame.new(Camera.CFrame.Position, node.Position)
            Camera.CFrame = Camera.CFrame:Lerp(alignedMatrix, _G.Config.Sensitivity)
        end
    end
end)

-- ==================== PERIPHERAL CAPTURE HOOKS ====================
UserInputService.InputBegan:Connect(function(key, typing)
    if typing then return end
    if key.UserInputType == Enum.UserInputType.MouseButton2 then TargetHolding = true end
end)

UserInputService.InputEnded:Connect(function(key)
    if key.UserInputType == Enum.UserInputType.MouseButton2 then TargetHolding = false end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Config.InfiniteJump then
        local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then human:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==================== GAMEPLAY MANIPULATION CO-THREADS ====================
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
        local storage = game:GetService("ReplicatedStorage")
        local armory = storage:FindFirstChild("Weapons")
        
        if armory then
            for _, field in ipairs(armory:GetDescendants()) do
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
                local primary, secondary = values:FindFirstChild("ammocount"), values:FindFirstChild("ammocount2")
                if primary then primary.Value = 999 end
                if secondary then secondary.Value = 999 end
            end
        end
    end
end)

local networkSpeedHandle = nil
local function SyncSpeedParameters(status)
    if networkSpeedHandle then networkSpeedHandle:Disconnect() end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if status then
            hum.WalkSpeed = _G.Config.WalkSpeed
            networkSpeedHandle = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if _G.Config.SpeedHack and hum and hum.Parent then
                    hum.WalkSpeed = _G.Config.WalkSpeed
                end
            end)
        else
            hum.WalkSpeed = 16
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    if _G.Config.SpeedHack then SyncSpeedParameters(true) end
end)

-- ==================== CONTROLLER CANVAS DRAWING ====================
local Window = Rayfield:CreateWindow({
    Name = "Quotas Generation 6",
    LoadingTitle = "Initializing Modular Environment...",
    LoadingSubtitle = "by Quotas",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local WeaponsTab = Window:CreateTab("Weapons", nil)

-- Individual Modular Triggers
CombatTab:CreateToggle({ Name = "Enable Box ESP", CurrentValue = _G.Config.BoxESP, Callback = function(state) _G.Config.BoxESP = state end })
CombatTab:CreateToggle({ Name = "Enable Name & Dist ESP", CurrentValue = _G.Config.NameESP, Callback = function(state) _G.Config.NameESP = state end })
CombatTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = _G.Config.TeamCheck, Callback = function(state) _G.Config.TeamCheck = state end })

CombatTab:CreateToggle({ Name = "Aim Assistance Locked", CurrentValue = _G.Config.Aimbot, Callback = function(state) _G.Config.Aimbot = state end })
CombatTab:CreateToggle({ Name = "Display Central Reticle", CurrentValue = _G.Config.FOVCircle, Callback = function(state) _G.Config.FOVCircle = state end })
CombatTab:CreateSlider({ Name = "Reticle Bounds Size", Range = {30, 400}, Increment = 5, CurrentValue = _G.Config.FOVSize, Callback = function(val) _G.Config.FOVSize = val end })
CombatTab:CreateSlider({ Name = "Targeting Drag Weight", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(val) _G.Config.Sensitivity = (11 - val) * 0.02 end })
CombatTab:CreateDropdown({ Name = "Tracking Component", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {_G.Config.AimPart}, Callback = function(val) _G.Config.AimPart = val[1] end })
CombatTab:CreateToggle({ Name = "Volumetric Hitboxes", CurrentValue = _G.Config.SilentAim, Callback = function(state) _G.Config.SilentAim = state end })

-- Physics Panels
MovementTab:CreateToggle({ Name = "Bypass Jump Constraints", CurrentValue = _G.Config.InfiniteJump, Callback = function(state) _G.Config.InfiniteJump = state end })
MovementTab:CreateToggle({ Name = "Enable Target Velocity", CurrentValue = _G.Config.SpeedHack, Callback = function(state) _G.Config.SpeedHack = state SyncSpeedParameters(state) end })
MovementTab:CreateSlider({ Name = "Velocity Limit Profile", Range = {16, 200}, Increment = 2, CurrentValue = _G.Config.WalkSpeed, Callback = function(val) _G.Config.WalkSpeed = val if _G.Config.SpeedHack then SyncSpeedParameters(true) end end })

-- Weapon Panels
WeaponsTab:CreateToggle({ Name = "Bypass Munition Depletion", CurrentValue = _G.Config.InfAmmo, Callback = function(state) _G.Config.InfAmmo = state end })
WeaponsTab:CreateToggle({ Name = "Accelerate Cycle Speed", CurrentValue = _G.Config.FireRateMod, Callback = function(state) _G.Config.FireRateMod = state end })
WeaponsTab:CreateToggle({ Name = "Suppress Weapon Dispersion", CurrentValue = _G.Config.RecoilMod, Callback = function(state) _G.Config.RecoilMod = state end })

Rayfield:Notify({ Title = "Quotas G6 Active", Content = "Modular Core loaded safely.", Duration = 3 })
