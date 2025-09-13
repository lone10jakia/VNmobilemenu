--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "MEMAYBEO HUB - Full",
   LoadingTitle = "Đang tải menu...",
   LoadingSubtitle = "Auto Attack + Speed + HUD + Orbit",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Tabs
local TabMain = Window:CreateTab("Main")
local TabHud  = Window:CreateTab("Boss HUD")
local TabOrbit = Window:CreateTab("Orbit Boss")

-- Vars
local autoAttackEnabled = false
local AttackSpeed = 0.3 -- giây/đòn (mặc định)
local lastAttack = 0
local NormalSpeed = 16
local OrbitEnabled = false
local OrbitRadius = 15
local OrbitHeight = 5
local OrbitSpeed = 2
local orbitAngle = 0

--==================== AUTO ATTACK ====================
TabMain:CreateToggle({
    Name = "⚔ Auto Attack",
    CurrentValue = false,
    Callback = function(v) autoAttackEnabled = v end
})

TabMain:CreateSlider({
    Name = "⚡ Attack Speed (giây/đòn)",
    Range = {0.05, 1}, -- 0.05 = siêu nhanh, 1 = chậm
    Increment = 0.05,
    CurrentValue = AttackSpeed,
    Callback = function(v) AttackSpeed = v end
})

RunService.Heartbeat:Connect(function()
    if autoAttackEnabled then
        local char = lp.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                if tick() - lastAttack >= AttackSpeed then
                    pcall(function()
                        tool:Activate()
                        lastAttack = tick()
                    end)
                end
            end
        end
    end
end)

--==================== WALK SPEED ====================
TabMain:CreateSlider({
    Name = "🏃 WalkSpeed",
    Range = {10, 60},
    Increment = 1,
    CurrentValue = NormalSpeed,
    Callback = function(Value)
        NormalSpeed = Value
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Value end
        lp.CharacterAdded:Connect(function(c) c:WaitForChild("Humanoid").WalkSpeed = Value end)
    end
})

--==================== HUD ====================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local BossHud = Instance.new("TextLabel")

BossHud.Parent = ScreenGui
BossHud.BackgroundTransparency = 0.3
BossHud.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BossHud.BorderSizePixel = 0
BossHud.Position = UDim2.new(0.75, 0, 0.05, 0)
BossHud.Size = UDim2.new(0, 220, 0, 40)
BossHud.Font = Enum.Font.GothamBold
BossHud.Text = "Boss: Không có"
BossHud.TextColor3 = Color3.fromRGB(255, 50, 50)
BossHud.TextScaled = true
BossHud.Visible = true
BossHud.Active = true
BossHud.Draggable = true

local hudEnabled = true

TabHud:CreateToggle({
    Name = "Boss HUD",
    CurrentValue = true,
    Callback = function(v)
        hudEnabled = v
        BossHud.Visible = v
    end
})

TabHud:CreateColorPicker({
    Name = "Đổi màu chữ HUD",
    Color = BossHud.TextColor3,
    Callback = function(c) BossHud.TextColor3 = c end
})

local function getBoss()
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and string.find(npc.Name:lower(), "boss") then
            return npc
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not hudEnabled then return end
    local boss = getBoss()
    if boss and boss:FindFirstChild("Humanoid") then
        local hp = math.floor(boss.Humanoid.Health)
        local maxhp = math.floor(boss.Humanoid.MaxHealth)
        BossHud.Text = string.format("Boss %s: %d / %d", boss.Name, hp, maxhp)
    else
        BossHud.Text = "Boss: Không có"
    end
end)

--==================== ORBIT BOSS ====================
TabOrbit:CreateToggle({
    Name = "🌌 Orbit quanh Boss",
    CurrentValue = false,
    Callback = function(v) OrbitEnabled = v end
})

TabOrbit:CreateSlider({
    Name = "Bán kính (Radius)",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = OrbitRadius,
    Callback = function(v) OrbitRadius = v end
})

TabOrbit:CreateSlider({
    Name = "Độ cao (Height)",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = OrbitHeight,
    Callback = function(v) OrbitHeight = v end
})

TabOrbit:CreateSlider({
    Name = "Tốc độ quay (Speed)",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = OrbitSpeed,
    Callback = function(v) OrbitSpeed = v end
})

task.spawn(function()
    while task.wait(0.03) do
        if OrbitEnabled then
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local boss = getBoss()
            if hrp and boss and boss:FindFirstChild("HumanoidRootPart") then
                orbitAngle = orbitAngle + OrbitSpeed * 0.03
                local off = Vector3.new(math.cos(orbitAngle), 0, math.sin(orbitAngle)) * OrbitRadius
                local targetPos = boss.HumanoidRootPart.Position + off + Vector3.new(0, OrbitHeight, 0)
                hrp.CFrame = CFrame.new(targetPos, boss.HumanoidRootPart.Position)
            end
        end
    end
end)
