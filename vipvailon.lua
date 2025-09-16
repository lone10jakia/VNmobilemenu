--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "memaybeo Hub - Full",
   LoadingTitle = "Đang tải menu...",
   LoadingSubtitle = "Auto Heal + Attack + Speed + HUD",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Tabs
local TabMain = Window:CreateTab("Main")
local TabHud  = Window:CreateTab("Boss HUD")
local TabSet  = Window:CreateTab("Settings")

-- Vars
local autoAttackEnabled = false
local AutoHeal = false
local HealThreshold = 70
local BandageName = "Băng gạc"
local NormalSpeed = 16
local hitboxSize = Vector3.new(50,50,50)

-- Get tool from backpack
local function getToolFromBackpack(name)
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == name then
            return item
        end
    end
    return nil
end

-- Auto Attack toggle
TabMain:CreateToggle({
    Name = "⚔ Auto Attack",
    CurrentValue = false,
    Callback = function(v) autoAttackEnabled = v end
})

-- Auto Attack loop
RunService.Heartbeat:Connect(function()
    if autoAttackEnabled then
        local char = lp.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end
end)

-- Auto Heal toggle
TabMain:CreateToggle({
    Name = "🤕 Auto Heal",
    CurrentValue = false,
    Callback = function(v) AutoHeal = v end
})

-- Auto Heal loop
task.spawn(function()
    while task.wait(0.2) do
        if AutoHeal then
            local char = lp.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth * (HealThreshold / 100) then
                local bandage = getToolFromBackpack(BandageName)
                if bandage then
                    local oldTool = char:FindFirstChildOfClass("Tool")
                    humanoid:EquipTool(bandage)
                    task.wait(0.15)
                    VirtualUser:ClickButton1(Vector2.new())

                    repeat task.wait(0.2)
                    until humanoid.Health >= humanoid.MaxHealth or not char:FindFirstChild(BandageName)

                    if oldTool and lp.Backpack:FindFirstChild(oldTool.Name) then
                        humanoid:EquipTool(lp.Backpack[oldTool.Name])
                    end
                end
            end
        end
    end
end)

-- WalkSpeed
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

-- Toggle HUD
TabHud:CreateToggle({
    Name = "Boss HUD",
    CurrentValue = true,
    Callback = function(v)
        hudEnabled = v
        BossHud.Visible = v
    end
})

-- Color picker
TabHud:CreateColorPicker({
    Name = "Đổi màu chữ HUD",
    Color = BossHud.TextColor3,
    Callback = function(c) BossHud.TextColor3 = c end
})

-- tìm boss
local function getBoss()
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and string.find(npc.Name:lower(), "boss") then
            return npc
        end
    end
end

-- update HUD
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
