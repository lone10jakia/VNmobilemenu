-- // MEMAYBEO HUB FULL + HUD BOSS + KEY + FIXLAG \\ --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

-- ===== KEY SYSTEM =====
local keyList = {
    ["MEMAYBEOKEY1H"] = 3600, -- 1 giờ
    ["MEMAYBEOKEY10T"] = 100000, -- 1 tuần
}
local usedKeys = {}
local remainingTime = 0
local hubLoaded = false

-- ===== GUI NHẬP KEY =====
local playerGui = lp:WaitForChild("PlayerGui")
local keyGui = Instance.new("ScreenGui", playerGui)
keyGui.Name = "KeyGui"

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local txtLabel = Instance.new("TextLabel", frame)
txtLabel.Size = UDim2.new(1,0,0,30)
txtLabel.Position = UDim2.new(0,0,0,10)
txtLabel.Text = "Nhập Key để sử dụng MEMAYBEO HUB"
txtLabel.TextColor3 = Color3.fromRGB(255,255,255)
txtLabel.BackgroundTransparency = 1
txtLabel.TextSize = 14

local txtBox = Instance.new("TextBox", frame)
txtBox.Size = UDim2.new(0,200,0,30)
txtBox.Position = UDim2.new(0,50,0,50)
txtBox.ClearTextOnFocus = true
txtBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
txtBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", txtBox).CornerRadius = UDim.new(0,6)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0,100,0,30)
btn.Position = UDim2.new(0.5,-50,0,100)
btn.Text = "Xác nhận"
btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

-- Xác nhận key
btn.MouseButton1Click:Connect(function()
    local input = txtBox.Text
    if keyList[input] then
        if usedKeys[input] then
            txtBox.Text = ""
            txtBox.PlaceholderText = "Key đã sử dụng!"
        else
            remainingTime = keyList[input]
            hubLoaded = true
            usedKeys[input] = true
            keyGui:Destroy()
        end
    else
        txtBox.Text = ""
        txtBox.PlaceholderText = "Sai key!"
    end
end)

repeat task.wait() until hubLoaded

-- ===== CHARACTER =====
local hrp, hum
local function getChar()
    local char = lp.Character or lp.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
    return char
end
getChar()
lp.CharacterAdded:Connect(function() task.wait(1) getChar() end)

-- ===== GUI HUB =====
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "FarmGUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,300,0,300)
Main.Position = UDim2.new(0.05,0,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(40,40,40)
Main.Active, Main.Draggable = true,true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", Main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "MEMAYBEO HUB"
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Rainbow title
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = (hue+0.01)%1
        title.TextColor3 = Color3.fromHSV(hue,1,1)
    end
end)

-- Hiển thị thời gian key
local keyTimeLabel = Instance.new("TextLabel", Main)
keyTimeLabel.Size = UDim2.new(1,-20,0,20)
keyTimeLabel.Position = UDim2.new(0,10,0,35)
keyTimeLabel.BackgroundTransparency = 1
keyTimeLabel.TextSize = 14

-- Rainbow cho keyTimeLabel
task.spawn(function()
    local hue = 0
    while hubLoaded do
        if remainingTime > 0 then
            hue = (hue+0.01)%1
            keyTimeLabel.TextColor3 = Color3.fromHSV(hue,1,1)
            keyTimeLabel.Text = "Thời gian key: "..math.floor(remainingTime).." giây"
            remainingTime = remainingTime -1
        else
            keyTimeLabel.Text = "Key đã hết hạn!"
            hubLoaded = false
        end
        task.wait(1)
    end
end)

-- ===== BUTTON & BOX TEMPLATES =====
local function makeButton(text,posY)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0,100,0,30)
    b.Position = UDim2.new(0,10,0,posY)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    task.spawn(function()
        local hue=0
        while task.wait(0.05) do
            hue=(hue+0.01)%1
            b.TextColor3=Color3.fromHSV(hue,1,1)
        end
    end)
    return b
end

local function makeBox(name,default,posY)
    local l = Instance.new("TextLabel", Main)
    l.Text=name
    l.Size=UDim2.new(0,120,0,20)
    l.Position=UDim2.new(0,10,0,posY)
    l.TextColor3=Color3.new(1,1,1)
    l.BackgroundTransparency=1
    l.TextSize=14
    l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextBox", Main)
    b.Size=UDim2.new(0,80,0,20)
    b.Position=UDim2.new(0,150,0,posY)
    b.Text=tostring(default)
    b.BackgroundColor3=Color3.fromRGB(50,50,50)
    b.TextColor3=Color3.new(1,1,1)
    b.ClearTextOnFocus=false
    b.TextSize=14
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    return b
end

-- Buttons & Boxes
local btnFarm = makeButton("Farm ON/OFF",70)
local btnHop = makeButton("Đổi Server ít người",110)
local boxOrbitDist = makeBox("Khoảng cách Orbit",10,150)
local boxOrbitSpd = makeBox("Tốc độ Orbit",15,180)
local btnFixLag = makeButton("FixLag ON/OFF",240)
local fixLagEnabled = false

btnFixLag.MouseButton1Click:Connect(function()
    fixLagEnabled = not fixLagEnabled
    btnFixLag.BackgroundColor3 = fixLagEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
    if fixLagEnabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion") or obj:IsA("Smoke") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            end
        end
    end
end)

-- ===== FARM LOGIC =====
local farming = false
btnFarm.MouseButton1Click:Connect(function()
    farming = not farming
    btnFarm.BackgroundColor3 = farming and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
end)

local lastAttack=0
local attackInterval=0.3
local orbitAngle=0
local function performAttack()
    if os.clock()-lastAttack<attackInterval then return end
    lastAttack=os.clock()
    local tool=lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool and lp.Backpack then
        tool=lp.Backpack:FindFirstChildOfClass("Tool")
        if tool then tool.Parent=lp.Character end
    end
    if tool then pcall(function() tool:Activate() end) end
end

local function getNearestNPC2()
    local nearest, dist, hrp2 = nil, math.huge, nil
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m.Name=="NPC2" then
            local h = m:FindFirstChildOfClass("Humanoid")
            local p = m:FindFirstChild("HumanoidRootPart")
            if h and p and h.Health>0 then
                local d=(p.Position-hrp.Position).Magnitude
                if d<dist then nearest,dist,hrp2=m,d,p end
            end
        end
    end
    return nearest,hrp2,dist
end

RunService.Heartbeat:Connect(function(dt)
    if farming and hrp and hum and hum.Health>0 then
        local npc,npcHRP,dist=getNearestNPC2()
        if npc and npcHRP then
            local orbitDist = tonumber(boxOrbitDist.Text) or 10
            local orbitSpeed = tonumber(boxOrbitSpd.Text) or 15
            orbitAngle=orbitAngle+dt*orbitSpeed
            local offset=Vector3.new(math.cos(orbitAngle),0,math.sin(orbitAngle))*orbitDist
            hrp.CFrame=CFrame.new(npcHRP.Position+offset,npcHRP.Position)
            performAttack()
        end
    end
end)

-- ===== HUD NPC2 =====
local npcHUD = Instance.new("TextLabel", Main)
npcHUD.Size = UDim2.new(1,-20,0,25)
npcHUD.Position = UDim2.new(0,10,0,210)
npcHUD.Text = "NPC2: ??? / ???"
npcHUD.BackgroundTransparency = 1
npcHUD.Font = Enum.Font.SourceSansBold
npcHUD.TextSize = 14

task.spawn(function()
    local hue=0
    while true do
        hue=(hue+0.01)%1
        npcHUD.TextColor3=Color3.fromHSV(hue,1,1)
        task.wait(0.05)
    end
end)

RunService.Heartbeat:Connect(function()
    local npc,npcHRP,dist=getNearestNPC2()
    if npc and npc:FindFirstChildOfClass("Humanoid") then
        local h=npc:FindFirstChildOfClass("Humanoid")
        npcHUD.Text=string.format("NPC2 HP: %d / %d",h.Health,h.MaxHealth)
    else
        npcHUD.Text="NPC2: Không thấy"
    end
end)

-- ===== SERVER HOP =====
btnHop.MouseButton1Click:Connect(function()
    local gameId=game.PlaceId
    local cursor=""
    local smallest,serverId=math.huge,nil
    local HttpService = game:GetService("HttpService")
    repeat
        local url="https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor~="" and "&cursor="..cursor or "")
        local data=HttpService:JSONDecode(game:HttpGet(url))
        for _,s in ipairs(data.data) do
            if s.playing<smallest and s.id~=game.JobId then
                smallest=s.playing
                serverId=s.id
            end
        end
        cursor=data.nextPageCursor or ""
    until cursor=="" or serverId
    if serverId then
        TeleportService:TeleportToPlaceInstance(gameId,serverId,lp)
    else
        warn("Không tìm thấy server khác!")
    end
end)
