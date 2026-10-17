-- ============================================
-- LennonHub (UI Unchanged) + yslemEgg (Instant TP Logic)
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local networking = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")

------------------------------------------------------------------
-- 1. yslemEgg 核心配置與模組加載
------------------------------------------------------------------
local CFG = {
	SpeedCap = 1.15,
	HopRatio = 1.515,
	HopMin = 40,
	HopGap = 0.06,
	HopGapMin = 0.06,
	HopGapMax = 0.2,
	HopRetries = 6,
	HopLift = 42,
	LandOffset = 14,
	LandSettle = 0.08,
	DropDelay = 0.05,
	GrabInterval = 0.03,
	RegrabFar = 40,
	Height = 70,
	ClimbShare = 0.5,
	CarryRatio = 0.9,
	EasyRatio = 1.3,
}
local FPS = { 60, 30, 0.15 }

local function safeRequire(getter)
	local ok, result = pcall(function() return require(getter()) end)
	return ok and result or nil
end

local EggState = safeRequire(function() return ReplicatedStorage.Client.EggState end)
local Assets = safeRequire(function() return ReplicatedStorage.Data.Assets end)
local Mutations = safeRequire(function() return ReplicatedStorage.Shared.Modules.Mutations end)
local Rarity = safeRequire(function() return ReplicatedStorage.Data.Rarity end)
local AreaEggCycle = safeRequire(function() return ReplicatedStorage.Shared.Util.AreaEggCycle end)
local AssetViewport = safeRequire(function() return ReplicatedStorage.Client.AssetViewport end)

local function remote(name)
	return networking:FindFirstChild(name)
end

local function root()
	local character = localPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

------------------------------------------------------------------
-- 2. Shield Logic (Humanoid Swap 防護盾)
------------------------------------------------------------------
local shield = { Original = nil, Clone = nil, Links = {}, Connection = nil, Added = nil }

local function walkSpeed()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local speed = humanoid and humanoid.WalkSpeed or 16
	if shield.Original and shield.Original.Health > 0 then
		speed = math.min(speed, shield.Original.WalkSpeed)
	end
	local ok, result = pcall(function()
		local stat = localPlayer:FindFirstChild("leaderstats")
		stat = stat and stat:FindFirstChild("Speed")
		local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
		return stat and util.SpeedPowerToWalkSpeed(stat.Value) or nil
	end)
	if ok and type(result) == "number" and result > 0 then
		speed = math.min(speed, result)
	end
	return speed
end

local function shieldControls(humanoid)
	pcall(function()
		local scripts = localPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if type(controls) == "table" then controls.humanoid = humanoid end
		end
	end)
end

local function shieldAnimate(character)
	local animate = character and character:FindFirstChild("Animate")
	if animate and animate:IsA("LocalScript") then
		task.spawn(function()
			animate.Enabled = false
			task.wait()
			animate.Enabled = true
		end)
	end
end

local function shieldUnlink()
	for _, link in ipairs(shield.Links) do pcall(function() link:Disconnect() end) end
	table.clear(shield.Links)
end

local groundedStates = {
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.RunningNoPhysics] = true,
	[Enum.HumanoidStateType.Landed] = true,
}

local function grounded(humanoid)
	if not humanoid or humanoid.Health <= 0 or humanoid.FloorMaterial == Enum.Material.Air then return false end
	return groundedStates[humanoid:GetState()] == true
end

local function shieldSwap()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 or (shield.Clone and shield.Clone.Parent == character) or not grounded(humanoid) then return end

	local clone = humanoid:Clone()
	humanoid.Parent = nil
	clone.Parent = character
	workspace.CurrentCamera.CameraSubject = clone
	shieldControls(clone)
	shieldAnimate(character)
	shield.Original = humanoid
	shield.Clone = clone

	table.insert(shield.Links, humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if clone.Parent ~= nil then clone.WalkSpeed = humanoid.WalkSpeed end
	end))

	local animator = humanoid:FindFirstChildOfClass("Animator")
	local animator2 = clone:FindFirstChildOfClass("Animator")
	if animator and animator2 then
		table.insert(shield.Links, animator.AnimationPlayed:Connect(function(played)
			local animation = played.Animation
			if not animation or clone.Parent == nil then return end
			local ok, track = pcall(function() return animator2:LoadAnimation(animation) end)
			if not ok or not track then return end
			pcall(function()
				track.Priority = played.Priority
				track.Looped = played.Looped
				track:Play(0.05, math.max(played.WeightTarget, 0.01), played.Speed)
			end)
			local stopped
			stopped = played.Stopped:Connect(function()
				stopped:Disconnect()
				pcall(function() track:Stop(0.1) end)
			end)
		end))
	end

	table.insert(shield.Links, clone.Died:Connect(function()
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		local current = localPlayer.Character
		if current and humanoid.Parent == nil then
			humanoid.Parent = current
			workspace.CurrentCamera.CameraSubject = humanoid
			shieldControls(humanoid)
		end
		pcall(function() clone:Destroy() end)
		humanoid.Health = 0
	end))
end

local function shieldUndo()
	shieldUnlink()
	local character = localPlayer.Character
	local original, clone = shield.Original, shield.Clone
	shield.Original, shield.Clone = nil, nil
	if original and clone and character and original.Parent == nil and clone.Parent == character then
		original.Parent = character
		workspace.CurrentCamera.CameraSubject = original
		shieldControls(original)
		pcall(function() clone:Destroy() end)
		shieldAnimate(character)
	end
end

local function shieldStart()
	shieldSwap()
	local n = 0
	shield.Connection = RunService.Heartbeat:Connect(function(dt)
		n += dt
		local character = localPlayer.Character
		local missing = not (shield.Clone and character and shield.Clone.Parent == character)
		if (missing and 0.25 or 3) <= n then
			n = 0
			shieldSwap()
		end
	end)
	shield.Added = localPlayer.CharacterAdded:Connect(function(character)
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			task.wait(1)
			if shield.Connection and localPlayer.Character == character then shieldSwap() end
		end)
	end)
end

local function shieldStop()
	if shield.Connection then shield.Connection:Disconnect() shield.Connection = nil end
	if shield.Added then shield.Added:Disconnect() shield.Added = nil end
	shieldUndo()
end

------------------------------------------------------------------
-- 3. Carry State & Base Logic
------------------------------------------------------------------
local state = { Carrying = false, Uid = nil, Delivered = 0, Busy = false, Cancel = false, Mult = 1, PulledAt = 0, HeldSeen = 0, GuessedDrop = false }

if type(EggState) == "table" and type(EggState.CarryChanged) == "table" and type(EggState.CarryChanged.Connect) == "function" then
	EggState.CarryChanged:Connect(function(arg)
		local carrying = type(arg) == "table" and arg.IsCarrying == true
		if carrying and arg.GuardDisabled == true then carrying = false end
		state.GuessedDrop = false
		if carrying then state.HeldSeen = os.clock() end
		if carrying and type(arg.Uid) == "string" then
			state.Uid = arg.Uid
			local mult = tonumber(arg.SpeedMultiplier)
			if mult and mult > 0 then state.Mult = mult end
		end
		state.Carrying = carrying
	end)
end

pcall(function()
	remote("RE/EggWorld/FieldEggRedeemVerdict").OnClientEvent:Connect(function() state.Delivered = os.clock() end)
	remote("RE/RigSync/Refresh").OnClientEvent:Connect(function(arg)
		if type(arg) == "table" and arg.Action == "Relocate" then state.PulledAt = os.clock() end
	end)
end)

local function takeEgg(uid)
	if type(uid) == "string" and type(EggState) == "table" and type(EggState.CarryFieldEgg) == "function" then
		pcall(EggState.CarryFieldEgg, uid)
	end
end

local function dropEgg()
	if type(EggState) == "table" and type(EggState.DropFieldEgg) == "function" then
		pcall(EggState.DropFieldEgg, "PlayerRequest")
	end
end

local function promptNear(position, radius)
	local best, bestDistance = nil, radius
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
			local prompt = child:FindFirstChild("CarryAreaEgg")
			if prompt and prompt:IsA("ProximityPrompt") then
				local distance = (child.Position - position).Magnitude
				if distance < bestDistance then best, bestDistance = prompt, distance end
			end
		end
	end
	return best
end

local function heldByMe(uid)
	local character = localPlayer.Character
	if type(uid) ~= "string" or not character then return false end
	local egg = workspace:FindFirstChild(uid)
	if not egg then return false end
	for _, d in ipairs(egg:GetDescendants()) do
		if d:IsA("WeldConstraint") or d:IsA("JointInstance") then
			local ok, a, b = pcall(function() return d.Part0, d.Part1 end)
			if ok and ((a and a:IsDescendantOf(character)) or (b and b:IsDescendantOf(character))) then return true end
		end
	end
	return false
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if not state.Carrying then
			if state.GuessedDrop and heldByMe(state.Uid) then
				state.GuessedDrop, state.Carrying, state.HeldSeen = false, true, os.clock()
			end
		elseif heldByMe(state.Uid) then
			state.HeldSeen = os.clock()
		elseif os.clock() - state.HeldSeen > 0.8 then
			state.Carrying, state.GuessedDrop = false, true
		end
	end
end)

local function snapshot()
	local list = {}
	local ok, result = pcall(function() return remote("RF/EggWorld/AskFieldEggSnapshot"):InvokeServer() end)
	local records = ok and type(result) == "table" and result.Records or nil
	if type(records) ~= "table" then return list end
	for _, record in pairs(records) do
		if type(record) == "table" and type(record.Uid) == "string" and (record.State == "Slot" or record.State == "Dropped") and typeof(record.BottomCFrame) == "CFrame" then
			list[#list + 1] = record
		end
	end
	return list
end

local function eggPosition(uid)
	for _, record in ipairs(snapshot()) do
		if record.Uid == uid then return record.BottomCFrame.Position end
	end
	return nil
end

------------------------------------------------------------------
-- 4. Instant TP 核心偷蛋邏輯
------------------------------------------------------------------
local fpsGen = 0
local function fpsOn()
	if typeof(setfpscap) ~= "function" then return end
	fpsGen += 1
	local mine = fpsGen
	task.spawn(function()
		local high = true
		local started = os.clock()
		while fpsGen == mine and os.clock() - started < 60 do
			pcall(setfpscap, high and FPS[1] or FPS[2])
			high = not high
			task.wait(FPS[3])
		end
	end)
end

local function fpsOff()
	fpsGen += 1
	if typeof(setfpscap) == "function" then pcall(setfpscap, 240) end
end

local function frozenCamera()
	local camera = workspace.CurrentCamera
	if not camera then return function() end end
	local oldType = camera.CameraType
	local frameCF = camera.CFrame
	pcall(function()
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = frameCF
	end)
	return function() pcall(function() camera.CameraType = oldType end) end
end

local stealClone = nil
local function dropClone()
	local copy = stealClone
	stealClone = nil
	if copy then pcall(function() copy:Destroy() end) end
end

local function postClone()
	dropClone()
	local character = localPlayer.Character
	if not character then return end
	local was = character.Archivable
	character.Archivable = true
	local copy = character:Clone()
	character.Archivable = was
	if copy then
		for _, d in ipairs(copy:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("Humanoid") then
				pcall(function() d:Destroy() end)
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
			end
		end
		copy.Name = "Clone"
		copy.Parent = workspace
		stealClone = copy
	end
end

local function lineInfo()
	local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	world = world and world:FindFirstChild("Areas")
	world = world and world:FindFirstChild("SeparationLine")
	local ok = world and world:IsA("BasePart")
	return ok and world.Position.X or 552.2, ok and world.Position.Y or 67.67
end

local function homePoint()
	for _, def in ipairs({
		{ { "GearGiver_Slap", "Podium" }, Vector3.new(-16.415, 21.072, -6.106) },
		{ { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
		{ { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
	}) do
		local node = workspace
		for _, name in ipairs(def[1]) do node = node and node:FindFirstChild(name) or nil end
		if node and node:IsA("BasePart") then return node.CFrame:PointToWorldSpace(def[2]) end
	end
	return Vector3.new(528.7, 70.57, -364.11)
end

local function place(position)
	local r = root()
	if not r then return end
	pcall(function()
		r.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0)
		r.AssemblyLinearVelocity = Vector3.zero
		r.AssemblyAngularVelocity = Vector3.zero
	end)
end

local dangerCache, dangerAt = {}, 0
local function dangers()
	if os.clock() - dangerAt < 1 then return dangerCache end
	dangerAt = os.clock()
	local list = {}
	local function add(inst)
		local ok, cf, size = pcall(function()
			if inst:IsA("Model") then return inst:GetBoundingBox()
			elseif inst:IsA("BasePart") then return inst.CFrame, inst.Size end
		end)
		if ok and cf and size then
			local half = Vector3.new(math.abs(size.X), 0, math.abs(size.Z)) * 0.5
			local rot = (cf - cf.Position):VectorToWorldSpace(half)
			local rx = math.max(math.abs(rot.X), half.X, half.Z)
			local rz = math.max(math.abs(rot.Z), half.X, half.Z)
			list[#list + 1] = { MinX = cf.Position.X - rx, MaxX = cf.Position.X + rx, MinZ = cf.Position.Z - rz, MaxZ = cf.Position.Z + rz }
		end
	end
	local function bad(name)
		if name == "ScrambleLocalVisuals" or name == "DrScrambleEvent" then return false end
		name = string.lower(name)
		return string.find(name, "portal", 1, true) or string.find(name, "teleport", 1, true) or string.find(name, "mech", 1, true) or string.find(name, "arena", 1, true) or string.find(name, "scramble", 1, true)
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if (child:IsA("Model") or child:IsA("BasePart") or child:IsA("Folder")) and bad(child.Name) then
			if child:IsA("Folder") then
				for _, inner in ipairs(child:GetChildren()) do add(inner) end
			else add(child) end
		end
	end
	dangerCache = list
	return list
end

local function avoid(from, to)
	for _, d in ipairs(dangers()) do
		local x0, x1, z0, z1 = d.MinX - 12, d.MaxX + 12, d.MinZ - 12, d.MaxZ + 12
		if not (from.X >= x0 and from.X <= x1 and from.Z >= z0 and from.Z <= z1) then
			local t0, t1, hit = 0, 1, true
			for _, axis in ipairs({ { from.X, to.X - from.X, x0, x1 }, { from.Z, to.Z - from.Z, z0, z1 } }) do
				local pos, delta, lo, hi = axis[1], axis[2], axis[3], axis[4]
				if math.abs(delta) < 1e-6 then
					if pos < lo or pos > hi then hit = false end
				else
					local ta, tb = (lo - pos) / delta, (hi - pos) / delta
					if ta > tb then ta, tb = tb, ta end
					t0, t1 = math.max(t0, ta), math.min(t1, tb)
					if t0 > t1 then hit = false end
				end
			end
			if hit then
				local zLow, zHigh = z0 - 2, z1 + 2
				local z = math.abs(from.Z - zLow) <= math.abs(from.Z - zHigh) and zLow or zHigh
				if z < -440 or z > -290 then z = z == zLow and zHigh or zLow end
				local x = math.abs(from.X - x0) <= math.abs(from.X - x1) and x0 or x1
				if math.abs(from.Z - z) < 3 then x = math.abs(to.X - x0) <= math.abs(to.X - x1) and x0 or x1 end
				return Vector3.new(x, to.Y, z)
			end
		end
	end
	return to
end

local function runToEgg(uid, egg)
	local lineX = lineInfo()
	local home = homePoint()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		if character:FindFirstChildWhichIsA("Tool") then pcall(function() humanoid:UnequipTools() end) end
	end

	local r = root()
	if not r then return false end
	local stage = "field"
	if r.Position.X < lineX - 2 and Vector3.new(r.Position.X - home.X, 0, r.Position.Z - home.Z).Magnitude > 20 then stage = "safe" end

	local started, lastCheck, lastPos, lastTake = os.clock(), os.clock(), r.Position, 0
	while os.clock() - started < 120 and not state.Cancel do
		r = root()
		if not r then return false end
		local flatEgg = Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z)
		if stage == "field" and flatEgg.Magnitude <= 2.5 then break end
		local target = egg
		if stage == "safe" then
			if Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude <= 6 then stage = "field" else target = home end
		end

		local waypoint = avoid(r.Position, target)
		local flat = Vector3.new(waypoint.X - r.Position.X, 0, waypoint.Z - r.Position.Z)
		local unit = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
		local speed = math.max(walkSpeed() * CFG.SpeedCap, 8)
		local v = unit * math.min(speed, flat.Magnitude / 0.05)
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, r.AssemblyLinearVelocity.Y, v.Z)
			if humanoid and unit.Magnitude > 0 then humanoid:Move(unit, false) end
		end)

		if os.clock() - lastCheck >= 1.5 then
			if (r.Position - lastPos).Magnitude < 3 and humanoid and flatEgg.Magnitude > 15 then pcall(function() humanoid.Jump = true end) end
			lastPos, lastCheck = r.Position, os.clock()
		end

		if stage == "field" and flatEgg.Magnitude <= 9 and os.clock() - lastTake > 0.1 then
			lastTake = os.clock()
			takeEgg(uid)
		end
		RunService.Heartbeat:Wait()
	end

	r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			if humanoid then humanoid:Move(Vector3.zero, false) end
		end)
	end
	return state.Carrying or (r ~= nil and Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z).Magnitude <= 6)
end

local function eggNow(uid, cache)
	local node = workspace:FindFirstChild(uid)
	local slots = workspace:FindFirstChild("AreaEggSlotsClient")
	node = node or (slots and slots:FindFirstChild(uid))
	if node then
		local ok, pos = pcall(function() return node:GetPivot().Position end)
		if ok and pos then
			cache.Pos, cache.At = pos, os.clock()
			return pos
		end
	end
	if os.clock() - cache.At >= 0.5 then
		cache.At = os.clock()
		cache.Pos = eggPosition(uid) or cache.Pos
	end
	return cache.Pos
end

local function grab(uid, timeout)
	local cache = { At = 0 }
	local waited, since = 0, 1
	while not state.Carrying and waited < timeout and not state.Cancel do
		local r = root()
		local egg = eggNow(uid, cache)
		local dt = math.max(RunService.Heartbeat:Wait(), 1 / 240)
		waited += dt
		since += dt
		if r and egg then
			local delta = egg - r.Position
			if delta.Magnitude > 2 then
				local pace = math.max(walkSpeed() * CFG.SpeedCap, 16)
				local v = delta / math.max(0.08, dt)
				if v.Magnitude > pace then v = v.Unit * pace end
				pcall(function()
					r.AssemblyLinearVelocity = v + Vector3.new(0, workspace.Gravity * dt * 0.5, 0)
					r.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			if since >= CFG.GrabInterval then
				since = 0
				local prompt = promptNear(egg - Vector3.new(0, 3, 0), 10)
				if prompt and typeof(fireproximityprompt) == "function" then
					pcall(function() prompt.HoldDuration = 0 end)
					pcall(fireproximityprompt, prompt)
				end
				task.spawn(takeEgg, uid)
			end
		elseif since >= CFG.GrabInterval then
			since = 0
			task.spawn(takeEgg, uid)
		end
	end
	local r = root()
	if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
	return state.Carrying and state.Uid == uid
end

local function regrab(uid)
	if state.Carrying then return true end
	local r = root()
	local egg = eggPosition(uid)
	if r and egg and Vector3.new(r.Position.X - egg.X, 0, r.Position.Z - egg.Z).Magnitude > CFG.RegrabFar then
		place(egg + Vector3.new(0, 3, 0))
	end
	return grab(uid, 3)
end

local function groundY(position, fallback)
	local y = fallback
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { localPlayer.Character }
		params.IgnoreWater = true
		local hit = workspace:Raycast(position + Vector3.new(0, 60, 0), Vector3.new(0, -140, 0), params)
		if hit and hit.Material ~= Enum.Material.Water and math.abs(hit.Position.Y - fallback) < 40 then
			y = hit.Position.Y + 3.5
		end
	end)
	return y
end

local function carrySpeed(distance)
	local ws = walkSpeed()
	local base = ws * math.min(CFG.CarryRatio, CFG.SpeedCap) * state.Mult
	local fast = base * 1.5
	local excess = 5.5 * base
	local limit = fast
	if distance and distance > excess then limit = math.min(fast, base * distance / (distance - excess)) end
	return math.min(math.max(math.min(base * CFG.EasyRatio, limit), base), math.max(ws * CFG.SpeedCap, base))
end

local function runHome(lineX, laneZ)
	local started = os.clock()
	local home = homePoint()
	local checkpoint = lineX - 7
	local height = CFG.Height
	local share = math.clamp(CFG.ClimbShare, 0.1, 0.9)
	local descent = height * math.sqrt(1 - share * share) / share
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.PlatformStand = false end

	local r = root()
	if r and character and height > 0.5 and home.Y + height - 2 > r.Position.Y then
		pcall(function()
			character:PivotTo(CFrame.new(Vector3.new(r.Position.X, home.Y + height, r.Position.Z)) * r.CFrame.Rotation)
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	local start = root()
	local speed = carrySpeed(start and (Vector3.new(start.Position.X - home.X, 0, start.Position.Z - home.Z).Magnitude + math.max(0, height) * 2) or nil)

	local last = os.clock()
	local timeout = 0
	while state.Carrying and state.Delivered < started and not state.Cancel and timeout < 25 do
		r = root()
		if not r then return false end
		local now = os.clock()
		local dt = math.max(now - last, 1 / 240)
		last = now
		timeout += dt

		local toHome = r.Position.X <= checkpoint + 2
		local target = toHome and home or Vector3.new(checkpoint, home.Y, laneZ)
		if toHome and Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude < 2 then break end
		local aim = avoid(r.Position, target)
		local flat = Vector3.new(aim.X - r.Position.X, 0, aim.Z - r.Position.Z)
		local remaining = toHome and 0 or math.max(0, r.Position.X - checkpoint)
		local wantY = home.Y + height
		if toHome or remaining <= descent then wantY = home.Y + height * math.clamp(remaining / math.max(descent, 1), 0, 1) end
		local vy = math.clamp((wantY - r.Position.Y) / 0.12, -speed * share, speed * share)
		local horizontal = math.sqrt(math.max(speed * speed - vy * vy, 0))
		local v = flat.Magnitude > 0.01 and flat.Unit * math.min(horizontal, flat.Magnitude / 0.05) or Vector3.zero
		pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z) end)
		RunService.Heartbeat:Wait()
	end

	if humanoid then pcall(function() humanoid:Move(Vector3.zero, false) end) end

	local settle = 0
	while settle < 2 and state.Delivered < started and state.Carrying and not state.Cancel do
		settle += RunService.Heartbeat:Wait()
	end
	if state.Carrying and state.Delivered < started and not state.Cancel then
		task.wait(0.2)
		dropEgg()
		local waited = 0
		while state.Delivered < started and waited < 1 do waited += RunService.Heartbeat:Wait() end
	end
	return state.Delivered >= started
end

local function instantTP(uid)
	local started = os.clock()
	local lineX, lineY = lineInfo()
	local r = root()
	if not r then return false end
	local laneZ = math.clamp(r.Position.Z, -425, -300)
	local landing = Vector3.new(lineX + CFG.LandOffset, lineY + 3.35, laneZ)

	local hopStep = math.max(walkSpeed() * CFG.HopRatio, CFG.HopMin)
	local hopY = r.Position.Y + CFG.HopLift
	local x = r.Position.X
	local retries = 0
	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	pcall(postClone)
	fpsOn()

	while x - hopStep > landing.X and not state.Cancel do
		if not state.Carrying then
			if not regrab(uid) then break end
			local current = root()
			if current then x = math.min(x, current.Position.X) end
			continue
		end

		local nextX = x - hopStep
		local pulledBefore = state.PulledAt
		local held = 0
		while held < CFG.HopGap do
			place(Vector3.new(nextX, hopY, laneZ))
			held += RunService.Heartbeat:Wait()
		end

		local check = root()
		local pulled = state.PulledAt > pulledBefore or (check ~= nil and (check.Position.X - nextX > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and state.Carrying and not state.Cancel do
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.02)
			if retries > CFG.HopRetries then break end
			local settle = 0
			while settle < 0.12 and not state.Cancel do
				place(Vector3.new(x, hopY, laneZ))
				settle += RunService.Heartbeat:Wait()
			end
		else
			x = nextX
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
		end
	end

	landing = Vector3.new(landing.X, groundY(landing, landing.Y), landing.Z)
	local function land()
		local current = root()
		if current and current.Position.X <= landing.X + 1 and current.Position.Y > landing.Y - 25 then
			pcall(function() current.AssemblyLinearVelocity = Vector3.zero end)
			return
		end
		place(landing)
	end
	land()
	for attempt = 1, 3 do
		local settle = 0
		while settle < CFG.LandSettle and not state.Cancel do settle += RunService.Heartbeat:Wait() end
		local landed = root()
		if state.Carrying and landed and (landed.Position.X - landing.X > 12 or landed.Position.Y < landing.Y - 25) then
			land()
		else break end
	end
	dropClone()

	if state.Carrying and not state.Cancel do
		local delay = 0
		while delay < CFG.DropDelay do delay += RunService.Heartbeat:Wait() end
		dropEgg()
		local waited = 0
		while state.Carrying and waited < 1 and not state.Cancel do waited += RunService.Heartbeat:Wait() end
		local current = root()
		if current then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
				current.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		releaseCamera()
		dropClone()
		if not grab(uid, 3) and not regrab(uid) then
			fpsOff()
			return false
		end
		dropClone()
	end
	releaseCamera()

	local ok = false
	if state.Carrying then ok = runHome(lineX, laneZ) end
	fpsOff()
	return ok or state.Delivered >= started
end

local function stealAndDeliver(uid)
	if state.Busy then return end
	state.Busy = true
	state.Cancel = false
	task.spawn(function()
		local ok, err = pcall(function()
			local egg = eggPosition(uid)
			if not egg then return end
			if state.Carrying and state.Uid ~= uid then
				dropEgg()
				local waited = 0
				while state.Carrying and waited < 1 do waited += RunService.Heartbeat:Wait() end
			end
			fpsOn()
			if not runToEgg(uid, egg) then fpsOff() return end
			if not grab(uid, 4) then fpsOff() return end
			instantTP(uid)
		end)
		fpsOff()
		dropClone()
		if state.ReleaseCamera then
			pcall(state.ReleaseCamera)
			state.ReleaseCamera = nil
		end
		state.Busy = false
	end)
end

------------------------------------------------------------------
-- 5. 保留 LennonHub 原有 UI 界面 (完整結構 + 綁定 Instant TP 執行)
------------------------------------------------------------------
local tbl4 = {
	enabled = false,
	running = true,
	bestEgg = nil,
	selectedEgg = nil,
	selectedUid = nil,
	dropdownOpen = false,
	filteredEggs = {},
	rarityFilter = {},
	loopEnabled = false,
	lastRefresh = 0,
}

local tbl5 = {
	{ Key = "cosmic", Label = "Cosmic", Color = Color3.fromRGB(215, 90, 255) },
	{ Key = "secret", Label = "Secret", Color = Color3.fromRGB(255, 255, 255) },
	{ Key = "eternal", Label = "Eternal", Color = Color3.fromRGB(255, 220, 80) },
	{ Key = "divine", Label = "Divine", Color = Color3.fromRGB(80, 235, 235) },
}

local function normalizeRarityKey(arg)
	return string.lower(tostring(arg or "")):gsub("%s+", "")
end

local function isRarityFilterActive()
	for _, v in ipairs(tbl5) do
		if tbl4.rarityFilter[v.Key] then return true end
	end
	return false
end

local function eggMatchesRarityFilter(arg)
	if not isRarityFilterActive() then return true end
	return tbl4.rarityFilter[normalizeRarityKey(arg.RarityName)] == true
end

local function describe(record)
	local directory = type(Assets) == "table" and Assets.Directory or nil
	local entry = type(directory) == "table" and directory[tostring(record.AssetCategory)] or nil
	local info = { Uid = record.Uid, Category = tostring(record.AssetCategory), Name = tostring(record.AssetCategory), RarityName = "", RarityColor = Color3.fromRGB(170, 190, 178), Generation = 0 }

	if type(entry) == "table" then
		info.Name = tostring(entry.DisplayName or record.AssetCategory)
		if type(entry.Rarity) == "table" then
			info.RarityName = entry.Rarity.DisplayName or entry.Rarity.Name or ""
		end

		local scale = tonumber(record.AssetScale) or 1
		local factor = scale > 5 and (scale / 5) ^ 1.2 * 19.637875755794113 or scale ^ 1.85
		local mutation = 1
		if type(Mutations) == "table" and type(Mutations.EarningsFor) == "function" then
			local okM, resM = pcall(Mutations.EarningsFor, type(record.Mutations) == "table" and record.Mutations or {})
			if okM and type(resM) == "number" then mutation = resM end
		end
		info.Generation = math.round((tonumber(entry.EarningRate) or 0) * factor * mutation)
	end
	return info
end

local function formatNumber(arg)
	local n13 = tonumber(arg) or 0
	local function fn2(arg2) return (string.format("%.2f", arg2):gsub("(%..-)0+$", "%1"):gsub("%.$", "")) end
	local n14 = math.abs(n13)
	for _, v16 in ipairs({ { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
		if n14 >= v16[1] then return fn2(n13 / v16[1]) .. v16[2] end
	end
	return tostring(math.floor(n13 + 0.5))
end

-- 清除舊 UI
pcall(function()
	local pGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	if pGui then
		for _, child in ipairs(pGui:GetChildren()) do
			if child.Name:sub(1, 3) == "LH_" or child.Name == "LennonHub" then child:Destroy() end
		end
	end
end)

-- UI 建構
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LH_" .. tostring(math.random(1000000, 9999999))
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local imageButton = Instance.new("ImageButton")
imageButton.Name = "LennonIcon"
imageButton.Size = UDim2.fromOffset(42, 42)
imageButton.Position = UDim2.new(0, 14, 0.5, -21)
imageButton.BackgroundColor3 = Color3.fromRGB(8, 12, 10)
imageButton.Image = "rbxassetid://103090301992311"
imageButton.Parent = screenGui
Instance.new("UICorner", imageButton).CornerRadius = UDim.new(1, 0)

local frame = Instance.new("Frame")
frame.Name = "LennonPanel"
frame.Size = UDim2.fromOffset(262, 185)
frame.Position = UDim2.new(0.5, 140, 0.5, -92)
frame.BackgroundColor3 = Color3.fromRGB(7, 10, 8)
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, -20, 0, 42)
frame2.Position = UDim2.fromOffset(10, 10)
frame2.BackgroundTransparency = 1
frame2.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -70, 0, 18)
textLabel.Position = UDim2.new(0, 34, 0, 4)
textLabel.BackgroundTransparency = 1
textLabel.Text = "LENNON HUB"
textLabel.TextColor3 = Color3.fromRGB(235, 255, 240)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = frame2

local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, -70, 0, 13)
textLabel2.Position = UDim2.new(0, 34, 0, 22)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "INSTANT TP SYSTEM"
textLabel2.TextColor3 = Color3.fromRGB(90, 130, 100)
textLabel2.Font = Enum.Font.GothamMedium
textLabel2.TextXAlignment = Enum.TextXAlignment.Left
textLabel2.Parent = frame2

local textButtonClose = Instance.new("TextButton")
textButtonClose.Size = UDim2.fromOffset(24, 24)
textButtonClose.Position = UDim2.new(1, -24, 0.5, -12)
textButtonClose.BackgroundTransparency = 0.25
textButtonClose.Text = "X"
textButtonClose.TextColor3 = Color3.fromRGB(160, 180, 165)
textButtonClose.Parent = frame2
Instance.new("UICorner", textButtonClose).CornerRadius = UDim.new(1, 0)

local frame5 = Instance.new("Frame")
frame5.Size = UDim2.new(1, -20, 0, 52)
frame5.Position = UDim2.fromOffset(10, 60)
frame5.BackgroundColor3 = Color3.fromRGB(13, 19, 15)
frame5.Parent = frame
Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 9)

local textLabel5 = Instance.new("TextLabel")
textLabel5.Size = UDim2.new(0, 100, 0, 17)
textLabel5.Position = UDim2.fromOffset(52, 20)
textLabel5.BackgroundTransparency = 1
textLabel5.Text = "SEARCHING..."
textLabel5.TextColor3 = Color3.fromRGB(235, 255, 240)
textLabel5.Font = Enum.Font.GothamBold
textLabel5.TextXAlignment = Enum.TextXAlignment.Left
textLabel5.Parent = frame5

local textLabel7 = Instance.new("TextLabel")
textLabel7.AnchorPoint = Vector2.new(1, 0)
textLabel7.Size = UDim2.fromOffset(60, 17)
textLabel7.Position = UDim2.new(1, -24, 0, 20)
textLabel7.BackgroundTransparency = 1
textLabel7.Text = "--"
textLabel7.TextColor3 = Color3.fromRGB(50, 255, 110)
textLabel7.Font = Enum.Font.GothamBold
textLabel7.TextXAlignment = Enum.TextXAlignment.Right
textLabel7.Parent = frame5

local textButtonStart = Instance.new("TextButton")
textButtonStart.Size = UDim2.new(1, -20, 0, 55)
textButtonStart.Position = UDim2.fromOffset(10, 120)
textButtonStart.BackgroundColor3 = Color3.fromRGB(13, 19, 15)
textButtonStart.Text = ""
textButtonStart.Parent = frame
Instance.new("UICorner", textButtonStart).CornerRadius = UDim.new(0, 9)

local textLabel8 = Instance.new("TextLabel")
textLabel8.Size = UDim2.fromOffset(88, 20)
textLabel8.Position = UDim2.fromOffset(12, 8)
textLabel8.BackgroundTransparency = 1
textLabel8.Text = "INSTANT TP"
textLabel8.TextColor3 = Color3.fromRGB(230, 240, 233)
textLabel8.Font = Enum.Font.GothamBold
textLabel8.TextXAlignment = Enum.TextXAlignment.Left
textLabel8.Parent = textButtonStart

local textLabel9 = Instance.new("TextLabel")
textLabel9.Size = UDim2.fromOffset(120, 14)
textLabel9.Position = UDim2.fromOffset(12, 30)
textLabel9.BackgroundTransparency = 1
textLabel9.Text = "Click to steal best egg"
textLabel9.TextColor3 = Color3.fromRGB(100, 125, 108)
textLabel9.Font = Enum.Font.Gotham
textLabel9.TextXAlignment = Enum.TextXAlignment.Left
textLabel9.Parent = textButtonStart

------------------------------------------------------------------
-- 6. 界面數據更新與事件綁定
------------------------------------------------------------------
local function refreshEggs()
	local list = snapshot()
	table.clear(tbl4.filteredEggs)
	for _, rec in ipairs(list) do
		local data = describe(rec)
		if eggMatchesRarityFilter(data) then
			tbl4.filteredEggs[#tbl4.filteredEggs + 1] = data
		end
	end
	table.sort(tbl4.filteredEggs, function(a, b) return a.Generation > b.Generation end)
	tbl4.bestEgg = tbl4.filteredEggs[1]

	if tbl4.bestEgg then
		textLabel5.Text = tbl4.bestEgg.Name
		textLabel7.Text = formatNumber(tbl4.bestEgg.Generation)
	else
		textLabel5.Text = "NO EGG FOUND"
		textLabel7.Text = "--"
	end
end

textButtonStart.MouseButton1Click:Connect(function()
	if state.Busy then
		state.Cancel = true
		textLabel9.Text = "CANCELING..."
		return
	end

	refreshEggs()
	local target = tbl4.selectedEgg or tbl4.bestEgg
	if not target then
		textLabel9.Text = "NO EGG TO STEAL"
		return
	end

	textLabel9.Text = "STEALING..."
	task.spawn(function()
		stealAndDeliver(target.Uid)
		while state.Busy do task.wait(0.1) end
		textLabel9.Text = "Click to steal best egg"
	end)
end)

imageButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

textButtonClose.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- 開啟盾牌與背景定時刷新
shieldStart()

task.spawn(function()
	while true do
		task.wait(2)
		if frame.Visible and not state.Busy then
			refreshEggs()
		end
	end
end)
