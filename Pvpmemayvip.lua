-- MEMAYBEO HUB - FULL PVP MODE 100%
-- Không key - Không bỏ chức năng nào - Inf Stamina + Fast Respawn full
-- Đại ca quẩy cho tụi nó khóc =))

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Blur + GUI chính
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

-- Background image + title
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
SubTitle.Text = "PVP MODE - FULL CHỨC NĂNG"
SubTitle.TextColor3 = Color3.fromRGB(200,200,200)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14

-- Search box
local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Position = UDim2.new(0,5,0,70)
SearchBox.Size = UDim2.new(0.9,0,0,30)
SearchBox.PlaceholderText = "Tìm kiếm..."
SearchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
SearchBox.TextColor3 = Color3.new(1,1,1)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = false
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,4)
Instance.new("UIPadding", SearchBox).PaddingLeft = UDim.new(0,10)

-- ScrollingFrame + Grid
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Position = UDim2.new(0,5,0,115)
Scroll.Size = UDim2.new(1,0,1,-110)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0,0,0,0)

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0,180,0,50)
Grid.CellPadding = UDim2.new(0,10,0,10)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0, Grid.AbsoluteContentSize.Y + 20)
end)

-- Nút ẩn/hiện menu
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
        TweenService:Create(MainFrame, TweenInfo.new(0.5), {Position = UDim2.new(-1, arsenal,0.5,0)}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.5), {Position = UDim2.new(0,0,0.5,0)}):Play()
        ToggleBtn.Text = ">"
    end
end)

-- Danh sách toggle để search
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

-- Search
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = string.lower(SearchBox.Text)
    for _, v in ipairs(toggleList) do
        v.frame.Visible = string.find(string.lower(v.name), text) ~= nil
    end
end)
-- ==================== ESP MÁU ====================
local function CreateHealthESP(character)
    if not getgenv().healthEspEnabled then return end
    local head = character:FindFirstChild("Head")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if head and hum and not head:FindFirstChild("HealthESP") then
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "HealthESP"
        bill.Size = UDim2.new(4,0,1.5,0)
        bill.StudsOffset = Vector3.new(0,3,0)
        bill.AlwaysOnTop = true

        local barBG = Instance.new("Frame", bill)
        barBG.Size = UDim2.new(1,0,0.2,0)
        barBG.Position = UDim2.new(0,0,0.5,0)
        barBG.BackgroundColor3 = Color3.fromRGB(50,50,50)

        local bar = Instance.new("Frame", barBG)
        bar.Name = "HealthBar"
        bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
        bar.Size = UDim2.new(1,0,1,0)

        local text = Instance.new("TextLabel", bill)
        text.Name = "HPText"
        text.Size = UDim2.new(1,0,0.5,0)
        text.Position = UDim2.new(0,0,0,-10)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1,1,1)
        text.TextStrokeTransparency = 0
        text.Font = Enum.Font.SourceSansBold
        text.TextScaled = true
        text.Text = math.floor(hum.Health) .. "/" .. hum.MaxHealth
    end
end

RunService.RenderStepped:Connect(function()
    if getgenv().healthEspEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                CreateHealthESP(plr.Character)
                local head = plr.Character:FindFirstChild("Head")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and head:FindFirstChild("HealthESP") then
                    local bill = head.HealthESP
                    local bar = bill.Frame.HealthBar
                    local txt = bill.HPText
                    local ratio = hum.Health / hum.MaxHealth
                    bar.Size = UDim2.new(math.clamp(ratio,0,1),0,1,0)
                    bar.BackgroundColor3 = ratio > 0.6 and Color3.fromRGB(0,255,0) or ratio > 0.3 and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
                    txt.Text = math.floor(hum.Health) .. "/" .. hum.MaxHealth
                end
            end
        end
    end
end)

-- ==================== INF STAMINA V1 ====================
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

-- ==================== INF STAMINA V2 (HOOK PROFILECONTROLLER) ====================
AddToggle("Inf Stamina v2", false, function(state)
    if not state then return end
    local connections = getconnections and getconnections(RunService.RenderStepped) or {}
    
    local function HookUpvalue(func, upname, value)
        if debug and debug.setupvalue then
            debug.setupvalue(func, upname, value)
        elseif setupvalue then
            setupvalue(func, upname, value)
        end
    end
    
    local function FindAndSet(func, maxval)
        for i = 1, 50 do
            local success, upval = pcall(debug.getupvalue, func, i)
            if success and typeof(upval) == "number" and upval < maxval then
                pcall(HookUpvalue, func, i, maxval)
                return true
            end
        end
        return false
    end
    
    for _, conn in ipairs(connections) do
        local func = conn.Function
        if func then
            local info = debug.getinfo(func)
            if info and info.source and string.find(info.source, "ProfileController") then
                FindAndSet(func, 999999999)
                break
            end
        end
    end
end)

-- ==================== AIM + LINE ====================
local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255,0,0)
AimLine.Thickness = 2
AimLine.Transparency = 1
AimLine.Visible = false

local function GetNearestPlayer()
    local closest, dist = nil, math.huge
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = plr
            end
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
                local target = GetNearestPlayer()
                if target and target.Character and LocalPlayer.Character then
                    local myRoot = LocalPlayer.Character.HumanoidRootPart
                    local tarRoot = target.Character.HumanoidRootPart
                    if myRoot and tarRoot then
                        myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(tarRoot.Position.X, myRoot.Position.Y, tarRoot.Position.Z))
                        
                        local from, onScreen1 = Camera:WorldToViewportPoint(myRoot.Position)
                        local to, onScreen2 = Camera:WorldToViewportPoint(tarRoot.Position)
                        if onScreen1 and onScreen2 then
                            AimLine.From = Vector2.new(from.X, from.Y)
                            AimLine.To = Vector2.new(to.X, to.Y)
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
                for _, plr in Players:GetPlayers() do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if mag < dist then
                            dist = mag
                            closest = plr
                        end
                    end
                end
                
                if closest and closest.Character then
                    local targetRoot = closest.Character.HumanoidRootPart
                    local lookVec = targetRoot.CFrame.LookVector
                    local forwardDot = lookVec:Dot((root.Position - targetRoot.Position).Unit)
                    local offset = forwardDot < 0 and (targetRoot.CFrame.RightVector * math.random(-5,5)) or (targetRoot.CFrame.RightVector * (math.random() - 0.5) * 8)
                    local targetPos = targetRoot.Position - lookVec * math.random(10,14) + offset * 5
                    
                    if (root.Position - targetPos).Magnitude <= 1 then
                        root.CFrame = CFrame.new(targetPos, targetRoot.Position)
                    else
                        TweenService:Create(root, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {CFrame = CFrame.new(targetPos, targetRoot.Position)}):Play()
                    end
                    
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        hum.Jump = true
                    end
                end
            end
        end)
    end
end)

-- ==================== AUTO HIT ====================
AddToggle("Auto Hit Players", false, function(state)
    getgenv().AutoPvp = state
    if state then
        spawn(function()
            while getgenv().AutoPvp do
                task.wait()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Tool") then continue end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Activate") then
                    tool:Activate()
                end
            end
        end)
    end
end)

-- ==================== TẮT BLUR MENU ====================
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

-- ==================== ESP THÔNG TIN (TÊN + LEVEL + PVP) ====================
AddToggle("ESP Thông Tin", false, function(state)
    getgenv().PlayerInfo = state
    if state then
        spawn(function()
            while getgenv().PlayerInfo do
                task.wait()
                for _, plr in Players:GetPlayers() do
                    if plr ~= LocalPlayer and plr.Character then
                        local head = plr.Character:FindFirstChild("Head")
                        if head and not head:FindFirstChild("PlayerInfo") then
                            local bill = Instance.new("BillboardGui", head)
                            bill.Name = "PlayerInfo"
                            bill.Size = UDim2.new(4,0,2,0)
                            bill.StudsOffset = Vector3.new(0,3,0)
                            bill.AlwaysOnTop = true
                            
                            local name = Instance.new("TextLabel", bill)
                            name.Size = UDim2.new(1,0,0.5,0)
                            name.BackgroundTransparency = 1
                            name.Text = plr.Name
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
                            
                            local level = plr:FindFirstChild("stats") and plr.stats:FindFirstChild("Level") and plr.stats.Level.Value or "N/A"
                            local pvp = plr.Character and plr.Character:GetAttribute("PvPRemain") and "ON" or "OFF"
                            info.Text = "Level: "..tostring(level).." | PvP: "..pvp
                        end
                    end
                end
            end
        end)
    end
end)



-- ==================== AUTO LẤY BĂNG GẠC ====================
local function GetBandage()
    game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services")
        :WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory")
        :FireServer("eue", "băng gạc")
end

AddToggle("Auto Lấy Băng Gạc", false, function(state)
    getgenv().AutoLayBan = state
    if state then
        spawn(function()
            while getgenv().AutoLayBan do
                task.wait(0.3)
                if not LocalPlayer.Backpack:FindFirstChild("băng gạc") and not (LocalPlayer.Character and LocalPlayer.Character:Find-- ==================== HEALTH MODE PRO (GIỮ VŨ KHÍ + AUTO ATTACK) ====================
local CurrentTool = nil
local AutoAttackEnabled = false

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

                -- Lưu lại vũ khí hiện tại
                CurrentTool = char:FindFirstChildOfClass("Tool")

                -- Tìm băng gạc trong backpack
                local bandage = LocalPlayer.Backpack:FindFirstChild("băng gạc")
                if bandage then
                    hum:EquipTool(bandage)
                    task.wait(0.15)
                    bandage:Activate()
                    task.wait(1.2)

                    -- Trở lại vũ khí cũ ngay lập tức
                    if CurrentTool and CurrentTool.Parent == LocalPlayer.Backpack then
                        hum:EquipTool(CurrentTool)
                    end
                end
            end
        end)
    end
end)

-- ==================== AUTO ATTACK (SPAM ĐÁNH KHI CẦM VŨ KHÍ) ====================
AddToggle("Auto Attack (Spam Đánh)", false, function(state)
    AutoAttackEnabled = state
    if state then
        spawn(function()
            while AutoAttackEnabled do
                task.wait()
                local char = LocalPlayer.Character
                if not char then continue end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                end
            end
        end)
    end
end)
-- ==================== INSTANT NHẶT GHẾ + CHỌI GHẾ NO CD ====================
AddToggle("Instant Nhặt Ghế", false, function(state)
    AutoNhatGhe = state
    if state then
        spawn(function()
            while AutoNhatGhe do
                task.wait()
                for _, chair in pairs(workspace.Ghe:GetChildren()) do
                    if chair.Name == "Chair" then
                        chair.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,150,0)
                    end
                    if chair.Name == "Chair" and chair:FindFirstChild("hitbox") and chair.hitbox:FindFirstChild("ClickDetector") then
                        if not LocalPlayer.Backpack:FindFirstChild("Ghế") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Ghế")) then
                            fireclickdetector(chair.hitbox.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)

AddToggle("Chọi Ghế No CD", false, function(state)
    AutoNhatGheb = state
    if state then
        spawn(function()
            while AutoNhatGheb do
                task.wait()
                local tool = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Ghế") or LocalPlayer.Backpack:FindFirstChild("Ghế"))
                if tool then
                    for _, v in pairs(tool["ghe/client"]:GetChildren()) do
                        if v.Name == "ScreenGui" then
                            v.Enabled = false
                            if v:FindFirstChild("CanvasGroup") and v.CanvasGroup:FindFirstChild("Frame") then
                                v.CanvasGroup.Frame.Size = UDim2.new(1,0,0,0)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==================== SPIN BOT ====================
AddToggle("Spin", false, function(state)
    AutoSpin = state
    if state then
        spawn(function()
            while AutoSpin do
                task.wait(0.03)
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    char.Humanoid.AutoRotate = false
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(999), 0)
                end
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
        end)
    end
end)

-- ==================== FIX LAG V1 ====================
AddToggle("FixLag v1", false, function(state)
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/getscript-vn/Api/refs/heads/main/Anti%20Lag"))()
    end
end)

-- ==================== FOV 120 ====================
local oldFov = workspace.CurrentCamera.FieldOfView
AddToggle("Fov 120", false, function(state)
    workspace.CurrentCamera.FieldOfView = state and 120 or oldFov
end)

-- ==================== HỒI SINH NHANH (BETA) ====================
AddToggle("Hồi Sinh Nhanh (beta)", false, function(state)
    FastRespawn = state
    if state then
        spawn(function()
            while FastRespawn do
                task.wait()
                local deadGui = LocalPlayer.PlayerGui:FindFirstChild("Dead")
                if deadGui then
                    deadGui.Dead.Position = UDim2.new(9999,0,9999,0)
                    deadGui.MainFrame.Position = UDim2.new(9999,0,9999,0)
                end
                if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("dead") then
                    if replicatesignal then
                        replicatesignal(LocalPlayer.Kill)
                    elseif LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    else
                        LocalPlayer.Character:BreakJoints()
                    end
                end
            end
        end)
    end
end)

-- ==================== HIỆN THANH MÁU TOGGLE ====================
AddToggle("Hiện Thanh Máu", false, function(state)
    getgenv().healthEspEnabled = state
end)

print[[
███╗   ███╗███████╗███╗   ███╗ █████╗ ██╗   ██╗██████╗ ███████╗ ██████╗ 
████╗ ████║██╔════╝████╗ ████║██╔══██╗╚██╗ ██╔╝██╔══██╗██╔════╝██╔═══██╗
██╔████╔██║█████╗  ██╔████╔██║███████║ ╚████╔╝ ██████╔╝█████╗  ██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██╔══██║  ╚██╔╝  ██╔══██╗██╔══╝  ██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║██║  ██║   ██║   ██████╔╝███████╗╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝ 
                      PVP HUB - FULL CHỨC NĂNG - KHÔNG KEY
                       ĐẠI CA QUẨY CHO TỤI NÓ KHÓC LUÔN ĐI!!!
]]

Fluent:Notify({
    Title = "MEMAYBEO HUB",
    Content = "ĐÃ LOAD FULL 100% - KHÔNG BỎ GÌ HẾT - QUẨY CHẾT SERVER ĐI ĐẠI CA!!!",
    Duration = 10
})
