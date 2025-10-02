--== MEMAYBEO HUB v3 (FixLag gộp 1 nút + Respawn Safe + HitBox + Auto Attack) ==--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0,40,0,40)
ToggleButton.Position = UDim2.new(1,-50,0,10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
ToggleButton.Text = "👑"
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.fromRGB(0,255,127)
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui
Instance.new("UICorner",ToggleButton).CornerRadius = UDim.new(1,0)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,130,0,240)
MainFrame.Position = UDim2.new(1,150,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,20)
Title.BackgroundTransparency = 1
Title.Text = "MEMAYBEO HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0,255,127)

--== Button maker
local function makeButton(posY,text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,110,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = text.." OFF"
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = MainFrame
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,5)
    return btn
end

local SpinButton      = makeButton(25,"🔄 Xoay:")
local SpeedButton     = makeButton(60,"👟 Tăng tốc:")
local HealthButton    = makeButton(95,"❤️ Thanh máu:")
local HitBoxButton    = makeButton(130,"📦 HitBox:")
local AutoAttackButton= makeButton(165,"⚔️ Auto Đánh:")
local FixLagButton    = makeButton(200,"⚡ FixLag:")

--== Variables
local spinActive,speedBoost,healthVisible,hitBoxActive,autoAttack,fixLag =
false,false,false,false,false,false
local spinSpeed = 2500
local normalSpeed, boostedSpeed = 16, 32
local hitBoxSize = Vector3.new(7,7,7)

local function getHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

--== Spin
SpinButton.MouseButton1Click:Connect(function()
    spinActive = not spinActive
    SpinButton.Text = "🔄 Xoay: "..(spinActive and "ON" or "OFF")
end)
RunService.RenderStepped:Connect(function(dt)
    if spinActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(spinSpeed * dt), 0)
    end
end)

--== Speed
local function applySpeed()
    local h = getHumanoid()
    if h then h.WalkSpeed = speedBoost and boostedSpeed or normalSpeed end
end
SpeedButton.MouseButton1Click:Connect(function()
    speedBoost = not speedBoost
    SpeedButton.Text = "👟 Tăng tốc: "..(speedBoost and "ON" or "OFF")
    applySpeed()
end)

task.spawn(function()
    while true do
        if speedBoost then applySpeed() end
        task.wait(0.5)
    end
end)

--== Health Bar
local function addHealthBar(char)
    if not healthVisible then return end
    local head, hum = char:FindFirstChild("Head"), char:FindFirstChild("Humanoid")
    if not (head and hum) or head:FindFirstChild("HealthDisplay") then return end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name, Billboard.Size, Billboard.StudsOffset, Billboard.AlwaysOnTop =
    "HealthDisplay", UDim2.new(4,0,1,0), Vector3.new(0,3,0), true
    Billboard.Adornee, Billboard.Parent = head, head

    local barBack = Instance.new("Frame")
    barBack.Size = UDim2.new(1,0,0.4,0)
    barBack.Position = UDim2.new(0,0,0.3,0)
    barBack.BackgroundColor3 = Color3.fromRGB(50,50,50)
    barBack.BorderSizePixel = 0
    barBack.Parent = Billboard

    local bar = Instance.new("Frame")
    bar.Name, bar.Size, bar.BackgroundColor3, bar.BorderSizePixel =
    "Bar", UDim2.new(1,0,1,0), Color3.fromRGB(0,255,0), 0
    bar.Parent = barBack

    local hpText = Instance.new("TextLabel")
    hpText.Size, hpText.BackgroundTransparency, hpText.Font, hpText.TextScaled, hpText.TextColor3 =
    UDim2.new(1,0,1,0), 1, Enum.Font.GothamBold, true, Color3.fromRGB(255,255,255)
    hpText.Text = math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
    hpText.Parent = barBack

    hum.HealthChanged:Connect(function(h)
        local ratio = math.max(h / hum.MaxHealth, 0)
        bar.Size = UDim2.new(ratio,0,1,0)
        bar.BackgroundColor3 = Color3.fromRGB(255*(1-ratio), 255*ratio, 0)
        hpText.Text = math.floor(h).." / "..math.floor(hum.MaxHealth)
    end)
end
HealthButton.MouseButton1Click:Connect(function()
    healthVisible = not healthVisible
    HealthButton.Text = "❤️ Thanh máu: "..(healthVisible and "ON" or "OFF")
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then addHealthBar(plr.Character) end
    end
end)

--== HitBox (liên tục)
local function setHitBox(char,size)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = size
        hrp.Transparency = 0.7
        hrp.BrickColor = BrickColor.new("Really red")
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
    end
end
HitBoxButton.MouseButton1Click:Connect(function()
    hitBoxActive = not hitBoxActive
    HitBoxButton.Text = "📦 HitBox: "..(hitBoxActive and "ON" or "OFF")
end)
task.spawn(function()
    while true do
        if hitBoxActive then
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr~=LocalPlayer and plr.Character then
                    setHitBox(plr.Character,hitBoxSize)
                end
            end
        end
        task.wait(0.3)
    end
end)

--== Auto Attack
AutoAttackButton.MouseButton1Click:Connect(function()
    autoAttack = not autoAttack
    AutoAttackButton.Text = "⚔️ Auto Đánh: "..(autoAttack and "ON" or "OFF")
end)
task.spawn(function()
    while true do
        if autoAttack and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
        task.wait(0.05)
    end
end)

--== FixLag (1 nút gộp tất cả)
local function doFixLag()
    -- Xoá hiệu ứng + decal
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion")
        or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 1 end)
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        end
    end
    -- Tắt ánh sáng phụ
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("Atmosphere") then
            pcall(function() v.Enabled = false end)
        end
    end
    -- Giảm bóng
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e6
    Lighting.Brightness = 1
end
FixLagButton.MouseButton1Click:Connect(function()
    fixLag = not fixLag
    FixLagButton.Text = "⚡ FixLag: "..(fixLag and "ON" or "OFF")
    if fixLag then
        task.spawn(function()
            while fixLag do
                doFixLag()
                task.wait(3)
            end
        end)
    end
end)

--== Respawn Safe
local function reapply()
    if speedBoost then applySpeed() end
    if healthVisible then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character then addHealthBar(plr.Character) end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    reapply()
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if hitBoxActive then setHitBox(plr.Character,hitBoxSize) end
        if healthVisible then addHealthBar(plr.Character) end
    end)
end)

--== Toggle Menu (hiệu ứng trượt)
local menuVisible = false
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        MainFrame.Visible = true
        TweenService:Create(MainFrame,TweenInfo.new(0.3),
        {Position=UDim2.new(1,-150,0.3,0)}):Play()
    else
        local t = TweenService:Create(MainFrame,TweenInfo.new(0.3),
        {Position=UDim2.new(1,150,0.3,0)})
        t:Play()
        t.Completed:Connect(function() MainFrame.Visible=false end)
    end
end)
