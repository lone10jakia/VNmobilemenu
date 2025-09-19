--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "memaybeo Hub - Full",
   LoadingTitle = "Đang tải menu vip nè...",
   LoadingSubtitle = " nhìn con cặc ",
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
local HealThreshold = 50
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
