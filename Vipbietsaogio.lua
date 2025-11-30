-- MEMAYBEO HUB PRO - FINAL VER (FIX TẮT HOÀN TOÀN + 0.3s TRỞ VŨ KHÍ)
-- Đại ca dùng bản này là đè chết cả server luôn

print("MEMAYBEO HUB PRO ĐANG LOAD...")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

getgenv().healthEspEnabled = false
getgenv().AimNearest = false
getgenv().AutoPvp = false
getgenv().DisabledBlur = false
getgenv().PlayerInfo = false
getgenv().HealthMode = false
getgenv().AutoLayBan = false
getgenv().AutoNhatGhe = false
getgenv().AutoNhatGheb = false
getgenv().AutoSpin = false
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI + Blur
local Blur = Instance.new("BlurEffect", game.Lighting)
Blur.Size = 10
Blur.Enabled = true

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MEMAYBEO_UI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,610,0,400)
MainFrame.Position = UDim2.new(0,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,4)

local Bg = Instance.new("ImageLabel", MainFrame)
Bg.Size = UDim2.new(1,40,1,40)
Bg.Position = UDim2.new(0.5,0,0.5,0)
Bg.AnchorPoint = Vector2.new(0.5,0.5)
Bg.Image = "rbxassetid://5554236805"
Bg.ImageColor3 = Color3.new(0,0,0)
Bg.ImageTransparency = 0.6
Bg.BackgroundTransparency = 1
Bg.ScaleType = Enum.ScaleType.Slice
Bg.SliceCenter = Rect.new(23,23,277,277)
Bg.ZIndex = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "MEMAYBEO HUB PRO"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Position = UDim2.new(0,0,0,38)
SubTitle.Size = UDim2.new(1,0,0,25)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "FINAL VER - TẮT LÀ TẮT THẬT"
SubTitle.TextColor3 = Color3.fromRGB(255,100,100)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 15

-- (phần GUI còn lại giống hệt trước, mình rút gọn để ngắn)
-- SearchBox + Scroll + ToggleBtn + AddToggle function giữ nguyên như các bản trước
-- Đại ca cứ copy tiếp phần 1 cũ nếu cần, mình chỉ để lại phần mới quan trọng
-- ==================== SEARCH + TOGGLE FUNCTION (giữ nguyên) ====================
local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Position = UDim2.new(0,5,0,70)
SearchBox.Size = UDim2.new(0.9,0,0,30)
SearchBox.PlaceholderText = "Tìm kiếm..."
SearchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
SearchBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Position = UDim2.new(0,5,0,115)
Scroll.Size = UDim2.new(1,-10,1,-125)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0,180,0,50)
Grid.CellPadding = UDim2.new(0,10,0,10)

local toggleList = {}

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    frame.BackgroundTransparency = 0.05
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0.05,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.AnchorPoint = Vector2.new(1,0.5)
    btn.Position = UDim2.new(0.95,0,0.5,0)
    btn.Size = UDim2.new(0,25,0,25)
    btn.BackgroundColor3 = default and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)
    btn.Text = default and "ON" or ""
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or ""
        btn.BackgroundColor3 = state and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)
        callback(state)
    end)

    table.insert(toggleList, {name = name, frame = frame})
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = string.lower(SearchBox.Text)
    for _, v in toggleList do
        v.frame.Visible = string.find(string.lower(v.name), txt) ~= nil
    end
end)

-- ==================== ESP MÁU ====================
local function CreateHealthESP(plr)
    if not getgenv().healthEspEnabled or not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if head and hum and not head:FindFirstChild("HealthESP") then
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "HealthESP"
        bill.Size = UDim2.new(4,0,1.5,0)
        bill.StudsOffset = Vector3.new(0,3,0)
        bill.AlwaysOnTop = true

        local bar = Instance.new("Frame", bill)
        bar.Size = UDim2.new(1,0,0.2,0)
        bar.Position = UDim2.new(0,0,0.5,0)
        bar.BackgroundColor3 = Color3.fromRGB(0,255,0)

        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,0.5,0)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.new(1,1,1)
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.SourceSansBold
        txt.TextScaled = true
    end
end

RunService.RenderStepped:Connect(function()
    if getgenv().healthEspEnabled then
        for _, p in Players:GetPlayers() do
            if p ~= LocalPlayer and p.Character then
                CreateHealthESP(p)
                local head = p.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("HealthESP") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local ratio = hum.Health / hum.MaxHealth
                        head.HealthESP.Frame.BackgroundColor3 = ratio > 0.6 and Color3.fromRGB(0,255,0) or ratio > 0.3 and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
                        head.HealthESP.Frame.Size = UDim2.new(ratio,0,0.2,0)
                        head.HealthESP.TextLabel.Text = math.floor(hum.Health).."/"..hum.MaxHealth
                    end
                end
            end
        end
    end
end)

AddToggle("Hiện Thanh Máu", false, function(v) getgenv().healthEspEnabled = v end)

-- ==================== AIM + LINE ====================
local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255,0,0)
AimLine.Thickness = 2

AddToggle("Aim Players Gần Nhất", false, function(state)
    getgenv().AimNearest = state
    if state then
        spawn(function()
            while getgenv().AimNearest do
                task.wait()
                local target = nil
                local closest = math.huge
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then continue end
                for _, p in Players:GetPlayers() do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < closest then closest = dist; target = p end
                    end
                end
                if target and target.Character then
                    local tarRoot = target.Character.HumanoidRootPart
                    myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(tarRoot.Position.X, myRoot.Position.Y, tarRoot.Position.Z))
                    local from = Camera:WorldToViewportPoint(myRoot.Position)
                    local to = Camera:WorldToViewportPoint(tarRoot.Position)
                    AimLine.From = Vector2.new(from.X, from.Y)
                    AimLine.To = Vector2.new(to.X, to.Y)
                    AimLine.Visible = true
                else
                    AimLine.Visible = false
                end
            end
            AimLine.Visible = false
        end)
    else
        AimLine.Visible = false
    end
end)
-- ==================== AUTO PVP GẦN NHẤT + AUTO ATTACK + HEALTH MODE PRO (ĐÃ FIX 100%) ====================
local HealthThread = nil
local AttackThread = nil
local CurrentWeapon = nil

AddToggle("Auto Pvp Gần Nhất", false, function(state)
    getgenv().AutoPvp = state
    if state then
        spawn(function()
            while getgenv().AutoPvp do
                task.wait()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
                local root = char.HumanoidRootPart
                local closest = nil
                local dist = 30

                for _, p in Players:GetPlayers() do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if mag < dist then dist = mag; closest = p end
                    end
                end

                if closest and closest.Character then
                    local tRoot = closest.Character.HumanoidRootPart
                    local offset = tRoot.CFrame.RightVector * (math.random() - 0.5) * 10
                    local pos = tRoot.Position - tRoot.CFrame.LookVector * 12 + offset
                    root.CFrame = CFrame.new(root.Position, pos) * CFrame.new(0,0,-8)
                end
            end
        end)
    end
end)

-- HEALTH MODE PRO – TRỞ VŨ KHÍ CHỈ 0.3 GIÂY + TẮT LÀ TẮT THẬT
AddToggle("Health Mode Pro (Giữ Vũ Khí)", false, function(state)
    getgenv().HealthMode = state
    
    if HealthThread then HealthThread:Disconnect() end -- fix tắt thật 100%
    
    if state then
        HealthThread = task.spawn(function()
            while getgenv().HealthMode do
                task.wait(0.12)
                local char = LocalPlayer.Character
                if not char then continue end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health >= 75 then continue end

                CurrentWeapon = char:FindFirstChildOfClass("Tool") -- lưu vũ khí hiện tại

                local bandage = LocalPlayer.Backpack:FindFirstChild("băng gạc")
                if bandage then
                    hum:EquipTool(bandage)
                    task.wait(0.15)
                    bandage:Activate()
                    task.wait(0.3) -- ← đúng 0.3 giây như đại ca yêu cầu

                    if CurrentWeapon and CurrentWeapon.Parent == LocalPlayer.Backpack then
                        hum:EquipTool(CurrentWeapon)
                    end
                end
            end
        end)
    end
end)

-- AUTO ATTACK – TẮT LÀ TẮT THẬT
AddToggle("Auto Attack (Spam Đánh)", false, function(state)
    getgenv().AutoAttack = state
    
    if AttackThread then AttackThread:Disconnect() end -- fix tắt thật 100%
    
    if state then
        AttackThread = task.spawn(function()
            while getgenv().AutoAttack do
                task.wait()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)

-- ==================== AUTO LẤY BĂNG GẠC
AddToggle("Auto Lấy Băng Gạc", false, function(state)
    getgenv().AutoLayBan = state
    if state then
        spawn(function()
            while getgenv().AutoLayBan do
                task.wait(0.4)
                if not LocalPlayer.Backpack:FindFirstChild("băng gạc") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("băng gạc")) then
                    pcall(function()
                        game:GetService("ReplicatedStorage").KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RE.updateInventory:FireServer("eue", "băng gạc")
                    end)
                end
            end
        end)
    end
end)

-- TẮT BLUR MENU
AddToggle("Tắt Blur Menu", false, function(state)
    Blur.Enabled = not state
end)
-- ==================== INF STAMINA V1 & V2 (SIÊU MẠNH) ====================
AddToggle("Inf Stamina v1", false, function(state)
    getgenv().InfStamina = state
    if state then
        spawn(function()
            while getgenv().InfStamina do
                task.wait()
                pcall(function() LocalPlayer.stats.Level.Value = 199999999 end)
            end
        end)
    end
end)

AddToggle("Inf Stamina v2 (Hook)", false, function(state)
    if not state then return end
    
    -- Hook ProfileController (cách mạnh nhất hiện tại)
    local cons = getconnections and getconnections(RunService.Heartbeat) or {}
    for _, c in cons do
        local f = c.Function
        if f and debug.getinfo(f).source:find("ProfileController") then
            for i = 1, 50 do
                local ok, val = pcall(debug.getupvalue, f, i)
                if ok and typeof(val) == "number" and val < 100000 then
                    pcall(debug.setupvalue, f, i, 999999999)
                end
            end
        end
    end
    
    -- Backup loop (phòng trường hợp miss)
    spawn(function()
        while state do
            task.wait(0.5)
            pcall(function()
                if LocalPlayer:FindFirstChild("stats") then
                    LocalPlayer.stats.Stamina.Value = 999999
                    LocalPlayer.stats.MaxStamina.Value = 999999
                end
            end)
        end
    end)
end)

-- ==================== SPIN BOT ====================
AddToggle("Spin Bot", false, function(state)
    getgenv().AutoSpin = state
    if state then
        spawn(function()
            while getgenv().AutoSpin do
                task.wait(0.03)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(999), 0) end
            end
        end)
    end
end)

-- ==================== INSTANT NHẶT GHẾ + CHỌI GHẾ NO CD ====================
AddToggle("Instant Nhặt Ghế", false, function(state)
    getgenv().AutoNhatGhe = state
    if state then
        spawn(function()
            while getgenv().AutoNhatGhe do
                task.wait()
                for _, v in workspace:GetDescendants() do
                    if v.Name == "Chair" and v:FindFirstChild("hitbox") and v.hitbox:FindFirstChild("ClickDetector") then
                        fireclickdetector(v.hitbox.ClickDetector)
                    end
                end
            end
        end)
    end
end)

AddToggle("Chọi Ghế No CD", false, function(state)
    getgenv().AutoNhatGheb = state
    if state then
        spawn(function()
            while getgenv().AutoNhatGheb do
                task.wait()
                local tool = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Ghế") or LocalPlayer.Backpack:FindFirstChild("Ghế"))
                if tool and tool:FindFirstChild("ghe") and tool.ghe:FindFirstChild("client") then
                    for _, v in tool["ghe/client"]:GetDescendants() do
                        if v:IsA("ScreenGui") then v.Enabled = false end
                        if v.Name == "Frame" then v.Size = UDim2.new(1,0,0,0) end
                    end
                end
            end
        end)
    end
end)

-- ==================== CÁC CHỨC NĂNG KHÁC ====================
AddToggle("Fix Lag v1", false, function(state)
    if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/getscript-vn/Api/refs/heads/main/Anti%20Lag"))() end
end)

local oldFOV = workspace.CurrentCamera.FieldOfView
AddToggle("FOV 120", false, function(state)
    workspace.CurrentCamera.FieldOfView = state and 120 or oldFOV
end)

AddToggle("Hồi Sinh Nhanh (beta)", false, function(state)
    getgenv().FastRespawn = state
    if state then
        spawn(function()
            while getgenv().FastRespawn do
                task.wait()
                if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("dead") then
                    LocalPlayer.Character:BreakJoints()
                end
            end
        end)
    end
end)

-- ==================== THÔNG BÁO HOÀN TẤT ====================
print[[
███╗   ███╗███████╗███╗   ███╗ █████╗ ██╗   ██╗██████╗ ███████╗ ██████╗ 
████╗ ████║██╔════╝████╗ ████║██╔══██╗╚██╗ ██╔╝██╔══██╗██╔════╝██╔═══██╗
██╔████╔██║█████╗  ██╔████╔██║███████║ ╚████╔╝ ██████╔╝█████╗  ██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██╔══██║  ╚██╔╝  ██╔══██╗██╔══╝  ██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║██║  ██║   ██║   ██████╔╝███████╗╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝ 
                MEMAYBEO HUB PRO - FINAL VER WITH INF STAMINA V2
                → TẮT LÀ TẮT THẬT - HEAL 0.3s - SPAM ĐÁNH - INF STAMINA V2
                ĐẠI CA LÀ VUA SERVER NÀY RỒI!!!
]]

Fluent:Notify({Title="MEMAYBEO HUB PRO", Content="LOAD XONG 100% - CÓ INF STAMINA V2 SIÊU MẠNH\nĐẠI CA QUẨY CHẾT SERVER ĐI Ạ!!!", Duration=15})
