-- ==================== SYSTEM CORE ARCHITECTURE ====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Global Configuration Profile (Combined)
_G.Config = {
    -- ESP Settings
    BoxESP = false,
    NameESP = false,
    TeamCheck = true,
    SkeletonESP = false,
    DistanceESP = false,
    ShowHealthText = false,
    HealthBarEnabled = false,
    ShowTracer = false,
    
    -- ESP Colors
    ColorSkeleton = Color3.fromRGB(255,255,255),
    ColorBox = Color3.fromRGB(255,255,255),
    ColorDistance = Color3.fromRGB(255,255,255),
    ColorShowName = Color3.fromRGB(255,255,255),
    ColorShowHealthText = Color3.fromRGB(255,255,255),
    ColorShowTracer = Color3.fromRGB(255,255,255),

    -- Camera Aimbot Settings
    Aimbot = false,
    FOVCircle = true,
    FOVSize = 90,
    Sensitivity = 0.05,
    AimPart = "Head",
    UseClosestByDistance = false,

    -- Silent Aim Settings (From Script 2)
    SilentAimEnabled = false,
    SilentAimFOV = 250,
    SilentAimShowFOV = false,
    SilentAimHitChance = 100,
    FovColorSilentAim = Color3.fromRGB(255,255,255),
    FovLockedColorSilentAim = Color3.fromRGB(255,0,0),
    HitboxSize = 12,
    
    -- Physics & Weapon Mods
    InfiniteJump = false,
    SpeedHack = false,
    WalkSpeed = 100,
    InfAmmo = false,
    FireRateMod = false,
    RecoilMod = false
}

local TargetHolding = false
local ActiveRegistry = {}
local LockedTarget = nil -- Camera Aimbot Target
local SilentAimTarget = nil -- Silent Aim Target

-- Safe Remote for Silent Aim
local ShootRemote
pcall(function()
    ShootRemote = ReplicatedStorage.Blaster.Remotes.Shoot
end)

-- ==================== DRAWING OVERLAYS (FOV) ====================
-- Camera Aimbot FOV
local ScreenFOV = Drawing.new("Circle")
ScreenFOV.Visible = _G.Config.FOVCircle
ScreenFOV.Radius = _G.Config.FOVSize
ScreenFOV.Color = Color3.fromRGB(235, 60, 60)
ScreenFOV.Thickness = 1.5
ScreenFOV.Filled = false
ScreenFOV.NumSides = 64

-- Silent Aim FOV
local SilentAimFOV = Drawing.new("Circle")
SilentAimFOV.Thickness = 1
SilentAimFOV.Filled = false
SilentAimFOV.NumSides = 64
SilentAimFOV.Transparency = 0.8
SilentAimFOV.Visible = false

local function FetchViewportCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- ==================== ADVANCED ESP CONSTRUCTOR ====================
local function NewLine(thick)
    local l = Drawing.new("Line")
    l.Thickness = thick or 1
    l.Transparency = 1
    l.Visible = false
    return l
end

local function NewText()
    local t = Drawing.new("Text")
    t.Size = 14
    t.Center = true
    t.Outline = true
    t.Visible = false
    return t
end

local function NewSquare()
    local s = Drawing.new("Square")
    s.Filled = true
    s.Transparency = 1
    s.Visible = false
    return s
end

local function DestroyESPInstance(plr)
    if ActiveRegistry[plr] then
        pcall(function()
            local ent = ActiveRegistry[plr]
            if ent.Box then for _, l in ipairs(ent.Box) do l:Remove() end end
            if ent.Skeleton then for _, l in ipairs(ent.Skeleton) do l:Remove() end end
            if ent.Text then ent.Text:Remove() end
            if ent.Distance then ent.Distance:Remove() end
            if ent.HealthText then ent.HealthText:Remove() end
            if ent.Tracer then ent.Tracer:Remove() end
            if ent.HealthBG then ent.HealthBG:Remove() end
            if ent.HealthBar then ent.HealthBar:Remove() end
        end)
        ActiveRegistry[plr] = nil
    end
end

local function AllocateESPInstance(plr)
    if plr == LocalPlayer then return end
    DestroyESPInstance(plr)

    ActiveRegistry[plr] = {
        Box = { NewLine(2), NewLine(2), NewLine(2), NewLine(2), NewLine(2), NewLine(2), NewLine(2), NewLine(2) },
        Skeleton = {},
        Text = NewText(),
        Distance = NewText(),
        HealthText = NewText(),
        Tracer = NewLine(),
        HealthBG = NewSquare(),
        HealthBar = NewSquare()
    }
end

local function AttachToPlayer(plr)
    if plr == LocalPlayer then return end
    AllocateESPInstance(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        AllocateESPInstance(plr)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do AttachToPlayer(plr) end
Players.PlayerAdded:Connect(AttachToPlayer)
Players.PlayerRemoving:Connect(DestroyESPInstance)

-- Garbage Collector Sweep
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

-- ==================== TARGETING LOGIC (AIMBOT & SILENT) ====================
-- Helper Functions
local function isAlive(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart") or (model:FindFirstChildOfClass("Humanoid") and model:FindFirstChildOfClass("Humanoid").RootPart)
end

-- Camera Aimbot Targeting
local function GetClosestPlayerForCamera()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local mousePos = UserInputService:GetMouseLocation()
    local target = nil
    local shortest = math.huge

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and isAlive(v.Character) then
            if _G.Config.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local root = getRoot(v.Character)
            if root then
                local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                if onScreen then
                    local distFromCursor = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distFromCursor <= _G.Config.FOVSize then
                        if _G.Config.UseClosestByDistance then
                            local dist3D = (root.Position - myPos).Magnitude
                            if dist3D < shortest then shortest = dist3D; target = v end
                        else
                            if distFromCursor < shortest then shortest = distFromCursor; target = v end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Silent Aim Targeting (Includes Bots)
local function GetSilentAimTarget()
    local closest, dist = nil, math.huge
    local center = FetchViewportCenter()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
            if _G.Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local root = getRoot(plr.Character)
            if root then
                local pos, onscreen = Camera:WorldToViewportPoint(root.Position)
                if onscreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if mag <= _G.Config.SilentAimFOV and mag < dist then
                        dist = mag
                        closest = plr.Character:FindFirstChildOfClass("Humanoid")
                    end
                end
            end
        end
    end

    local bots = Workspace:FindFirstChild("Bots")
    if bots then
        for _, bot in ipairs(bots:GetChildren()) do
            if bot:IsA("Model") and isAlive(bot) then
                local root = getRoot(bot)
                if root then
                    local pos, onscreen = Camera:WorldToViewportPoint(root.Position)
                    if onscreen then
                        local mag = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if mag <= _G.Config.SilentAimFOV and mag < dist then
                            dist = mag
                            closest = bot:FindFirstChildOfClass("Humanoid")
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Skeleton Bones Helper
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

-- ==================== MAIN RENDER LOOP (ESP & AIMBOT) ====================
RunService.RenderStepped:Connect(function()
    local currentCenter = FetchViewportCenter()
    
    -- Update FOV Circles
    ScreenFOV.Position = currentCenter
    ScreenFOV.Radius = _G.Config.FOVSize
    ScreenFOV.Visible = _G.Config.FOVCircle

    SilentAimFOV.Position = currentCenter
    SilentAimFOV.Radius = _G.Config.SilentAimFOV
    SilentAimFOV.Color = SilentAimTarget and _G.Config.FovLockedColorSilentAim or _G.Config.FovColorSilentAim
    SilentAimFOV.Visible = _G.Config.SilentAimShowFOV

    -- Silent Aim Target Processing
    if _G.Config.SilentAimEnabled then
        SilentAimTarget = GetSilentAimTarget()
    else
        SilentAimTarget = nil
    end

    -- Process ESP Engine
    for plr, entity in pairs(ActiveRegistry) do
        if not plr or not Players:FindFirstChild(plr.Name) then
            DestroyESPInstance(plr)
            continue
        end

        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local isActive = hrp and head and (hum == nil or hum.Health > 0)
        local isAlly = (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team)
        local displayAllowed = isActive and (not _G.Config.TeamCheck or not isAlly)

        if displayAllowed then
            local rootScreenPos, inFrame = Camera:WorldToViewportPoint(hrp.Position)

            if inFrame then
                local headOffset = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local footOffset = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.0, 0))
                
                local calculatedHeight = math.abs(footOffset.Y - headOffset.Y)
                local calculatedWidth = calculatedHeight / 2
                local root2D = Vector2.new(rootScreenPos.X, rootScreenPos.Y)

                -- 1. Corners Box ESP
                if _G.Config.BoxESP then
                    local x = headOffset.X - calculatedWidth / 2
                    local y = headOffset.Y
                    local w = calculatedWidth * 0.25
                    local h = calculatedHeight * 0.25

                    entity.Box[1].From = Vector2.new(x, y); entity.Box[1].To = Vector2.new(x + w, y)
                    entity.Box[2].From = Vector2.new(x, y); entity.Box[2].To = Vector2.new(x, y + h)
                    entity.Box[3].From = Vector2.new(x + calculatedWidth, y); entity.Box[3].To = Vector2.new(x + calculatedWidth - w, y)
                    entity.Box[4].From = Vector2.new(x + calculatedWidth, y); entity.Box[4].To = Vector2.new(x + calculatedWidth, y + h)
                    entity.Box[5].From = Vector2.new(x, y + calculatedHeight); entity.Box[5].To = Vector2.new(x + w, y + calculatedHeight)
                    entity.Box[6].From = Vector2.new(x, y + calculatedHeight); entity.Box[6].To = Vector2.new(x, y + calculatedHeight - h)
                    entity.Box[7].From = Vector2.new(x + calculatedWidth, y + calculatedHeight); entity.Box[7].To = Vector2.new(x + calculatedWidth - w, y + calculatedHeight)
                    entity.Box[8].From = Vector2.new(x + calculatedWidth, y + calculatedHeight); entity.Box[8].To = Vector2.new(x + calculatedWidth, y + calculatedHeight - h)

                    for _, l in ipairs(entity.Box) do l.Color = _G.Config.ColorBox; l.Visible = true end
                else
                    for _, l in ipairs(entity.Box) do l.Visible = false end
                end

                -- 2. Skeleton ESP
                if _G.Config.SkeletonESP then
                    local bones = getBones(char)
                    if #entity.Skeleton ~= #bones then
                        for _, l in pairs(entity.Skeleton) do l:Remove() end
                        entity.Skeleton = {}
                        for _ = 1, #bones do table.insert(entity.Skeleton, NewLine()) end
                    end

                    for i, bone in ipairs(bones) do
                        local a = char:FindFirstChild(bone[1])
                        local b = char:FindFirstChild(bone[2])
                        local line = entity.Skeleton[i]
                        if a and b then
                            local a2D, aOn = Camera:WorldToViewportPoint(a.Position)
                            local b2D, bOn = Camera:WorldToViewportPoint(b.Position)
                            if aOn and bOn then
                                line.From = Vector2.new(a2D.X, a2D.Y)
                                line.To = Vector2.new(b2D.X, b2D.Y)
                                line.Color = _G.Config.ColorSkeleton
                                line.Visible = true
                            else line.Visible = false end
                        else line.Visible = false end
                    end
                else
                    for _, l in pairs(entity.Skeleton) do l.Visible = false end
                end

                -- 3. Name ESP
                if _G.Config.NameESP then
                    entity.Text.Text = plr.Name
                    entity.Text.Position = Vector2.new(headOffset.X, headOffset.Y - 14)
                    entity.Text.Color = _G.Config.ColorShowName
                    entity.Text.Visible = true
                else entity.Text.Visible = false end

                -- 4. Distance ESP
                if _G.Config.DistanceESP then
                    entity.Distance.Text = string.format("[%.1fm]", rootScreenPos.Z)
                    entity.Distance.Position = root2D + Vector2.new(0, 20)
                    entity.Distance.Color = _G.Config.ColorDistance
                    entity.Distance.Visible = true
                else entity.Distance.Visible = false end

                -- 5. Health Bar
                if _G.Config.HealthBarEnabled and hum then
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barWidth = 4
                    local x = headOffset.X - (calculatedWidth / 2) - 7
                    local y = headOffset.Y

                    entity.HealthBG.Size = Vector2.new(barWidth, calculatedHeight)
                    entity.HealthBG.Position = Vector2.new(x, y)
                    entity.HealthBG.Color = Color3.fromRGB(30, 30, 30)
                    entity.HealthBG.Visible = true

                    entity.HealthBar.Size = Vector2.new(barWidth, calculatedHeight * hp)
                    entity.HealthBar.Position = Vector2.new(x, y + (calculatedHeight - (calculatedHeight * hp)))
                    entity.HealthBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
                    entity.HealthBar.Visible = true
                else
                    entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
                end

                -- 6. Health Text
                if _G.Config.ShowHealthText and hum then
                    entity.HealthText.Text = math.floor((hum.Health / hum.MaxHealth) * 100) .. "%"
                    entity.HealthText.Position = root2D + Vector2.new(0, 35)
                    entity.HealthText.Color = _G.Config.ColorShowHealthText
                    entity.HealthText.Visible = true
                else entity.HealthText.Visible = false end

                -- 7. Tracer ESP
                if _G.Config.ShowTracer then
                    entity.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    entity.Tracer.To = root2D
                    entity.Tracer.Color = _G.Config.ColorShowTracer
                    entity.Tracer.Visible = true
                else entity.Tracer.Visible = false end
            else
                -- Offscreen cleanup
                for _, l in ipairs(entity.Box) do l.Visible = false end
                for _, l in pairs(entity.Skeleton) do l.Visible = false end
                entity.Text.Visible = false; entity.Distance.Visible = false
                entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
                entity.HealthText.Visible = false; entity.Tracer.Visible = false
            end
        else
            -- Non-active cleanup
            for _, l in ipairs(entity.Box) do l.Visible = false end
            for _, l in pairs(entity.Skeleton) do l.Visible = false end
            entity.Text.Visible = false; entity.Distance.Visible = false
            entity.HealthBG.Visible = false; entity.HealthBar.Visible = false
            entity.HealthText.Visible = false; entity.Tracer.Visible = false
        end
    end

    -- Smooth Camera Aimbot Tracking
    if TargetHolding and _G.Config.Aimbot and LockedTarget then
        local char = LockedTarget.Character
        if char and char:FindFirstChild(_G.Config.AimPart) and isAlive(char) then
            local node = char[_G.Config.AimPart]
            local alignedMatrix = CFrame.new(Camera.CFrame.Position, node.Position)
            pcall(function()
                TweenService:Create(Camera, TweenInfo.new(_G.Config.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    CFrame = alignedMatrix
                }):Play()
            end)
        else
            LockedTarget = GetClosestPlayerForCamera()
        end
    end
end)

-- ==================== METAMETHOD HOOK (SILENT AIM) ====================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller()
        and ShootRemote
        and self == ShootRemote
        and method == "FireServer"
        and _G.Config.SilentAimEnabled
        and SilentAimTarget
        and math.random(1, 100) <= _G.Config.SilentAimHitChance then

        args[4] = {
            ["1"] = SilentAimTarget,
            ["2"] = SilentAimTarget,
            ["3"] = SilentAimTarget
        }
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)

-- ==================== PERIPHERAL CAPTURE HOOKS ====================
UserInputService.InputBegan:Connect(function(key, typing)
    if typing then return end
    if key.UserInputType == Enum.UserInputType.MouseButton2 then
        TargetHolding = true
        if _G.Config.Aimbot then LockedTarget = GetClosestPlayerForCamera() end
    end
end)

UserInputService.InputEnded:Connect(function(key)
    if key.UserInputType == Enum.UserInputType.MouseButton2 then
        TargetHolding = false
        LockedTarget = nil
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Config.InfiniteJump then
        local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then human:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==================== GAMEPLAY MANIPULATION CO-THREADS ====================
-- Volumetric Hitboxes Loop
task.spawn(function()
    while true do
        task.wait(1)
        if _G.Config.SilentAimEnabled and not ShootRemote then -- fallback if not using remote hooks
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

-- Weapons Mod Loop
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

-- ==================== CONTROLLER CANVAS DRAWING (RAYFIELD) ====================
local Window = Rayfield:CreateWindow({
    Name = "Quotas G6 x Xcx Hybrid Hub",
    LoadingTitle = "Initializing Merged Environment...",
    LoadingSubtitle = "by Quotas & Xcx",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Camera Aimbot", nil)
local SilentAimTab = Window:CreateTab("Silent Aim", nil)
local EspTab = Window:CreateTab("Visuals (ESP)", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local WeaponsTab = Window:CreateTab("Weapons", nil)

-- 1. Camera Aimbot Tab
CombatTab:CreateToggle({ Name = "Enable Camera Aimbot", CurrentValue = _G.Config.Aimbot, Callback = function(state) _G.Config.Aimbot = state end })
CombatTab:CreateToggle({ Name = "Display Aimbot FOV", CurrentValue = _G.Config.FOVCircle, Callback = function(state) _G.Config.FOVCircle = state end })
CombatTab:CreateSlider({ Name = "FOV Size", Range = {30, 400}, Increment = 5, CurrentValue = _G.Config.FOVSize, Callback = function(val) _G.Config.FOVSize = val end })
CombatTab:CreateSlider({ Name = "Smoothing (Lower = Faster)", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(val) _G.Config.Sensitivity = (11 - val) * 0.02 end })
CombatTab:CreateDropdown({ Name = "Target Bone", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {_G.Config.AimPart}, Callback = function(val) _G.Config.AimPart = val[1] end })
CombatTab:CreateToggle({ Name = "Distance Priority (3D)", CurrentValue = _G.Config.UseClosestByDistance, Callback = function(state) _G.Config.UseClosestByDistance = state end })
CombatTab:CreateToggle({ Name = "Team Check", CurrentValue = _G.Config.TeamCheck, Callback = function(state) _G.Config.TeamCheck = state end })

-- 2. Silent Aim Tab
SilentAimTab:CreateToggle({ Name = "Enable Silent Aim", CurrentValue = _G.Config.SilentAimEnabled, Callback = function(state) _G.Config.SilentAimEnabled = state end })
SilentAimTab:CreateToggle({ Name = "Show Silent Aim FOV", CurrentValue = _G.Config.SilentAimShowFOV, Callback = function(state) _G.Config.SilentAimShowFOV = state end })
SilentAimTab:CreateSlider({ Name = "Silent Aim FOV Size", Range = {50, 1000}, Increment = 10, CurrentValue = _G.Config.SilentAimFOV, Callback = function(v) _G.Config.SilentAimFOV = v end })
SilentAimTab:CreateSlider({ Name = "Hit Chance (%)", Range = {1, 100}, Increment = 1, CurrentValue = _G.Config.SilentAimHitChance, Callback = function(v) _G.Config.SilentAimHitChance = v end })
SilentAimTab:CreateSlider({ Name = "Fallback Volumetric Hitbox Size", Range = {2, 30}, Increment = 1, CurrentValue = _G.Config.HitboxSize, Callback = function(v) _G.Config.HitboxSize = v end })
SilentAimTab:CreateColorPicker({ Name = "FOV Default Color", Color = _G.Config.FovColorSilentAim, Callback = function(v) _G.Config.FovColorSilentAim = v end })
SilentAimTab:CreateColorPicker({ Name = "FOV Locked Color", Color = _G.Config.FovLockedColorSilentAim, Callback = function(v) _G.Config.FovLockedColorSilentAim = v end })

-- 3. Visuals (ESP) Tab
EspTab:CreateToggle({ Name = "Boxes ESP", CurrentValue = _G.Config.BoxESP, Callback = function(state) _G.Config.BoxESP = state end })
EspTab:CreateToggle({ Name = "Skeleton ESP", CurrentValue = _G.Config.SkeletonESP, Callback = function(state) _G.Config.SkeletonESP = state end })
EspTab:CreateToggle({ Name = "Show Names", CurrentValue = _G.Config.NameESP, Callback = function(state) _G.Config.NameESP = state end })
EspTab:CreateToggle({ Name = "Show Distance", CurrentValue = _G.Config.DistanceESP, Callback = function(state) _G.Config.DistanceESP = state end })
EspTab:CreateToggle({ Name = "Health Bar", CurrentValue = _G.Config.HealthBarEnabled, Callback = function(state) _G.Config.HealthBarEnabled = state end })
EspTab:CreateToggle({ Name = "Health Percentage Text", CurrentValue = _G.Config.ShowHealthText, Callback = function(state) _G.Config.ShowHealthText = state end })
EspTab:CreateToggle({ Name = "Tracers", CurrentValue = _G.Config.ShowTracer, Callback = function(state) _G.Config.ShowTracer = state end })
EspTab:CreateColorPicker({ Name = "Box Color", Color = _G.Config.ColorBox, Callback = function(v) _G.Config.ColorBox = v end })
EspTab:CreateColorPicker({ Name = "Skeleton Color", Color = _G.Config.ColorSkeleton, Callback = function(v) _G.Config.ColorSkeleton = v end })

-- 4. Movement Tab
MovementTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = _G.Config.InfiniteJump, Callback = function(state) _G.Config.InfiniteJump = state end })
MovementTab:CreateToggle({ Name = "Speed Hack", CurrentValue = _G.Config.SpeedHack, Callback = function(state) _G.Config.SpeedHack = state SyncSpeedParameters(state) end })
MovementTab:CreateSlider({ Name = "WalkSpeed Value", Range = {16, 200}, Increment = 2, CurrentValue = _G.Config.WalkSpeed, Callback = function(val) _G.Config.WalkSpeed = val if _G.Config.SpeedHack then SyncSpeedParameters(true) end end })

-- 5. Weapons Tab
WeaponsTab:CreateToggle({ Name = "Infinite Ammo", CurrentValue = _G.Config.InfAmmo, Callback = function(state) _G.Config.InfAmmo = state end })
WeaponsTab:CreateToggle({ Name = "Fast Fire Rate", CurrentValue = _G.Config.FireRateMod, Callback = function(state) _G.Config.FireRateMod = state end })
WeaponsTab:CreateToggle({ Name = "No Recoil / Spread", CurrentValue = _G.Config.RecoilMod, Callback = function(state) _G.Config.RecoilMod = state end })

Rayfield:Notify({ Title = "Hybrid System Loaded", Content = "Merged Modules initialized successfully.", Duration = 4 })
