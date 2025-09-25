-- LocalScript: Troll Overlay (Safe Fade Black/White + Rainbow Text, Infinite Time)
-- Put into StarterPlayer -> StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
if not player then return end
-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TrollOverlay"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
-- Fullscreen frame
local full = Instance.new("Frame")
full.Size = UDim2.new(1,0,1,0)
full.BackgroundColor3 = Color3.fromRGB(0,0,0)
full.Parent = gui
-- Text
local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,0,0,100)
text.Position = UDim2.new(0,0,0.4,0)
text.BackgroundTransparency = 1
text.Text = "coi thằng ngu bị lừa kìa hahaha"
text.Font = Enum.Font.GothamBlack
text.TextSize = 48
text.TextColor3 = Color3.new(1,1,1)
text.Parent = full
-- Rainbow text loop
spawn(function()
local hue = 0
while true do
hue = (hue + 0.006) % 1
text.TextColor3 = Color3.fromHSV(hue, 0.9, 1)
task.wait(0.03)
end
end)
-- Fade black/white loop (soft "flash")
spawn(function()
while true do
TweenService:Create(full, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
task.wait(0.4)
TweenService:Create(full, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
{BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
task.wait(0.4)
end
end)
