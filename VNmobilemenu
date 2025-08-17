-- 🇻🇳 Việt Nam Mobile Menu Full Final Auto Respawn ESP + Hitbox
-- Code by ChatGPT hỗ trợ bạn :))

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Lưu / đọc config
local configFile = "VNMenu_Config.txt"
local function saveConfig(data)
    if writefile then
        writefile(configFile, game:GetService("HttpService"):JSONEncode(data))
    end
end
local function loadConfig()
    if readfile and isfile and isfile(configFile) then
        return game:GetService("HttpService"):JSONDecode(readfile(configFile))
    end
    return {}
end

-- Config mặc định
local cfg = loadConfig()
local WalkSpeed = cfg.WalkSpeed or 16
local JumpPower = cfg.JumpPower or 50
local AutoBhop  = cfg.AutoBhop or false
local AutoHit   = cfg.AutoHit or false
local NoClip    = cfg.NoClip or false
local ESP       = cfg.ESP or false
local Hitbox    = cfg.Hitbox or false

local NormalSize = Vector3.new(2,2,1)
local BigSize    = Vector3.new(15,15,15)

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 360)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
frame.Active = true

-- 🔘 Nút Hide/Show
local menuVisible = true
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Text = "🔘"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    toggleBtn.BackgroundColor3 = menuVisible and Color3.fromRGB(200,0,0) or Color3.fromRGB(0,180,0)
end)

-- 👉 Kéo menu
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- 👉 Kéo nút 🔘
local draggingBtn, dragStartBtn, startPosBtn
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true dragStartBtn = input.Position startPosBtn = toggleBtn.Position
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if draggingBtn and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartBtn
        toggleBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then draggingBtn = false end
end)

-- ⚡ WalkSpeed nhập số
local wsBox = Instance.new("TextBox", frame)
wsBox.Size = UDim2.new(0, 180, 0, 30)
wsBox.Position = UDim2.new(0, 10, 0, 10)
wsBox.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBox.Text = tostring(WalkSpeed)
wsBox.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(wsBox.Text)
        if val then
            WalkSpeed = val
            saveConfig({WalkSpeed=WalkSpeed,JumpPower=JumpPower,AutoBhop=AutoBhop,AutoHit=AutoHit,NoClip=NoClip,ESP=ESP,Hitbox=Hitbox})
        else wsBox.Text = "⚡ lỗi số!" end
    end
end)

-- 🦘 JumpPower nhập số
local jpBox = Instance.new("TextBox", frame)
jpBox.Size = UDim2.new(0, 180, 0, 30)
jpBox.Position = UDim2.new(0, 10, 0, 50)
jpBox.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
jpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBox.Text = tostring(JumpPower)
jpBox.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(jpBox.Text)
        if val then
            JumpPower = val
            saveConfig({WalkSpeed=WalkSpeed,JumpPower=JumpPower,AutoBhop=AutoBhop,AutoHit=AutoHit,NoClip=NoClip,ESP=ESP,Hitbox=Hitbox})
        else jpBox.Text = "🦘 lỗi số!" end
    end
end)

-- ESP func
local function addESP(plr)
    if plr.Character and not plr.Character:FindFirstChild("VN_ESP") then
        local h = Instance.new("Highlight")
        h.Name = "VN_ESP" h.Adornee = plr.Character h.FillTransparency=1 h.OutlineColor=Color3.fromRGB(255,0,0) h.Parent=plr.Character
    end
end
local function removeESP(plr)
    if plr.Character and plr.Character:FindFirstChild("VN_ESP") then plr.Character.VN_ESP:Destroy() end
end
local function toggleESP(state)
    for _,plr in pairs(Players:GetPlayers()) do if plr~=LocalPlayer then
        if state then addESP(plr) else removeESP(plr) end
    end end
end

-- Hitbox
local function setHitbox(size)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=plr.Character.HumanoidRootPart
            hrp.Size=size hrp.Transparency=(size==NormalSize) and 1 or 0.7
        end
    end
end

-- Khi player spawn lại thì gắn lại ESP/Hitbox
local function setupPlayer(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if ESP then addESP(plr) end
        if Hitbox then setHitbox(BigSize) end
    end)
end
for _,plr in pairs(Players:GetPlayers()) do
    if plr~=LocalPlayer then setupPlayer(plr) end
end
Players.PlayerAdded:Connect(setupPlayer)

-- Toggle button helper
local function createToggle(name, order, state, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 90 + (order * 35))
    btn.BackgroundColor3 = Color3.fromRGB(90, 0, 120)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name.." ["..(state and "ON" or "OFF").."]"
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name.." ["..(state and "ON" or "OFF").."]"
        callback(state)
        saveConfig({WalkSpeed=WalkSpeed,JumpPower=JumpPower,AutoBhop=AutoBhop,AutoHit=AutoHit,NoClip=NoClip,ESP=ESP,Hitbox=Hitbox})
    end)
    return btn
end

-- Nút toggle
createToggle("🐇 AutoBhop",0,AutoBhop,function(st)AutoBhop=st end)
createToggle("⚔ Auto Đánh",1,AutoHit,function(st)AutoHit=st end)
createToggle("👻 NoClip",2,NoClip,function(st)NoClip=st end)
createToggle("👁 ESP",3,ESP,function(st)ESP=st toggleESP(st) end)
createToggle("🟦 Hitbox",4,Hitbox,function(st)Hitbox=st setHitbox(st and BigSize or NormalSize) end)

-- 🔄 Reset Config
local resetBtn = Instance.new("TextButton", frame)
resetBtn.Size = UDim2.new(0, 180, 0, 30)
resetBtn.Position = UDim2.new(0, 10, 0, 90 + (5 * 35))
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Text = "🔄 Reset Config"
resetBtn.MouseButton1Click:Connect(function()
    WalkSpeed = 16
    JumpPower = 50
    AutoBhop,AutoHit,NoClip,ESP,Hitbox = false,false,false,false,false
    wsBox.Text = tostring(WalkSpeed)
    jpBox.Text = tostring(JumpPower)
    toggleESP(false) setHitbox(NormalSize)
    saveConfig({WalkSpeed=WalkSpeed,JumpPower=JumpPower,AutoBhop=AutoBhop,AutoHit=AutoHit,NoClip=NoClip,ESP=ESP,Hitbox=Hitbox})
end)

-- Loop
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum=LocalPlayer.Character.Humanoid
        hum.WalkSpeed=WalkSpeed
        hum.JumpPower=JumpPower
    end
    if AutoBhop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum=LocalPlayer.Character.Humanoid
        if hum.FloorMaterial~=Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
    if AutoHit then
        local tool=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end
    if NoClip and LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)
