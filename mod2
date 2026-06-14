--// GLOBAL SETTINGS
getgenv().SilentAim = {
    Enabled = false,
    FOV = 250,
    ShowFOV = false,
    HitChance = 100
}

getgenv().FovColorSilentAim = Color3.fromRGB(255,255,255)
getgenv().FovLockedColorSilentAim = Color3.fromRGB(255,0,0)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// SAFE REMOTE
local ShootRemote
pcall(function()
    ShootRemote = ReplicatedStorage.Blaster.Remotes.Shoot
end)

--// FOV CIRCLE
local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.Filled = false
Circle.NumSides = 64
Circle.Transparency = 0.8
Circle.Visible = false

--// TARGET
local Target = nil

--// FUNCTIONS
local function isAlive(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
        or (model:FindFirstChildOfClass("Humanoid") and model:FindFirstChildOfClass("Humanoid").RootPart)
end

local function getTarget()
    local closest, dist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isAlive(plr.Character) then
            local root = getRoot(plr.Character)
            if root then
                local pos, onscreen = Camera:WorldToViewportPoint(root.Position)
                if onscreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if mag <= getgenv().SilentAim.FOV and mag < dist then
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
                        if mag <= getgenv().SilentAim.FOV and mag < dist then
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

--// RENDER LOOP
RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    Circle.Radius = getgenv().SilentAim.FOV
    Circle.Color = Target and getgenv().FovLockedColorSilentAim or getgenv().FovColorSilentAim
    Circle.Visible = getgenv().SilentAim.ShowFOV

    if getgenv().SilentAim.Enabled then
        Target = getTarget()
    else
        Target = nil
    end
end)

--// SILENT AIM HOOK
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller()
        and ShootRemote
        and self == ShootRemote
        and method == "FireServer"
        and getgenv().SilentAim.Enabled
        and Target
        and math.random(1,100) <= getgenv().SilentAim.HitChance then

        args[4] = {
            ["1"] = Target,
            ["2"] = Target,
            ["3"] = Target
        }

        return oldNamecall(self, unpack(args))
    end

    return oldNamecall(self, ...)
end)

--// ⚙️ Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

--// ⚙️ Variables
local Holding = false
local LockedTarget = nil

--// ⚙️ AIMBOT SETTINGS
getgenv().AimbotEnabled = false
getgenv().AimbotKey = Enum.UserInputType.MouseButton2
getgenv().AimPart = "Head"
getgenv().TeamCheck = false
getgenv().UseClosestByDistance = false -- true = ระยะ 3D ใน FOV / false = ระยะเมาส์ใน FOV
getgenv().Sensitivity = 0.05 -- ยิ่งน้อย ยิ่งเร็ว

--// ⚙️ FOV SETTINGS
getgenv().FOVCircleEnabled = false
getgenv().FOVCircleRadius = 100
getgenv().FOVCircleColor = Color3.fromRGB(255, 255, 255)
getgenv().FOVCircleTransparency = 0.5
getgenv().FOVCircleFilled = false
getgenv().FOVCircleThickness = 1
getgenv().FOVCircleVisible = false
getgenv().CircleSides = 64

--// 🎯 Drawing FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = getgenv().FOVCircleRadius
FOVCircle.Color = getgenv().FOVCircleColor
FOVCircle.Transparency = 1 - getgenv().FOVCircleTransparency
FOVCircle.Filled = getgenv().FOVCircleFilled
FOVCircle.NumSides = getgenv().CircleSides
FOVCircle.Thickness = getgenv().FOVCircleThickness
FOVCircle.Visible = getgenv().FOVCircleVisible

--// 🧠 Function : Get Closest Player
local function GetClosestPlayer()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local mousePos = UserInputService:GetMouseLocation()
    local target = nil
    local shortest = math.huge

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
            local humanoid = v.Character.Humanoid
            if humanoid.Health > 0 and (not getgenv().TeamCheck or v.Team ~= LocalPlayer.Team) then
                local root = v.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                if onScreen then
                    local distFromCursor = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                    if distFromCursor <= getgenv().FOVCircleRadius then
                        if getgenv().UseClosestByDistance then
                            local dist3D = (root.Position - myPos).Magnitude
                            if dist3D < shortest then
                                shortest = dist3D
                                target = v
                            end
                        else
                            if distFromCursor < shortest then
                                shortest = distFromCursor
                                target = v
                            end
                        end
                    end
                end
            end
        end
    end

    return target
end

--// 🖱️ Input Events
UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == getgenv().AimbotKey and getgenv().AimbotEnabled then
        Holding = true
        LockedTarget = GetClosestPlayer()
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == getgenv().AimbotKey then
        Holding = false
        LockedTarget = nil
    end
end)

--// 🔄 Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    if getgenv().FOVCircleEnabled then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = getgenv().FOVCircleRadius
        FOVCircle.Color = getgenv().FOVCircleColor
        FOVCircle.Visible = getgenv().FOVCircleVisible
        FOVCircle.Filled = getgenv().FOVCircleFilled
        FOVCircle.Thickness = getgenv().FOVCircleThickness
        FOVCircle.Transparency = 1 - getgenv().FOVCircleTransparency
        FOVCircle.NumSides = getgenv().CircleSides
    else
        FOVCircle.Visible = false
    end

    -- Aimbot Tracking
    if Holding and getgenv().AimbotEnabled and LockedTarget then
        local char = LockedTarget.Character
        if char and char:FindFirstChild(getgenv().AimPart) and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local aimPart = char[getgenv().AimPart]
            local aimPos = aimPart.Position
            local newCFrame = CFrame.new(Camera.CFrame.Position, aimPos)

            -- ทำให้ลื่นขึ้นโดยใช้ pcall ป้องกัน error
            pcall(function()
                TweenService:Create(Camera, TweenInfo.new(getgenv().Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    CFrame = newCFrame
                }):Play()
            end)
        else
            -- ถ้าเป้าตายหรือหายไป ไม่เปลี่ยนเป้าใหม่อัตโนมัติ
            LockedTarget = GetClosestPlayer()
        end
    end
end)

--=========== ESP ===========--

-- 🔧 Global Settings
getgenv().Skeleton = false
getgenv().Box = false
getgenv().Distance = false
getgenv().ShowName = false
getgenv().ShowHealthText = false
getgenv().HealthEnabled = false
getgenv().ShowTracer = false
getgenv().TeamCheckEsp = false
getgenv().RefreshRate = 0.03

getgenv().ColorSkeleton = Color3.fromRGB(255,255,255)
getgenv().ColorBox = Color3.fromRGB(255,255,255)
getgenv().ColorDistance = Color3.fromRGB(255,255,255)
getgenv().ColorShowName = Color3.fromRGB(255,255,255)
getgenv().ColorShowHealthText = Color3.fromRGB(255,255,255)
getgenv().ColorShowTracer = Color3.fromRGB(255,255,255)

-- 🚀 Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP = {}

-- =========================
-- 🧱 Drawing Helpers
-- =========================
local function NewLine(thick)
    local l = Drawing.new("Line")
    l.Thickness = thick or 1
    l.Transparency = 1
    l.Visible = false
    return l
end

local function NewText()
    local t = Drawing.new("Text")
    t.Size = 16
    t.Center = true
    t.Outline = true
    t.Font = 2
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

-- =========================
-- 🧹 CLEAN FUNCTIONS
-- =========================
local function removeESP(player)
    if not ESP[player] then return end
    for _, v in pairs(ESP[player]) do
        if typeof(v) == "table" then
            for _, obj in pairs(v) do
                if obj then obj:Remove() end
            end
        else
            v:Remove()
        end
    end
    ESP[player] = nil
end

local function hideESP(player)
    if not ESP[player] then return end
    for _, v in pairs(ESP[player]) do
        if typeof(v) == "table" then
            for _, obj in pairs(v) do
                if obj then obj.Visible = false end
            end
        else
            v.Visible = false
        end
    end
end

-- =========================
-- 🦴 Skeleton
-- =========================
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

-- =========================
-- 🔄 MAIN LOOP
-- =========================
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if getgenv().TeamCheckEsp and player.Team == LocalPlayer.Team then
            hideESP(player)
            continue
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if not (char and hrp and head and humanoid) then
            hideESP(player)
            continue
        end

        local root3D, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            hideESP(player)
            continue
        end

        -- CREATE ONCE
        if not ESP[player] then
            ESP[player] = {
                Skeleton = {},
                Box = {
                    NewLine(2),NewLine(2),NewLine(2),NewLine(2),
                    NewLine(2),NewLine(2),NewLine(2),NewLine(2)
                },
                Distance = NewText(),
                Name = NewText(),
                HealthText = NewText(),
                Tracer = NewLine(),
                HealthBG = NewSquare(),
                HealthBar = NewSquare()
            }

            humanoid.Died:Connect(function()
                removeESP(player)
            end)

            player.CharacterRemoving:Connect(function()
                removeESP(player)
            end)
        end

        local esp = ESP[player]
        local root2D = Vector2.new(root3D.X, root3D.Y)

        -- 🦴 Skeleton
        if getgenv().Skeleton then
            local bones = getBones(char)
            if #esp.Skeleton ~= #bones then
                for _, l in pairs(esp.Skeleton) do l:Remove() end
                esp.Skeleton = {}
                for _ = 1, #bones do
                    table.insert(esp.Skeleton, NewLine())
                end
            end

            for i, bone in ipairs(bones) do
                local a = char:FindFirstChild(bone[1])
                local b = char:FindFirstChild(bone[2])
                local line = esp.Skeleton[i]
                if a and b then
                    local a2D, aOn = Camera:WorldToViewportPoint(a.Position)
                    local b2D, bOn = Camera:WorldToViewportPoint(b.Position)
                    if aOn and bOn then
                        line.From = Vector2.new(a2D.X,a2D.Y)
                        line.To = Vector2.new(b2D.X,b2D.Y)
                        line.Color = getgenv().ColorSkeleton
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for _, l in pairs(esp.Skeleton) do l.Visible = false end
        end

        -- 🔳 BOX
        if getgenv().Box then
            local headPos3D = head.Position + Vector3.new(0, 0.5, 0)
            local footPos3D = hrp.Position - Vector3.new(0, 3, 0)

            local head2D, hOn = Camera:WorldToViewportPoint(headPos3D)
            local foot2D, fOn = Camera:WorldToViewportPoint(footPos3D)

            local box = esp.Box

            if hOn and fOn then
                local height = math.abs(head2D.Y - foot2D.Y)
                local width = height / 2

                local x = head2D.X - width / 2
                local y = head2D.Y

                local w = width * 0.25
                local h = height * 0.25

                -- TL
                box[1].From = Vector2.new(x, y)
                box[1].To   = Vector2.new(x + w, y)

                box[2].From = Vector2.new(x, y)
                box[2].To   = Vector2.new(x, y + h)

                -- TR
                box[3].From = Vector2.new(x + width, y)
                box[3].To   = Vector2.new(x + width - w, y)

                box[4].From = Vector2.new(x + width, y)
                box[4].To   = Vector2.new(x + width, y + h)

                -- BL
                box[5].From = Vector2.new(x, y + height)
                box[5].To   = Vector2.new(x + w, y + height)

                box[6].From = Vector2.new(x, y + height)
                box[6].To   = Vector2.new(x, y + height - h)

                -- BR
                box[7].From = Vector2.new(x + width, y + height)
                box[7].To   = Vector2.new(x + width - w, y + height)

                box[8].From = Vector2.new(x + width, y + height)
                box[8].To   = Vector2.new(x + width, y + height - h)

                for _, l in ipairs(box) do
                    l.Color = getgenv().ColorBox
                    l.Visible = true
                end
            else
                for _, l in ipairs(box) do
                    l.Visible = false
                end
            end
        else
            for _, l in ipairs(esp.Box) do
                l.Visible = false
            end
        end

        -- 📏 Distance
        if getgenv().Distance then
            esp.Distance.Text = string.format("[%.1fm]", root3D.Z)
            esp.Distance.Position = root2D + Vector2.new(0,30)
            esp.Distance.Color = getgenv().ColorDistance
            esp.Distance.Visible = true
        else
            esp.Distance.Visible = false
        end

        -- ❤️ HEALTH BAR
        if getgenv().HealthEnabled then
            local headPos3D = head.Position + Vector3.new(0, 0.5, 0)
            local footPos3D = hrp.Position - Vector3.new(0, 3, 0)

            local head2D, hOn = Camera:WorldToViewportPoint(headPos3D)
            local foot2D, fOn = Camera:WorldToViewportPoint(footPos3D)

            if hOn and fOn then
                local height = math.abs(head2D.Y - foot2D.Y)
                local hp = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

                local barWidth = 4
                local x = head2D.X - (height / 2) - 6
                local y = head2D.Y

                -- Background
                esp.HealthBG.Size = Vector2.new(barWidth, height)
                esp.HealthBG.Position = Vector2.new(x, y)
                esp.HealthBG.Color = Color3.fromRGB(30, 30, 30)
                esp.HealthBG.Visible = true

                -- Foreground
                esp.HealthBar.Size = Vector2.new(barWidth, height * hp)
                esp.HealthBar.Position = Vector2.new(
                    x,
                    y + (height - (height * hp))
                )
                esp.HealthBar.Color = Color3.fromRGB(
                    255 * (1 - hp),
                    255 * hp,
                    0
                )
                esp.HealthBar.Visible = true
            else
                esp.HealthBG.Visible = false
                esp.HealthBar.Visible = false
            end
        else
            esp.HealthBG.Visible = false
            esp.HealthBar.Visible = false
        end

        -- 🧑 Name
        if getgenv().ShowName then
            local h2D = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.8,0))
            esp.Name.Text = player.Name
            esp.Name.Position = Vector2.new(h2D.X,h2D.Y - 12)
            esp.Name.Color = getgenv().ColorShowName
            esp.Name.Visible = true
        else
            esp.Name.Visible = false
        end

        -- ❤️ Health %
        if getgenv().ShowHealthText then
            esp.HealthText.Text = math.floor((humanoid.Health / humanoid.MaxHealth)*100).."%"
            esp.HealthText.Position = root2D + Vector2.new(0,45)
            esp.HealthText.Color = getgenv().ColorShowHealthText
            esp.HealthText.Visible = true
        else
            esp.HealthText.Visible = false
        end

        -- 📍 Tracer
        if getgenv().ShowTracer then
            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            esp.Tracer.To = root2D
            esp.Tracer.Color = getgenv().ColorShowTracer
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
    end
end

-- 🔁 LOOP
task.spawn(function()
    while task.wait(getgenv().RefreshRate) do
        pcall(updateESP)
    end
end)

Players.PlayerRemoving:Connect(removeESP)

--// UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local MarketplaceService = game:GetService("MarketplaceService")
local gameName = "Unknown Game"
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local Window = Rayfield:CreateWindow({
    Name = gameName .. " || Create By Xcx",
    LoadingTitle = gameName,
    LoadingSubtitle = "by Xcx",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XcxHub",
        FileName = "SilentAim"
    }
})

local TabSectionAimbot = Window:CreateTab("Aimbot", 4483362458)
local SilentAimTab = Window:CreateTab("Silent Aim", 4483362458)
local TabSectionEsp = Window:CreateTab("Silent Aim", 4483362458)

--=========== Aimbot ===========--
TabSectionAimbot:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
        getgenv().AimbotEnabled = Value
   end,
})
TabSectionAimbot:CreateToggle({
   Name = "Show FOV",
   CurrentValue = false,
   Flag = "FovToggleAimbot",
   Callback = function(Value)
        getgenv().FOVCircleEnabled = Value
        getgenv().FOVCircleVisible = Value
   end,
})

local FovSliderAimbot = TabSectionAimbot:CreateSlider({
    Name = "FOV Size",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = getgenv().FOVCircleRadius,
    Callback = function(v)
        getgenv().FOVCircleRadius = v
    end
})

TabSectionAimbot:CreateInput({
    Name = "FOV Input",
    PlaceholderText = "50 - 1000",
    Callback = function(txt)
        local n = tonumber(txt)
        if n then
            n = math.clamp(n, 50, 1000)
            getgenv().FOVCircleRadius = n
            FovSliderAimbot:Set(n)
        end
    end
})

local FovColorPicker = TabSectionAimbot:CreateColorPicker({
    Name = "FOV Color",
    Color = getgenv().FOVCircleColor,
    Flag = "FovColorPickerAimbot",
    Callback = function(Value)
        getgenv().FOVCircleColor = Value
    end
})

--=========== Silent Aim ===========--
SilentAimTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(v)
        getgenv().SilentAim.Enabled = v
    end
})

SilentAimTab:CreateToggle({
    Name = "Show FOV",
    CurrentValue = false,
    Callback = function(v)
        getgenv().SilentAim.ShowFOV = v
    end
})

local FovSlider = SilentAimTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = getgenv().SilentAim.FOV,
    Callback = function(v)
        getgenv().SilentAim.FOV = v
    end
})

SilentAimTab:CreateInput({
    Name = "FOV Input",
    PlaceholderText = "50 - 1000",
    Callback = function(txt)
        local n = tonumber(txt)
        if n then
            n = math.clamp(n, 50, 1000)
            getgenv().SilentAim.FOV = n
            FovSlider:Set(n)
        end
    end
})

SilentAimTab:CreateColorPicker({
    Name = "FOV Color",
    Color = getgenv().FovColorSilentAim,
    Callback = function(v)
        getgenv().FovColorSilentAim = v
    end
})

SilentAimTab:CreateColorPicker({
    Name = "FOV Locked Color",
    Color = getgenv().FovLockedColorSilentAim,
    Callback = function(v)
        getgenv().FovLockedColorSilentAim = v
    end
})
--=========== Esp ===========--
TabSectionEsp:CreateToggle({
   Name = "Skeleton",
   CurrentValue = false,
   Flag = "ToggleSkeletonEsp",
   Callback = function(Value)
        getgenv().Skeleton = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "Box",
   CurrentValue = false,
   Flag = "ToggleBoxEsp",
   Callback = function(Value)
        getgenv().Box = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "Distance",
   CurrentValue = false,
   Flag = "ToggleDistanceEsp",
   Callback = function(Value)
        getgenv().Distance = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "ShowName",
   CurrentValue = false,
   Flag = "ToggleShowNameEsp",
   Callback = function(Value)
        getgenv().ShowName = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "ShowHealthText",
   CurrentValue = false,
   Flag = "ToggleShowHealthTextEsp",
   Callback = function(Value)
        getgenv().ShowHealthText = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "HealthEnabled",
   CurrentValue = false,
   Flag = "ToggleHealthEnabledEsp",
   Callback = function(Value)
        getgenv().HealthEnabled = Value
   end,
})
TabSectionEsp:CreateToggle({
   Name = "ShowTracer",
   CurrentValue = false,
   Flag = "ToggleShowTracerEsp",
   Callback = function(Value)
        getgenv().ShowTracer = Value
   end,
})

local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorSkeleton",
    Color = getgenv().ColorSkeleton,
    Flag = "ColorSkeleton",
    Callback = function(Value)
        getgenv().ColorSkeleton = Value
    end
})
local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorBox",
    Color = getgenv().ColorBox,
    Flag = "ColorBox",
    Callback = function(Value)
        getgenv().ColorBox = Value
    end
})
local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorDistance",
    Color = getgenv().ColorDistance,
    Flag = "ColorDistance",
    Callback = function(Value)
        getgenv().ColorDistance = Value
    end
})
local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorShowName",
    Color = getgenv().ColorShowName,
    Flag = "ColorShowName",
    Callback = function(Value)
        getgenv().ColorShowName = Value
    end
})
local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorShowHealthText",
    Color = getgenv().ColorShowHealthText,
    Flag = "ColorShowHealthText",
    Callback = function(Value)
        getgenv().ColorShowHealthText = Value
    end
})
local FovColorPicker = TabSectionEsp:CreateColorPicker({
    Name = "ColorShowTracer",
    Color = getgenv().ColorShowTracer,
    Flag = "ColorShowTracer",
    Callback = function(Value)
        getgenv().ColorShowTracer = Value
    end
})
