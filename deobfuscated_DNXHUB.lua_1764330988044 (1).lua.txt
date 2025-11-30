-- filename: 
-- version: lua51
-- line: [0, 0] id: 0
local r0_0 = game:GetService("RunService")
local r1_0 = "GH2HealthBillboard"
local function r2_0()
  -- line: [0, 0] id: 9
  local r0_9 = workspace:FindFirstChild("GiangHo2")
  if not r0_9 then
    return nil
  end
  local r1_9 = r0_9:FindFirstChild("NPCs")
  if not r1_9 then
    return nil
  end
  return r1_9:FindFirstChild("NPC2")
end
local function r3_0(r0_56)
  -- line: [0, 0] id: 56
  if not r0_56 then
    return nil
  end
  local r1_56 = r0_56:FindFirstChild(r1_0)
  if not r1_56 then
    r1_56 = Instance.new("BillboardGui")
    r1_56.Name = r1_0
    r1_56.Size = UDim2.new(0, 100, 0, 30)
    r1_56.StudsOffset = Vector3.new(0, 2.7, 0)
    r1_56.AlwaysOnTop = true
    r1_56.Adornee = r0_56
    r1_56.Parent = r0_56
    local r2_56 = Instance.new("TextLabel")
    r2_56.Name = "HealthLabel"
    r2_56.Size = UDim2.new(1, 0, 1, 0)
    r2_56.BackgroundTransparency = 1
    r2_56.TextColor3 = Color3.fromRGB(255, 255, 255)
    r2_56.TextStrokeTransparency = 0.2
    r2_56.Font = Enum.Font.GothamBold
    r2_56.TextScaled = true
    r2_56.Text = ""
    r2_56.Parent = r1_56
    local r3_56 = Instance.new("Frame")
    r3_56.Name = "HealthBarBackground"
    r3_56.Size = UDim2.new(1, 0, 0.2, 0)
    r3_56.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    r3_56.BorderSizePixel = 0
    r3_56.Parent = r1_56
    local r4_56 = Instance.new("Frame")
    r4_56.Name = "HealthBar"
    r4_56.Size = UDim2.new(1, 0, 1, 0)
    r4_56.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    r4_56.BorderSizePixel = 0
    r4_56.Parent = r3_56
  end
  return r1_56
end
local function r4_0(r0_70)
  -- line: [0, 0] id: 70
  if r0_70 then
    local r1_70 = r0_70:FindFirstChild(r1_0)
    if r1_70 then
      r1_70:Destroy()
    end
  end
end
local r5_0 = nil
r0_0.Heartbeat:Connect(function()
  -- line: [0, 0] id: 12
  local r0_12 = r2_0()
  if r0_12 and r0_12:FindFirstChild("Humanoid") and r0_12:FindFirstChild("Head") then
    local r1_12 = r0_12.Humanoid
    local r2_12 = r0_12.Head
    local r3_12 = r3_0(r2_12)
    r5_0 = r2_12
    if r1_12.Health > 0 then
      r3_12.Enabled = true
      local r4_12 = r3_12:FindFirstChild("HealthLabel")
      local r5_12 = r3_12:FindFirstChild("HealthBar")
      if r4_12 then
        r4_12.Text = string.format("%d/%d", math.floor(r1_12.Health), math.floor(r1_12.MaxHealth))
      end
      if r5_12 then
        r5_12.Size = UDim2.new(r1_12.Health / r1_12.MaxHealth, 0, 1, 0)
      end
    else
      r3_12.Enabled = false
    end
  elseif r5_0 then
    r4_0(r5_0)
    r5_0 = nil
  end
end)
local r8_0 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local r9_0 = Instance.new("ScreenGui")
r9_0.Name = "RightCtrlVirtual"
r9_0.ResetOnSpawn = false
r9_0.IgnoreGuiInset = true
r9_0.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
r9_0.Parent = r8_0
local r10_0 = Instance.new("ImageButton")
r10_0.Name = "RightCtrlButton"
r10_0.Size = UDim2.new(0, 55, 0, 55)
r10_0.Position = UDim2.new(0, 600, 0.1, 0)
r10_0.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
r10_0.BorderSizePixel = 0
r10_0.Image = "rbxassetid://78786669442059"
r10_0.Parent = r9_0
local r11_0 = Instance.new("UICorner")
r11_0.CornerRadius = UDim.new(1, 0)
r11_0.Parent = r10_0
local r12_0 = Instance.new("UIStroke")
r12_0.Color = Color3.fromRGB(255, 255, 255)
r12_0.Thickness = 1.5
r12_0.Parent = r10_0
r10_0.MouseButton1Down:Connect(function()
  -- line: [0, 0] id: 18
  pcall(function()
    -- line: [0, 0] id: 19
    keypress(Enum.KeyCode.RightControl)
  end)
end)
local r13_0 = game:GetService("Players")
local r14_0 = game:GetService("ReplicatedStorage")
local r15_0 = game:GetService("TweenService")
local r16_0 = game:GetService("VirtualUser")
local r17_0 = game:GetService("RunService")
local r18_0 = r13_0.LocalPlayer
if not r18_0.Character then
  local r19_0 = r18_0.CharacterAdded:Wait()
end
local r20_0 = false
local r21_0 = false
local r22_0 = false
local r23_0 = false
local r24_0 = nil
local r25_0 = false
function EquipWeapon(r0_76)
  -- line: [0, 0] id: 76
  local r1_76 = r18_0.Backpack:FindFirstChild(r0_76)
  if r1_76 then
    r1_76.Parent = r18_0.Character
  end
end
function UnInventoryWeapon(r0_59)
  -- line: [0, 0] id: 59
  for r5_59, r6_59 in pairs(r18_0.PlayerGui.Inventory.MainFrame.List:GetChildren()) do
    if r6_59.Name == r0_59 then
      r6_59:Activate()
    end
  end
end
local r26_0 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local r27_0 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local r28_0 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local r29_0 = r26_0:CreateWindow({
  Title = "MEMAYBEO HUB",
  SubTitle = "By MEMAYBEO HUB",
  TabWidth = 160,
  Size = UDim2.fromOffset(500, 300),
  Acrylic = true,
  Theme = "Dark",
  MinimizeKey = Enum.KeyCode.LeftControl,
})
local r30_0 = {
  Main = r29_0:AddTab({
    Title = "Auto Băng Gạc",
    Icon = "package",
  }),
}
r30_0.Main:AddButton({
  Title = "Tắt Balo",
  Callback = function()
    -- line: [0, 0] id: 5
    local r0_5 = r8_0:FindFirstChild("Inventory")
    if r0_5 and r0_5:FindFirstChild("MainFrame") then
      r0_5.MainFrame.Visible = false
    end
  end,
})
r30_0.Main:AddButton({
  Title = "Bật Lại Balo",
  Callback = function()
    -- line: [0, 0] id: 61
    local r0_61 = r8_0:FindFirstChild("Inventory")
    if r0_61 and r0_61:FindFirstChild("MainFrame") then
      r0_61.MainFrame.Visible = true
    end
  end,
})
local r31_0 = false
local r32_0 = true
r30_0.Main:AddToggle("AutoBangGac", {
  Title = "Auto Băng Gạc (HP < 60)",
  Default = false,
  Callback = function(r0_58)
    -- line: [0, 0] id: 58
    r31_0 = r0_58
  end,
})
local function r33_0(r0_23)
  -- line: [0, 0] id: 23
  pcall(function()
    -- line: [0, 0] id: 24
    local r1_24 = game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit").Services.InventoryService.RE.updateInventory
    r1_24:FireServer("refresh")
    task.wait(1)
    r1_24:FireServer("eue", r0_23)
  end)
end
task.spawn(function()
  -- line: [0, 0] id: 17
  while task.wait(1) do
    local r0_17 = r31_0
    if r0_17 then
      r0_17 = r32_0
      if r0_17 then
        r0_17 = r18_0.Character
        local r1_17 = r0_17 and r0_17:FindFirstChildOfClass("Humanoid")
        local r2_17 = r18_0:FindFirstChildOfClass("Backpack")
        if r1_17 and r1_17.Health < 80 then
          r32_0 = false
          if r2_17 and not r2_17:FindFirstChild("băng gạc") then
            r33_0("băng gạc")
            task.wait(1.5)
          end
          local r3_17 = r2_17 and r2_17:FindFirstChild("băng gạc")
          if r3_17 then
            r1_17:EquipTool(r3_17)
            task.wait(0.3)
            r3_17:Activate()
          end
          while true do
            task.wait(1)
            if r1_17.Health <= 80 then
              local r4_17 = r31_0
              if not r4_17 then
                break
              end
            else
              break
            end
          end
          task.wait(2)
          r32_0 = true
        end
      end
    end
  end
end)
local r34_0 = false
r30_0.Main:AddToggle("AutoBuyBandage", {
  Title = "Auto Mua Băng Gạc (5s)",
  Default = false,
  Callback = function(r0_16)
    -- line: [0, 0] id: 16
    r34_0 = r0_16
  end,
})
task.spawn(function()
  -- line: [0, 0] id: 2
  while task.wait(5) do
    local r0_2 = r34_0
    if r0_2 then
      pcall(function()
        -- line: [0, 0] id: 3
        game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyItem"):FireServer(unpack({
          "băng gạc",
          5
        }))
      end)
    end
  end
end)
r30_0.framboss = r29_0:AddTab({
  Title = "Farm Boss",
  Icon = "sword",
})
local r35_0 = true
local r36_0 = r30_0.framboss:AddButton({
  Title = "Select Weapon",
  Description = "Weapon Hiện Tại : None",
  Callback = function()
    -- line: [0, 0] id: 20
    local r0_20 = {}
    for r4_20, r5_20 in pairs(r18_0.Backpack:GetChildren()) do
      table.insert(r0_20, {
        Title = r5_20.Name,
        Callback = function()
          -- line: [0, 0] id: 21
          r24_0 = r5_20.Name
          print("Vũ khí đã chọn: " .. r5_20.Name)
        end,
      })
      -- close: r4_20
    end
    for r4_20, r5_20 in pairs(r18_0.Character:GetChildren()) do
      if r5_20:IsA("Tool") then
        table.insert(r0_20, {
          Title = r5_20.Name,
          Callback = function()
            -- line: [0, 0] id: 22
            r24_0 = r5_20.Name
            print("Vũ khí đã chọn: " .. r5_20.Name)
          end,
        })
      end
      -- close: r4_20
    end
    r29_0:Dialog({
      Title = "Select Weapon",
      Content = "Chọn một vũ khí:",
      Buttons = r0_20,
    })
  end,
})
task.spawn(function()
  -- line: [0, 0] id: 39
  while task.wait() do
    local r0_39 = r24_0
    if r0_39 then
      r36_0:SetDesc("Weapon Hiện Tại : " .. r24_0)
    end
  end
end)
function EquipWeapon(r0_14)
  -- line: [0, 0] id: 14
  local r1_14 = r18_0.Backpack:FindFirstChild(r0_14)
  if r1_14 then
    r1_14.Parent = r18_0.Character
    print("�ã trang bị vũ khí: " .. r0_14)
    return true
  end
  return false
end
function RequestFromInventory(r0_73)
  -- line: [0, 0] id: 73
  r14_0:WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack({
    "eue",
    r0_73
  }))
end
task.spawn(function()
  -- line: [0, 0] id: 38
  while task.wait(1) do
    local r0_38 = r24_0
    if r0_38 then
      r0_38 = r35_0
      if r0_38 then
        r35_0 = false
        r0_38 = r18_0.Character:FindFirstChild(r24_0)
        if r0_38 then
          print("Vũ khí đã có trong nhân vật.")
        else
          r0_38 = r18_0.Backpack:FindFirstChild(r24_0)
          if r0_38 then
            EquipWeapon(r24_0)
          else
            RequestFromInventory(r24_0)
          end
        end
        task.wait(1)
        r0_38 = true
        r35_0 = r0_38
      end
    end
  end
end)
r30_0.framboss:AddToggle("AutoFarm", {
  Title = "Farm Boss",
  Default = false,
}):OnChanged(function(r0_42)
  -- line: [0, 0] id: 42
  r21_0 = r0_42
  if r0_42 then
    StartAutoFarm()
  end
end)
local r37_0 = false
r30_0.framboss:AddToggle("AutoLoot", {
  Title = "Auto Loot (Range 500)",
  Default = false,
}):OnChanged(function(r0_28)
  -- line: [0, 0] id: 28
  r37_0 = r0_28
  if r0_28 then
    StartAutoLoot()
  end
end)
function StartAutoLoot()
  -- line: [0, 0] id: 34
  task.spawn(function()
    -- line: [0, 0] id: 35
    while r37_0 do
      task.wait(0.5)
      local r0_35 = pairs
      for r3_35, r4_35 in r0_35(workspace.GiangHo2.Drop:GetChildren()) do
        local r5_35 = r4_35:FindFirstChild("ProximityPrompt") or r4_35:FindFirstChildOfClass("ProximityPrompt")
        if r5_35 and r18_0.Character and r18_0.Character:FindFirstChild("HumanoidRootPart") and (r18_0.Character.HumanoidRootPart.Position - r4_35.Position).Magnitude <= 500 then
          r18_0.Character.HumanoidRootPart.CFrame = r4_35.CFrame
          fireproximityprompt(r5_35)
          task.wait(0.1)
        end
      end
    end
  end)
end
local r38_0 = 17
local r39_0 = 35
local r40_0 = r30_0.framboss:AddInput("RadiusInput", {
  Title = "Bán kính quay (Radius)",
  Default = tostring(r38_0),
  Placeholder = "Nhập bán kính (vd: 20)",
  Numeric = true,
  Finished = true,
  Callback = function(r0_60)
    -- line: [0, 0] id: 60
    local r1_60 = tonumber(r0_60)
    if r1_60 then
      r38_0 = r1_60
      print("�ã cập nhật bán kính:", r38_0)
    else
      print("Giá trị radius không hợp lệ.")
    end
  end,
})
local r41_0 = r30_0.framboss:AddInput("SpeedInput", {
  Title = "Tốc độ quay (Speed)",
  Default = tostring(r39_0),
  Placeholder = "Nhập tốc độ (vd: 2.5)",
  Numeric = true,
  Finished = true,
  Callback = function(r0_36)
    -- line: [0, 0] id: 36
    local r1_36 = tonumber(r0_36)
    if r1_36 then
      r39_0 = r1_36
      print("�ã cập nhật tốc độ:", r39_0)
    else
      print("Giá trị speed không hợp lệ.")
    end
  end,
})
function StartAutoFarm()
  -- line: [0, 0] id: 10
  task.spawn(function()
    -- line: [0, 0] id: 11
    while r21_0 do
      local r0_11 = nil
      for r4_11, r5_11 in pairs(workspace.GiangHo2.NPCs:GetChildren()) do
        if r5_11:FindFirstChild("Humanoid") and 0 < r5_11.Humanoid.Health and r5_11:FindFirstChild("HumanoidRootPart") then
          r0_11 = r5_11
          break
        end
      end
      if r0_11 then
        local r1_11 = r0_11:FindFirstChild("HumanoidRootPart")
        if r1_11 then
          CircleAroundBoss(r1_11)
        end
        if r18_0.Character and r24_0 and not r18_0.Character:FindFirstChild(r24_0) then
          EquipWeapon(r24_0)
        end
        while r21_0 and r0_11 do
          local r2_11 = r0_11:FindFirstChild("Humanoid")
          if r2_11 then
            r2_11 = r0_11.Humanoid.Health
            if r2_11 > 0 then
              task.wait()
            else
              break
            end
          else
            break
          end
        end
        task.wait(5)
      else
        task.wait()
      end
    end
  end)
end
function CircleAroundBoss(r0_30)
  -- line: [0, 0] id: 30
  task.spawn(function()
    -- line: [0, 0] id: 31
    local r0_31 = r18_0.Character and r18_0.Character:FindFirstChild("HumanoidRootPart")
    if not r0_31 or not r0_30 then
      return 
    end
    local r1_31 = r38_0
    local r2_31 = r39_0
    local r3_31 = 0
    while r21_0 do
      local r4_31 = r0_30.Parent
      if r4_31 then
        r4_31 = r0_30.Parent:FindFirstChild("Humanoid")
        if r4_31 then
          r4_31 = r0_30.Parent.Humanoid.Health
          if r4_31 > 0 then
            r3_31 = (r3_31 + r2_31 * task.wait()) % 2 * math.pi
            r4_31 = r0_30.Position + Vector3.new(math.cos(r3_31) * r1_31, 0, math.sin(r3_31) * r1_31)
            r0_31.CFrame = CFrame.lookAt(r4_31 + Vector3.new(0, 2, 0), r0_30.Position)
            r16_0:CaptureController()
            r16_0:Button1Down(Vector2.new(1280, 672))
          else
            break
          end
        else
          break
        end
      else
        break
      end
    end
  end)
end
r30_0.framboss:AddButton({
  Title = "Tele vào chỗ boss",
  Description = "Tele vào chỗ boss",
  Callback = function()
    -- line: [0, 0] id: 82
    local r0_82 = game.Players.LocalPlayer
    (r0_82.Character or r0_82.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2572.62158, 279.985016, -1368.58911, 0.679292798, 0.0000000251945931, -0.733867347, 0.0000000143844403, 1, 0.0000000476459938, 0.733867347, -0.000000042921851, 0.679292798)
  end,
})
task.spawn(function()
  -- line: [0, 0] id: 53
  local r0_53 = game:GetService("VirtualUser")
  game:GetService("Players").LocalPlayer.Idled:Connect(function()
    -- line: [0, 0] id: 54
    r0_53:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    r0_53:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    print("�� Anti-AFK kích hoạt.")
  end)
  while task.wait(1170) do
    r0_53:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    r0_53:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    print("����� Anti-AFK tự động sau 19.5 phút.")
  end
end)
local r42_0 = game:GetService("Players")
local r43_0 = game:GetService("RunService")
local r44_0 = game:GetService("HttpService")
local r45_0 = r42_0.LocalPlayer
local r46_0 = {
  Detector = r29_0:AddTab({
    Title = "webhook",
    Icon = "link",
  }),
}
local r47_0 = ""
local r48_0 = false
local r49_0 = {}
local r50_0 = 50
local r51_0 = nil
local function r52_0()
  -- line: [0, 0] id: 6
  return os.date("%d/%m/%Y %H:%M:%S")
end
local function r53_0(r0_52)
  -- line: [0, 0] id: 52
  if r47_0 == "" then
    return 
  end
  local r1_52 = {
    title = "����� Item Spawn!",
    description = ("Phát hiện **%s** gần bạn!"):format(r0_52:upper()),
    color = 65280,
    fields = {
      {
        name = "�� Thời gian (VN)",
        value = r52_0(),
        inline = true,
      },
      {
        name = "����� Người chơi",
        value = r45_0.Name .. " (UserId: " .. r45_0.UserId .. ")",
        inline = true,
      }
    },
    footer = {
      text = "Loot Alert System",
    },
  }
  local r2_52 = request
  if not r2_52 then
    r2_52 = http_request
    if not r2_52 then
      r2_52 = syn
      if r2_52 then
        r2_52 = syn.request or fluxus and fluxus.request
      else
        goto label_49	-- block#6 is visited secondly
      end
    end
  end
  if r2_52 then
    local r3_52 = r2_52
    local r4_52 = {
      Url = r47_0,
      Method = "POST",
      Headers = {
        ["Content-Type"] = "application/json",
      },
    }
    r4_52.Body = r44_0:JSONEncode({
      embeds = {
        r1_52
      },
    })
    r3_52(r4_52)
  end
end
local function r54_0(r0_85)
  -- line: [0, 0] id: 85
  if r0_85:IsA("BasePart") then
    return r0_85.Position
  end
  if r0_85:IsA("Tool") then
    local r1_85 = r0_85:FindFirstChildWhichIsA("BasePart")
    if r1_85 then
      return r1_85.Position
    end
  end
  if r0_85:IsA("Model") then
    local r1_85 = r0_85.PrimaryPart or r0_85:FindFirstChildWhichIsA("BasePart")
    if r1_85 then
      return r1_85.Position
    end
  end
  return nil
end
local function r55_0(r0_13)
  -- line: [0, 0] id: 13
  if r0_13.Name == "Cash" or r0_13.Name == "Chest" then
    local r1_13 = r54_0(r0_13)
    if r1_13 then
      return r0_13.Name, r1_13
    end
  end
  local r1_13 = r0_13.Parent
  if r1_13 and (r1_13.Name == "Cash" or r1_13.Name == "Chest") then
    local r2_13 = r54_0(r1_13) or r54_0(r0_13)
    if r2_13 then
      return r1_13.Name, r2_13
    end
  end
  return nil, nil
end
local function r56_0()
  -- line: [0, 0] id: 26
  r51_0 = r43_0.Heartbeat:Connect(function()
    -- line: [0, 0] id: 27
    local r0_27 = r45_0.Character
    local r1_27 = r0_27 and r0_27:FindFirstChild("HumanoidRootPart")
    if not r1_27 then
      return 
    end
    for r5_27, r6_27 in ipairs(workspace:GetDescendants()) do
      if r6_27:IsA("BasePart") or r6_27:IsA("Model") or r6_27:IsA("Tool") then
        local r7_27, r8_27 = r55_0(r6_27)
        if r7_27 and r8_27 and (r8_27 - r1_27.Position).Magnitude <= r50_0 and not r49_0[r6_27] then
          r49_0[r6_27] = tick()
          r53_0(r7_27)
        end
      end
    end
    for r5_27, r6_27 in pairs(r49_0) do
      if tick() - r6_27 > 10 then
        r49_0[r5_27] = nil
      end
    end
  end)
end
local function r57_0()
  -- line: [0, 0] id: 41
  if r51_0 then
    r51_0:Disconnect()
    r51_0 = nil
  end
end
r46_0.Detector:AddInput("WebhookInput", {
  Title = "Webhook URL",
  Default = "",
  Placeholder = "Dán link webhook vào đây...",
  Callback = function(r0_4)
    -- line: [0, 0] id: 4
    r47_0 = r0_4
    r26_0:Notify({
      Title = "Webhook",
      Content = "�ã lưu link webhook!",
      Duration = 3,
    })
  end,
})
r46_0.Detector:AddToggle("DetectorToggle", {
  Title = "Bật Detector",
  Default = false,
  Callback = function(r0_32)
    -- line: [0, 0] id: 32
    r48_0 = r0_32
    if r48_0 then
      r56_0()
      r26_0:Notify({
        Title = "Detector",
        Content = "�ang theo dõi item!",
        Duration = 3,
      })
    else
      r57_0()
      r26_0:Notify({
        Title = "Detector",
        Content = "�ã tắt detector.",
        Duration = 3,
      })
    end
  end,
})
local r58_0 = r29_0:AddTab({
  Title = "Fix Lag",
  Icon = "cpu",
})
local function r59_0(r0_7)
  -- line: [0, 0] id: 7
  local r1_7 = game:GetService("Lighting")
  local r2_7 = workspace:FindFirstChildOfClass("Terrain")
  if r0_7 >= 10 then
    r1_7.GlobalShadows = false
    r1_7.FogEnd = 9000000000
  end
  if r0_7 >= 20 then
    for r6_7, r7_7 in ipairs(r1_7:GetChildren()) do
      if r7_7:IsA("BloomEffect") or r7_7:IsA("SunRaysEffect") then
        r7_7.Enabled = false
      end
    end
  end
  if r0_7 >= 30 then
    for r6_7, r7_7 in ipairs(r1_7:GetChildren()) do
      if r7_7:IsA("ColorCorrectionEffect") or r7_7:IsA("BlurEffect") then
        r7_7.Enabled = false
      end
    end
  end
  if 40 <= r0_7 and r2_7 then
    r2_7.WaterWaveSize = 0
    r2_7.WaterWaveSpeed = 0
    r2_7.WaterReflectance = 0
    r2_7.WaterTransparency = 0
  end
  if r0_7 >= 50 then
    for r6_7, r7_7 in ipairs(workspace:GetDescendants()) do
      if r7_7:IsA("BasePart") then
        r7_7.Material = Enum.Material.SmoothPlastic
      end
    end
  end
  if r0_7 >= 60 then
    for r6_7, r7_7 in ipairs(workspace:GetDescendants()) do
      if r7_7:IsA("ParticleEmitter") or r7_7:IsA("Trail") then
        r7_7.Enabled = false
      end
    end
  end
  if r0_7 >= 70 then
    for r6_7, r7_7 in ipairs(workspace:GetDescendants()) do
      if r7_7:IsA("Decal") or r7_7:IsA("Texture") then
        r7_7:Destroy()
      elseif r7_7:IsA("MeshPart") then
        r7_7.TextureID = ""
      end
    end
  end
  if r0_7 >= 80 then
    for r6_7, r7_7 in ipairs(workspace:GetDescendants()) do
      if r7_7:IsA("BasePart") then
        r7_7.Color = Color3.new(1, 1, 1)
      end
    end
  end
  r26_0:Notify({
    Title = "Fix Lag",
    Content = "�ã xoá đồ họa ở mức " .. r0_7 .. "%",
    Duration = 3,
  })
end
for r63_0, r64_0 in ipairs({
  10,
  20,
  30,
  40,
  50,
  60,
  70,
  80
}) do
  local r67_0 = {}
  local r69_0 = r64_0
  r67_0.Title = "Xóa Đồ Họa " .. r69_0 .. "%"
  local function r68_0()
    -- line: [0, 0] id: 1
    r59_0(r64_0)
  end
  r67_0.Callback = r68_0
  r58_0:AddButton(r67_0)
  -- close: r63_0
end
local r60_0 = nil
local r64_0 = {
  Title = "White Screen Mode",
  Default = false,
  Callback = function(r0_57)
    -- line: [0, 0] id: 57
    if r0_57 and not r60_0 then
      r60_0 = Instance.new("ScreenGui")
      r60_0.Name = "WhiteScreen"
      r60_0.IgnoreGuiInset = true
      r60_0.ResetOnSpawn = false
      r60_0.Parent = game:GetService("CoreGui")
      local r1_57 = Instance.new("Frame")
      r1_57.BackgroundColor3 = Color3.new(1, 1, 1)
      r1_57.Size = UDim2.new(1, 0, 1, 0)
      r1_57.Parent = r60_0
    elseif r60_0 then
      r60_0:Destroy()
      r60_0 = nil
    end
  end,
}
r58_0:AddToggle("WhiteScreenToggle", r64_0)
local r61_0 = r29_0:AddTab({
  Title = "fram tiền",
  Icon = "dollar-sign",
})
r64_0 = "Players"
local r62_0 = game:GetService(r64_0)
r64_0 = r62_0.LocalPlayer:WaitForChild("leaderstats")
local r65_0 = r64_0:WaitForChild("VND")
local function r66_0(r0_25)
  -- line: [0, 0] id: 25
  local r1_25 = tostring(r0_25)
  local r2_25 = nil
  repeat
    r1_25, k = r1_25:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
    r2_25 = r1_25
  until k == 0
  return r2_25
end
local r67_0 = 0
local r68_0 = r65_0.Value
local r69_0 = r61_0:AddParagraph({
  Title = "bộ đếm tiền",
  Content = r66_0(r67_0) .. " VND",
})
local r70_0 = r61_0:AddParagraph({
  Title = "Số Dư Hiện Tại",
  Content = r66_0(r68_0) .. " VND",
})
r61_0:AddButton({
  Title = "Reset bộ đếm tiền",
  Callback = function()
    -- line: [0, 0] id: 66
    r67_0 = 0
    r69_0:SetDesc(r66_0(r67_0) .. " VND")
    r26_0:Notify({
      Title = "Money Tracker",
      Content = "�ã reset bộ đếm tiền!",
      Duration = 3,
    })
  end,
})
r65_0:GetPropertyChangedSignal("Value"):Connect(function()
  -- line: [0, 0] id: 8
  local r0_8 = r65_0.Value
  if r68_0 < r0_8 then
    r67_0 = r67_0 + r0_8 - r68_0
    r69_0:SetDesc(r66_0(r67_0) .. " VND")
  end
  r70_0:SetDesc(r66_0(r0_8) .. " VND")
  r68_0 = r0_8
end)
local r71_0 = game:GetService("VirtualUser")
local r72_0 = false
local r73_0 = nil
local r74_0 = nil
r61_0:AddToggle("AntiAFKToggle", {
  Title = "Anti AFK ",
  Default = false,
  Callback = function(r0_67)
    -- line: [0, 0] id: 67
    r72_0 = r0_67
    if r72_0 then
      if r73_0 then
        r73_0:Disconnect()
      end
      r73_0 = r62_0.LocalPlayer.Idled:Connect(function()
        -- line: [0, 0] id: 68
        r71_0:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        r71_0:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
      r74_0 = task.spawn(function()
        -- line: [0, 0] id: 69
        while r72_0 do
          task.wait(1080)
          r71_0:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
          task.wait(1)
          r71_0:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
          r26_0:Notify({
            Title = "Anti-AFK",
            Content = "�ã nhấn tự động (sau 18 phút).",
            Duration = 3,
          })
        end
      end)
      r26_0:Notify({
        Title = "Anti-AFK",
        Content = "�ã bật chống kick (18 phút).",
        Duration = 3,
      })
    else
      if r73_0 then
        r73_0:Disconnect()
        r73_0 = nil
      end
      r72_0 = false
      r26_0:Notify({
        Title = "Anti-AFK",
        Content = "�ã tắt chống kick.",
        Duration = 3,
      })
    end
  end,
})
local r75_0 = r29_0:AddTab({
  Title = "PvP",
  Icon = "swords",
})
local r76_0 = game:GetService("Players")
local r77_0 = game:GetService("RunService")
local r78_0 = game:GetService("Stats")
local r79_0 = r76_0.LocalPlayer
local r80_0 = false
local r81_0 = 5
local r82_0 = nil
local r83_0 = false
local r84_0 = false
local r85_0 = false
local r86_0 = false
local r87_0 = false
local r88_0 = {}
local r89_0 = Instance.new("Folder")
r89_0.Name = "ESP"
r89_0.Parent = workspace
r75_0:AddSlider("SpinSpeedSlider", {
  Title = "Tốc độ Spin",
  Min = 1,
  Max = 10000,
  Default = 5,
  Rounding = 1,
  Callback = function(r0_15)
    -- line: [0, 0] id: 15
    r81_0 = r0_15
  end,
})
r75_0:AddToggle("PvPSpinToggle", {
  Title = "PvP Spin (Xoay liên tục)",
  Default = false,
  Callback = function(r0_83)
    -- line: [0, 0] id: 83
    r80_0 = r0_83
    local r1_83 = r79_0.Character
    if not r1_83 then
      return 
    end
    local r2_83 = r1_83:FindFirstChildOfClass("Humanoid")
    local r3_83 = r1_83:FindFirstChild("HumanoidRootPart")
    if not r2_83 or not r3_83 then
      return 
    end
    if r0_83 then
      r2_83.AutoRotate = false
      task.spawn(function()
        -- line: [0, 0] id: 84
        while r80_0 do
          local r0_84 = r2_83
          if r0_84 then
            r0_84 = r3_83
            if r0_84 then
              r3_83.CFrame = r3_83.CFrame * CFrame.Angles(0, math.rad(r81_0), 0)
              task.wait(0.03)
            else
              break
            end
          else
            break
          end
        end
      end)
    else
      r2_83.AutoRotate = true
    end
  end,
})
r79_0.CharacterAdded:Connect(function(r0_50)
  -- line: [0, 0] id: 50
  if r80_0 then
    task.wait(0.5)
    local r1_50 = r0_50:WaitForChild("Humanoid", 5)
    if r1_50 then
      r1_50.AutoRotate = false
    end
  end
end)
r75_0:AddToggle("MaxLevelToggle", {
  Title = "inf stamina",
  Default = false,
  Callback = function(r0_79)
    -- line: [0, 0] id: 79
    if r0_79 then
      local r1_79 = r79_0:FindFirstChild("stats")
      local r2_79 = r1_79 and r1_79:FindFirstChild("Level")
      if r2_79 then
        r2_79.Value = 1000000000
      end
    end
  end,
})
local function r90_0()
  -- line: [0, 0] id: 51
  local r0_51 = {}
  for r4_51, r5_51 in ipairs(r76_0:GetPlayers()) do
    if r5_51 ~= r79_0 then
      table.insert(r0_51, r5_51.Name)
    end
  end
  return r0_51
end
r75_0:AddToggle("ESPToggle", {
  Title = "Hiện ESP Line & Tên",
  Default = false,
  Callback = function(r0_55)
    -- line: [0, 0] id: 55
    r85_0 = r0_55
    if not r85_0 then
      for r4_55, r5_55 in pairs(r89_0:GetChildren()) do
        r5_55:Destroy()
      end
    end
  end,
})
r75_0:AddToggle("AutoToolToggle", {
  Title = "Auto đánh Tool",
  Default = false,
  Callback = function(r0_62)
    -- line: [0, 0] id: 62
    r84_0 = r0_62
    task.spawn(function()
      -- line: [0, 0] id: 63
      while r84_0 do
        local r0_63 = r79_0.Character
        if r0_63 then
          r0_63 = r79_0.Character:FindFirstChildOfClass("Tool")
          if r0_63 then
            pcall(function()
              -- line: [0, 0] id: 64
              r0_63:Activate()
            end)
          end
          -- close: r0_63
        end
        r0_63 = task
        r0_63 = r0_63.wait
        r0_63(0.1)
      end
    end)
  end,
})
local r91_0 = nil
r75_0:AddToggle("AimPlayerToggle", {
  Title = "Aim Player",
  Default = false,
  Callback = function(r0_74)
    -- line: [0, 0] id: 74
    r83_0 = r0_74
    if r91_0 then
      r91_0:Disconnect()
      r91_0 = nil
    end
    if r83_0 then
      r91_0 = r77_0.RenderStepped:Connect(function()
        -- line: [0, 0] id: 75
        if not r82_0 then
          return 
        end
        local r0_75 = r76_0:FindFirstChild(r82_0)
        local r1_75 = r79_0.Character
        if not r0_75 or not r1_75 then
          return 
        end
        local r2_75 = r0_75.Character
        if not r2_75 then
          return 
        end
        local r3_75 = r2_75:FindFirstChild("Head")
        local r4_75 = r1_75:FindFirstChild("HumanoidRootPart")
        if not r3_75 or not r4_75 then
          return 
        end
        r4_75.CFrame = CFrame.new(r4_75.Position, r4_75.Position + (r3_75.Position - r4_75.Position).Unit)
      end)
    end
  end,
})
local function r92_0(r0_77)
  -- line: [0, 0] id: 77
  if not r0_77.Character or not r0_77.Character:FindFirstChild("HumanoidRootPart") then
    return 
  end
  local r1_77 = r0_77.Character.HumanoidRootPart
  local r2_77 = Instance.new("BillboardGui")
  r2_77.Name = "NameESP_" .. r0_77.Name
  r2_77.Size = UDim2.new(0, 150, 0, 35)
  r2_77.Adornee = r1_77
  r2_77.AlwaysOnTop = true
  r2_77.MaxDistance = 2000
  r2_77.Parent = r89_0
  local r3_77 = Instance.new("TextLabel")
  r3_77.Size = UDim2.fromScale(1, 1)
  r3_77.BackgroundTransparency = 0.5
  r3_77.BackgroundColor3 = Color3.new(0, 0, 0)
  r3_77.Text = r0_77.Name
  r3_77.TextColor3 = Color3.new(1, 0, 0)
  r3_77.TextScaled = true
  r3_77.TextStrokeTransparency = 0
  r3_77.Font = Enum.Font.SourceSansBold
  r3_77.Parent = r2_77
  local r4_77 = Drawing.new("Line")
  r4_77.Visible = true
  r4_77.Color = Color3.new(1, 0, 0)
  r4_77.Thickness = 2
  r77_0.RenderStepped:Connect(function()
    -- line: [0, 0] id: 78
    if not r85_0 then
      r4_77.Visible = false
      r2_77.Enabled = false
      return 
    end
    if r0_77.Character and r0_77.Character:FindFirstChild("HumanoidRootPart") and r79_0.Character and r79_0.Character:FindFirstChild("HumanoidRootPart") then
      local r0_78 = workspace.CurrentCamera
      local r1_78 = r0_78:WorldToViewportPoint(r1_77.Position)
      local r2_78 = r0_78:WorldToViewportPoint(r79_0.Character.HumanoidRootPart.Position)
      r4_77.From = Vector2.new(r2_78.X, r2_78.Y)
      r4_77.To = Vector2.new(r1_78.X, r1_78.Y)
      r4_77.Visible = true
      r2_77.Enabled = true
    else
      r4_77.Visible = false
      r2_77.Enabled = false
    end
  end)
end
task.spawn(function()
  -- line: [0, 0] id: 81
  -- notice: unreachable block#11
  while true do
    if r85_0 then
      local r0_81 = ipairs
      for r3_81, r4_81 in r0_81(r76_0:GetPlayers()) do
        if r4_81 ~= r79_0 and not r89_0:FindFirstChild(("NameESP_" .. r4_81.Name)) then
          r92_0(r4_81)
        end
      end
    else
      local r0_81 = pairs
      for r3_81, r4_81 in r0_81(r89_0:GetChildren()) do
        r4_81:Destroy()
      end
    end
    task.wait(2)
  end
end)
local r93_0 = r75_0:AddButton({
  Title = "Chọn Target",
  Description = "Target hiện tại: None",
  Callback = function()
    -- line: [0, 0] id: 43
    local r0_43 = r90_0()
    local r3_43 = nil	-- notice: implicit variable refs by block#[2]
    if #r0_43 == 0 then
      warn("Chưa có player nào để chọn!")
      return 
    end
    local r1_43 = 1
    local r2_43 = 5
    function r3_43()
      -- line: [0, 0] id: 44
      local r0_44 = {}
      local r2_44 = math.min(r1_43 * r2_43, #r0_43)
      local r7_44 = nil	-- notice: implicit variable refs by block#[7]
      for r6_44 = (r1_43 - 1) * r2_43 + 1, r2_44, 1 do
        r7_44 = r0_43[r6_44]
        table.insert(r0_44, {
          Title = r7_44,
          Callback = function()
            -- line: [0, 0] id: 47
            r82_0 = r7_44
            print("�� Target đã chọn:", r7_44)
          end,
        })
        -- close: r7_44
      end
      table.insert(r0_44, {
        Title = "����� Không chọn",
        Callback = function()
          -- line: [0, 0] id: 45
          local r0_45 = nil	-- notice: implicit variable refs by block#[0]
          r82_0 = r0_45
        end,
      })
      table.insert(r0_44, {
        Title = "�� Thoát",
        Callback = function()
          -- line: [0, 0] id: 48
        end,
      })
      if r1_43 > 1 then
        table.insert(r0_44, {
          Title = "�� Trang trước",
          Callback = function()
            -- line: [0, 0] id: 49
            r1_43 = r1_43 - 1
            r3_43()
          end,
        })
      end
      if r2_44 < #r0_43 then
        table.insert(r0_44, {
          Title = "�� Trang sau",
          Callback = function()
            -- line: [0, 0] id: 46
            r1_43 = r1_43 + 1
            r3_43()
          end,
        })
      end
      local r5_44 = {}
      r7_44 = r1_43
      r5_44.Title = "Chọn Target (Trang " .. r7_44 .. ")"
      r5_44.Content = "Chọn player bạn muốn nhắm:"
      r5_44.Buttons = r0_44
      r29_0:Dialog(r5_44)
    end
    r3_43()
  end,
})
task.spawn(function()
  -- line: [0, 0] id: 72
  while task.wait(1) do
    local r0_72 = r82_0
    if r0_72 then
      r93_0:SetDesc("Target hiện tại: " .. r82_0)
    else
      r93_0:SetDesc("Target hiện tại: None")
    end
  end
end)
r75_0:AddToggle("ToolHitboxESP", {
  Title = "Hiện Hitbox Vũ Khí",
  Default = false,
}):OnChanged(function(r0_29)
  -- line: [0, 0] id: 29
  r86_0 = r0_29
  if not r0_29 then
    for r4_29, r5_29 in pairs(r88_0) do
      if r5_29 and r5_29.Parent then
        r5_29:Destroy()
      end
    end
    r88_0 = {}
  end
end)
local function r94_0(r0_71)
  -- line: [0, 0] id: 71
  if r0_71 and r0_71:FindFirstChild("Handle") and not r88_0[r0_71] then
    local r1_71 = r0_71.Handle
    local r2_71 = Instance.new("SelectionBox")
    r2_71.Name = "ToolHitboxESP"
    r2_71.Adornee = r1_71
    r2_71.LineThickness = 0.05
    r2_71.Color3 = Color3.fromRGB(0, 255, 0)
    r2_71.SurfaceTransparency = 1
    r2_71.Parent = r1_71
    r88_0[r0_71] = r2_71
  end
end
r77_0.RenderStepped:Connect(function()
  -- line: [0, 0] id: 37
  if r86_0 then
    for r3_37, r4_37 in ipairs(r76_0:GetPlayers()) do
      if r4_37.Character then
        for r8_37, r9_37 in ipairs(r4_37.Character:GetChildren()) do
          if r9_37:IsA("Tool") then
            r94_0(r9_37)
          end
        end
      end
    end
  end
end)
r76_0.PlayerRemoving:Connect(function(r0_33)
  -- line: [0, 0] id: 33
  if r0_33.Character then
    for r4_33, r5_33 in ipairs(r0_33.Character:GetChildren()) do
      if r88_0[r5_33] then
        r88_0[r5_33]:Destroy()
        r88_0[r5_33] = nil
      end
    end
  end
end)
r75_0:AddToggle("HealthESP", {
  Title = "Hiện Thanh Máu",
  Default = false,
}):OnChanged(function(r0_65)
  -- line: [0, 0] id: 65
  r87_0 = r0_65
  if not r0_65 then
    for r4_65, r5_65 in ipairs(r76_0:GetPlayers()) do
      if r5_65.Character and r5_65.Character:FindFirstChild("Head") then
        local r6_65 = r5_65.Character.Head
        if r6_65:FindFirstChild("HealthESP") then
          r6_65.HealthESP:Destroy()
        end
      end
    end
  end
end)
local function r95_0(r0_40)
  -- line: [0, 0] id: 40
  if not r87_0 then
    return 
  end
  local r1_40 = r0_40:FindFirstChild("Head")
  local r2_40 = r0_40:FindFirstChildOfClass("Humanoid")
  if r1_40 and r2_40 and not r1_40:FindFirstChild("HealthESP") then
    local r3_40 = Instance.new("BillboardGui")
    r3_40.Name = "HealthESP"
    r3_40.Size = UDim2.new(4, 0, 1.5, 0)
    r3_40.StudsOffset = Vector3.new(0, 3, 0)
    r3_40.AlwaysOnTop = true
    r3_40.Parent = r1_40
    local r4_40 = Instance.new("Frame", r3_40)
    r4_40.Size = UDim2.new(1, 0, 0.2, 0)
    r4_40.Position = UDim2.new(0, 0, 0.5, 0)
    r4_40.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local r5_40 = Instance.new("Frame", r4_40)
    r5_40.Name = "HealthBar"
    r5_40.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    r5_40.Size = UDim2.new(1, 0, 1, 0)
    local r6_40 = Instance.new("TextLabel", r3_40)
    r6_40.Name = "HPText"
    r6_40.Size = UDim2.new(1, 0, 0.5, 0)
    r6_40.Position = UDim2.new(0, 0, 0, -10)
    r6_40.BackgroundTransparency = 1
    r6_40.TextColor3 = Color3.fromRGB(255, 255, 255)
    r6_40.TextStrokeTransparency = 0
    r6_40.Font = Enum.Font.SourceSansBold
    r6_40.TextScaled = true
    r6_40.Text = tostring(r2_40.Health) .. "/" .. tostring(r2_40.MaxHealth)
  end
end
r77_0.RenderStepped:Connect(function()
  -- line: [0, 0] id: 80
  if r87_0 then
    for r3_80, r4_80 in ipairs(r76_0:GetPlayers()) do
      if r4_80 ~= r79_0 and r4_80.Character then
        r95_0(r4_80.Character)
        local r5_80 = r4_80.Character:FindFirstChildOfClass("Humanoid")
        local r6_80 = r4_80.Character:FindFirstChild("Head")
        if r5_80 and r6_80 and r6_80:FindFirstChild("HealthESP") then
          local r7_80 = r6_80.HealthESP
          local r8_80 = r7_80.Frame.HealthBar
          local r9_80 = r7_80.HPText
          r8_80.Size = UDim2.new(math.clamp(r5_80.Health / r5_80.MaxHealth, 0, 1), 0, 1, 0)
          local r10_80 = r5_80.Health / r5_80.MaxHealth
          if r10_80 > 0.6 then
            r8_80.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
          elseif r10_80 > 0.3 then
            r8_80.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
          else
            r8_80.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
          end
          r9_80.Text = math.floor(r5_80.Health) .. "/" .. math.floor(r5_80.MaxHealth)
        end
      end
    end
  end
end)
local r96_0 = r29_0:AddTab({
  Title = "Settings",
  Icon = "settings",
})
r28_0:SetLibrary(r26_0)
r27_0:Serary(r26_0)
r27_0:IgnoreThemeSettings()
r27_0:SetIgnoreIndexes({})
r28_0:SetFolder("MyHub")
r27_0:SetFolder("MyHub/Configs")
r28_0:BuildInterfaceSection(r96_0)
r27_0:BuildConfigSection(r96_0)
r29_0:SelectTab(1)
r27_0:LoadAutoloadConfig()
