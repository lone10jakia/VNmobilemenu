--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "MỆT VÃI LỒN RA CẦN BỒI THƯỜNG",
    LoadingTitle = "ĐỤ MÁ THẰNG LỒN...",
    LoadingSubtitle = "MỆT QUÁ",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "HackCaiIon",
       FileName = "Config"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Farm Boss")

-- Biến
local OrbitEnabled = false
local SelectedBoss = nil
local BossName = nil
local RADIUS = 20
local HEIGHT = 10
local SPEED = 1.5

-- Label hiển thị boss
local BossLabel = MainTab:CreateLabel("Boss: Chưa chọn")

-- Hàm tìm boss theo tên ở bất kỳ đâu trong workspace
local function FindBossByName(name)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name and obj:FindFirstChildOfClass("Humanoid") then
            return obj
        end
    end
    return nil
end

-- Nút chọn boss bằng click
MainTab:CreateButton({
    Name = "Chọn Boss bằng Click",
    Callback = function()
        local mouse = player:GetMouse()
        Rayfield:Notify({
            Title = "Hack Boss",
            Content = "Click vào boss để chọn!",
            Duration = 5,
            Image = 4483362458
        })

        local conn
        conn = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if not target then return end

            local model = target
            while model and not (model:IsA("Model") and model:FindFirstChildOfClass("Humanoid")) do
                model = model.Parent
            end

            if model then
                SelectedBoss = model
                BossName = model.Name
                BossLabel:Set("Boss: " .. BossName)
                Rayfield:Notify({
                    Title = "Hack Boss",
                    Content = "Đã chọn boss: " .. BossName,
                    Duration = 5,
                    Image = 4483362458
                })
                conn:Disconnect()
            end
        end)
    end
})

-- Slider chỉnh bán kính
MainTab:CreateSlider({
    Name = "Bán kính vòng quanh",
    Range = {5, 100},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = RADIUS,
    Callback = function(Value)
        RADIUS = Value
    end,
})

-- Slider chỉnh độ cao
MainTab:CreateSlider({
    Name = "Độ cao trên boss",
    Range = {0, 50},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = HEIGHT,
    Callback = function(Value)
        HEIGHT = Value
    end,
})

-- Slider chỉnh tốc độ
MainTab:CreateSlider({
    Name = "Tốc độ bay vòng",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = SPEED,
    Callback = function(Value)
        SPEED = Value
    end,
})

-- Toggle Auto Orbit
MainTab:CreateToggle({
   Name = "Bay vòng quanh Boss",
   CurrentValue = false,
   Flag = "OrbitBoss",
   Callback = function(Value)
       OrbitEnabled = Value
   end,
})

-- Vòng lặp orbit
RunService.Heartbeat:Connect(function()
    if OrbitEnabled and SelectedBoss then
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if SelectedBoss:FindFirstChild("HumanoidRootPart") then
            local bhrp = SelectedBoss.HumanoidRootPart
            local angle = tick() * SPEED
            local targetPos = bhrp.Position + Vector3.new(
                math.cos(angle) * RADIUS,
                HEIGHT,
                math.sin(angle) * RADIUS
            )

            hrp.CFrame = CFrame.new(targetPos, bhrp.Position)

            -- Auto đánh nếu có tool
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    tool:Activate()
                end)
            end
        end
    end
end)

-- Theo dõi boss respawn + cập nhật máu
task.spawn(function()
    while true do
        task.wait(0.5)
        if BossName then
            if SelectedBoss and SelectedBoss:FindFirstChildOfClass("Humanoid") then
                local hum = SelectedBoss:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    BossLabel:Set("Boss: " .. BossName .. " | HP: " ..
                        math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                else
                    BossLabel:Set("Boss: " .. BossName .. " | Đang chết...")
                end
            else
                -- Nếu SelectedBoss mất → tìm boss mới theo BossName
                local newBoss = FindBossByName(BossName)
                if newBoss then
                    SelectedBoss = newBoss
                    local hum = newBoss:FindFirstChildOfClass("Humanoid")
                    if hum then
                        BossLabel:Set("Boss: " .. BossName .. " | HP: " ..
                            math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                    end
                    Rayfield:Notify({
                        Title = "Hack Boss",
                        Content = "Boss đã hồi sinh: " .. BossName,
                        Duration = 5,
                        Image = 4483362458
                    })
                else
                    BossLabel:Set("Boss: " .. BossName .. " | Đã chết, chờ respawn...")
                end
            end
        end
    end
end)
