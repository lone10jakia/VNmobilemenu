-- Farm Boss NPC2: Orbit + Aim + Auto Attack + GUI + Server Hop

-- Dùng trong KRNL

 

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local HttpService = game:GetService("HttpService")

local TeleportService = game:GetService("TeleportService")

 

local lp = Players.LocalPlayer

local hrp, hum

 

local function getChar()

    local char = lp.Character or lp.CharacterAdded:Wait()

    hrp = char:WaitForChild("HumanoidRootPart")

    hum = char:WaitForChild("Humanoid")

    return char

end

getChar()

 

lp.CharacterAdded:Connect(function()

    task.wait(1)

    getChar()

end)

 

-- Tìm NPC2 gần nhất

local function getNearestNPC2()

    local nearest, dist, hrp2 = nil, math.huge, nil

    for _, m in ipairs(workspace:GetDescendants()) do

        if m:IsA("Model") and m.Name == "NPC2" then

            local h = m:FindFirstChildOfClass("Humanoid")

            local p = m:FindFirstChild("HumanoidRootPart")

            if h and p and h.Health > 0 then

                local d = (p.Position - hrp.Position).Magnitude

                if d < dist then

                    nearest, dist, hrp2 = m, d, p

                end

            end

        end

    end

    return nearest, hrp2, dist

end

 

-- Auto Attack

local lastAttack = 0

local attackInterval = 0.3 -- mặc định 0.3s

local function performAttack()

    if os.clock() - lastAttack < attackInterval then return end

    lastAttack = os.clock()

    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")

    if not tool and lp.Backpack then

        tool = lp.Backpack:FindFirstChildOfClass("Tool")

        if tool then tool.Parent = lp.Character end

    end

    if tool then pcall(function() tool:Activate() end) end

end

 

-- ===== GUI =====

local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)

ScreenGui.Name = "FarmGUI"

 

local Main = Instance.new("Frame", ScreenGui)

Main.Size = UDim2.new(0, 250, 0, 180)

Main.Position = UDim2.new(0.05, 0, 0.3, 0)

Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

Main.Active, Main.Draggable = true, true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

 

local title = Instance.new("TextLabel", Main)

title.Size = UDim2.new(1, 0, 0, 30)

title.Text = "Farm Boss GUI"

title.TextColor3 = Color3.new(1,1,1)

title.BackgroundTransparency = 1

title.Font = Enum.Font.SourceSansBold

title.TextSize = 18

 

-- Button template

local function makeButton(text, posY)

    local b = Instance.new("TextButton", Main)

    b.Size = UDim2.new(0, 100, 0, 30)

    b.Position = UDim2.new(0, 10, 0, posY)

    b.Text = text

    b.TextColor3 = Color3.new(1,1,1)

    b.BackgroundColor3 = Color3.fromRGB(60,60,60)

    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    return b

end

 

-- Box template

local function makeBox(name, default, posY)

    local l = Instance.new("TextLabel", Main)

    l.Text = name

    l.Size = UDim2.new(0, 120, 0, 20)

    l.Position = UDim2.new(0, 10, 0, posY)

    l.TextColor3 = Color3.new(1,1,1)

    l.BackgroundTransparency = 1

    l.TextSize = 14

    l.TextXAlignment = Enum.TextXAlignment.Left

 

    local b = Instance.new("TextBox", Main)

    b.Size = UDim2.new(0, 80, 0, 20)

    b.Position = UDim2.new(0, 150, 0, posY)

    b.Text = tostring(default)

    b.BackgroundColor3 = Color3.fromRGB(50,50,50)

    b.TextColor3 = Color3.new(1,1,1)

    b.ClearTextOnFocus = false

    b.TextSize = 14

    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)

    return b

end

 

-- Buttons & Boxes

local btnFarm = makeButton("Farm ON/OFF", 40)

local btnHop = makeButton("Đổi Server ít người", 80)

 

local boxOrbitDist = makeBox("Khoảng cách Orbit", 10, 120) -- mặc định 10 studs

local boxOrbitSpd = makeBox("Tốc độ Orbit", 15, 150) -- mặc định 15

 

-- ===== Logic Farm =====

local farming = false

btnFarm.MouseButton1Click:Connect(function()

    farming = not farming

    btnFarm.BackgroundColor3 = farming and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)

end)

 

local orbitAngle = 0

RunService.Heartbeat:Connect(function(dt)

    if not farming or not hrp or not hum or hum.Health <= 0 then return end

    local npc, npcHRP, dist = getNearestNPC2()

    if not npc or not npcHRP then return end

 

    -- đọc giá trị GUI

    local orbitDist = tonumber(boxOrbitDist.Text) or 10

    local orbitSpeed = tonumber(boxOrbitSpd.Text) or 15

 

    -- Aim + Orbit

    orbitAngle = orbitAngle + dt * orbitSpeed

    local offset = Vector3.new(math.cos(orbitAngle), 0, math.sin(orbitAngle)) * orbitDist

    local targetPos = npcHRP.Position + offset

    hrp.CFrame = CFrame.new(targetPos, npcHRP.Position)

 

    -- Auto Attack

    performAttack()

end)

 

-- ===== Server Hop =====

local function serverHop()

    local gameId = game.PlaceId

    local servers = {}

    local cursor = ""

    local smallest, serverId = math.huge, nil

 

    repeat

        local url = "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")

        local data = HttpService:JSONDecode(game:HttpGet(url))

        for _, s in ipairs(data.data) do

            if s.playing < smallest and s.id ~= game.JobId then

                smallest = s.playing

                serverId = s.id

            end

        end

        cursor = data.nextPageCursor or ""

    until cursor == "" or serverId

 

    if serverId then

        TeleportService:TeleportToPlaceInstance(gameId, serverId, lp)

    else

        warn("Không tìm thấy server khác!")

    end

end

 

btnHop.MouseButton1Click:Connect(function()

    serverHop()

end)

-- ===== HUD Hiển Thị Máu NPC2 =====

local npcHUD = Instance.new("TextLabel", Main)

npcHUD.Size = UDim2.new(1, -20, 0, 25)

npcHUD.Position = UDim2.new(0, 10, 0, 150)

npcHUD.Text = "NPC2: ??? / ???"

npcHUD.TextColor3 = Color3.fromRGB(255, 50, 50) -- chữ đỏ

npcHUD.BackgroundTransparency = 1

npcHUD.Font = Enum.Font.SourceSansBold

npcHUD.TextSize = 14 -- chữ bé

 

-- Update HUD theo máu NPC2

RunService.Heartbeat:Connect(function()

    local npc, npcHRP, dist = getNearestNPC2()

    if npc and npc:FindFirstChildOfClass("Humanoid") then

        local h = npc:FindFirstChildOfClass("Humanoid")

        npcHUD.Text = string.format("NPC2 HP: %d / %d", h.Health, h.MaxHealth)

    else

        npcHUD.Text = "NPC2: Không thấy"

    end

end)
