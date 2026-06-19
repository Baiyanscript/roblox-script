-- =================================================================
-- 🤖 GOD MODE SYSTEM V3 (全新手工打造 · 防重疊精緻彩色版)
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- 核心狀態變數
local isEnabled = false
local isGodmodeActive = false
local ghostClone, heartbeatConn, noclipConn, deathConn
local lastPromptTime = 0

-- =================================================================
-- 🎨 UI 基礎實例與排版建構 (100% 重新計算防重疊坐標)
-- =================================================================

local main = Instance.new("ScreenGui")
main.Name = "GodModeGui_V3"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- 主背景框架 (精簡輕量化)
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137) -- 招牌亮綠色
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.BorderSizePixel = 1
Frame.Position = UDim2.new(0.1, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 180, 0, 70) -- 固定寬高，完美承載內部元件
Frame.Active = true
Frame.Draggable = true

-- 粉色標題列 (固定於頂部，絕不跑位)
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TitleLabel"
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255) -- 復古粉色
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 26) -- 高度固定 26 像素
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "無敵UI介面V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 14
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

-- 黃色無敵主開關 (獨立下半部區域，與標題隔離 8 像素安全間距)
local onof = Instance.new("TextButton")
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74) -- 鮮豔黃色
onof.BorderSizePixel = 0
onof.Position = UDim2.new(0.05, 0, 0, 34) -- 從 34 像素開始渲染，完美避開頂部
onof.Size = UDim2.new(0.9, 0, 0, 28)     -- 高度 28 像素
onof.Font = Enum.Font.SourceSansBold
onof.Text = "無敵 : 關閉"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 15

-- =================================================================
-- 📌 右上角小工具鈕群 (改用正向相對坐標排版，徹底防重疊)
-- =================================================================

-- 關閉按鈕 (X) -> 置於主框架右上方外側
local closebutton = Instance.new("TextButton")
closebutton.Name = "CloseButton"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0) -- 警告紅
closebutton.Size = UDim2.new(0, 30, 0, 22)
closebutton.Position = UDim2.new(1, -30, 0, -24) -- 精準排列於頂部右側
closebutton.Font = Enum.Font.SourceSansBold
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16

-- 最小化按鈕 (-) -> 置於關閉按鈕左側，寬度固定，絕不互撞
local mini = Instance.new("TextButton")
mini.Name = "MinimizeButton"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230) -- 淡紫色
mini.Size = UDim2.new(0, 30, 0, 22)
mini.Position = UDim2.new(1, -64, 0, -24) -- 中間預留 4 像素安全空隙
mini.Font = Enum.Font.SourceSansBold
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 18

-- 最大化還原鈕 (+) -> 重疊於最小化按鈕位置，由代碼控制顯示隱藏
local mini2 = Instance.new("TextButton")
mini2.Name = "MaximizeButton"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Size = UDim2.new(0, 30, 0, 22)
mini2.Position = UDim2.new(1, -64, 0, -24)
mini2.Font = Enum.Font.SourceSansBold
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255, 255, 255)
mini2.TextSize = 18
mini2.Visible = false

-- =================================================================
-- ⚡ GODMODE 無敵核心後台邏輯
-- =================================================================

local function characterCleanup()
	isGodmodeActive = false
	if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	if deathConn then deathConn:Disconnect() deathConn = nil end
	
	local char = player.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root and ghostClone and ghostClone:FindFirstChild("HumanoidRootPart") then 
			root.CFrame = ghostClone.HumanoidRootPart.CFrame 
		end
		if char:FindFirstChild("Humanoid") then 
			char.Humanoid.PlatformStand = false 
			camera.CameraSubject = char.Humanoid 
		end
	end
	if ghostClone then ghostClone:Destroy() ghostClone = nil end
end

local function startGodmode()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
	
	characterCleanup()
	isGodmodeActive = true
	
	-- 建立分身軀殼
	char.Archivable = true
	ghostClone = char:Clone()
	ghostClone.Name = "God_GhostDecoy"
	ghostClone.Parent = Workspace
	char.Archivable = false
	
	-- 設定分身半透明外觀與碰撞體
	for _, part in pairs(ghostClone:GetDescendants()) do
		if part:IsA("BasePart") then
			if part.Name:lower():find("root") or part.Name:lower():find("collision") then
				part.Transparency = 0.5
			else
				part.Transparency = 0
			end
			part.CanCollide = true
		elseif part:IsA("Decal") or part:IsA("Texture") then
			part.Transparency = 0
		end
	end

	if char:FindFirstChild("Animate") then 
		char.Animate:Clone().Parent = ghostClone 
	end
	
	char.Humanoid.PlatformStand = true
	camera.CameraSubject = ghostClone.Humanoid
	
	-- 真身動態無條件穿牆 (Noclip)
	noclipConn = RunService.Stepped:Connect(function()
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)

	-- 分身同步操作與遠程交互優化
	heartbeatConn = RunService.Heartbeat:Connect(function()
		if ghostClone and ghostClone:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
			local moveDirection = char.Humanoid.MoveDirection
			ghostClone.Humanoid:Move(moveDirection, false)
			ghostClone.Humanoid.Jump = char.Humanoid.Jump
			
			if moveDirection.Magnitude > 0 then
				local targetHeading = CFrame.lookAt(ghostClone.HumanoidRootPart.Position, ghostClone.HumanoidRootPart.Position + moveDirection)
				ghostClone.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame:Lerp(targetHeading, 0.25)
			end
			
			-- 自動提升周圍 ProximityPrompt 的點擊範圍與無限制
			if tick() - lastPromptTime > 0.5 then
				for _, prompt in pairs(Workspace:GetDescendants()) do
					if prompt:IsA("ProximityPrompt") then
						prompt.MaxActivationDistance = 25
						prompt.RequiresLineOfSight = false
					end
				end
				lastPromptTime = tick()
			end
			
			-- 地底安全隔離真身 (實現完美無敵)
			char.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
			char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		else 
			characterCleanup() 
		end
	end)
	
	deathConn = char.Humanoid.Died:Connect(characterCleanup)
end

-- =================================================================
-- 互動事件綁定
-- =================================================================

-- 無敵主開關
onof.MouseButton1Down:Connect(function()
	isEnabled = not isEnabled
	if isEnabled then
		onof.Text = "無敵 : 開啟"
		onof.BackgroundColor3 = Color3.fromRGB(79, 255, 152) -- 開啟時切換至亮綠色提示
		startGodmode()
	else
		onof.Text = "無敵 : 關閉"
		onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74) -- 關閉時還原黃色
		characterCleanup()
	end
end)

-- 關閉 UI 按鈕
closebutton.MouseButton1Click:Connect(function()
	characterCleanup()
	main:Destroy()
end)

-- 最小化控制
mini.MouseButton1Click:Connect(function()
	onof.Visible = false
	mini.Visible = false
	mini2.Visible = true
	Frame.BackgroundTransparency = 1
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextTransparency = 1
	Frame.BorderSizePixel = 0
end)

-- 最大化還原控制
mini2.MouseButton1Click:Connect(function()
	onof.Visible = true
	mini.Visible = true
	mini2.Visible = false
	Frame.BackgroundTransparency = 0
	TextLabel.BackgroundTransparency = 0
	TextLabel.TextTransparency = 0
	Frame.BorderSizePixel = 1
end)

-- 玩家重生自動防卡死與續裝
player.CharacterAdded:Connect(function()
	task.wait(0.7)
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
	if char and char:FindFirstChild("Animate") then char.Animate.Disabled = false end
	if isEnabled then startGodmode() end
end)

-- 提示執行成功
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "無敵UI介面V3",
	Text = "重新製作完成！BY Baiyan",
	Icon = ""
})
