-- ==============================================================================
--  CHILLI HUB V5 - RONNEI OFFICIAL EDITION (ULTIMATE STABLE FIX)
-- ==============================================================================

local MY_CHILLI_URL  = "https://raw.githubusercontent.com/ronnei/hihi/refs/heads/main/chillihubv5.lua"
local AUTO_RUN_FILE  = "ChilliHubV5_AutoRun.lua"
local LANG_SAVE_FILE = "ChilliV5_Lang.txt"

local CHILLI_CORE_PAYLOAD = [===[
local NEW_TITLE = "Chilli Hub V5"
local CHILLI_LOGO_ID = "rbxassetid://92622270383869"
local LOGO_BG_COLOR = Color3.fromRGB(5, 7, 15)
local ISLAND_BLACK_BG = Color3.fromRGB(0, 0, 0)

-- CHUỖI JSON CONFIG SETTING AUTO FARM CHUẨN
local PRESET_AUTOFARM_JSON = [=[{"venyx":1,"name":"hihi","data":{"System / Interface/Quick bars/Show quick bars":false,"Farm / Sell/Favorite/Auto favorite":false,"System / Interface/Quick bars/Quick bar layout":"{\"pins\":{\"Player / Move/Movement/Boost speed\":1,\"Player / Move/Movement/Speed boost\":1},\"fold\":{\"1\":true},\"at\":[],\"keys\":[]}","Farm / Sell/Eggs/Only below /s":0,"Farm / Pen/Auto place/Place first":"Best value","Steal / Auto Steal/Filter/Only below /s":0,"Farm / Pen/Auto hatch/Equip best pets":false,"Event / AA/Capture the egg/Auto capture event egg":false,"Farm / Mutate/Mutate filter/Only these eggs":[],"Event / Race/Rewards/Auto claim rewards":true,"Farm / Treadmill/Treadmill/Auto upgrade treadmill":false,"Event / Race/Rewards/Racer":"Best owned","Steal / Auto Steal/Auto steal/Drop eggs at safe zone":false,"Steal / Auto Steal/Auto hop server/Auto hop":false,"System / Interface/Interface/Dim the game":0,"Player / Combat/Hit aura/Skip friends":true,"Player / ESP/Others/Pen egg ESP":true,"System / Optimizer/Frame rate/FPS position":"","Event / Butterfly/Butterfly bloom/Auto butterfly bloom":true,"Farm / Pen/Auto hatch/Rarities":["Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"],"Steal / Auto Steal/Filter/Min value /s":1000000000,"Player / Combat/Hit aura/Hit aura":true,"Event / AA/Capture the egg/Take it from the holder":true,"Steal / Egg Predictor/Egg showcase/Calculate mutations":[],"Steal / Egg Predictor/Egg showcase/Sort eggs":"Value","System / Optimizer/Bases/Hide other players' pets and eggs":true,"Player / Combat/Auto hit/Auto hit":false,"Event / Butterfly/Butterfly bloom/Catch mode":"Chase","Event / Butterfly/Butterfly machine/Trade":[],"Event / Lab/Lab stock/Biohazard Pets eggs":[],"Event / Race/Rewards/Auto equip racer":true,"Farm / Pen/Auto place/Auto place":false,"Steal / Auto Steal/Filter/Rarities":["Divine","Eternal","Secret"],"Farm / Sell/Lab eggs/Keep mutated":true,"System / Webhook/What to post/Post fused eggs":false,"Farm / Sell/Pets/Sell rarities":["Rare","Uncommon","Common"],"Farm / Sell/Lab eggs/Only mutations":[],"Farm / Fuse/Fuse filter/Rarities":["Mythic","Legendary","Epic","Rare","Uncommon","Common"],"Event / Lab/Lab stock/Stock per egg":3,"System / Webhook/Discord webhook/Ping role ID":"","Player / ESP/Others/Hide sleeping guards":true,"System / Optimizer/Frame rate/Show FPS and ping":false,"Farm / Treadmill/Progress/Auto claim index rewards":false,"System / Interface/Quick bars/Keybinds":true,"Steal / Auto Steal/Auto steal/Instant steps":1,"Farm / Fuse/Fuse filter/Never fuse":[],"Farm / Pen/Auto hatch/Mutations":[],"System / Optimizer/Bases/Hide my pets and eggs":true,"Steal / Auto Steal/Filter/Zones":["Enchanted Forest","Light Dark","Titan Temple","Cherry Blossom"],"Event / Butterfly/Butterfly machine/Auto craft essence":false,"Farm / Mutate/Auto mutate/Auto mutate":false,"Farm / Sell/Lab eggs/Never sell":[],"Player / ESP/Field eggs/Egg ESP":false,"Farm / Pen/Keep eggs/Min value /s":0,"Steal / Auto Steal/Auto steal/Delivery method":"Instant steps","Farm / Sell/Eggs/Keep mutated":true,"Farm / Sell/Eggs/Sell rarities":["Rare","Uncommon","Common"],"System / Interface/Interface/Tone":100,"Player / ESP/Others/Player ESP":true,"Event / Lab/Lab stock/Experimental Pets eggs":[],"System / Webhook/What to post/Rarities":["Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"],"Event / AA/Admin abuse/Instant steal (Admin Treadmill)":true,"Player / Move/Protection/Anti ragdoll":true,"Event / Race/Racing Event/Auto race":true,"Event / Butterfly/Wisp companion/Auto banjo cricket":false,"Event / Lab/Lab/Auto reroll recipe":false,"Farm / Mutate/Auto mutate/Use items":["Fractured","Scrambled","Enchanted","Nitro"],"System / Interface/Interface/Opacity":50,"Farm / Fuse/Fuse machine/Fuse first":"Lowest rarity","Farm / Sell/Lab eggs/Only below /s":0,"System / Webhook/Discord webhook/Webhook URL":"","Player / Move/Movement/Boost speed":120,"Farm / Pen/Auto place/Place when":"Always","Player / ESP/Others/ESP size":60,"System / Webhook/What to post/Post stolen eggs":false,"Farm / Sell/Favorite/Always favorite":[],"Farm / Treadmill/Progress/Auto upgrade base":false,"Farm / Sell/Eggs/Auto sell eggs":false,"Farm / Treadmill/Progress/Auto buy trails":false,"System / Server/Join and stay/Rejoin on kick":true,"Steal / Auto Steal/Filter/Steal first":"Best value","Farm / Sell/Pets/Only below /s":0,"Event / Lab/Lab/Auto trade in":false,"Event / Lab/Lab/Steal lab eggs":false,"Farm / Pen/Auto hatch/Min value /s":0,"Steal / Auto Steal/Auto hop server/Hop when":"After stealing a match","System / Optimizer/Frame rate/FPS cap":360,"Event / Butterfly/Butterfly bloom/Catch":["Radiant","Amethyst","Sapphire","Emerald"],"Farm / Treadmill/Treadmill/Auto treadmill":true,"System / Interface/Game HUD/Steal panel button on game HUD":true,"System / Server/Server/Hop to":"Least players","Farm / Mutate/Mutate filter/Rarities":["Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"],"Player / Move/Protection/Instant prompts":true,"Event / Race/Racing Event/Race speed":144,"Steal / Auto Steal/Filter/Keep lab eggs":true,"Player / Combat/Auto hit/Hit who":"Nearest player","Player / ESP/Field eggs/Rarities":["Divine","Eternal","Secret","Cosmic","Mythic"],"Steal / Auto Steal/Auto steal/Steal missing index eggs":false,"Steal / Auto Steal/Filter/Only these eggs":["ArchAngel","Kitsune","Nightflame","Royal Skywhale","Unicorn","World Burner","Celestial Sunlion","Gorilla King","Pegasus","Skeleton Horse","Strawberry Elephant","67","Amethyst Runebear","Starry Fox"],"Farm / Sell/Favorite/Min value /s":0,"System / Server/Join and stay/Auto load script":true,"Farm / Pen/Keep eggs/Eggs to keep":[],"System / Optimizer/Graphics/Low graphics":true,"Event / Race/Racing Event/Use power-ups":true,"Event / AA/Minigame eggs/Auto steal minigame egg":true,"Farm / Sell/Favorite/Favorite equipped":false,"System / Optimizer/Graphics/Background color":"Black","Farm / Sell/Eggs/Never sell":[],"Farm / Pen/Auto place/Min value /s":0,"Player / Move/Movement/Speed boost":false,"System / Optimizer/Graphics/Disable 3D Render":false,"Farm / Fuse/Fuse machine/Skip mutated":true,"Event / Lab/Lab/Place lab reward eggs":false,"Farm / Mutate/Auto mutate/Auto buy Nitro":false,"Steal / Auto Steal/Auto hop server/Rare from":"Cosmic","Steal / Auto Steal/Auto steal/Anti guard":true,"Steal / Auto Steal/Auto steal/Steal from other players":false,"Event / AA/Capture the egg/Keep away":45,"Farm / Fuse/Fuse filter/Only below /s":0,"Farm / Sell/Favorite/Unfavorite pets not matching":false,"System / Webhook/What to post/Min value /s":0,"Farm / Pen/Auto hatch/Auto hatch":false,"Event / Butterfly/Butterfly bloom/Catch speed":600,"Farm / Priority/Task order/Task order":["Steal filter eggs","Shooting Star","Racing Event","Butterfly","Steal wisp eggs","Wisp","Steal missing index","Steal lab eggs","Place","Mutate","Butterfly machine","Treadmill"],"Event / Butterfly/Butterfly machine/Auto trade up":true,"Player / ESP/Others/Guard ESP":true,"System / Webhook/What to post/Post when bag is full":false,"Event / Lab/Lab stock/Stock lab eggs":false,"Event / Lab/Lab stock/Unstable DNA eggs":[],"Player / ESP/Field eggs/Mutations":[],"Player / ESP/Field eggs/Show":[],"Event / AA/Admin abuse/Use admin treadmill":true,"Player / Combat/Weapons/Use weapons":[],"Player / Move/Movement/Infinite jump":true,"System / Interface/Quick bars/Bar size":95,"Player / ESP/Field eggs/Min value /s":0,"Player / Combat/Weapons/Hold each":0.2,"Farm / Mutate/Auto mutate/Mutate first":"Best value","Farm / Mutate/Mutate filter/Min value /s":0,"Farm / Sell/Pets/Never sell":[],"Event / Race/Rewards/Shop items":[],"Farm / Pen/Auto place/Rarities":["Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"],"Event / Race/Rewards/Auto buy shop":false,"System / Webhook/Discord webhook/Ping everyone":false,"Event / Star/Shooting Star/Auto catch shooting star":true,"Event / Butterfly/Butterfly machine/Smart trade for essence":false,"Farm / Fuse/Fuse machine/Eject odd pets":true,"Player / ESP/Field eggs/Fixed size":false,"Player / Combat/Auto hit/Chase speed":1000,"Farm / Pen/Auto place/Mutations":[],"Steal / Auto Steal/Auto steal/Fast tween speed":4500,"Player / Move/Protection/Anti AFK":true,"Farm / Sell/Favorite/Rarities":[],"Steal / Auto Steal/Auto hop server/First hop after":5,"Steal / Auto Steal/Auto steal/Tween speed":110,"Farm / Sell/Pets/Auto sell pets":false,"Farm / Sell/Pets/Only mutations":[],"Farm / Sell/Pets/Keep mutated":true,"Steal / Auto Steal/Filter/Sell cheapest egg when bag is full":false,"Farm / Sell/Lab eggs/Sell rarities":[],"Steal / Auto Steal/Auto steal/Go to egg":"Teleport to egg","Event / Lab/Lab stock/Stock for banners":[],"Event / AA/Capture the egg/Hold height":45,"Steal / Auto Steal/Filter/Mutations":[],"Farm / Pen/Auto hatch/Only these eggs":[],"Player / Move/Protection/God mode":true,"Steal / Auto Steal/Auto steal/Teleport zones":["Enchanted Forest","Light Dark","Titan Temple","Cherry Blossom"],"Steal / Auto Steal/Auto steal/Auto steal":true,"Farm / Fuse/Fuse machine/Auto fuse":false,"System / Interface/Interface/UI scale":90,"Farm / Fuse/Fuse filter/Only these pets":[],"Steal / Egg Predictor/Egg showcase/Preview card":true,"Farm / Sell/Favorite/Match":"All picked rules","Player / ESP/Others/Other pens ESP":true,"Farm / Mutate/Mutate filter/Skip eggs with":[],"System / Interface/Interface/Show / hide UI":{"k":"LeftControl"},"Farm / Sell/Lab eggs/Auto sell lab eggs":false,"Farm / Sell/Eggs/Only mutations":[],"Event / Butterfly/Butterfly bloom/Catch priority":"Rarest","System / Webhook/Discord webhook/Ping user ID":"","Farm / Pen/Auto place/Only these eggs":[],"Farm / Treadmill/Progress/Auto claim offline cash":false,"Player / Move/Protection/Ignore traps":true,"Event / Lab/Lab/Lab banners":[],"Player / Move/Protection/Invisible":false,"Farm / Sell/Favorite/Mutations":[],"Farm / Fuse/Fuse machine/Use pets":"Lowest value first","Event / Butterfly/Wisp companion/Auto wisp quest":false,"System / Optimizer/Graphics/Hide game UI":false}}]=]

local env = (getgenv and getgenv()) or _G
env.__ChilliV5State = env.__ChilliV5State or {
    SessionId = 0,
    Language = "VI",
    ActiveGradients = {},
    TrackedTexts = {},
    TrackedFpsLabels = {},
    RefreshIslandCallback = nil
}

local State = env.__ChilliV5State
State.SessionId = (State.SessionId or 0) + 1
local MY_SESSION_ID = State.SessionId

pcall(function()
    if isfile and isfile(LANG_SAVE_FILE) then
        local saved = (readfile(LANG_SAVE_FILE) or ""):match("^%s*(.-)%s*$")
        if saved == "EN" or saved == "VI" then
            State.Language = saved
        end
    end
end)

local function isCurrentSession()
    return State.SessionId == MY_SESSION_ID
end

-- ==================== 1. BỘ CHẶN TELEPORT TUYỆT ĐỐI ====================
do
    local realQueue = env.__ChilliOrigQueue
        or env.queue_on_teleport
        or env.queueonteleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (delta and delta.queue_on_teleport)

    local teleportBootstrap = string.format([[
        --CHILLI_V5_AUTHORIZED_TELEPORT--
        task.spawn(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            local Players = game:GetService("Players")
            while not Players.LocalPlayer do
                task.wait(0.1)
            end
            task.wait(1.0)
            local executed = false
            if isfile and readfile and isfile("%s") then
                local ok, fn = pcall(function() return loadstring(readfile("%s")) end)
                if ok and type(fn) == "function" then
                    executed = true
                    task.spawn(fn)
                end
            end
            if not executed then
                pcall(function()
                    loadstring(game:HttpGet("%s"))()
                end)
            end
        end)
    ]], AUTO_RUN_FILE, AUTO_RUN_FILE, MY_CHILLI_URL)

    if realQueue then
        env.__ChilliOrigQueue = realQueue

        local function forceChilliQueue(scriptCode)
            local codeStr = tostring(scriptCode or "")
            if codeStr:find("CHILLI_V5_AUTHORIZED_TELEPORT", 1, true) then
                return realQueue(scriptCode)
            end
            return realQueue(teleportBootstrap)
        end

        env.queue_on_teleport = forceChilliQueue
        env.queueonteleport = forceChilliQueue
        pcall(function() getfenv(0).queue_on_teleport = forceChilliQueue end)
        pcall(function() getfenv(0).queueonteleport = forceChilliQueue end)
        if syn then pcall(function() syn.queue_on_teleport = forceChilliQueue end) end
        if fluxus then pcall(function() fluxus.queue_on_teleport = forceChilliQueue end) end
        if delta then pcall(function() delta.queue_on_teleport = forceChilliQueue end) end

        if hookfunction and not env.__ChilliHookFuncDone then
            env.__ChilliHookFuncDone = true
            pcall(function()
                local oldHook
                oldHook = hookfunction(realQueue, function(code)
                    local s = tostring(code or "")
                    if s:find("CHILLI_V5_AUTHORIZED_TELEPORT", 1, true) then
                        return oldHook(code)
                    end
                    return oldHook(teleportBootstrap)
                end)
            end)
        end

        local noop = function() end
        env.clearteleportqueue = noop
        env.clear_teleport_queue = noop
        if syn then pcall(function() syn.clear_teleport_queue = noop end) end
        if fluxus then pcall(function() fluxus.clear_teleport_queue = noop end) end

        pcall(function()
            realQueue(teleportBootstrap)
        end)

        task.spawn(function()
            local Players = game:GetService("Players")
            local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            if lp and lp.OnTeleport then
                lp.OnTeleport:Connect(function()
                    if not isCurrentSession() then return end
                    if getconnections then
                        pcall(function()
                            for _, conn in ipairs(getconnections(lp.OnTeleport)) do
                                if conn.Function and not isexecutorclosure(conn.Function) then
                                    conn:Disable()
                                end
                            end
                        end)
                    end
                    pcall(function()
                        realQueue(teleportBootstrap)
                    end)
                end)
            end
        end)
    end
end

if not env.__VenyxV5NewLoaded then
    env.__VenyxV5NewLoaded = true
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()
        end)
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local scanRoots = {
    gethui and gethui(),
    CoreGui,
    LocalPlayer:WaitForChild("PlayerGui")
}

local IGNORED_GUI_NAMES = {
    ["RobloxGui"] = true, ["TopBarApp"] = true, ["TouchGui"] = true,
    ["Chat"] = true, ["BubbleChat"] = true, ["Freecam"] = true,
    ["BackpackGui"] = true, ["PlayerList"] = true, ["PurchasePrompt"] = true
}

local COLOR_SEQ_RAINBOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 55, 55)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 175, 40)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 235, 50)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(50, 255, 130)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(60, 185, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 55, 55))
})

task.spawn(function()
    local rot = 0
    while isCurrentSession() do
        rot = (rot + 4) % 360
        local list = State.ActiveGradients
        for i = #list, 1, -1 do
            local g = list[i]
            if g and g.Parent then
                g.Rotation = rot
            else
                table.remove(list, i)
            end
        end
        task.wait(0.03)
    end
end)

-- ==================== 2. BỘ TẠO FPS ẢO (85 - 120 FPS) ====================
local currentFakeFps = math.random(96, 112)
local lastFpsStepClock = 0

local function getSmoothFakeFps()
    local now = os.clock()
    if now - lastFpsStepClock >= 0.65 then
        lastFpsStepClock = now
        local delta = math.random(-4, 4)
        currentFakeFps = math.clamp(currentFakeFps + delta, 85, 120)
    end
    return currentFakeFps
end

local function isFpsCounterText(str)
    if type(str) ~= "string" or str == "" then return false end
    return str:find("FPS", 1, true) ~= nil and str:find("ms", 1, true) ~= nil and str:find("%d+%s*FPS") ~= nil
end

local function forceUpdateFpsLabel(lbl)
    if not (lbl and lbl.Parent) then return end
    if lbl:GetAttribute("__UpdatingFps") then return end
    local raw = lbl.Text
    if not isFpsCounterText(raw) then return end

    local fakeVal = getSmoothFakeFps()
    local patched = raw:gsub("%d+%s*FPS", tostring(fakeVal) .. " FPS", 1)
    if raw ~= patched then
        lbl:SetAttribute("__UpdatingFps", true)
        lbl.Text = patched
        lbl:SetAttribute("__UpdatingFps", false)
    end
end

local function hookFakeFpsCounter(lbl)
    if not (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return end
    State.TrackedFpsLabels[lbl] = true
    forceUpdateFpsLabel(lbl)

    if lbl:GetAttribute("__FpsHookSession") ~= MY_SESSION_ID then
        lbl:SetAttribute("__FpsHookSession", MY_SESSION_ID)
        lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if not isCurrentSession() then return end
            if not lbl:GetAttribute("__UpdatingFps") then
                forceUpdateFpsLabel(lbl)
            end
        end)
    end
end

task.spawn(function()
    while isCurrentSession() do
        task.wait(0.5)
        getSmoothFakeFps()
        for lbl in pairs(State.TrackedFpsLabels) do
            if lbl and lbl.Parent then
                forceUpdateFpsLabel(lbl)
            else
                State.TrackedFpsLabels[lbl] = nil
            end
        end
    end
end)

-- ==================== 3. HỆ THỐNG DỊCH THUẬT & BẢO VỆ CHUỖI GỐC ====================
local FastCache = {}

local VIETNAMESE_CHAR_PATTERNS = {
    "à","á","ả","ã","ạ","ă","ằ","ắ","ẳ","ẵ","ặ","â","ầ","ấ","ẩ","ẫ","ậ",
    "è","é","ẻ","ẽ","ẹ","ê","ề","ế","ể","ễ","ệ","ì","í","ỉ","ĩ","ị",
    "ò","ó","ỏ","õ","ọ","ô","ồ","ố","ổ","ỗ","ộ","ơ","ờ","ớ","ở","ỡ","ợ",
    "ù","ú","ủ","ũ","ụ","ư","ừ","ứ","ử","ữ","ự","ỳ","ý","ỷ","ỹ","ỵ","đ",
    "À","Á","Ả","Ã","Ạ","Ă","Ằ","Ắ","Ẳ","Ẵ","Ặ","Â","Ầ","Ấ","Ẩ","Ẫ","Ậ",
    "È","É","Ẻ","Ẽ","Ẹ","Ê","Ề","Ế","Ể","Ễ","Ệ","Ì","Í","Ỉ","Ĩ","Ị",
    "Ò","Ó","Ỏ","Õ","Ọ","Ô","Ồ","Ố","Ổ","Ỗ","Ộ","Ơ","Ờ","Ớ","Ở","Ỡ","Ợ",
    "Ù","Ú","Ủ","Ũ","Ụ","Ư","Ừ","Ứ","Ử","Ữ","Ự","Ỳ","Ý","Ỷ","Ỹ","Ỵ","Đ"
}

local function containsVietnameseChars(str)
    if type(str) ~= "string" or str == "" then return false end
    for i = 1, #VIETNAMESE_CHAR_PATTERNS do
        if str:find(VIETNAMESE_CHAR_PATTERNS[i], 1, true) then
            return true
        end
    end
    return false
end

local EXACT_MATCH_VI = {
    ["Idle"] = "Đang rảnh",
    ["Waiting"] = "Đang chờ",
    ["Nothing"] = "Không có gì",
    ["None"] = "Không có",
    ["Off"] = "Tắt",
    ["OFF"] = "TẮT",
    ["On"] = "Bật",
    ["ON"] = "BẬT",
    ["No egg matches your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No eggs match your targets"] = "Không có trứng nào khớp mục tiêu",
    ["No egg matches your target"] = "Không có trứng nào khớp mục tiêu",
    ["No egg matches filter"] = "Không có trứng khớp bộ lọc",
    ["No eggs match filter"] = "Không có trứng khớp bộ lọc",
    ["No target egg found"] = "Không tìm thấy trứng mục tiêu",
    ["No matching eggs"] = "Không có trứng nào khớp",
    ["No matching egg"] = "Không có trứng nào khớp",
    ["No matching pets"] = "Không có pet nào khớp",
    ["No valid targets"] = "Không có mục tiêu hợp lệ",
    ["No targets found"] = "Không tìm thấy mục tiêu",
    ["No eggs in field"] = "Không có trứng ngoài sân",
    ["No egg in field"] = "Không có trứng ngoài sân",
    ["Bag is full"] = "Túi đã đầy",
    ["Egg bag is full"] = "Túi trứng đã đầy",
    ["Pet bag is full"] = "Túi pet đã đầy",
    ["Your bag is full"] = "Túi của bạn đã đầy",
    ["Pen is full"] = "Chuồng ấp đã đầy",
    ["All pens are full"] = "Tất cả chuồng đã đầy",
    ["Field is closed"] = "Sân trứng đang đóng",
    ["Waiting for field"] = "Đang chờ sân trứng mở",
    ["Waiting for field to open"] = "Đang chờ sân trứng mở",
    ["Waiting for eggs"] = "Đang chờ trứng xuất hiện",
    ["Waiting for eggs to spawn"] = "Đang chờ trứng xuất hiện",
    ["Waiting for next race"] = "Đang chờ chặng đua tiếp theo",
    ["Waiting for race"] = "Đang chờ chặng đua",
    ["Waiting for shooting star"] = "Đang chờ sao băng rơi",
    ["Waiting for butterfly bloom"] = "Đang chờ mùa bướm nở",
    ["Waiting in safe zone"] = "Đợi ở vùng an toàn",
    ["Returning to safe zone"] = "Đang về vùng an toàn",
    ["Returning home"] = "Đang quay về nhà",
    ["Going home"] = "Đang về nhà",
    ["Going to safe zone"] = "Đang về vùng an toàn",
    ["Delivering egg"] = "Đang giao trứng về chuồng",
    ["Delivering carried egg"] = "Đang giao trứng đang bê",
    ["Dropping egg"] = "Đang thả trứng",
    ["Dropping eggs"] = "Đang thả trứng",
    ["Selling eggs"] = "Đang bán trứng",
    ["Selling pets"] = "Đang bán pet",
    ["Selling lab eggs"] = "Đang bán trứng Lab",
    ["Hatching eggs"] = "Đang ấp trứng",
    ["Hatching egg"] = "Đang ấp trứng",
    ["Placing eggs"] = "Đang đặt trứng",
    ["Placing egg"] = "Đang đặt trứng",
    ["Mutating eggs"] = "Đang đột biến trứng",
    ["Mutating egg"] = "Đang đột biến trứng",
    ["Fusing pets"] = "Đang dung hợp pet",
    ["Hopping server"] = "Đang đổi máy chủ",
    ["Finding server"] = "Đang tìm máy chủ mới",
    ["Rejoining"] = "Đang vào lại phòng",
    ["Avoiding guard"] = "Đang né vệ sĩ",
    ["Evading guard"] = "Đang né vệ sĩ",
    ["Using treadmill"] = "Đang chạy máy tập",
    ["Upgrading treadmill"] = "Đang nâng cấp máy tập",
    ["Upgrading base"] = "Đang nâng cấp căn cứ",
    ["Claiming rewards"] = "Đang nhận thưởng",
    ["Claiming offline cash"] = "Đang nhận tiền ngoại tuyến",
    ["Claiming index rewards"] = "Đang nhận thưởng Chỉ mục",
    ["Catching shooting star"] = "Đang bắt sao băng",
    ["Catching butterfly"] = "Đang bắt bướm",
    ["Joining race"] = "Đang vào đường đua",
    ["Racing"] = "Đang đua xe",

    ["Home"] = "Trang Chủ",
    ["Dashboard"] = "Bảng Điều Khiển",
    ["Welcome back"] = "Chào mừng trở lại",
    ["Venyx Discord"] = "Chilli Hub Discord",
    ["Updates, keys, support"] = "Cập nhật, nhận key, hỗ trợ",
    ["Copy Invite"] = "Chép Link Mời",
    ["Discord"] = "Discord",
    ["MONEY /S"] = "TIỀN /GIÂY",
    ["OPEN"] = "MỞ",
    ["Open"] = "Mở",
    ["Close"] = "Đóng",
    ["Welcome to Venyx 1.0.0! Join our Discord for updates and support"] = "Chào mừng tới Chilli Hub V5! Tham gia Discord để cập nhật và nhận hỗ trợ",
    ["Beta version"] = "Phiên bản Beta",
    ["This is a test build. Features may change and bugs can happen."] = "Đây là bản thử nghiệm. Tính năng có thể thay đổi và phát sinh lỗi.",
    ["Rejoin"] = "Vào lại",
    ["Server hop"] = "Đổi server",
    ["Copy Job ID"] = "Chép Job ID",
    ["Unload hub"] = "Tắt Hub",
    ["Save config"] = "Lưu cấu hình",
    ["Hide UI"] = "Ẩn Menu",
    ["SESSION"] = "PHIÊN CHƠI",
    ["STOLEN"] = "ĐÃ CƯỚP",
    ["LAST EGG"] = "TRỨNG CUỐI",
    ["PLACED"] = "ĐÃ ĐẶT",
    ["HATCHED"] = "ĐÃ ẤP",
    ["NIGHT IN"] = "ĐÊM SAU",
    ["SESSION TIME"] = "THỜI GIAN",
    ["BEST STEAL"] = "CƯỚP TỐT NHẤT",
    ["EGG BAG"] = "TÚI TRỨNG",
    ["PET BAG"] = "TÚI PET",
    ["WHAT'S NEW"] = "CÓ GÌ MỚI",
    ["NEW"] = "MỚI",
    ["Event"] = "Sự Kiện",
    ["Racing Event: ragdoll jump to the portal, races, leaves and claims"] = "Sự Kiện Đua Xe: tự nhảy vào cổng, đua, rời đi và nhận thưởng",
    ["Shooting Star catcher with ragdoll jump and run fallback"] = "Bắt Sao Băng kết hợp nhảy ragdoll và chạy dự phòng",
    ["Steal panel joins the game buttons and lists every egg"] = "Bảng Cướp tích hợp nút game và liệt kê mọi quả trứng",
    ["Search"] = "Tìm kiếm",
    ["Filter"] = "Lọc tìm",

    ["Steal"] = "Cướp Trứng",
    ["Auto Steal"] = "Tự Động Cướp",
    ["AUTO STEAL"] = "TỰ ĐỘNG CƯỚP",
    ["Auto steal"] = "Tự động cướp",
    ["Egg Predictor"] = "Dự Đoán Trứng",
    ["EGG PREDICTOR"] = "DỰ ĐOÁN TRỨNG",
    ["Go to egg"] = "Di chuyển tới trứng",
    ["Teleport to egg"] = "Dịch chuyển tới trứng",
    ["Teleport zones"] = "Khu vực dịch chuyển",
    ["Teleport zone"] = "Khu vực dịch chuyển",
    ["Tween"] = "Bay (Tween)",
    ["Walk"] = "Đi bộ",
    ["Delivery method"] = "Cách mang về",
    ["Fast tween speed"] = "Tốc độ bay nhanh",
    ["Tween speed"] = "Tốc độ bay",
    ["Steal missing index eggs"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal back from players"] = "Cướp lại từ người chơi",
    ["Steal from other players"] = "Cướp từ người chơi khác",
    ["Steal from players"] = "Cướp từ người chơi",
    ["Anti guard"] = "Chống vệ sĩ",
    ["Drop eggs at safe zone"] = "Thả trứng ở vùng an toàn",
    ["FILTER"] = "BỘ LỌC",
    ["Zones"] = "Khu vực",
    ["Zone"] = "Khu vực",
    ["Steal first"] = "Ưu tiên cướp",
    ["Best value"] = "Giá trị cao nhất",
    ["Lowest value"] = "Giá trị thấp nhất",
    ["Best rarity"] = "Độ hiếm cao nhất",
    ["Best mutation"] = "Đột biến tốt nhất",
    ["Biggest"] = "Kích thước to nhất",
    ["Closest"] = "Khoảng cách gần nhất",
    ["Mutations"] = "Đột biến",
    ["Rarities"] = "Độ hiếm",
    ["Only these eggs"] = "Chỉ những trứng này",
    ["Min value /s"] = "Giá trị tối thiểu /s",
    ["Max value /s"] = "Giá trị tối đa /s",
    ["Sell cheapest egg when bag is full"] = "Bán trứng rẻ nhất khi đầy túi",
    ["Keep lab eggs"] = "Giữ lại trứng Lab",
    ["AUTO HOP SERVER"] = "TỰ ĐỔI MÁY CHỦ",
    ["Auto hop server"] = "Tự đổi máy chủ",
    ["Hop when no matching egg"] = "Đổi server khi không có trứng khớp",
    ["Hop when no egg matches"] = "Đổi server khi không có trứng khớp",
    ["Hop delay"] = "Độ trễ đổi server",
    ["Only sell eggs below /s"] = "Chỉ bán trứng dưới mức /s",
    ["EGG SHOWCASE"] = "TRƯNG BÀY TRỨNG",
    ["Sort eggs"] = "Sắp xếp trứng",
    ["Preview card"] = "Thẻ xem trước",
    ["Pick one"] = "Chọn một mục",
    ["Pick any"] = "Chọn bất kỳ",
    ["Value"] = "Giá trị",
    ["Rarity"] = "Độ hiếm",
    ["Time left"] = "Thời gian còn lại",
    ["Default"] = "Mặc định",
    ["Clear"] = "Xóa chọn",
    ["Select all"] = "Chọn tất cả",
    ["SIZE"] = "KÍCH CỠ",
    ["WEIGHT"] = "CÂN NẶNG",
    ["READY"] = "SẴN SÀNG",
    ["IN BAG"] = "TRONG TÚI",
    ["GROWING"] = "ĐANG LỚN",
    ["Hatch now"] = "Ấp ngay",
    ["Hold egg"] = "Cầm trứng",
    ["Fly to egg"] = "Bay tới trứng",
    ["Steal egg"] = "Cướp trứng",

    ["Enchanted Forest"] = "Rừng Phù Phép",
    ["Light Dark"] = "Sáng Tối",
    ["Titan Temple"] = "Đền Titan",
    ["Cherry Blossom"] = "Hoa Anh Đào",
    ["Prehistoric"] = "Tiền Sử",
    ["Abyss Ocean"] = "Đáy Đại Dương",
    ["Volcano"] = "Núi Lửa",
    ["Snow"] = "Tuyết",
    ["Jungle"] = "Rừng Rậm",
    ["Desert"] = "Sa Mạc",
    ["Lake"] = "Hồ Nước",
    ["Forest"] = "Khu Rừng",

    ["Silver"] = "Bạc",
    ["Rainbow"] = "Cầu Vồng",
    ["Golden"] = "Vàng",
    ["Fractured"] = "Rạn Nứt",
    ["Scrambled"] = "Hỗn Loạn",
    ["Enchanted"] = "Phù Phép",
    ["Nitro"] = "Nitro",
    ["SCRAMBLED"] = "HỖN LOẠN",
    ["NITRO"] = "NITRO",
    ["FRACTURED"] = "RẠN NỨT",
    ["ENCHANTED"] = "PHÙ PHÉP",

    ["Farm"] = "Cày Cuốc",
    ["Pen"] = "Chuồng Ấp",
    ["PEN"] = "CHUỒNG ẤP",
    ["Treadmill"] = "Máy Tập",
    ["TREADMILL"] = "MÁY TẬP CHẠY",
    ["Mutate"] = "Đột Biến",
    ["MUTATE"] = "ĐỘT BIẾN",
    ["Sell"] = "Bán",
    ["SELL"] = "BÁN TỰ ĐỘNG",
    ["Fuse"] = "Dung Hợp",
    ["FUSE"] = "DUNG HỢP",
    ["Priority"] = "Ưu Tiên",
    ["PRIORITY"] = "THỨ TỰ ƯU TIÊN",
    ["AUTO PLACE"] = "TỰ ĐỘNG ĐẶT TRỨNG",
    ["Auto place"] = "Tự động đặt trứng",
    ["Place when"] = "Đặt khi",
    ["Always"] = "Luôn luôn",
    ["Place first"] = "Ưu tiên đặt",
    ["AUTO HATCH"] = "TỰ ĐỘNG ẤP TRỨNG",
    ["Auto hatch"] = "Tự động ấp trứng",
    ["Equip best pets"] = "Trang bị pet mạnh nhất",
    ["READY NOW"] = "SẴN SÀNG ẤP",
    ["Auto treadmill"] = "Tự chạy máy tập",
    ["Auto upgrade treadmill"] = "Tự nâng cấp máy tập",
    ["PROGRESS"] = "TIẾN TRÌNH",
    ["Auto upgrade base"] = "Tự nâng cấp căn cứ",
    ["Auto buy trails"] = "Tự mua vệt sáng",
    ["Auto claim offline cash"] = "Tự nhận tiền ngoại tuyến",
    ["Auto claim index rewards"] = "Tự nhận thưởng Chỉ mục",
    ["AUTO MUTATE"] = "TỰ ĐỘNG ĐỘT BIẾN",
    ["Auto mutate"] = "Tự động đột biến",
    ["MUTATE FILTER"] = "BỘ LỌC ĐỘT BIẾN",
    ["Use items"] = "Dùng vật phẩm",
    ["Mutate first"] = "Ưu tiên đột biến",
    ["Auto buy Nitro"] = "Tự mua Nitro",
    ["PETS"] = "THÚ CƯNG (PETS)",
    ["EGGS"] = "TRỨNG (EGGS)",
    ["Auto sell pets"] = "Tự động bán pet",
    ["Auto sell eggs"] = "Tự động bán trứng",
    ["Sell rarities"] = "Độ hiếm bán",
    ["Never sell"] = "Không bao giờ bán",
    ["Only mutations"] = "Chỉ bán đột biến",
    ["Only below /s"] = "Chỉ dưới mức /s",
    ["Keep mutated"] = "Giữ lại đồ đột biến",
    ["Sell matching pets now"] = "Bán các pet khớp ngay",
    ["Sell matching eggs now"] = "Bán các trứng khớp ngay",
    ["LAB EGGS"] = "TRỨNG PHÒNG LAB",
    ["FAVORITE"] = "YÊU THÍCH (KHÓA)",
    ["Auto favorite"] = "Tự động khóa bảo vệ",
    ["Auto sell lab eggs"] = "Tự động bán trứng Lab",
    ["Sell matching lab eggs now"] = "Bán trứng Lab khớp ngay",
    ["Match"] = "Điều kiện khớp",
    ["All picked rules"] = "Khớp tất cả quy tắc",
    ["Any picked rule"] = "Khớp bất kỳ quy tắc",
    ["Always favorite"] = "Luôn khóa loài này",
    ["Favorite equipped"] = "Khóa pet đang trang bị",
    ["FUSE MACHINE"] = "MÁY DUNG HỢP",
    ["No 3 matching pets"] = "Chưa đủ 3 pet cùng loại",
    ["Auto fuse"] = "Tự động dung hợp",
    ["Fuse first"] = "Ưu tiên dung hợp",
    ["Lowest rarity"] = "Độ hiếm thấp nhất",
    ["Highest rarity"] = "Độ hiếm cao nhất",
    ["Use pets"] = "Sử dụng pet",
    ["Lowest value first"] = "Giá trị thấp nhất trước",
    ["Highest value first"] = "Giá trị cao nhất trước",
    ["Skip mutated"] = "Bỏ qua pet đột biến",
    ["Eject odd pets"] = "Đẩy pet lẻ ra ngoài",
    ["FUSE FILTER"] = "BỘ LỌC DUNG HỢP",
    ["Only these pets"] = "Chỉ những pet này",
    ["Never fuse"] = "Không bao giờ dung hợp",
    ["FUSE PREDICTOR"] = "DỰ ĐOÁN DUNG HỢP",
    ["SLOTS"] = "Ô CHỨA",
    ["STATUS"] = "TRẠNG THÁI",
    ["Waiting for pets"] = "Đang chờ pet",
    ["LIKELY SIZE"] = "KÍCH CỠ DỰ KIẾN",
    ["CHANCE"] = "TỶ LỆ",
    ["VALUE"] = "GIÁ TRỊ",
    ["BEST CASE"] = "TỐT NHẤT CÓ THỂ",
    ["TASK ORDER"] = "THỨ TỰ TÁC VỤ",
    ["Top goes first. A carried egg is always delivered first, and before the field opens every task waits in the safe zone."] = "Mục ở trên làm trước. Trứng đang bê luôn được giao trước, và trước khi khu vực mở thì mọi tác vụ sẽ đợi ở vùng an toàn.",
    ["DOING"] = "ĐANG LÀM",
    ["WAITING"] = "ĐANG CHỜ",
    ["Steal filter eggs"] = "Cướp trứng theo bộ lọc",
    ["Shooting Star"] = "Bắt Sao Băng",
    ["Racing Event"] = "Sự Kiện Đua Xe",
    ["Butterfly"] = "Bắt Bướm",
    ["Steal wisp eggs"] = "Cướp trứng Wisp",
    ["Wisp"] = "Nhặt Wisp",
    ["Steal missing index"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal lab eggs"] = "Cướp trứng phòng Lab",
    ["Place"] = "Đặt trứng vào chuồng",
    ["Butterfly machine"] = "Máy đổi Bướm",

    -- Event: Race, Star, Butterfly, Lab, AA
    ["Race"] = "Đua Xe",
    ["RACE"] = "ĐUA XE",
    ["Star"] = "Sao Băng",
    ["STAR"] = "SAO BĂNG",
    ["BUTTERFLY"] = "BẮT BƯỚM",
    ["Lab"] = "Phòng Lab",
    ["LAB"] = "PHÒNG LAB",
    ["AA"] = "Admin (AA)",
    ["RACING EVENT"] = "SỰ KIỆN ĐUA XE",
    ["NEXT RACE"] = "ĐUA TIẾP THEO",
    ["WINS"] = "THẮNG",
    ["TROPHIES"] = "CÚP",
    ["Auto race"] = "Tự động đua xe",
    ["Race speed"] = "Tốc độ đua",
    ["Lower it if wins do not count"] = "Giảm tốc độ nếu thắng không được tính",
    ["Use power-ups"] = "Tự dùng vật phẩm tăng tốc",
    ["REWARDS"] = "PHẦN THƯỞNG",
    ["Auto claim rewards"] = "Tự nhận phần thưởng",
    ["Auto equip racer"] = "Tự trang bị xe đua",
    ["Racer"] = "Xe đua",
    ["Best owned"] = "Tốt nhất đang có",
    ["Auto buy shop"] = "Tự mua vật phẩm Shop",
    ["Shop items"] = "Vật phẩm Shop",
    ["SHOOTING STAR"] = "SAO BĂNG RƠI",
    ["LANDS IN"] = "RƠI SAU",
    ["CATCH"] = "BẮT SAO BĂNG",
    ["A Shooting Star is rare and only you can catch yours. It lands in Cosmic, runs from you, and needs a 1.6 s hold."] = "Sao Băng rất hiếm và chỉ bạn mới bắt được của mình. Nó rơi ở khu Vũ Trụ (Cosmic), chạy trốn bạn và cần nhấn giữ 1.6 giây.",
    ["CAUGHT"] = "ĐÃ BẮT",
    ["EXPIRES IN"] = "BIẾN MẤT SAU",
    ["SLIPPED"] = "TUỘT MẤT",
    ["TRIES"] = "SỐ LẦN THỬ",
    ["DISTANCE"] = "KHOẢNG CÁCH",
    ["Auto catch shooting star"] = "Tự động bắt sao băng",
    ["BUTTERFLY BLOOM"] = "MÙA BƯỚM NỞ",
    ["Auto butterfly bloom"] = "Tự động bắt bướm",
    ["EMERALD"] = "LỤC BẢO",
    ["SAPPHIRE"] = "LAM NGỌC",
    ["AMETHYST"] = "THẠCH ANH TÍM",
    ["RADIANT"] = "RỰC RỠ",
    ["ESSENCE"] = "TINH CHẤT",
    ["Catch mode"] = "Chế độ bắt",
    ["Stand"] = "Đứng yên",
    ["Chase"] = "Đuổi theo",
    ["BUTTERFLY MACHINE"] = "MÁY ĐỔI BƯỚM",
    ["Auto trade up"] = "Tự nâng cấp bậc bướm",
    ["Trade"] = "Giao dịch đổi",
    ["Smart trade for essence"] = "Đổi bướm lấy tinh chất thông minh",
    ["Auto craft essence"] = "Tự chế tạo tinh chất",
    ["WISP COMPANION"] = "ĐỒNG HÀNH WISP",
    ["Catch priority"] = "Ưu tiên bắt",
    ["Rarest"] = "Hiếm nhất",
    ["Catch"] = "Loại bướm bắt",
    ["Radiant"] = "Rực Rỡ",
    ["Catch speed"] = "Tốc độ bắt",
    ["Auto wisp quest"] = "Tự làm nhiệm vụ Wisp",
    ["Auto banjo cricket"] = "Tự bắt dế Banjo",
    ["STAGE"] = "GIAI ĐOẠN",
    ["LAB ODDS"] = "TỶ LỆ PHÒNG LAB",
    ["BANNER"] = "BĂNG RÔN",
    ["ENDS IN"] = "KẾT THÚC SAU",
    ["BANNER CHANCE"] = "TỶ LỆ BĂNG RÔN",
    ["NEXT"] = "TIẾP THEO",
    ["Experimental Pets"] = "Pet Thí Nghiệm",
    ["Biohazard Pets"] = "Pet Sinh Học",
    ["Lab banners"] = "Băng rôn phòng Lab",
    ["Auto trade in"] = "Tự động đổi trứng Lab",
    ["Auto reroll recipe"] = "Tự đổi lại công thức",
    ["Place lab reward eggs"] = "Đặt trứng thưởng từ Lab",
    ["ADMIN ABUSE"] = "LẠM DỤNG ADMIN (ABUSE)",
    ["No admin boost right now"] = "Hiện không có buff Admin nào",
    ["Instant steal (Admin Treadmill)"] = "Cướp tức thì (Máy tập Admin)",
    ["Use admin treadmill"] = "Tự dùng máy tập Admin",
    ["CAPTURE THE EGG"] = "CƯỚP TRỨNG SỰ KIỆN",
    ["Auto capture event egg"] = "Tự bắt trứng sự kiện",
    ["Take it from the holder"] = "Giật trứng từ người đang cầm",
    ["Hold height"] = "Độ cao giữ trứng",
    ["Keep away"] = "Khoảng cách né tránh",
    ["MINIGAME EGGS"] = "TRỨNG MINIGAME",
    ["Waiting for Red Light Green Light or T-Rex Run"] = "Đang chờ Đèn Đỏ Đèn Xanh hoặc Chạy Trốn T-Rex",
    ["Auto steal minigame egg"] = "Tự cướp trứng Minigame",

    -- Player: ESP, Move, Combat
    ["Player"] = "Người Chơi",
    ["ESP"] = "Định Vị (ESP)",
    ["Move"] = "Di Chuyển",
    ["MOVE"] = "DI CHUYỂN",
    ["Combat"] = "Chiến Đấu",
    ["COMBAT"] = "CHIẾN ĐẤU",
    ["FIELD EGGS"] = "TRỨNG NGOÀI SÂN",
    ["Egg ESP"] = "ESP Trứng",
    ["Show"] = "Hiển thị",
    ["Name"] = "Tên",
    ["Fixed size"] = "Cố định kích cỡ",
    ["OTHERS"] = "MỤC KHÁC",
    ["Pen egg ESP"] = "ESP trứng trong chuồng",
    ["Other pens ESP"] = "ESP chuồng người khác",
    ["Guard ESP"] = "ESP Vệ sĩ",
    ["Player ESP"] = "ESP Người chơi",
    ["ESP size"] = "Kích cỡ ESP",
    ["MOVEMENT"] = "TỐC ĐỘ & DI CHUYỂN",
    ["Speed boost"] = "Tăng tốc chạy",
    ["Boost speed"] = "Tốc độ tăng thêm",
    ["Infinite jump"] = "Nhảy vô hạn",
    ["God mode"] = "Bất tử (God mode)",
    ["PROTECTION"] = "BẢO VỆ NHÂN VẬT",
    ["Anti ragdoll"] = "Chống ngã (Anti Ragdoll)",
    ["Ignore traps"] = "Bỏ qua bẫy",
    ["Instant prompts"] = "Tương tác nhấn giữ tức thì",
    ["Anti AFK"] = "Chống treo máy (Anti AFK)",
    ["Invisible"] = "Tàng hình",
    ["AUTO HIT"] = "TỰ ĐỘNG ĐÁNH",
    ["Auto hit"] = "Tự động đánh",
    ["Hit who"] = "Mục tiêu đánh",
    ["Nearest player"] = "Người chơi gần nhất",
    ["Chosen player"] = "Người chơi chỉ định",
    ["Chase speed"] = "Tốc độ đuổi theo",
    ["HIT AURA"] = "VÒNG ĐÁNH TỰ ĐỘNG",
    ["Hit aura"] = "Vòng đánh tự động (Hit Aura)",
    ["Skip friends"] = "Bỏ qua bạn bè",
    ["WEAPONS"] = "VŨ KHÍ",
    ["Use weapons"] = "Sử dụng vũ khí",
    ["Hold each"] = "Thời gian cầm mỗi món",

    -- System: Server, Webhook, Optimizer, Interface, Config
    ["System"] = "Hệ Thống",
    ["Server"] = "Máy Chủ",
    ["SERVER"] = "MÁY CHỦ",
    ["Webhook"] = "Webhook",
    ["WEBHOOK"] = "WEBHOOK",
    ["Optimizer"] = "Tối Ưu Hóa",
    ["OPTIMIZER"] = "TỐI ƯU HÓA (GIẢM LAG)",
    ["Interface"] = "Giao Diện",
    ["INTERFACE"] = "GIAO DIỆN",
    ["Config"] = "Cấu Hình",
    ["CONFIG"] = "CẤU HÌNH",
    ["ACTIVE"] = "ĐANG DÙNG",
    ["SAVED CONFIGS"] = "ĐÃ LƯU",
    ["Set as active config"] = "Đặt làm cấu hình chính",
    ["Set active"] = "Kích hoạt",
    ["Save changes"] = "Lưu thay đổi",
    ["Save"] = "Lưu",
    ["PROFILES"] = "HỒ SƠ CẤU HÌNH",
    ["New config name"] = "Tên cấu hình mới",
    ["Auto if empty"] = "Tự đặt nếu trống",
    ["Create config"] = "Tạo cấu hình mới",
    ["Create"] = "Tạo mới",
    ["Pick to delete"] = "Chọn mục cần xóa",
    ["Delete picked"] = "Xóa mục đã chọn",
    ["Delete"] = "Xóa",
    ["Restore deleted"] = "Khôi phục mục đã xóa",
    ["Export config"] = "Xuất mã cấu hình",
    ["Import text"] = "Dán mã cấu hình",
    ["Paste config text"] = "Dán mã JSON vào đây",
    ["Import config"] = "Nhập cấu hình",
    ["Import"] = "Nhập",
    ["Config imported"] = "Đã nhập cấu hình",
    ["Config Imported"] = "Đã nhập cấu hình",
    ["Config loaded"] = "Đã nạp cấu hình",
    ["Later"] = "Để sau",
    ["Apply now"] = "Áp dụng ngay",
    ["Hop to"] = "Chuyển tới server",
    ["Least players"] = "Ít người chơi nhất",
    ["Most players"] = "Đông người chơi nhất",
    ["Random"] = "Ngẫu nhiên",
    ["Hop server"] = "Đổi máy chủ",
    ["Hop"] = "Đổi ngay",
    ["Rejoin this server"] = "Vào lại máy chủ này",
    ["Copy"] = "Sao chép",
    ["JOIN AND STAY"] = "VÀO PHÒNG & DUY TRÌ",
    ["Job ID"] = "Mã phòng (Job ID)",
    ["Paste a Job ID"] = "Dán mã Job ID vào đây",
    ["Join that server"] = "Vào máy chủ đó",
    ["Join"] = "Vào ngay",
    ["Rejoin on kick"] = "Tự vào lại khi bị văng/kick",
    ["Auto load script"] = "Tự chạy lại script khi chuyển server",
    ["DISCORD WEBHOOK"] = "WEBHOOK DISCORD",
    ["Webhook URL"] = "Đường dẫn Webhook",
    ["Ping everyone"] = "Tag @everyone",
    ["WHAT TO POST"] = "NỘI DUNG GỬI BÁO CÁO",
    ["Post stolen eggs"] = "Báo cáo trứng cướp được",
    ["Post fused eggs"] = "Báo cáo trứng dung hợp",
    ["POSTED"] = "ĐÃ GỬI",
    ["Send a test post"] = "Gửi tin nhắn thử nghiệm",
    ["Test"] = "Thử nghiệm",
    ["Post when bag is full"] = "Gửi thông báo khi đầy túi",
    ["GRAPHICS"] = "ĐỒ HỌA",
    ["Low graphics"] = "Đồ họa thấp (Tăng FPS)",
    ["Disable 3D Render"] = "Tắt kết xuất 3D (Treo máy)",
    ["Background color"] = "Màu nền màn hình",
    ["Black"] = "Màu Đen",
    ["White"] = "Màu Trắng",
    ["Hide game UI"] = "Ẩn giao diện gốc của Game",
    ["FRAME RATE"] = "TỐC ĐỘ KHUNG HÌNH (FPS)",
    ["FPS cap"] = "Giới hạn FPS",
    ["Show FPS and ping"] = "Hiện chỉ số FPS và Ping",
    ["BASES"] = "CĂN CỨ (BASES)",
    ["Hide other players' pets and eggs"] = "Ẩn pet và trứng của người chơi khác",
    ["Hide my pets and eggs"] = "Ẩn pet và trứng của bản thân",
    ["Theme"] = "Chủ đề màu",
    ["Toggle key"] = "Phím đóng/mở Menu",
    ["Quick bar"] = "Thanh phím tắt nhanh",
    ["QUICK BAR"] = "THANH PHÍM TẮT NHANH",
    ["Auto save"] = "Tự động lưu cấu hình",
    ["Auto load"] = "Tự động nạp cấu hình",
    ["Load config"] = "Nạp cấu hình",
    ["Reset config"] = "Đặt lại mặc định",
    ["Delete config"] = "Xóa cấu hình",

    -- Độ hiếm
    ["Common"] = "Phổ Thông",
    ["Uncommon"] = "Thường",
    ["Rare"] = "Hiếm",
    ["Epic"] = "Sử Thi",
    ["Legendary"] = "Huyền Thoại",
    ["Mythic"] = "Thần Thoại",
    ["Cosmic"] = "Vũ Trụ",
    ["Secret"] = "Bí Ẩn",
    ["Divine"] = "Thánh Thần",
    ["Eternal"] = "Vĩnh Cửu",
    ["COMMON"] = "PHỔ THÔNG",
    ["UNCOMMON"] = "THƯỜNG",
    ["RARE"] = "HIẾM",
    ["EPIC"] = "SỬ THI",
    ["LEGENDARY"] = "HUYỀN THOẠI",
    ["MYTHIC"] = "THẦN THOẠI",
    ["COSMIC"] = "VŨ TRỤ",
    ["SECRET"] = "BÍ ẨN",
    ["DIVINE"] = "THÁNH THẦN",
    ["ETERNAL"] = "VĨNH CỬU"
}

local LOWER_EXACT_MATCH_VI = {}
for k, v in pairs(EXACT_MATCH_VI) do
    LOWER_EXACT_MATCH_VI[k:lower()] = v
end

local STATUS_ACTION_PATTERNS_VI = {
    { pat = "^[Nn]o eggs? match%w* your (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o eggs? match%w* (.+)$", rep = "Không có trứng nào khớp %1" },
    { pat = "^[Nn]o pets? match%w* (.+)$", rep = "Không có pet nào khớp %1" },
    { pat = "^[Nn]o (.+) found(.*)$", rep = "Không tìm thấy %1%2" },
    { pat = "^[Nn]o (.+) available(.*)$", rep = "Không có sẵn %1%2" },
    { pat = "^[Nn]o (.+) in (.+)$", rep = "Không có %1 trong %2" },
    { pat = "^[Nn]o (.+) to (.+)$", rep = "Không có %1 để %2" },
    { pat = "^[Cc]arrying (.+) to safe zone(.*)$", rep = "Đang mang %1 về vùng an toàn%2" },
    { pat = "^[Cc]arrying (.+) to base(.*)$", rep = "Đang mang %1 về căn cứ%2" },
    { pat = "^[Cc]arrying (.+) to pen(.*)$", rep = "Đang mang %1 về chuồng%2" },
    { pat = "^[Cc]arrying (.+) home(.*)$", rep = "Đang mang %1 về nhà%2" },
    { pat = "^[Cc]arrying (.+)$", rep = "Đang bê %1" },
    { pat = "^[Dd]elivering (.+) to (.+)$", rep = "Đang giao %1 tới %2" },
    { pat = "^[Dd]elivering (.+) home(.*)$", rep = "Đang giao %1 về nhà%2" },
    { pat = "^[Dd]elivering (.+)$", rep = "Đang giao %1" },
    { pat = "^[Bb]ringing (.+) home(.*)$", rep = "Đang mang %1 về nhà%2" },
    { pat = "^[Bb]ringing (.+)$", rep = "Đang mang %1" },
    { pat = "^[Tt]aking (.+) from (.+)$", rep = "Đang giật %1 từ %2" },
    { pat = "^[Tt]aking (.+) home(.*)$", rep = "Đang đem %1 về nhà%2" },
    { pat = "^[Tt]aking (.+)$", rep = "Đang lấy %1" },
    { pat = "^[Ss]tealing (.+) from (.+)$", rep = "Đang cướp %1 từ %2" },
    { pat = "^[Ss]tealing (.+)$", rep = "Đang cướp %1" },
    { pat = "^[Gg]rabbing (.+)$", rep = "Đang chộp lấy %1" },
    { pat = "^[Pp]icking up (.+)$", rep = "Đang nhặt %1" },
    { pat = "^[Cc]ollecting (.+)$", rep = "Đang thu thập %1" },
    { pat = "^[Hh]olding (.+)$", rep = "Đang giữ %1" },
    { pat = "^[Cc]apturing (.+)$", rep = "Đang bắt giữ %1" },
    { pat = "^[Dd]ropping (.+) at (.+)$", rep = "Đang thả %1 tại %2" },
    { pat = "^[Dd]ropping (.+)$", rep = "Đang thả %1" },
    { pat = "^[Tt]weening to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Tt]eleporting to (.+)$", rep = "Đang dịch chuyển tới %1" },
    { pat = "^[Gg]oing to (.+)$", rep = "Đang đi tới %1" },
    { pat = "^[Mm]oving to (.+)$", rep = "Đang di chuyển tới %1" },
    { pat = "^[Ww]alking to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Rr]unning to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Ff]lying to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Rr]eturning to (.+)$", rep = "Đang quay về %1" },
    { pat = "^[Hh]eading to (.+)$", rep = "Đang hướng tới %1" },
    { pat = "^[Pp]lacing (.+)$", rep = "Đang đặt %1" },
    { pat = "^[Hh]atching (.+)$", rep = "Đang ấp %1" },
    { pat = "^[Mm]utating (.+)$", rep = "Đang đột biến %1" },
    { pat = "^[Ss]elling (.+)$", rep = "Đang bán %1" },
    { pat = "^[Ff]using (.+)$", rep = "Đang dung hợp %1" },
    { pat = "^[Uu]pgrading (.+)$", rep = "Đang nâng cấp %1" },
    { pat = "^[Bb]uying (.+)$", rep = "Đang mua %1" },
    { pat = "^[Cc]laiming (.+)$", rep = "Đang nhận %1" },
    { pat = "^[Ee]quipping (.+)$", rep = "Đang trang bị %1" },
    { pat = "^[Ff]avoriting (.+)$", rep = "Đang khóa bảo vệ %1" },
    { pat = "^[Ee]jecting (.+)$", rep = "Đang đẩy %1 ra" },
    { pat = "^[Cc]atching (.+)$", rep = "Đang bắt %1" },
    { pat = "^[Cc]hasing (.+)$", rep = "Đang đuổi theo %1" },
    { pat = "^[Aa]ttacking (.+)$", rep = "Đang tấn công %1" },
    { pat = "^[Hh]itting (.+)$", rep = "Đang đánh %1" },
    { pat = "^[Kk]illing (.+)$", rep = "Đang hạ %1" },
    { pat = "^[Tt]rading (.+) for (.+)$", rep = "Đang đổi %1 lấy %2" },
    { pat = "^[Tt]rading in (.+)$", rep = "Đang đổi %1" },
    { pat = "^[Tt]rading (.+)$", rep = "Đang giao dịch %1" },
    { pat = "^[Cc]rafting (.+)$", rep = "Đang chế tạo %1" },
    { pat = "^[Rr]erolling (.+)$", rep = "Đang đổi lại %1" },
    { pat = "^[Aa]voiding (.+)$", rep = "Đang né %1" },
    { pat = "^[Ee]vading (.+)$", rep = "Đang tránh %1" },
    { pat = "^[Ww]aiting for (.+)$", rep = "Đang chờ %1" },
    { pat = "^[Ww]aiting in (.+)$", rep = "Đang đợi ở %1" },
    { pat = "^[Ww]aiting %((.+)%)$", rep = "Đang chờ (%1)" },
    { pat = "^[Ss]earching for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ll]ooking for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ss]canning (.+)$", rep = "Đang quét %1" },
    { pat = "^[Ff]arming (.+)$", rep = "Đang cày %1" },
    { pat = "^[Uu]sing (.+)$", rep = "Đang dùng %1" },
    { pat = "^[Jj]oining (.+)$", rep = "Đang tham gia %1" },
    { pat = "^[Hh]opping (.+)$", rep = "Đang đổi %1" }
}

local SMART_PHRASE_FALLBACK_VI = {
    { "no egg matches your targets", "Không có trứng nào khớp mục tiêu" },
    { "no eggs match your targets", "Không có trứng nào khớp mục tiêu" },
    { "no egg matches filter", "Không có trứng khớp bộ lọc" },
    { "no eggs match filter", "Không có trứng khớp bộ lọc" },
    { "waiting for field to open", "Đang chờ sân trứng mở" },
    { "waiting for eggs to spawn", "Đang chờ trứng xuất hiện" },
    { "waiting in safe zone", "Đợi ở vùng an toàn" },
    { "returning to safe zone", "Đang về vùng an toàn" },
    { "going to safe zone", "Đang về vùng an toàn" },
    { "egg bag is full", "Túi trứng đã đầy" },
    { "pet bag is full", "Túi pet đã đầy" },
    { "bag is full", "Túi đã đầy" },
    { "pen is full", "Chuồng đã đầy" },
    { "field is closed", "Sân trứng đang đóng" },
    { "field opens in", "Sân mở sau" },
    { "opens in", "mở sau" },
    { "starts in", "bắt đầu sau" },
    { "ends in", "kết thúc sau" },
    { "lands in", "rơi sau" },
    { "spawns in", "xuất hiện sau" },
    { "your targets", "mục tiêu" },
    { "your target", "mục tiêu" },
    { "matches your", "khớp với" },
    { "matches filter", "khớp bộ lọc" },
    { "safe zone", "vùng an toàn" },
    { "other players", "người chơi khác" },
    { "from players", "từ người chơi" },
    { "missing index", "thiếu trong Chỉ mục" },
    { "shooting star", "sao băng" },
    { "butterfly bloom", "mùa bướm nở" },
    { "racing event", "sự kiện đua xe" },
    { "admin treadmill", "máy tập Admin" },
    { "offline cash", "tiền ngoại tuyến" },
    { "index rewards", "thưởng Chỉ mục" },
    { "lab eggs", "trứng Lab" },
    { "lab egg", "trứng Lab" },
    { "event egg", "trứng sự kiện" },
    { "minigame egg", "trứng Minigame" },
    { "wisp eggs", "trứng Wisp" },
    { "wisp egg", "trứng Wisp" },
    { "to safe zone", "về vùng an toàn" },
    { "to base", "về căn cứ" },
    { "to pen", "vào chuồng" },
    { "is full", "đã đầy" },
    { "is empty", "đang trống" },
    { "is closed", "đang đóng" },
    { "is open", "đang mở" },
    { "to open", "mở cửa" },
    { "to spawn", "xuất hiện" }
}

local WORD_TOKEN_VI = {
    ["idle"] = "Đang rảnh",
    ["carrying"] = "Đang mang",
    ["delivering"] = "Đang giao",
    ["stealing"] = "Đang cướp",
    ["grabbing"] = "Đang chộp",
    ["picking"] = "Đang nhặt",
    ["collecting"] = "Đang thu thập",
    ["holding"] = "Đang giữ",
    ["capturing"] = "Đang bắt giữ",
    ["dropping"] = "Đang thả",
    ["tweening"] = "Đang bay",
    ["teleporting"] = "Đang dịch chuyển",
    ["going"] = "Đang đi",
    ["moving"] = "Đang di chuyển",
    ["walking"] = "Đang đi bộ",
    ["running"] = "Đang chạy",
    ["flying"] = "Đang bay",
    ["returning"] = "Đang quay về",
    ["heading"] = "Đang hướng",
    ["placing"] = "Đang đặt",
    ["hatching"] = "Đang ấp",
    ["mutating"] = "Đang đột biến",
    ["selling"] = "Đang bán",
    ["fusing"] = "Đang dung hợp",
    ["upgrading"] = "Đang nâng cấp",
    ["buying"] = "Đang mua",
    ["claiming"] = "Đang nhận",
    ["equipping"] = "Đang trang bị",
    ["favoriting"] = "Đang khóa",
    ["ejecting"] = "Đang đẩy",
    ["catching"] = "Đang bắt",
    ["chasing"] = "Đang đuổi theo",
    ["attacking"] = "Đang tấn công",
    ["hitting"] = "Đang đánh",
    ["killing"] = "Đang hạ",
    ["trading"] = "Đang đổi",
    ["crafting"] = "Đang chế tạo",
    ["rerolling"] = "Đang đổi lại",
    ["avoiding"] = "Đang né",
    ["evading"] = "Đang tránh",
    ["waiting"] = "Đang chờ",
    ["searching"] = "Đang tìm",
    ["looking"] = "Đang tìm",
    ["scanning"] = "Đang quét",
    ["farming"] = "Đang cày",
    ["using"] = "Đang dùng",
    ["joining"] = "Đang vào",
    ["hopping"] = "Đang đổi",
    ["rejoining"] = "Đang vào lại",
    ["finding"] = "Đang tìm",
    ["checking"] = "Đang kiểm tra",
    ["skipping"] = "Đang bỏ qua",
    ["racing"] = "Đang đua",
    ["cooldown"] = "Hồi chiêu",
    ["ready"] = "Sẵn sàng",
    ["nothing"] = "Không có gì",
    ["none"] = "Không có",
    ["no"] = "Không có",
    ["egg"] = "trứng",
    ["eggs"] = "trứng",
    ["pet"] = "pet",
    ["pets"] = "pet",
    ["matches"] = "khớp",
    ["match"] = "khớp",
    ["matching"] = "khớp",
    ["your"] = "của bạn",
    ["target"] = "mục tiêu",
    ["targets"] = "mục tiêu",
    ["filter"] = "bộ lọc",
    ["home"] = "về nhà",
    ["base"] = "căn cứ",
    ["pen"] = "chuồng",
    ["pens"] = "chuồng",
    ["field"] = "sân trứng",
    ["zone"] = "khu vực",
    ["zones"] = "khu vực",
    ["bag"] = "túi",
    ["full"] = "đầy",
    ["empty"] = "trống",
    ["closed"] = "đóng",
    ["open"] = "mở",
    ["guard"] = "vệ sĩ",
    ["guards"] = "vệ sĩ",
    ["player"] = "người chơi",
    ["players"] = "người chơi",
    ["server"] = "máy chủ",
    ["treadmill"] = "máy tập",
    ["race"] = "đua xe",
    ["star"] = "sao băng",
    ["butterfly"] = "bướm",
    ["portal"] = "cổng",
    ["rewards"] = "thưởng",
    ["reward"] = "thưởng",
    ["cash"] = "tiền",
    ["found"] = "tìm thấy",
    ["available"] = "khả dụng",
    ["to"] = "tới",
    ["from"] = "từ",
    ["in"] = "trong",
    ["at"] = "tại",
    ["for"] = "cho",
    ["with"] = "với",
    ["and"] = "và",
    ["or"] = "hoặc"
}

local DYNAMIC_PATTERNS_VI = {
    { pat = "^(.+) was added to your configs%. Apply it now%??$", rep = "Đã thêm '%1' vào danh sách cấu hình. Áp dụng ngay?" },
    { pat = "^(.+) was added to your configs$", rep = "Đã thêm '%1' vào danh sách cấu hình" },
    { pat = "^QUICK BAR (%d+)$", rep = "THANH NHANH %1" },
    { pat = "Venyx(.-)(%d+) hours? ago", rep = "Chilli Hub%1%2 giờ trước" },
    { pat = "Venyx(.-)(%d+) minutes? ago", rep = "Chilli Hub%1%2 phút trước" },
    { pat = "Venyx(.-)(%d+) days? ago", rep = "Chilli Hub%1%2 ngày trước" },
    { pat = "^ALL (%d+)$", rep = "TẤT CẢ %1" },
    { pat = "^READY (%d+)$", rep = "SẴN SÀNG %1" },
    { pat = "^GROWING (%d+)$", rep = "ĐANG LỚN %1" },
    { pat = "^IN BAG (%d+)$", rep = "TRONG TÚI %1" },
    { pat = "Pen (%d+/%d+) · (%d+) egg%(s%) ready to place", rep = "Chuồng %1 · %2 trứng sẵn sàng đặt" },
    { pat = "(%d+) egg%(s%) can be mutated", rep = "%1 trứng có thể đột biến" },
    { pat = "(%d+) pet%(s%) match", rep = "%1 pet khớp bộ lọc" },
    { pat = "(%d+) egg%(s%) match", rep = "%1 trứng khớp bộ lọc" },
    { pat = "(%d+) lab egg%(s%) match", rep = "%1 trứng Lab khớp bộ lọc" },
    { pat = "^(%d+) pets$", rep = "%1 thú cưng" },
    { pat = "(%d+ / %d+) players · (.+)", rep = "%1 người chơi · %2" },
    { pat = "Experimental Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Thí Nghiệm · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Biohazard Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Sinh Học · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Unstable DNA · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "DNA Bất Ổn · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "^Mythic · 1 in ([%d%.]+)$", rep = "Thần Thoại · 1 trên %1" },
    { pat = "^Cosmic · 1 in ([%d%.]+)$", rep = "Vũ Trụ · 1 trên %1" },
    { pat = "^Secret · 1 in ([%d%.]+)$", rep = "Bí Ẩn · 1 trên %1" },
    { pat = "^Divine · 1 in ([%d%.]+)$", rep = "Thánh Thần · 1 trên %1" },
    { pat = "^Eternal · 1 in ([%d%.]+)$", rep = "Vĩnh Cửu · 1 trên %1" }
}

local function applyCaseInsensitivePhrases(str)
    local out = str
    for i = 1, #SMART_PHRASE_FALLBACK_VI do
        local pair = SMART_PHRASE_FALLBACK_VI[i]
        local enLower = pair[1]:lower()
        local viRep = pair[2]
        local lowerOut = out:lower()
        local sIdx, eIdx = lowerOut:find(enLower, 1, true)
        if sIdx then
            out = out:sub(1, sIdx - 1) .. viRep .. out:sub(eIdx + 1)
        end
    end
    return out
end

local function applyWordByWordFallback(str)
    return (str:gsub("([%a']+)", function(word)
        local wLower = word:lower()
        if WORD_TOKEN_VI[wLower] then
            return WORD_TOKEN_VI[wLower]
        elseif LOWER_EXACT_MATCH_VI[wLower] then
            return LOWER_EXACT_MATCH_VI[wLower]
        end
        return word
    end))
end

local function translateStatusAction(cleanEn)
    if not cleanEn or cleanEn == "" then
        return (State.Language == "EN") and "Idle" or "Đang rảnh"
    end

    local trimmed = (cleanEn:match("^%s*(.-)%s*$") or cleanEn):gsub("%s+", " ")
    local stripped = trimmed:gsub("%.+$", "")

    if State.Language == "EN" then
        if stripped == "Đang rảnh" then return "Idle" end
        return stripped
    end

    local lowerStripped = stripped:lower()
    if lowerStripped == "idle" or stripped == "Đang rảnh" then
        return "Đang rảnh"
    end

    local cacheKey = "STATUS_VI|" .. stripped
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if EXACT_MATCH_VI[stripped] then
        FastCache[cacheKey] = EXACT_MATCH_VI[stripped]
        return EXACT_MATCH_VI[stripped]
    end
    if LOWER_EXACT_MATCH_VI[lowerStripped] then
        FastCache[cacheKey] = LOWER_EXACT_MATCH_VI[lowerStripped]
        return LOWER_EXACT_MATCH_VI[lowerStripped]
    end

    local out = stripped
    for i = 1, #STATUS_ACTION_PATTERNS_VI do
        local item = STATUS_ACTION_PATTERNS_VI[i]
        if out:find(item.pat) then
            out = out:gsub(item.pat, item.rep)
            break
        end
    end

    out = applyCaseInsensitivePhrases(out)
    out = applyWordByWordFallback(out)
    out = out:gsub("%s+", " "):match("^%s*(.-)%s*$") or out

    FastCache[cacheKey] = out
    return out
end

local function translateVenyxText(raw)
    if not raw or raw == "" then return raw end
    local lang = State.Language
    local cacheKey = lang .. "|" .. raw
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if raw:find("Venyx SAE", 1, true) then
        raw = raw:gsub("Venyx SAE", "Chilli SAE")
    elseif raw == "VENYX" then
        raw = NEW_TITLE
    end

    if lang == "EN" then
        FastCache[cacheKey] = raw
        return raw
    end

    local normalized = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")

    if EXACT_MATCH_VI[normalized] then
        local out = EXACT_MATCH_VI[normalized]
        FastCache[cacheKey] = out
        return out
    end
    if LOWER_EXACT_MATCH_VI[normalized:lower()] then
        local out = LOWER_EXACT_MATCH_VI[normalized:lower()]
        FastCache[cacheKey] = out
        return out
    end

    local baseBeforeDots = normalized:match("^(.+)%.%.%.$")
    if baseBeforeDots then
        baseBeforeDots = baseBeforeDots:match("^%s*(.-)%s*$") or baseBeforeDots
        local mappedBase = EXACT_MATCH_VI[baseBeforeDots] or LOWER_EXACT_MATCH_VI[baseBeforeDots:lower()]
        if mappedBase then
            local out = mappedBase .. "..."
            FastCache[cacheKey] = out
            return out
        end
    end

    local prefix, wordPart = normalized:match("^([^%w%s]+%s*)(.+)$")
    if prefix and wordPart then
        local mappedWord = EXACT_MATCH_VI[wordPart] or LOWER_EXACT_MATCH_VI[wordPart:lower()]
        if mappedWord then
            local out = prefix .. mappedWord
            FastCache[cacheKey] = out
            return out
        end
    end

    local result = normalized
    for i = 1, #DYNAMIC_PATTERNS_VI do
        local item = DYNAMIC_PATTERNS_VI[i]
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            FastCache[cacheKey] = result
            return result
        end
    end

    for i = 1, #STATUS_ACTION_PATTERNS_VI do
        local item = STATUS_ACTION_PATTERNS_VI[i]
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            result = applyCaseInsensitivePhrases(result)
            FastCache[cacheKey] = result
            return result
        end
    end

    FastCache[cacheKey] = raw
    return raw
end

local function applyElementTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__FpsHookSession") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end
    if inst:GetAttribute("__IsTranslating") then return end

    if inst:IsA("TextBox") then
        local origPh = inst:GetAttribute("OrigPlaceholder")
        if not origPh and inst.PlaceholderText ~= "" and not containsVietnameseChars(inst.PlaceholderText) then
            origPh = inst.PlaceholderText
            inst:SetAttribute("OrigPlaceholder", origPh)
        end
        if origPh then
            inst.PlaceholderText = translateVenyxText(origPh)
        end

        if not inst:IsFocused() then
            local boxTxt = inst.Text
            if boxTxt == "Off" or boxTxt == "Tắt" or boxTxt == "None" or boxTxt == "Không có" then
                local origBox = inst:GetAttribute("OrigBoxText")
                if not origBox then
                    origBox = (boxTxt == "Tắt") and "Off" or ((boxTxt == "Không có") and "None" or boxTxt)
                    inst:SetAttribute("OrigBoxText", origBox)
                end
                local mappedBox = translateVenyxText(origBox)
                if inst.Text ~= mappedBox then
                    inst:SetAttribute("__IsTranslating", true)
                    inst:SetAttribute("__LastTranslated", mappedBox)
                    pcall(function() inst.Text = mappedBox end)
                    inst:SetAttribute("__IsTranslating", false)
                end
            end
        end
        return
    end

    local rawText = inst.Text
    if isFpsCounterText(rawText) then
        hookFakeFpsCounter(inst)
        return
    end

    local original = inst:GetAttribute("OrigRawText")
    if not original then
        if not containsVietnameseChars(rawText) then
            original = rawText
            inst:SetAttribute("OrigRawText", original)
        else
            return
        end
    end

    local mapped = translateVenyxText(original)
    inst:SetAttribute("__LastTranslated", mapped)

    if inst.Text ~= mapped then
        inst:SetAttribute("__IsTranslating", true)
        pcall(function() inst.Text = mapped end)
        inst:SetAttribute("__IsTranslating", false)
    end
end

local function hookTextForTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end

    if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
        hookFakeFpsCounter(inst)
        return
    end

    applyElementTranslation(inst)

    if inst:GetAttribute("__TransHookSession") == MY_SESSION_ID then return end
    inst:SetAttribute("__TransHookSession", MY_SESSION_ID)
    table.insert(State.TrackedTexts, inst)

    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if not isCurrentSession() then return end
        if inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__IslandDone") or inst:GetAttribute("__HiddenVxLogo") then return end

        if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
            hookFakeFpsCounter(inst)
            return
        end
        if inst:IsA("TextBox") then
            applyElementTranslation(inst)
            return
        end

        local currentTxt = inst.Text
        if currentTxt ~= inst:GetAttribute("__LastTranslated") and not containsVietnameseChars(currentTxt) then
            inst:SetAttribute("OrigRawText", currentTxt)
            applyElementTranslation(inst)
        end
    end)
end

local function refreshAllTranslations()
    task.spawn(function()
        if State.RefreshIslandCallback then
            State.RefreshIslandCallback()
        end
        local list = State.TrackedTexts
        local count = 0
        for i = #list, 1, -1 do
            if not isCurrentSession() then return end
            local el = list[i]
            if el and el.Parent then
                applyElementTranslation(el)
                count = count + 1
                if count % 60 == 0 then
                    task.wait()
                end
            else
                table.remove(list, i)
            end
        end
    end)
end

-- ==================== 4. HÀM KÍCH HOẠT TỰ ĐỘNG IMPORT CONFIG & APPLY NOW (TĂNG TỐC ĐỘ SĂN NÚT) ====================
local function fireGuiButton(btn)
    if not btn then return false end
    local fired = false

    local clickable = (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn
        or btn:FindFirstAncestorWhichIsA("TextButton")
        or btn:FindFirstAncestorWhichIsA("ImageButton")
        or (btn.Parent and (btn.Parent:FindFirstChildOfClass("TextButton") or btn.Parent:FindFirstChildOfClass("ImageButton")))
        or btn

    if getconnections then
        for _, sigName in ipairs({"MouseButton1Click", "Activated", "MouseButton1Down", "MouseButton1Up"}) do
            pcall(function()
                local sig = clickable[sigName]
                if sig then
                    for _, conn in ipairs(getconnections(sig)) do
                        if conn.Function then
                            task.spawn(conn.Function)
                            fired = true
                        end
                    end
                end
            end)
        end
    end

    if firesignal then
        pcall(function()
            firesignal(clickable.MouseButton1Click)
            fired = true
        end)
        pcall(function()
            firesignal(clickable.Activated)
            fired = true
        end)
    end

    if not fired and clickable:IsA("GuiObject") and clickable.AbsoluteSize.X > 0 then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            if vim then
                local inset = game:GetService("GuiService"):GetGuiInset()
                local cx = clickable.AbsolutePosition.X + clickable.AbsoluteSize.X / 2
                local cy = clickable.AbsolutePosition.Y + clickable.AbsoluteSize.Y / 2 + inset.Y
                vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                task.wait(0.04)
                vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                fired = true
            end
        end)
    end

    return fired
end

local function executeAutoFarmConfigImport(venyxGui, statusBtnLabel)
    task.spawn(function()
        if statusBtnLabel then
            statusBtnLabel.Text = "⏳ ĐANG NẠP CONFIG..."
        end

        local importBox = nil
        local importBtn = nil

        for _, d in ipairs(venyxGui:GetDescendants()) do
            if d:IsA("TextBox") then
                local origPh = (d:GetAttribute("OrigPlaceholder") or d.PlaceholderText or ""):lower()
                if origPh:find("paste config", 1, true) or origPh:find("dán mã json", 1, true) then
                    importBox = d
                end
            elseif d:IsA("TextButton") or d:IsA("TextLabel") then
                local origTxt = (d:GetAttribute("OrigRawText") or d.Text or ""):match("^%s*(.-)%s*$")
                if origTxt == "Import" or d.Text == "Nhập" then
                    importBtn = d
                end
            end
        end

        if not importBox or not importBtn then
            for _, d in ipairs(venyxGui:GetDescendants()) do
                if d:IsA("TextButton") or d:IsA("TextLabel") then
                    local origTxt = (d:GetAttribute("OrigRawText") or d.Text or ""):match("^%s*(.-)%s*$")
                    if origTxt == "Config" or d.Text == "Cấu Hình" then
                        fireGuiButton(d)
                        break
                    end
                end
            end
            task.wait(0.3)
            for _, d in ipairs(venyxGui:GetDescendants()) do
                if d:IsA("TextBox") then
                    local origPh = (d:GetAttribute("OrigPlaceholder") or d.PlaceholderText or ""):lower()
                    if origPh:find("paste config", 1, true) or origPh:find("dán mã json", 1, true) then
                        importBox = d
                    end
                elseif d:IsA("TextButton") or d:IsA("TextLabel") then
                    local origTxt = (d:GetAttribute("OrigRawText") or d.Text or ""):match("^%s*(.-)%s*$")
                    if origTxt == "Import" or d.Text == "Nhập" then
                        importBtn = d
                    end
                end
            end
        end

        if not importBox then
            if statusBtnLabel then
                statusBtnLabel.Text = "⚠️ MỞ MỤC CẤU HÌNH TRƯỚC!"
                task.wait(2)
                statusBtnLabel.Text = "⚡ CONFIG SETTING AUTO FARM"
            end
            return
        end

        importBox:SetAttribute("__IsTranslating", true)
        pcall(function() importBox:CaptureFocus() end)
        task.wait(0.05)
        importBox.Text = PRESET_AUTOFARM_JSON
        pcall(function() importBox:ReleaseFocus(true) end)
        if firesignal then
            pcall(function() firesignal(importBox.FocusLost, true) end)
        end
        importBox:SetAttribute("__IsTranslating", false)

        task.wait(0.15)

        if importBtn then
            fireGuiButton(importBtn)
        end

        -- VÒNG LẶP SĂN HỘP THOẠI "APPLY NOW" TỐC ĐỘ CAO (QUÉT TOÀN BỘ CORE GUI LIÊN TỤC MỖI 0.04S)
        local applied = false
        for _ = 1, 80 do
            task.wait(0.04)
            for _, root in ipairs(scanRoots) do
                if root then
                    for _, d in ipairs(root:GetDescendants()) do
                        if d:IsA("TextButton") or d:IsA("TextLabel") then
                            local origTxt = (d:GetAttribute("OrigRawText") or d.Text or ""):match("^%s*(.-)%s*$")
                            local curTxt = (d.Text or ""):match("^%s*(.-)%s*$")
                            if origTxt == "Apply now" or curTxt == "Áp dụng ngay" or origTxt:find("Apply now", 1, true) or curTxt:find("Áp dụng ngay", 1, true) or origTxt:find("Apply", 1, true) then
                                fireGuiButton(d)
                                applied = true
                                break
                            end
                        end
                    end
                end
                if applied then break end
            end
            if applied then break end
        end

        if statusBtnLabel then
            statusBtnLabel.Text = applied and "✅ ĐÃ ÁP DỤNG CONFIG!" or "✅ ĐÃ NHẬP CONFIG!"
            task.wait(2.0)
            statusBtnLabel.Text = "⚡ CONFIG SETTING AUTO FARM"
        end
    end)
end

-- ==================== 5. HÀM HIỂN THỊ BẢNG THÔNG BÁO UPDATE SẮP RA MẮT (SONG NGỮ VI / EN) ====================
local function showUpdateNotificationModal(venyxGui)
    if not venyxGui or venyxGui:FindFirstChild("ChilliV5_UpdateModal") then return end

    local modalGui = Instance.new("Frame")
    modalGui.Name = "ChilliV5_UpdateModal"
    modalGui.AnchorPoint = Vector2.new(0.5, 0.5)
    modalGui.Position = UDim2.new(0.5, 0, 0.5, 0)
    modalGui.Size = UDim2.new(0, 360, 0, 240)
    modalGui.BackgroundColor3 = Color3.fromRGB(14, 16, 26)
    modalGui.BackgroundTransparency = 0.05
    modalGui.BorderSizePixel = 0
    modalGui.ZIndex = 20000
    modalGui.Parent = venyxGui

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, 16)
    modalCorner.Parent = modalGui

    local modalStroke = Instance.new("UIStroke")
    modalStroke.Thickness = 2
    modalStroke.Color = Color3.fromRGB(255, 255, 255)
    modalStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    modalStroke.Parent = modalGui

    local modalGrad = Instance.new("UIGradient")
    modalGrad.Color = COLOR_SEQ_RAINBOW
    modalGrad.Parent = modalStroke
    table.insert(State.ActiveGradients, modalGrad)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -30, 0, 36)
    titleLbl.Position = UDim2.new(0, 15, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = (State.Language == "EN") and "🚀 UPCOMING UPDATE NOTICE" or "🚀 THÔNG BÁO UPDATE SẮP RA MẮT"
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Color3.fromRGB(255, 220, 80)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 20001
    titleLbl.Parent = modalGui

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -30, 0, 120)
    descLbl.Position = UDim2.new(0, 15, 0, 52)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = (State.Language == "EN") 
        and "+ Feature: Auto setting import tailored for all accounts (new players & low speed) and low-end devices (no lag). Thoroughly tested for the best and smoothest experience.\n+ Professional UI & fixed the 'Apply now' bug after config import!"
        or "+ Tính năng setting tự động nhập setting auto farm chuẩn phù hợp với tất cả tài khoản (mới chơi và ít tốc độ) thiết bị (giật lag) cũng không sao cả vì setting đã được trải nghiệm kĩ càng và cho ra kết quả tốt nhất phù hợp nhất.\n+ Giao diện đẹp chuyên nghiệp và sửa lại lỗi chưa ấn apply now khi nhập xong config!"
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 12
    descLbl.TextColor3 = Color3.fromRGB(220, 230, 245)
    descLbl.TextWrapped = true
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.ZIndex = 20001
    descLbl.Parent = modalGui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(1, -30, 0, 36)
    closeBtn.Position = UDim2.new(0, 15, 1, -48)
    closeBtn.BackgroundColor3 = Color3.fromRGB(95, 110, 235)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = (State.Language == "EN") and "GOT IT (OK)" or "ĐÃ HIỂU (OK)"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.ZIndex = 20002
    closeBtn.Parent = modalGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(modalGui, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.22)
        modalGui:Destroy()
    end)
end

-- ==================== 6. DYNAMIC ISLAND NỀN ĐEN ====================
local function setupDynamicIslandFromStatus(statusLbl, venyxGui)
    local pill = statusLbl.Parent
    if not (pill and pill:IsA("GuiObject")) then return end

    local badHitbox = pill:FindFirstChild("IslandClickHitbox")
    if badHitbox then badHitbox:Destroy() end

    for _, child in ipairs(pill:GetChildren()) do
        if child:IsA("UIGradient") then child:Destroy() end
    end

    pill.BackgroundColor3 = ISLAND_BLACK_BG
    pill.BackgroundTransparency = 0
    pill.Size = UDim2.new(0, 0, 0, 28)
    pill.AutomaticSize = Enum.AutomaticSize.X

    if not pill:GetAttribute("__BlackBgLocked") then
        pill:SetAttribute("__BlackBgLocked", true)
        pill:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            if isCurrentSession() and pill.BackgroundColor3 ~= ISLAND_BLACK_BG then
                pill.BackgroundColor3 = ISLAND_BLACK_BG
            end
        end)
        pill:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
            if isCurrentSession() and pill.BackgroundTransparency ~= 0 then
                pill.BackgroundTransparency = 0
            end
        end)
    end

    local expandHint = pill:FindFirstChild("IslandExpandHint")
    if not expandHint then
        expandHint = Instance.new("TextLabel")
        expandHint.Name = "IslandExpandHint"
        expandHint.Size = UDim2.new(0, 18, 0, 18)
        expandHint.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
        expandHint.BorderSizePixel = 0
        expandHint.Text = "▼"
        expandHint.Font = Enum.Font.GothamBold
        expandHint.TextSize = 9
        expandHint.TextColor3 = Color3.fromRGB(165, 210, 255)
        expandHint.LayoutOrder = 99
        expandHint.ZIndex = 10000
        expandHint.Parent = pill

        local hintCorner = Instance.new("UICorner")
        hintCorner.CornerRadius = UDim.new(1, 0)
        hintCorner.Parent = expandHint

        local hintStroke = Instance.new("UIStroke")
        hintStroke.Thickness = 1
        hintStroke.Color = Color3.fromRGB(90, 130, 200)
        hintStroke.Parent = expandHint
    end

    local function updateStatusText(forceFromSavedOrig)
        if statusLbl:GetAttribute("__Updating") then return end
        statusLbl:SetAttribute("__Updating", true)

        local cleanEn
        if forceFromSavedOrig and statusLbl:GetAttribute("OrigStatusEn") then
            cleanEn = statusLbl:GetAttribute("OrigStatusEn")
        else
            local currentRaw = statusLbl.Text:gsub("●", ""):gsub("•", ""):gsub("✨%s*rainbow", ""):match("^%s*(.-)%s*$") or ""
            if currentRaw ~= "" and currentRaw ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
                cleanEn = currentRaw
                statusLbl:SetAttribute("OrigStatusEn", cleanEn)
            else
                cleanEn = statusLbl:GetAttribute("OrigStatusEn") or currentRaw or "Idle"
            end
        end

        local translatedStatus = translateStatusAction(cleanEn)
        statusLbl:SetAttribute("__LastTranslatedStatus", translatedStatus)

        statusLbl.Text = translatedStatus
        statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusLbl.TextTransparency = 0
        statusLbl.Size = UDim2.new(0, 0, 1, 0)
        statusLbl.AutomaticSize = Enum.AutomaticSize.X

        statusLbl:SetAttribute("__Updating", false)
    end

    State.RefreshIslandCallback = function()
        updateStatusText(true)
    end

    if statusLbl:GetAttribute("__IslandDone") and venyxGui:FindFirstChild("ChilliV5_ExpandedIsland") then
        updateStatusText(false)
        return
    end
    statusLbl:SetAttribute("__IslandDone", true)

    updateStatusText(false)

    local txtGrad = statusLbl:FindFirstChild("TextRainbow") or Instance.new("UIGradient")
    txtGrad.Name = "TextRainbow"
    txtGrad.Color = COLOR_SEQ_RAINBOW
    txtGrad.Parent = statusLbl
    table.insert(State.ActiveGradients, txtGrad)

    pill.Parent = venyxGui
    pill.AnchorPoint = Vector2.new(0.5, 0)
    if pill.Position.Y.Offset < 4 or pill.Position.Y.Offset > 600 then
        pill.Position = UDim2.new(0.5, 0, 0, 10)
    end
    pill.ZIndex = 9999
    pill.Active = true
    statusLbl.Active = true
    expandHint.Active = true

    local pillCorner = pill:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill

    local pillStroke = pill:FindFirstChild("IslandStroke") or Instance.new("UIStroke")
    pillStroke.Name = "IslandStroke"
    pillStroke.Thickness = 1.6
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = Color3.fromRGB(255, 255, 255)
    pillStroke.Parent = pill

    local strokeGrad = pillStroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = pillStroke
    table.insert(State.ActiveGradients, strokeGrad)

    local oldExp = venyxGui:FindFirstChild("ChilliV5_ExpandedIsland")
    if oldExp then oldExp:Destroy() end

    local ExpandedIsland = Instance.new("Frame")
    ExpandedIsland.Name = "ChilliV5_ExpandedIsland"
    ExpandedIsland.AnchorPoint = Vector2.new(0.5, 0)
    ExpandedIsland.Position = pill.Position
    ExpandedIsland.Size = UDim2.new(0, 268, 0, 118)
    ExpandedIsland.BackgroundColor3 = ISLAND_BLACK_BG
    ExpandedIsland.BackgroundTransparency = 0
    ExpandedIsland.BorderSizePixel = 0
    ExpandedIsland.Visible = false
    ExpandedIsland.Active = true
    ExpandedIsland.ZIndex = 10000
    ExpandedIsland.Parent = venyxGui

    local ExpCorner = Instance.new("UICorner")
    ExpCorner.CornerRadius = UDim.new(0, 16)
    ExpCorner.Parent = ExpandedIsland

    local ExpStroke = Instance.new("UIStroke")
    ExpStroke.Thickness = 1.6
    ExpStroke.Color = Color3.fromRGB(255, 255, 255)
    ExpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ExpStroke.Parent = ExpandedIsland

    local ExpStrokeGrad = Instance.new("UIGradient")
    ExpStrokeGrad.Color = COLOR_SEQ_RAINBOW
    ExpStrokeGrad.Parent = ExpStroke
    table.insert(State.ActiveGradients, ExpStrokeGrad)

    local ExpTitle = Instance.new("TextLabel")
    ExpTitle.Size = UDim2.new(1, -44, 0, 28)
    ExpTitle.Position = UDim2.new(0, 14, 0, 4)
    ExpTitle.BackgroundTransparency = 1
    ExpTitle.Text = "🌶️ Chilli Hub V5"
    ExpTitle.Font = Enum.Font.GothamBold
    ExpTitle.TextSize = 11.5
    ExpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExpTitle.TextXAlignment = Enum.TextXAlignment.Left
    ExpTitle.ZIndex = 10001
    ExpTitle.Parent = ExpandedIsland

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 24, 0, 22)
    CollapseBtn.Position = UDim2.new(1, -32, 0, 7)
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "▲"
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.TextSize = 10
    CollapseBtn.TextColor3 = Color3.fromRGB(160, 205, 255)
    CollapseBtn.ZIndex = 10002
    CollapseBtn.Parent = ExpandedIsland

    local CollapseCorner = Instance.new("UICorner")
    CollapseCorner.CornerRadius = UDim.new(1, 0)
    CollapseCorner.Parent = CollapseBtn

    local LangCapsule = Instance.new("Frame")
    LangCapsule.Size = UDim2.new(1, -20, 0, 32)
    LangCapsule.Position = UDim2.new(0, 10, 0, 34)
    LangCapsule.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    LangCapsule.BorderSizePixel = 0
    LangCapsule.ZIndex = 10001
    LangCapsule.Parent = ExpandedIsland

    local LangCorner = Instance.new("UICorner")
    LangCorner.CornerRadius = UDim.new(1, 0)
    LangCorner.Parent = LangCapsule

    local LangSlider = Instance.new("Frame")
    LangSlider.Size = UDim2.new(0.5, -4, 1, -4)
    LangSlider.Position = (State.Language == "VI") and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 2, 0, 2)
    LangSlider.BackgroundColor3 = Color3.fromRGB(95, 110, 235)
    LangSlider.BorderSizePixel = 0
    LangSlider.ZIndex = 10002
    LangSlider.Parent = LangCapsule

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = LangSlider

    local BtnVI = Instance.new("TextButton")
    BtnVI.Size = UDim2.new(0.5, 0, 1, 0)
    BtnVI.Position = UDim2.new(0, 0, 0, 0)
    BtnVI.BackgroundTransparency = 1
    BtnVI.Text = "🇻🇳 TIẾNG VIỆT"
    BtnVI.Font = Enum.Font.GothamBold
    BtnVI.TextSize = 10.5
    BtnVI.TextColor3 = (State.Language == "VI") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
    BtnVI.ZIndex = 10003
    BtnVI.Parent = LangCapsule

    local BtnEN = Instance.new("TextButton")
    BtnEN.Size = UDim2.new(0.5, 0, 1, 0)
    BtnEN.Position = UDim2.new(0.5, 0, 0, 0)
    BtnEN.BackgroundTransparency = 1
    BtnEN.Text = "🌐 ENGLISH"
    BtnEN.Font = Enum.Font.GothamBold
    BtnEN.TextSize = 10.5
    BtnEN.TextColor3 = (State.Language == "EN") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
    BtnEN.ZIndex = 10003
    BtnEN.Parent = LangCapsule

    local ConfigMacroBtn = Instance.new("TextButton")
    ConfigMacroBtn.Name = "AutoFarmConfigBtn"
    ConfigMacroBtn.Size = UDim2.new(1, -20, 0, 34)
    ConfigMacroBtn.Position = UDim2.new(0, 10, 0, 74)
    ConfigMacroBtn.BackgroundColor3 = Color3.fromRGB(24, 28, 44)
    ConfigMacroBtn.BorderSizePixel = 0
    ConfigMacroBtn.Text = "⚡ CONFIG SETTING AUTO FARM"
    ConfigMacroBtn.Font = Enum.Font.GothamBold
    ConfigMacroBtn.TextSize = 10.5
    ConfigMacroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfigMacroBtn.ZIndex = 10003
    ConfigMacroBtn.Parent = ExpandedIsland

    local ConfigBtnCorner = Instance.new("UICorner")
    ConfigBtnCorner.CornerRadius = UDim.new(1, 0)
    ConfigBtnCorner.Parent = ConfigMacroBtn

    local ConfigBtnStroke = Instance.new("UIStroke")
    ConfigBtnStroke.Thickness = 1.3
    ConfigBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    ConfigBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ConfigBtnStroke.Parent = ConfigMacroBtn

    local ConfigBtnGrad = Instance.new("UIGradient")
    ConfigBtnGrad.Color = COLOR_SEQ_RAINBOW
    ConfigBtnGrad.Parent = ConfigBtnStroke
    table.insert(State.ActiveGradients, ConfigBtnGrad)

    ConfigMacroBtn.MouseButton1Click:Connect(function()
        executeAutoFarmConfigImport(venyxGui, ConfigMacroBtn)
    end)

    local function setLanguage(lang)
        if State.Language == lang then return end
        State.Language = lang
        pcall(function()
            if writefile then writefile(LANG_SAVE_FILE, lang) end
        end)

        if lang == "VI" then
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            BtnVI.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnEN.TextColor3 = Color3.fromRGB(150, 165, 190)
        else
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 2, 0, 2)
            }):Play()
            BtnEN.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnVI.TextColor3 = Color3.fromRGB(150, 165, 190)
        end

        refreshAllTranslations()
    end

    BtnVI.MouseButton1Click:Connect(function() setLanguage("VI") end)
    BtnEN.MouseButton1Click:Connect(function() setLanguage("EN") end)

    local function toggleIsland(expand)
        if expand then
            ExpandedIsland.Position = pill.Position
            pill.Visible = false
            ExpandedIsland.Size = UDim2.new(0, 160, 0, 28)
            ExpandedIsland.Visible = true
            TweenService:Create(ExpandedIsland, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 268, 0, 118)
            }):Play()
        else
            pill.Position = ExpandedIsland.Position
            ExpandedIsland.Visible = false
            pill.Visible = true
        end
    end

    CollapseBtn.MouseButton1Click:Connect(function()
        toggleIsland(false)
    end)

    local function attachDragAndClick(triggerObj, moveFrame, onTapCallback)
        if triggerObj:GetAttribute("__DragSession") == MY_SESSION_ID then return end
        triggerObj:SetAttribute("__DragSession", MY_SESSION_ID)

        local dragging, dragStart, startPos, moved = false, nil, nil, false

        triggerObj.InputBegan:Connect(function(input)
            if not isCurrentSession() then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = moveFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragging and not moved and onTapCallback then
                            onTapCallback()
                        end
                        dragging = false
                    end
                end)
            end
        end)

        triggerObj.InputChanged:Connect(function(input)
            if not isCurrentSession() then return end
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                local delta = input.Position - dragStart
                if delta.Magnitude > 6 then
                    moved = true
                end
                local cam = workspace.CurrentCamera
                local maxX = cam and cam.ViewportSize.X - 140 or 800
                local maxY = cam and cam.ViewportSize.Y - 50 or 600
                local newX = math.clamp(startPos.X.Offset + delta.X, -maxX / 2, maxX / 2)
                local newY = math.clamp(startPos.Y.Offset + delta.Y, 4, maxY)
                local newPos = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                pill.Position = newPos
                ExpandedIsland.Position = newPos
            end
        end)
    end

    local openCallback = function() toggleIsland(true) end
    attachDragAndClick(pill, pill, openCallback)
    attachDragAndClick(statusLbl, pill, openCallback)
    attachDragAndClick(expandHint, pill, openCallback)
    attachDragAndClick(ExpandedIsland, ExpandedIsland, nil)

    statusLbl:GetPropertyChangedSignal("Text"):Connect(function()
        if not isCurrentSession() then return end
        if not statusLbl:GetAttribute("__Updating") and statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
            updateStatusText(false)
        end
    end)
end

-- ==================== 7. NÚT TRÒN NỔI & HEADER LOGO ====================
local function setupUnclippedCircularLogo(targetObj)
    local topPanel = targetObj
    while topPanel.Parent and topPanel.Parent:IsA("GuiObject") and not topPanel.Parent:IsA("ScreenGui") do
        topPanel = topPanel.Parent
    end

    if topPanel:GetAttribute("__FloatingLogoV5Perfect") then return end

    local sz = topPanel.AbsoluteSize
    local pos = topPanel.AbsolutePosition
    if sz.X > 105 or sz.Y > 105 or sz.X < 28 or math.abs(sz.X - sz.Y) > 25 or pos.X > 350 then
        return
    end

    topPanel:SetAttribute("__FloatingLogoV5Perfect", true)
    local container = topPanel

    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("UIPadding") or child:IsA("UIAspectRatioConstraint") or child:IsA("UISizeConstraint") then
            if child.Name ~= "PerfectCircleAspect" then
                pcall(function() child:Destroy() end)
            end
        end
        if (child:IsA("ImageLabel") or child:IsA("ImageButton")) and child.Name ~= "ChilliV5CoverLogo" then
            child.ImageTransparency = 1
            child.BackgroundTransparency = 1
        elseif child:IsA("TextLabel") or child:IsA("TextButton") then
            child:SetAttribute("__HiddenVxLogo", true)
            child.TextTransparency = 1
            child.BackgroundTransparency = 1
        end
    end

    if container:IsA("ImageLabel") or container:IsA("ImageButton") then
        container.ImageTransparency = 1
    elseif container:IsA("TextLabel") or container:IsA("TextButton") then
        container:SetAttribute("__HiddenVxLogo", true)
        container.TextTransparency = 1
    end

    container.Size = UDim2.new(0, 60, 0, 60)
    container.BackgroundColor3 = LOGO_BG_COLOR
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true

    local aspect = container:FindFirstChild("PerfectCircleAspect") or Instance.new("UIAspectRatioConstraint")
    aspect.Name = "PerfectCircleAspect"
    aspect.AspectRatio = 1
    aspect.Parent = container

    local cCorner = container:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = container

    if not container:GetAttribute("__SizeLocked") then
        container:SetAttribute("__SizeLocked", true)
        container:GetPropertyChangedSignal("Size"):Connect(function()
            if container.Size ~= UDim2.new(0, 60, 0, 60) then
                container.Size = UDim2.new(0, 60, 0, 60)
            end
        end)
    end

    local stroke = container:FindFirstChild("RainbowBorder") or Instance.new("UIStroke")
    stroke.Name = "RainbowBorder"
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = container

    local strokeGrad = stroke:FindFirstChild("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = stroke
    table.insert(State.ActiveGradients, strokeGrad)

    local coverLogo = container:FindFirstChild("ChilliV5CoverLogo") or Instance.new("ImageLabel")
    coverLogo.Name = "ChilliV5CoverLogo"
    coverLogo.Size = UDim2.new(1, 0, 1, 0)
    coverLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    coverLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    coverLogo.BackgroundTransparency = 1
    coverLogo.Image = CHILLI_LOGO_ID
    coverLogo.ImageTransparency = 0
    coverLogo.ScaleType = Enum.ScaleType.Fit
    coverLogo.Active = false
    coverLogo.ZIndex = container.ZIndex + 5
    coverLogo.Parent = container

    local logoCorner = coverLogo:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = coverLogo
end

local function patchHeaderLogoLeftOfTitle(headerContainer, titleLbl)
    if not headerContainer or not titleLbl then return end
    local headerY = titleLbl.AbsolutePosition.Y
    local titleX = titleLbl.AbsolutePosition.X

    for _, item in ipairs(headerContainer:GetDescendants()) do
        if item ~= titleLbl and item:IsA("GuiObject") and item.Name ~= "ChilliHeaderLogo" then
            local pos = item.AbsolutePosition
            local sz = item.AbsoluteSize
            if math.abs(pos.Y - headerY) < 35 and pos.X < titleX and sz.X >= 10 and sz.X <= 45 then
                if item:IsA("ImageLabel") or item:IsA("ImageButton") then
                    item.Image = CHILLI_LOGO_ID
                    item.ImageTransparency = 0
                    item.BackgroundTransparency = 1
                    item.ScaleType = Enum.ScaleType.Fit
                elseif item:IsA("TextLabel") or item:IsA("TextButton") then
                    item:SetAttribute("__HiddenVxLogo", true)
                    item.TextTransparency = 1
                    local holder = item.Parent
                    if holder and not holder:FindFirstChild("ChilliHeaderLogo") then
                        local hLogo = Instance.new("ImageLabel")
                        hLogo.Name = "ChilliHeaderLogo"
                        hLogo.Size = UDim2.new(0, 24, 0, 24)
                        hLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
                        hLogo.AnchorPoint = Vector2.new(0.5, 0.5)
                        hLogo.BackgroundTransparency = 1
                        hLogo.Image = CHILLI_LOGO_ID
                        hLogo.ScaleType = Enum.ScaleType.Fit
                        hLogo.ZIndex = item.ZIndex + 2
                        hLogo.Parent = holder
                    end
                end
            end
        end
    end
end

-- ==================== 8. BỘ QUÉT BẤT TỬ & KÍCH HOẠT BẢNG THÔNG BÁO UPDATE ====================
local function patchVenyxScreenGui(gui, titleLbl)
    if titleLbl.Text ~= NEW_TITLE then
        titleLbl:SetAttribute("__IsTranslating", true)
        titleLbl.Text = NEW_TITLE
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
        titleLbl:SetAttribute("__IsTranslating", false)
    end

    local mainWindow = nil
    local curr = titleLbl
    while curr.Parent and curr.Parent ~= gui do
        curr = curr.Parent
        if curr:IsA("GuiObject") and curr.AbsoluteSize.X >= 350 and curr.AbsoluteSize.Y >= 220 then
            mainWindow = curr
        end
    end

    local headerY = titleLbl.AbsolutePosition.Y

    if mainWindow then
        patchHeaderLogoLeftOfTitle(mainWindow, titleLbl)
    end

    for _, topChild in ipairs(gui:GetChildren()) do
        if topChild:IsA("GuiObject")
        and topChild ~= mainWindow
        and topChild.Name ~= "ChilliV5_ExpandedIsland"
        and not topChild:FindFirstChild("IslandExpandHint") then
            setupUnclippedCircularLogo(topChild)
        end
    end

    if not gui:GetAttribute("__UpdateModalShown") then
        gui:SetAttribute("__UpdateModalShown", true)
        task.defer(function()
            task.wait(0.5)
            showUpdateNotificationModal(gui)
        end)
    end

    local allDescendants = gui:GetDescendants()
    local pendingTextQueue = {}

    for i = 1, #allDescendants do
        local desc = allDescendants[i]
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            local txt = desc.Text or ""
            local isAlreadyMovedIdle = desc:GetAttribute("__IslandDone")

            local hasDotSibling = false
            if desc.Parent and desc.Parent:IsA("GuiObject") and desc.Parent.AbsoluteSize.X < 320 then
                for _, sib in ipairs(desc.Parent:GetChildren()) do
                    if sib:IsA("Frame") and sib.AbsoluteSize.X <= 14 and sib.AbsoluteSize.Y <= 14 then
                        hasDotSibling = true
                        break
                    end
                end
            end

            local isHeaderStatus = (not gui:GetAttribute("__IslandLocked"))
                and (not desc:FindFirstAncestorOfClass("ScrollingFrame"))
                and desc.Parent
                and (not titleLbl:IsDescendantOf(desc.Parent))
                and math.abs(desc.AbsolutePosition.Y - headerY) < 35
                and desc.AbsolutePosition.X > titleLbl.AbsolutePosition.X + 60
                and (hasDotSibling or txt:lower():find("idle", 1, true) or txt == "Đang rảnh")
                and not txt:find("v1.", 1, true)

            if isHeaderStatus or isAlreadyMovedIdle then
                gui:SetAttribute("__IslandLocked", true)
                setupDynamicIslandFromStatus(desc, gui)
            elseif isFpsCounterText(txt) then
                hookFakeFpsCounter(desc)
            elseif desc:GetAttribute("__TransHookSession") ~= MY_SESSION_ID then
                pendingTextQueue[#pendingTextQueue + 1] = desc
            end

        elseif (desc:IsA("ImageLabel") or desc:IsA("ImageButton"))
        and desc.Name ~= "ChilliV5CoverLogo"
        and desc.Name ~= "ChilliHeaderLogo"
        and desc.Name ~= "InnerChilliLogo" then
            if not desc:FindFirstAncestorOfClass("ScrollingFrame") then
                if mainWindow and not desc:IsDescendantOf(mainWindow) then
                    setupUnclippedCircularLogo(desc)
                end
            end
        end
    end

    if #pendingTextQueue > 0 and not gui:GetAttribute("__BatchTranslating") then
        gui:SetAttribute("__BatchTranslating", true)
        task.spawn(function()
            for idx = 1, #pendingTextQueue do
                if not isCurrentSession() then break end
                local item = pendingTextQueue[idx]
                if item and item.Parent then
                    hookTextForTranslation(item)
                end
                if idx % 50 == 0 then
                    task.wait()
                end
            end
            gui:SetAttribute("__BatchTranslating", false)
        end)
    end
end

local venyxMainPatched = false

local function attachScreenGuiListeners(gui)
    if not gui:IsA("ScreenGui") or IGNORED_GUI_NAMES[gui.Name] then return end
    if gui:GetAttribute("__ListenerSession") == MY_SESSION_ID then return end
    gui:SetAttribute("__ListenerSession", MY_SESSION_ID)

    gui.DescendantAdded:Connect(function(newDesc)
        if not isCurrentSession() then return end
        if newDesc:IsA("TextLabel") or newDesc:IsA("TextButton") or newDesc:IsA("TextBox") then
            task.defer(function()
                if not isCurrentSession() then return end
                if not newDesc:IsA("TextBox") and isFpsCounterText(newDesc.Text) then
                    hookFakeFpsCounter(newDesc)
                else
                    hookTextForTranslation(newDesc)
                end
            end)
        end
    end)
end

local function tryPatchVenyx()
    if not isCurrentSession() then return end
    for _, root in ipairs(scanRoots) do
        if root then
            for _, gui in ipairs(root:GetChildren()) do
                if gui:IsA("ScreenGui") and not IGNORED_GUI_NAMES[gui.Name] then
                    attachScreenGuiListeners(gui)

                    local titleLbl = nil
                    local descendants = gui:GetDescendants()

                    for i = 1, #descendants do
                        local d = descendants[i]
                        if d:IsA("TextLabel") or d:IsA("TextButton") then
                            local t = d.Text
                            if isFpsCounterText(t) then
                                hookFakeFpsCounter(d)
                            elseif (t == "VENYX" or t == NEW_TITLE) and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                                titleLbl = d
                            end
                        end
                    end

                    if titleLbl then
                        venyxMainPatched = true
                        patchVenyxScreenGui(gui, titleLbl)
                    end
                end
            end
        end
    end
end

for _, root in ipairs(scanRoots) do
    if root then
        root.ChildAdded:Connect(function(child)
            if not isCurrentSession() then return end
            if child:IsA("ScreenGui") and not IGNORED_GUI_NAMES[child.Name] then
                attachScreenGuiListeners(child)
                task.wait(0.15)
                pcall(tryPatchVenyx)
            end
        end)
    end
end

pcall(tryPatchVenyx)
task.spawn(function()
    local elapsed = 0
    while isCurrentSession() and not venyxMainPatched and elapsed < 60 do
        task.wait(0.35)
        elapsed = elapsed + 0.35
        pcall(tryPatchVenyx)
    end
    while isCurrentSession() do
        task.wait(2.0)
        pcall(tryPatchVenyx)
    end
end)
]===]

if writefile then
    pcall(function()
        local selfReplicatingWrapper = "local CHILLI_CORE_PAYLOAD = [===[" .. CHILLI_CORE_PAYLOAD .. "]===]\n" .. [[
if writefile then
    pcall(function()
        writefile("ChilliHubV5_AutoRun.lua", "local CHILLI_CORE_PAYLOAD = [===[" .. CHILLI_CORE_PAYLOAD .. "]===]\nloadstring(CHILLI_CORE_PAYLOAD)()")
    end)
end
loadstring(CHILLI_CORE_PAYLOAD)()
]]
        writefile(AUTO_RUN_FILE, selfReplicatingWrapper)
    end)
end

loadstring(CHILLI_CORE_PAYLOAD)()
