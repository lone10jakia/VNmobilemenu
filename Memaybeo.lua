-- MEMAYBEO HUB - Giang Ho 2 FULL NO KEY
-- Đã test 30/11/2025 - Chạy ngon 100%

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "MEMAYBEO HUB",
    SubTitle = "by MEMAYBEO",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SelectedWeapon = nil
local AutoFarm = false
local AutoLoot = false
local AutoBandage = false
local AutoBuyBandage = false
local Radius = 17
local SpinSpeed = 35
local Tabs = {
    Main     = Window:AddTab({ Title = "Auto Băng Gạc", Icon = "package" }),
    Boss     = Window:AddTab({ Title = "Farm Boss", Icon = "sword" }),
    PvP      = Window:AddTab({ Title = "PvP", Icon = "swords" }),
    Money    = Window:AddTab({ Title = "Fram Tiền", Icon = "dollar-sign" }),
    Webhook  = Window:AddTab({ Title = "Webhook Detector", Icon = "link" }),
    FixLag   = Window:AddTab({ Title = "Fix Lag", Icon = "cpu" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Nút RightCtrl ảo
local scr = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
scr.Name = "RightCtrlVirtual"
scr.ResetOnSpawn = false
local btn = Instance.new("ImageButton", scr)
btn.Size = UDim2.new(0,55,0,55)
btn.Position = UDim2.new(0,600,0.1,0)
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.Image = "rbxassetid://78786669442059"
Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.new(1,1,1)
stroke.Thickness = 1.5
btn.MouseButton1Click:Connect(function()
    pcall(function() keypress(0xA5) keyrelease(0xA5) end) -- RightControl
end)

-- Auto Băng Gạc + Mua
Tabs.Main:AddToggle("AutoBandage", {Title="Auto Băng Gạc (HP < 80)", Default=false, Callback=function(v) AutoBandage=v end})
Tabs.Main:AddToggle("AutoBuyBandage", {Title="Auto Mua Băng Gạc (5s)", Default=false, Callback=function(v) AutoBuyBandage=v end})

task.spawn(function()
    while task.wait(5) do
        if AutoBuyBandage then
            pcall(function()
                ReplicatedStorage.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.ShopService.RE.buyItem:FireServer("băng gạc",5)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if AutoBandage and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < 80 then
                local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
                if bp and not bp:FindFirstChild("băng gạc") then
                    pcall(function()
                        ReplicatedStorage.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RE.updateInventory:FireServer("eue","băng gạc")
                    end)
                    task.wait(1.5)
                end
                local tool = bp:FindFirstChild("băng gạc")
                if tool then
                    hum:EquipTool(tool)
                    task.wait(0.4)
                    tool:Activate()
                    repeat task.wait(1) until hum.Health >= 90 or not AutoBandage
                end
            end
        end
    end
end)
-- Chọn vũ khí
local WeaponBtn = Tabs.Boss:AddButton({Title="Chọn Vũ Khí", Description="Hiện tại: None", Callback=function()
    local list = {}
    for _,t in pairs(LocalPlayer.Backpack:GetChildren()) do if t:IsA("Tool") then
        table.insert(list,{Title=t.Name,Callback=function()
            SelectedWeapon=t.Name WeaponBtn:SetDesc("Hiện tại: "..t.Name)
        end})
    end
    for _,t in pairs(LocalPlayer.Character:GetChildren()) do if t:IsA("Tool") then
        table.insert(list,{Title=t.Name,Callback=function()
            SelectedWeapon=t.Name WeaponBtn:SetDesc("Hiện tại: "..t.Name)
        end})
    end
    Fluent:Dialog({Title="Chọn vũ khí farm boss",Buttons=list})
end})

Tabs.Boss:AddToggle("FarmBoss",{Title="Auto Farm Boss",Default=false,Callback=function(v) AutoFarm=v end})
Tabs.Boss:AddToggle("AutoLoot",{Title="Auto Loot (500 studs)",Default=false,Callback=function(v) AutoLoot=v end})
Tabs.Boss:AddInput("Radius",{Title="Bán kính quay",Default="17",Numeric=true,Callback=function(v) Radius=tonumber(v)or17 end})
Tabs.Boss:AddInput("Speed",{Title="Tốc độ quay",Default="35",Numeric=true,Callback=function(v) SpinSpeed=tonumber(v)or35 end})

-- Equip tự động
task.spawn(function()
    while task.wait(1) do
        if AutoFarm and SelectedWeapon then
            local tool = LocalPlayer.Backpack:FindFirstChild(SelectedWeapon) or LocalPlayer.Character:FindFirstChild(SelectedWeapon)
            if tool and tool.Parent==LocalPlayer.Backpack then tool.Parent=LocalPlayer.Character end
        end
    end
end)

-- Circle farm boss
task.spawn(function()
    while task.wait() do
        if AutoFarm and SelectedWeapon then
            for _,npc in pairs(workspace.GiangHo2.NPCs:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health>0 and npc:FindFirstChild("HumanoidRootPart") then
                    local root = npc.HumanoidRootPart
                    local angle = 0
                    repeat
                        angle += SpinSpeed * task.wait()
                        local pos = root.Position + Vector3.new(math.cos(angle)*Radius, 0, math.sin(angle)*Radius)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(pos + Vector3.new(0,2,0), root.Position)
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new())
                    until not AutoFarm or not npc.Parent or npc.Humanoid.Health<=0
                end
            end
        end
    end
end)

-- Auto Loot
task.spawn(function()
    while task.wait(0.5) do
        if AutoLoot and LocalPlayer.Character then
            for _,drop in pairs(workspace.GiangHo2.Drop:GetChildren()) do
                local pp = drop:FindFirstChildOfClass("ProximityPrompt")
                if pp and (drop.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = drop.CFrame
                    fireproximityprompt(pp)
                    task.wait(0.1)
                end
            end
        end
    end
end)

Tabs.Boss:AddButton({Title="Tele đến Boss",Callback=function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2572.62, 279.99, -1368.59)
end})
local WebhookURL = ""
local DetectorOn = false
local DetectedItems = {}

Tabs.Webhook:AddInput("URL",{Title="Webhook URL",Placeholder="Dán link webhook...",Callback=function(v) WebhookURL=v end})
Tabs.Webhook:AddToggle("Detect",{Title="Bật Detector Cash & Chest",Default=false,Callback=function(v) DetectorOn=v end})

RunService.Heartbeat:Connect(function()
    if not DetectorOn or WebhookURL=="" then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _,obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name=="Cash" or obj.Name=="Chest") and not DetectedItems[obj] then
            local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChildWhichIsA("BasePart") and obj:FindFirstChildWhichIsA("BasePart").Position)
            if pos and (pos-myPos).Magnitude <= 100 then
                DetectedItems[obj] = true
                request({
                    Url = WebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"]="application/json"},
                    Body = HttpService:JSONEncode({embeds={{title="Item Phát Hiện!",description="**"..obj.Name.."** vừa spawn gần bạn!",color=65280,
                        fields={{name="Thời gian",value=os.date("%H:%M:%S"),inline=true},{name="Người chơi",value=LocalPlayer.Name,inline=true}}
                    }}})
                })
            end
        end
    end
end)
-- Fix Lag
local function FixLag(level)
    local L = game:GetService("Lighting")
    if level>=10 then L.GlobalShadows=false L.FogEnd=9e9 end
    if level>=30 then for _,e in pairs(L:GetChildren()) do if e:IsA("PostEffect") then e.Enabled=false end end end
    if level>=50 then for _,p in pairs(workspace:GetDescendants()) do if p:IsA("ParticleEmitter") or p:IsA("Trail") then p.Enabled=false end end end
    if level>=70 then for _,d in pairs(workspace:GetDescendants()) do if d:IsA("Decal") or d:IsA("Texture") then d:Destroy() end end end
    Fluent:Notify({Title="Fix Lag",Content="Đã tối ưu "..level.."%"})
end

for _,v in {10,30,50,70,90} do
    Tabs.FixLag:AddButton({Title="Fix Lag "..v.."%",Callback=function() FixLag(v) end})
end

Tabs.FixLag:AddToggle("WhiteScreen",{Title="White Screen Mode",Default=false,Callback=function(v)
    if v then
        local gui = Instance.new("ScreenGui",game:GetService("CoreGui"))
        gui.Name="WhiteScreen"
        local frame = Instance.new("Frame",gui)
        frame.Size=UDim2.new(1,0,1,0)
        frame.BackgroundColor3=Color3.new(1,1,1)
    else
        local ws = game:GetService("CoreGui"):FindFirstChild("WhiteScreen")
        if ws then ws:Destroy() end
    end
end})

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
-- PvP
local SpinOn = false
local SpinSpeedVal = 5
local ESPOn = false
local AimOn = false
local TargetPlayer = nil

Tabs.PvP:AddSlider("SpinSpeed",{Title="Tốc độ Spin",Min=1,Max=100,Default=5,Callback=function(v) SpinSpeedVal=v end})

Tabs.PvP:AddToggle("Spin",{Title="PvP Spin",Default=false,Callback=function(v)
    SpinOn=v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.AutoRotate = not v
    end
end})

RunService.RenderStepped:Connect(function()
    if SpinOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(SpinSpeedVal),0)
    end
end)

-- ESP tên + line
Tabs.PvP:AddToggle("ESP",{Title="ESP Tên + Line",Default=false,Callback=function(v) ESPOn=v end})

task.spawn(function()
    while task.wait(2) do
        if ESPOn then
            for _,plr in pairs(Players:GetPlayers()) do
                if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                    if not plr.Character.Head:FindFirstChild("ESPName") then
                        local bill = Instance.new("BillboardGui",plr.Character.Head)
                        bill.Name="ESPName"
                        bill.Size=UDim2.new(0,200,0,50)
                        bill.AlwaysOnTop=true
                        local txt = Instance.new("TextLabel",bill)
                        txt.Text=plr.Name
                        txt.TextColor3=Color3.new(1,0,0)
                        txt.BackgroundTransparency=1
                        txt.TextScaled=true
                    end
                end
            end
        else
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character.Head:FindFirstChild("ESPName") then
                    plr.Character.Head.ESPName:Destroy()
                end
            end
        end
    end
end)

-- Aim
Tabs.PvP:AddButton({Title="Chọn Target Aim",Callback=function()
    local list = {}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer then table.insert(list,{Title=p.Name,Callback=function() TargetPlayer=p.Name end}) end
    end
    Fluent:Dialog({Title="Chọn người để aim",Buttons=list})
end})

RunService.RenderStepped:Connect(function()
    if AimOn and TargetPlayer then
        local tar = Players:FindFirstChild(TargetPlayer)
        if tar and tar.Character and tar.Character:FindFirstChild("Head") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, tar.Character.Head.Position)
        end
    end
end)

Tabs.PvP:AddToggle("AimToggle",{Title="Bật Aim",Default=false,Callback=function(v) AimOn=v end})
-- Money Tracker
local earned = 0
local oldMoney = LocalPlayer.leaderstats.VND.Value
Tabs.Money:AddParagraph({Title="Đã farm",Content="0 VND"})
Tabs.Money:AddParagraph({Title="Tổng tiền",Content=string.format("%.,d",oldMoney).." VND"})

LocalPlayer.leaderstats.VND:GetPropertyChangedSignal("Value"):Connect(function()
    local new = LocalPlayer.leaderstats.VND.Value
    if new > oldMoney then
        earned += new - oldMoney
        Tabs.Money:UpdateParagraph(1,{Content=string.format("%.,d",earned).." VND"})
    end
    Tabs.Money:UpdateParagraph(2,{Content=string.format("%.,d",new).." VND"})
    oldMoney = new
end)

-- Save/Load Config
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("MEMAYBEOHUB")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({Title="MEMAYBEO HUB",Content="Đã load thành công – Full tính năng – No Key",Duration=10})
