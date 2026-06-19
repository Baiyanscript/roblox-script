-- 🤖 GOD MODE SYSTEM (極簡彩色 UI 版)
-- 僅保留最核心的「無敵開關」，完全移除向上/向下/速度調整功能

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- ===================== 復古彩色 UI 外觀設定 =====================
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137) -- 亮綠色背景
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57) -- 保持原本的方塊大小
Frame.Active = true
Frame.Draggable = true

-- 粉色標題列 (改至上方填滿，更美觀)
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 26)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "無敵UI介面V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

-- 黃色無敵主開關 (置中放大)
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.05, 0, 0.5, 0)
onof.Size = UDim2.new(0.9, 0, 0, 25)
onof.Font = Enum.Font.SourceSans
onof.Text = "無敵 : 關閉"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 16.000

-- 右上角控制按鈕群
closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position = UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

-- ===================== 系統核心服務與無敵變數 =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local enabled = false
local isGodmode = false
local ghostClone, connection, noclipConn, deathConn = nil, nil, nil, nil
local lastPromptUpdate = 0

-- 啟動通知
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "無敵UI介面V3",
	Text = "BY Baiyan",
	Icon = ""
})

-- ===================== GODMODE 核心邏輯 (純淨版) =====================
local function cleanup()
	isGodmode = false
	if connection then connection:Disconnect() connection = nil end
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	if deathConn then deathConn:Disconnect() deathConn = nil end
	
	local char = player.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root and ghostClone then root.CFrame = ghostClone.HumanoidRootPart.CFrame end
		if char:FindFirstChild("Humanoid") then 
			char.Humanoid.PlatformStand = false 
			camera.CameraSubject = char.Humanoid 
		end
	end
	if ghostClone then ghostClone:Destroy() ghostClone = nil end
end

local function enableGodmode()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	cleanup()
	isGodmode = true
	
	char.Archivable = true
	ghostClone = char:Clone()
	ghostClone.Name = "GhostDecoy"
	ghostClone.Parent = workspace
	char.Archivable = false
	
	for _, v in pairs(ghostClone:GetDescendants()) do
		if v:IsA("BasePart") then
			if v.Name:lower():find("root") or v.Name:lower():find("collision") then
				v.Transparency = 0.5
			else
				v.Transparency = 0
			end
			v.CanCollide = true
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 0
		end
	end

	if char:FindFirstChild("Animate") then 
		char.Animate:Clone().Parent = ghostClone 
	end
	
	char.Humanoid.PlatformStand = true
	camera.CameraSubject = ghostClone.Humanoid
	
	-- 穿牆
	noclipConn = RunService.Stepped:Connect(function()
		if char then
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end)

	-- 追蹤與遠程物件優化邏輯
	connection = RunService.Heartbeat:Connect(function()
		if ghostClone and char and char:FindFirstChild("HumanoidRootPart") then
			local moveDir = char.Humanoid.MoveDirection
			ghostClone.Humanoid:Move(moveDir, false)
			ghostClone.Humanoid.Jump = char.Humanoid.Jump
			
			if moveDir.Magnitude > 0 then
				local targetRot = CFrame.lookAt(ghostClone.HumanoidRootPart.Position, ghostClone.HumanoidRootPart.Position + moveDir)
				ghostClone.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame:Lerp(targetRot, 0.25)
			end
			
			if tick() - lastPromptUpdate > 0.5 then
				for _, p in pairs(workspace:GetDescendants()) do
					if p:IsA("ProximityPrompt") then
						p.MaxActivationDistance = 25
						p.RequiresLineOfSight = false
					end
				end
				lastPromptUpdate = tick()
			end
			
			-- 真身隱藏在分身下方 15 格確保無敵
			char.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
			char.HumanoidRootPart.Velocity = Vector3.zero
		else 
			cleanup() 
		end
	end)
	
	deathConn = char.Humanoid.Died:Connect(cleanup)
end

-- ===================== 介面開關事件對接 =====================

onof.MouseButton1Down:Connect(function()
	enabled = not enabled
	if enabled then
		onof.Text = "無敵 : 開啟"
		onof.BackgroundColor3 = Color3.fromRGB(79, 255, 152) -- 開啟時變綠色提示
		enableGodmode()
	else
		onof.Text = "無敵 : 關閉"
		onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74) -- 關閉時還原黃色
		cleanup()
	end
end)

closebutton.MouseButton1Click:Connect(function()
	cleanup()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	onof.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position = UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	onof.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position = UDim2.new(0, 0, -1, 27)
end)

player.CharacterAdded:Connect(function()
	task.wait(0.7)
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.PlatformStand = false
	end
	if char:FindFirstChild("Animate") then
		char.Animate.Disabled = false
	end
	if enabled then
		enableGodmode()
	end
end)
