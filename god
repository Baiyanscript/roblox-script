local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function applyGodMode(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

player.CharacterAdded:Connect(applyGodMode)

if player.Character then
    applyGodMode(player.Character)
end
