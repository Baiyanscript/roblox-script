local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- STATES
local instantGrab = false
local godMode = false
local espEnabled = false
local autoCollect = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "BrainrotMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,360)
main.Position = UDim2.new(0.35,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "Brainrot Dev Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150,40,40)

-- MINIMIZE
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,25,0,25)
minimize.Position = UDim2.new(1,-60,0,5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- SPEED BOX
local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.new(0.9,0,0,30)
speedBox.Position = UDim2.new(0.05,0,0.15,0)
speedBox.PlaceholderText = "Enter Speed"
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.new(1,1,1)

-- SPEED BUTTON
local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.new(0.9,0,0,30)
speedBtn.Position = UDim2.new(0.05,0,0.26,0)
speedBtn.Text = "Set Speed"
speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- GOD MODE
local godBtn = Instance.new("TextButton", main)
godBtn.Size = UDim2.new(0.9,0,0,30)
godBtn.Position = UDim2.new(0.05,0,0.37,0)
godBtn.Text = "God Mode: OFF"
godBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- INSTANT GRAB
local grabBtn = Instance.new("TextButton", main)
grabBtn.Size = UDim2.new(0.9,0,0,30)
grabBtn.Position = UDim2.new(0.05,0,0.48,0)
grabBtn.Text = "Instant Grab: OFF"
grabBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- BEST BRAINROTS
local bestBtn = Instance.new("TextButton", main)
bestBtn.Size = UDim2.new(0.9,0,0,30)
bestBtn.Position = UDim2.new(0.05,0,0.59,0)
bestBtn.Text = "Grab Best 3 Brainrots"
bestBtn.BackgroundColor3 = Color3.fromRGB(80,120,60)

-- ESP
local espBtn = Instance.new("TextButton", main)
espBtn.Size = UDim2.new(0.9,0,0,30)
espBtn.Position = UDim2.new(0.05,0,0.70,0)
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- AUTO COLLECT
local autoBtn = Instance.new("TextButton", main)
autoBtn.Size = UDim2.new(0.9,0,0,30)
autoBtn.Position = UDim2.new(0.05,0,0.81,0)
autoBtn.Text = "Auto Collect: OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- FUNCTIONS

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local function getRoot()
	return getChar():WaitForChild("HumanoidRootPart")
end

-- SPEED
speedBtn.MouseButton1Click:Connect(function()

	local speed = tonumber(speedBox.Text)

	if speed then
		getHum().WalkSpeed = speed
	end

end)

-- GOD MODE
godBtn.MouseButton1Click:Connect(function()

	godMode = not godMode
	godBtn.Text = godMode and "God Mode: ON" or "God Mode: OFF"

end)

task.spawn(function()

	while true do
		task.wait(.2)

		if godMode then
			local hum = getHum()
			hum.Health = hum.MaxHealth
		end

	end

end)

-- INSTANT GRAB
grabBtn.MouseButton1Click:Connect(function()

	instantGrab = not instantGrab
	grabBtn.Text = instantGrab and "Instant Grab: ON" or "Instant Grab: OFF"

end)

task.spawn(function()

	while true do
		task.wait(.05)

		if instantGrab then
			local root = getRoot()

			for _,v in pairs(workspace:GetDescendants()) do
				if v.Name:lower():find("brainrot") and v:IsA("BasePart") then

					firetouchinterest(root,v,0)
					firetouchinterest(root,v,1)

				end
			end
		end

	end

end)

-- BEST BRAINROTS
bestBtn.MouseButton1Click:Connect(function()

	local root = getRoot()
	local brainrots = {}

	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name:lower():find("brainrot") and v:IsA("BasePart") then

			table.insert(brainrots,v)

		end
	end

	for i=1,math.min(3,#brainrots) do

		root.CFrame = brainrots[i].CFrame + Vector3.new(0,3,0)

		firetouchinterest(root,brainrots[i],0)
		firetouchinterest(root,brainrots[i],1)

		task.wait(.2)

	end

end)

-- ESP
local function createESP(brainrot)

	if brainrot:FindFirstChild("ESP") then return end

	local bb = Instance.new("BillboardGui",brainrot)
	bb.Name = "ESP"
	bb.Size = UDim2.new(0,200,0,60)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true

	local txt = Instance.new("TextLabel",bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.Font = Enum.Font.Gotham
	txt.TextSize = 14

	local level = brainrot:FindFirstChild("Level")
	local rarity = brainrot:FindFirstChild("Rarity")

	txt.Text =
		brainrot.Name..
		"\nLevel: "..(level and level.Value or "N/A")..
		"\nRarity: "..(rarity and rarity.Value or "N/A")

end

RunService.RenderStepped:Connect(function()

	if espEnabled then

		for _,v in pairs(workspace:GetDescendants()) do
			if v.Name:lower():find("brainrot") and v:IsA("BasePart") then
				createESP(v)
			end
		end

	else

		for _,v in pairs(workspace:GetDescendants()) do
			if v.Name == "ESP" then
				v:Destroy()
			end
		end

	end

end)

espBtn.MouseButton1Click:Connect(function()

	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"

end)

-- AUTO COLLECT
task.spawn(function()

	while true do
		task.wait(1)

		if autoCollect then

			for _,v in pairs(workspace:GetDescendants()) do
				if v:FindFirstChild("Money") then

					local stats = player:FindFirstChild("leaderstats")

					if stats and stats:FindFirstChild("Money") then
						stats.Money.Value += v.Money.Value
						v.Money.Value = 0
					end

				end
			end

		end

	end

end)

autoBtn.MouseButton1Click:Connect(function()

	autoCollect = not autoCollect
	autoBtn.Text = autoCollect and "Auto Collect: ON" or "Auto Collect: OFF"

end)

-- MINIMIZE
local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	main.Size =
		minimized and UDim2.new(0,300,0,35)
		or UDim2.new(0,300,0,360)

end)

-- CLOSE
close.MouseButton1Click:Connect(function()

	gui:Destroy()

end)
