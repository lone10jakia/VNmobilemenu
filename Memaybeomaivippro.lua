-- MEMAYBEO HUB - FULL PVP + HEALTH PRO + AUTO ATTACK
-- Đã thêm: Dùng băng gạc KHÔNG mất vũ khí + Spam đánh liên tục
-- Đại ca quẩy cho tụi nó khóc luôn

print("MEMAYBEO HUB ĐANG LOAD... ĐỢI CHÚT NHA ĐẠI CA")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Biến global
getgenv().healthEspEnabled = false
getgenv().InfStamina = false
getgenv().AimNearest = false
getgenv().AutoPvp = false
getgenv().DisabledBlur = false
getgenv().PlayerInfo = false
getgenv().HealthMode = false
getgenv().AutoLayBan = false
getgenv().AutoNhatGhe = false
getgenv().AutoNhatGheb = false
getgenv().AutoSpin = false
getgenv().FastRespawn = false
getgenv().AutoAttack = false  -- mới

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Blur + GUI
local Blur = Instance.new("BlurEffect", game.Lighting)
Blur.Size = 10
Blur.Enabled = true

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MEMAYBEO_UI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 610, 0, 400)
MainFrame.Position = UDim2.new(0, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.ClipsDescendants = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)

local Bg = Instance.new("ImageLabel", MainFrame)
Bg.Size = UDim2.new(1, 40, 1, 40)
Bg.Position = UDim2.new(0.5, 0, 0.5, 0)
Bg.AnchorPoint = Vector2.new(0.5, 0.5)
Bg.Image = "rbxassetid://5554236805"
Bg.ImageColor3 = Color3.new(0,0,0)
Bg.ImageTransparency = 0.6
Bg.BackgroundTransparency = 1
Bg.ScaleType = Enum.ScaleType.Slice
Bg.SliceCenter = Rect.new(23, 23, 277, 277)
Bg.ZIndex = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "MEMAYBEO HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Position = UDim2.new(0,0,0,35)
SubTitle.Size = UDim2.new(1,0,0,25)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PVP MODE - PRO EDITION"
SubTitle.TextColor3 = Color3.fromRGB(200,200,200)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14

local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Position = UDim2.new(0,5,0,70)
SearchBox.Size = UDim2.new(0.9,0,0,30)
SearchBox.PlaceholderText = "Tìm kiếm chức năng..."
SearchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
SearchBox.TextColor3 = Color3.new(1,1,1)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)
Instance.new("UIPadding", SearchBox).PaddingLeft = UDim.new(0,10)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Position = UDim2.new(0,5,0,115)
Scroll.Size = UDim2.new(1,0,1,-110)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0,180,0,50)
Grid.CellPadding = UDim2.new(0,10,0,10)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0, Grid.AbsoluteContentSize.Y + 20)
end)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,25,0,50)
ToggleBtn.Position = UDim2.new(0,600,0.5,0)
ToggleBtn.AnchorPoint = Vector2.new(0,0.5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
ToggleBtn.Text = "<"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20

local menuOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        TweenService:Create(MainFrame, TweenInfo.new(0.5), {Position = UDim2.new(0,0,0.5,0)}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.5), {Position = UDim2.new(0,600,0.5,0)}):Play()
        ToggleBtn.Text = "<"
        Blur.Enabled = true
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 10}):Play()
    else
        Blur.Enabled = false
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.5), {Position = UDim2.new(-1,0,0.5,0)}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.5), {Position = UDim2.new(0,0,0.5,0)}):Play()
        ToggleBtn.Text = ">"
    end
end)

local toggleList = {}

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(0,180,0,50)
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
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
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
    local text = string.lower(SearchBox.Text)
    for _, v in ipairs(toggleList) do
        v.frame.Visible = string.find(string.lower(v.name), text) ~= nil
    end
end)
-- ==================== ESP MÁU ====================
local function CreateHealthESP(char)
    if not getgenv().healthEspEnabled then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if head and hum and not head:FindFirstChild("HealthESP") then
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "HealthESP"
        bill.Size = UDim2.new(4,0,1.5,0)
        bill.StudsOffset = Vector3.new(0,3,0)
        bill.AlwaysOnTop = true

        local bg = Instance.new("Frame", bill)
        bg.Size = UDim2.new(1,0,0.2,0)
        bg.Position = UDim2.new(0,0,0.5,0)
        bg.BackgroundColor3 = Color3.fromRGB(50,50,50)

        local bar = Instance.new("Frame", bg)
        bar.Name = "HealthBar"
        bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
        bar.Size = UDim2.new(1,0,1,0)

        local txt = Instance.new("TextLabel", bill)
        txt.Name = "HPText"
        txt.Size = UDim2.new(1,0,0.5,0)
        txt.Position = UDim2.new(0,0,0,-10)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.new(1,1,1)
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.SourceSansBold
        txt.TextScaled = true
        txt.Text = math.floor(hum.Health).."/"..hum.MaxHealth
    end
end

RunService.RenderStepped:Connect(function()
    if getgenv().healthEspEnabled then
        for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer and plr.Character then
                CreateHealthESP(plr.Character)
                local head = plr.Character:FindFirstChild("Head")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and head:FindFirstChild("HealthESP") then
                    local bar = head.HealthESP.Frame.HealthBar
                    local txt = head.HealthESP.HPText
                    local ratio = hum.Health / hum.MaxHealth
                    bar.Size = UDim2.new(math.clamp(ratio,0,1),0,1,0)
                    bar.BackgroundColor3 = ratio > 0.6 and Color3.fromRGB(0,255,0) or ratio > 0.3 and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
                    txt.Text = math.floor(hum.Health).."/"..hum.MaxHealth
                end
            end
        end
    end
end)

AddToggle("Hiện Thanh Máu", false, function(v) getgenv().healthEspEnabled = v end)

-- ==================== INF STAMINA V1 & V2 ====================
AddToggle("Inf Stamina v1", false, function(state)
    getgenv().InfStamina = state
    if state then
        spawn(function()
            while getgenv().InfStamina do
                task.wait()
                pcall(function()
                    LocalPlayer.stats.Level.Value = 199999999
                end)
            end
        end)
    end
end)

AddToggle("Inf Stamina v2", false, function(state)
    if not state then return end
    local cons = getconnections and getconnections(RunService.RenderStepped) or {}
    for _, c in ipairs(cons) do
        local f = c.Function
        if f and debug.getinfo(f).source:find("ProfileController") then
            for i = 1, 50 do
                local ok, val = pcall(debug.getupvalue, f, i)
                if ok and type(val) == "number" and val < 1000000 then
                    pcall(debug.setupvalue, f, i, 999999999)
                end
            end
        end
    end
end)

-- ==================== AIM + LINE ====================
local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255,0,0)
AimLine.Thickness = 2
AimLine.Transparency = 1

local function GetNearest()
    local closest, dist = nil, math.huge
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then dist = mag; closest = p end
        end
    end
    return closest
end

AddToggle("Aim Players Gần Nhất", false, function(state)
    getgenv().AimNearest = state
    if state then
        spawn(function()
            while getgenv().AimNearest do
                task.wait()
                local target = GetNearest()
                if target and target.Character and LocalPlayer.Character then
                    local me = LocalPlayer.Character.HumanoidRootPart
                    local tar = target.Character.HumanoidRootPart
                    if me and tar then
                        me.CFrame = CFrame.new(me.Position, Vector3.new(tar.Position.X, me.Position.Y, tar.Position.Z))
                        local s1, v1 = Camera:WorldToViewportPoint(me.Position)
                        local s2, v2 = Camera:WorldToViewportPoint(tar.Position)
                        if v1 and v2 then
                            AimLine.From = Vector2.new(s1.X, s1.Y)
                            AimLine.To = Vector2.new(s2.X, s2.Y)
                            AimLine.Visible = true
                        else
                            AimLine.Visible = false
                        end
                    end
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
-- ==================== AUTO PVP GẦN NHẤT ====================
AddToggle("Auto Pvp Gần Nhất", false, function(state)
    getgenv().AutoPvp = state
    if state then
        spawn(function()
            while getgenv().AutoPvp do
                task.wait()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then continue end
                local root = char.HumanoidRootPart
                local hum = char.Humanoid

                local closest, dist = nil, 30
                for _, p in Players:GetPlayers() do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if mag < dist then dist = mag; closest = p end
                    end
                end

                if closest and closest.Character then
                    local tRoot = closest.Character.HumanoidRootPart
                    local look = tRoot.CFrame.LookVector
                    local dot = look:Dot((root.Position - tRoot.Position).Unit)
                    local offset = dot < 0 and (tRoot.CFrame.RightVector * math.random(-5,5)) or (tRoot.CFrame.RightVector * (math.random() - 0.5) * 8)
                    local targetPos = tRoot.Position - look * math.random(10,14) + offset * 5

                    if (root.Position - targetPos).Magnitude <= 1 then
                        root.CFrame = CFrame.new(targetPos, tRoot.Position)
                    else
                        TweenService:Create(root, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = CFrame.new(targetPos, tRoot.Position)}):Play()
                    end

                    if hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
                end
            end
        end)
    end
end)

-- ==================== TẮT BLUR ====================
AddToggle("Tắt Blur Của Menu", false, function(state)
    getgenv().DisabledBlur = state
    if state then
        spawn(function()
            while getgenv().DisabledBlur do
                Blur.Size = 0
                task.wait()
            end
        end)
    end
end)

-- ==================== ESP THÔNG TIN ====================
AddToggle("ESP Thông Tin", false, function(state)
    getgenv().PlayerInfo = state
    if state then
        spawn(function()
            while getgenv().PlayerInfo do
                task.wait()
                for _, p in Players:GetPlayers() do
                    if p ~= LocalPlayer and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        if head and not head:FindFirstChild("PlayerInfo") then
                            local bill = Instance.new("BillboardGui", head)
                            bill.Name = "PlayerInfo"
                            bill.Size = UDim2.new(4,0,2,0)
                            bill.StudsOffset = Vector3.new(0,3,0)
                            bill.AlwaysOnTop = true

                            local name = Instance.new("TextLabel", bill)
                            name.Size = UDim2.new(1,0,0.5,0)
                            name.BackgroundTransparency = 1
                            name.Text = p.Name
                            name.TextColor3 = Color3.new(1,1,1)
                            name.TextStrokeTransparency = 0
                            name.Font = Enum.Font.SourceSansBold
                            name.TextScaled = true

                            local info = Instance.new("TextLabel", bill)
                            info.Position = UDim2.new(0,0,0.5,0)
                            info.Size = UDim2.new(1,0,0.5,0)
                            info.BackgroundTransparency = 1
                            info.TextColor3 = Color3.new(1,1,1)
                            info.TextStrokeTransparency = 0
                            info.Font = Enum.Font.SourceSansBold
                            info.TextScaled = true

                            local lvl = p:FindFirstChild("stats") and p.stats:FindFirstChild("Level") and p.stats.Level.Value or "N/A"
                            local pvp = p.Character:GetAttribute("PvPRemain") and "ON" or "OFF"
                            info.Text = "Level: "..tostring(lvl).." | PvP: "..pvp
                        end
                    end
                end
            end
        end)
    end
end)

-- ==================== AUTO LẤY BĂNG GẠC ====================
local function GetBandage()
    pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("KnitPackages")
            :WaitForChild("_Index")
            :WaitForChild("sleitnick_knit@1.7.0")
            :WaitForChild("knit")
            :WaitForChild("Services")
            :WaitForChild("InventoryService")
            :WaitForChild("RE")
            :WaitForChild("updateInventory")
            :FireServer("eue", "băng gạc")
    end)
end

AddToggle("Auto Lấy Băng Gạc", false, function(state)
    getgenv().AutoLayBan = state
    if state then
        spawn(function()
            while getgenv().AutoLayBan do
                task.wait(0.3)
                if not LocalPlayer.Backpack:FindFirstChild("băng gạc") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("băng gạc")) then
                    GetBandage()
                end
            end
        end)
    end
end)

-- ==================== HEALTH MODE PRO + AUTO ATTACK (MỚI NHẤT) ====================
local CurrentWeapon = nil

AddToggle("Health Mode Pro (Giữ Vũ Khí)", false, function(state)
    getgenv().HealthMode = state
    if state then
        spawn(function()
            while getgenv().HealthMode do
                task.wait(0.1)
                local char = LocalPlayer.Character
                if not char then continue end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health >= 75 then continue end

                -- Lưu vũ khí hiện tại
                CurrentWeapon = char:FindFirstChildOfClass("Tool")

                local bandage = LocalPlayer.Backpack:FindFirstChild("băng gạc")
                if bandage then
                    hum:EquipTool(bandage)
                    task.wait(0.15)
                    bandage:Activate()
                    task.wait(1.2) -- thời gian dùng băng gạc

                    -- Trở lại vũ khí cũ ngay lập tức
                    if CurrentWeapon and CurrentWeapon.Parent == LocalPlayer.Backpack then
                        hum:EquipTool(CurrentWeapon)
                    end
                end
            end
        end)
    end
end)

AddToggle("Auto Attack (Spam Đánh)", false, function(state)
    getgenv().AutoAttack = state
    if state then
        spawn(function()
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
-- ==================== INSTANT NHẶT GHẾ + CHỌI GHẾ NO CD ====================
AddToggle("Instant Nhặt Ghế", false, function(state)
    getgenv().AutoNhatGhe = state
    if state then
        spawn(function()
            while getgenv().AutoNhatGhe do
                task.wait()
                for _, ghe in pairs(workspace:GetDescendants()) do
                    if ghe.Name == "Chair" or ghe:FindFirstChild("hitbox") and ghe.hitbox:FindFirstChild("ClickDetector") then
                        fireclickdetector(ghe.hitbox.ClickDetector)
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
                    for _, v in pairs(tool["ghe/client"]:GetDescendants()) do
                        if v:IsA("ScreenGui") then v.Enabled = false end
                        if v.Name == "Frame" then v.Size = UDim2.new(1,0,0,0) end
                    end
                end
            end
        end)
    end
end)

-- ==================== SPIN BOT ====================
AddToggle("Spin Bot", false, function(state)
    getgenv().AutoSpin = state
    if state then
        spawn(function()
            while getgenv().AutoSpin do
                task.wait(0.03)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(999), 0)
                end
            end
        end)
    end
end)

-- ==================== FIX LAG + FOV ====================
AddToggle("Fix Lag v1", false, function(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/getscript-vn/Api/refs/heads/main/Anti%20Lag"))()
    end
end)

local oldfov = workspace.CurrentCamera.FieldOfView
AddToggle("FOV 120", false, function(state)
    workspace.CurrentCamera.FieldOfView = state and 120 or oldfov
end)

-- ==================== HỒI SINH NHANH (BETA) ====================
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

-- ==================== KẾT THÚC ====================
print[[
███╗   ███╗███████╗███╗   ███╗ █████╗ ██╗   ██╗██████╗ ███████╗ ██████╗ 
████╗ ████║██╔════╝████╗ ████║██╔══██╗╚██╗ ██╔╝██╔══██╗██╔════╝██╔═══██╗
██╔████╔██║█████╗  ██╔████╔██║███████║ ╚████╔╝ ██████╔╝█████╗  ██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██╔══██║  ╚██╔╝  ██╔══██╗██╔══╝  ██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║██║  ██║   ██║   ██████╔╝███████╗╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝ 
               MEMAYBEO HUB PRO - HEALTH + AUTO ATTACK ĐÃ HOÀN THÀNH
]]

Fluent:Notify({
    Title = "MEMAYBEO HUB PRO",
    Content = "ĐÃ LOAD XONG 100% - HEALTH KHÔNG MẤT VŨ KHÍ + AUTO ATTACK SPAM ĐIÊN CUỒNG\nĐẠI CA QUẨY CHẾT SERVER ĐI Ạ!!!",
    Duration = 12
})
