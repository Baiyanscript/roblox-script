-- =================================================================
-- ✈️ FLY UI SYSTEM V3 (保持原版飛行邏輯 · 僅優化 UI 與加減輸入框)
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 核心狀態變數 (飛行速度預設 16)
local currentFlySpeed = 16
local flyEnabled = false
local flyConnection = nil

-- =================================================================
-- 🎨 UI 基礎實例與排版建構 (精準像素定位，徹底防重疊)
-- =================================================================

local main = Instance.new("ScreenGui")
main.Name = "FlyGui_V3"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- 主背景框架
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137) -- 亮綠色
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.BorderSizePixel = 1
Frame.Position = UDim2.new(0.1, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 180, 0, 100) -- 高度 100 像素
Frame.Active = true
Frame.Draggable = true

-- 粉色標題列
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TitleLabel"
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255) -- 復古粉色
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 26) 
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "無敵UI介面V3" -- 保持原標題文字
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 14
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

-- 黃色飛行功能主開關
local onof = Instance.new("TextButton")
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74) -- 預設黃色 (關閉)
onof.BorderSizePixel = 0
onof.Position = UDim2.new(0.05, 0, 0, 34) 
onof.Size = UDim2.new(0.9, 0, 0, 26)     
onof.Font = Enum.Font.SourceSansBold
onof.Text = "飛行功能 : 關閉"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14

-- =================================================================
-- 🛠️ 飛行速度調整組 (左減、中輸入、右加，位置完全固定，絕不重疊)
-- =================================================================

-- 速度「減」按鈕
local decSpeed = Instance.new("TextButton")
decSpeed.Name = "DecreaseSpeed"
decSpeed.Parent = Frame
decSpeed.BackgroundColor3 = Color3.fromRGB(240, 100, 100) -- 淡紅
decSpeed.BorderSizePixel = 0
decSpeed.Position = UDim2.new(0, 9, 0, 66) 
decSpeed.Size = UDim2.new(0, 30, 0, 26)
decSpeed.Font = Enum.Font.SourceSansBold
decSpeed.Text = "-"
decSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
decSpeed.TextSize = 20

-- 速度【打字輸入框】(可直接點擊打字修改數字)
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Parent = Frame
speedInput.BackgroundColor3 = Color3.fromRGB(79, 255, 152) -- 亮綠
speedInput.BorderSizePixel = 0
speedInput.Position = UDim2.new(0, 43, 0, 66) 
speedInput.Size = UDim2.new(0, 94, 0, 26)
speedInput.Font = Enum.Font.SourceSansBold
speedInput.Text = tostring(currentFlySpeed)
speedInput.TextColor3 = Color3.fromRGB(0, 0, 0)
speedInput.TextSize = 14
speedInput.ClearTextOnFocus = false

-- 速度「加」按鈕
local incSpeed = Instance.new("TextButton")
incSpeed.Name = "IncreaseSpeed"
incSpeed.Parent = Frame
incSpeed.BackgroundColor3 = Color3.fromRGB(100, 210, 240) -- 淡藍
incSpeed.BorderSizePixel = 0
incSpeed.Position = UDim2.new(0, 141, 0, 66) 
incSpeed.Size = UDim2.new(0, 30, 0, 26)
incSpeed.Font = Enum.Font.SourceSansBold
incSpeed.Text = "+"
incSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
incSpeed.TextSize = 18

-- =================================================================
-- 📌 右上角控制鈕群 (外側絕對坐標，防止跑位)
-- =================================================================

-- 關閉按鈕 (X)
local closebutton = Instance.new("TextButton")
closebutton.Name = "CloseButton"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0) 
closebutton.Size = UDim2.new(0, 30, 0, 22)
closebutton.Position = UDim2.new(1, -30, 0, -24) 
closebutton.Font = Enum.Font.SourceSansBold
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16

-- 最小化按鈕 (-)
local mini = Instance.new("TextButton")
mini.Name = "MinimizeButton"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230) 
mini.Size = UDim2.new(0, 30, 0, 22)
mini.Position = UDim2.new(1, -64, 0, -24) 
mini.Font = Enum.Font.SourceSansBold
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 18

-- 最大化還原鈕 (+)
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
-- ⚡ FLY 核心功能邏輯 (完全保留原版飛行算法，不作變動)
-- =================================================================

local function updateSpeedUI()
	speedInput.Text = tostring(currentFlySpeed)
end

local function disableFly()
	flyEnabled = false
	onof.Text = "飛行功能 : 關閉"
	onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
	
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
		char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		char.Humanoid.PlatformStand = false
	end
end

local function enableFly()
	disableFly()
	flyEnabled = true
	onof.Text = "飛行功能 : 開啟"
	onof.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
	
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
	
	local root = char.HumanoidRootPart
	local humanoid = char.Humanoid
	humanoid.PlatformStand = true
	
	-- 原版飛行心跳連線邏輯
	flyConnection = RunService.Heartbeat:Connect(function()
		if char and root and humanoid and flyEnabled then
			local moveDirection = humanoid.MoveDirection
			local cameraCFrame = workspace.CurrentCamera.CFrame
			local flyVelocity = Vector3.new(0, 0, 0)
			
			if moveDirection.Magnitude > 0 then
				flyVelocity = cameraCFrame:VectorToWorldSpace(Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit * currentFlySpeed)
			end
			
			root.Velocity = Vector3.new(flyVelocity.X, 0, flyVelocity.Z)
		else
			disableFly()
		end
	end)
end

-- =================================================================
-- 互動事件與動態縮小排版綁定
-- =================================================================

-- 飛行主開關
onof.MouseButton1Down:Connect(function()
	if flyEnabled then
		disableFly()
	else
		enableFly()
	end
end)

-- 【文字輸入框】直接打字輸入速度事件
speedInput.FocusLost:Connect(function(enterPressed)
	local inputNum = tonumber(speedInput.Text)
	if inputNum then
		currentFlySpeed = math.clamp(inputNum, 0, 1000)
	else
		currentFlySpeed = 16
	end
	updateSpeedUI()
end)

-- 速度「加」按鈕
incSpeed.MouseButton1Click:Connect(function()
	currentFlySpeed = math.min(1000, currentFlySpeed + 10)
	updateSpeedUI()
end)

-- 速度「減」按鈕
decSpeed.MouseButton1Click:Connect(function()
	currentFlySpeed = math.max(0, currentFlySpeed - 10)
	updateSpeedUI()
end)

-- 關閉 UI 按鈕
closebutton.MouseButton1Click:Connect(function()
	disableFly()
	main:Destroy()
end)

-- 最小化點擊：隱藏下方元件，標題移動到控制鈕左側
mini.MouseButton1Click:Connect(function()
	onof.Visible = false
	decSpeed.Visible = false
	speedInput.Visible = false
	incSpeed.Visible = false
	mini.Visible = false
	mini2.Visible = true
	
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	
	TextLabel.Position = UDim2.new(1, -164, 0, -24) 
	TextLabel.Size = UDim2.new(0, 96, 0, 22)         
end)

-- 最大化還原點擊
mini2.MouseButton1Click:Connect(function()
	onof.Visible = true
	decSpeed.Visible = true
	speedInput.Visible = true
	incSpeed.Visible = true
	mini.Visible = true
	mini2.Visible = false
	
	Frame.BackgroundTransparency = 0
	Frame.BorderSizePixel = 1
	
	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.Size = UDim2.new(1, 0, 0, 26)
end)

-- 玩家重生防卡死處理
player.CharacterAdded:Connect(function()
	disableFly()
end)

-- 提示執行成功
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "Fly 腳本外觀優化",
	Text = "原版飛行邏輯不變，UI與輸入框已升級！",
	Icon = ""
})
