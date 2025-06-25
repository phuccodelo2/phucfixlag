-- UI Library đơn giản (custom)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TabHolder = Instance.new("Frame")
local Script1Tab = Instance.new("Frame")
local SettingTab = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Logo = Instance.new("ImageLabel")
local Tab1Btn = Instance.new("TextButton")
local Tab2Btn = Instance.new("TextButton")

-- Các phần setting
local SpeedSlider, JumpSlider, FlyToggle, FlySpeedSlider, NoClipToggle

-- Cho phép kéo menu
MainFrame.Active = true
MainFrame.Draggable = true

-- Bật menu
ScreenGui.Name = "CustomUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Giao diện chính
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 300)

UICorner.Parent = MainFrame

-- Logo tròn
Logo.Name = "Logo"
Logo.Parent = MainFrame
Logo.Size = UDim2.new(0, 32, 0, 32)
Logo.Position = UDim2.new(0, -40, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://139344694264003" -- Logo đoàn hoàn

-- Nút bật/tắt menu
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.Text = "☰"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Tab nút
Tab1Btn.Name = "Tab1Btn"
Tab1Btn.Parent = MainFrame
Tab1Btn.Position = UDim2.new(0, 10, 0, 10)
Tab1Btn.Size = UDim2.new(0, 80, 0, 30)
Tab1Btn.Text = "Script1"
Tab1Btn.MouseButton1Click:Connect(function()
	Script1Tab.Visible = true
	SettingTab.Visible = false
end)

Tab2Btn.Name = "Tab2Btn"
Tab2Btn.Parent = MainFrame
Tab2Btn.Position = UDim2.new(0, 100, 0, 10)
Tab2Btn.Size = UDim2.new(0, 80, 0, 30)
Tab2Btn.Text = "Cài đặt"
Tab2Btn.MouseButton1Click:Connect(function()
	Script1Tab.Visible = false
	SettingTab.Visible = true
end)

-- Script1 Tab
Script1Tab.Name = "Script1Tab"
Script1Tab.Parent = MainFrame
Script1Tab.Position = UDim2.new(0, 0, 0, 50)
Script1Tab.Size = UDim2.new(1, 0, 1, -50)
Script1Tab.BackgroundTransparency = 1

local RunScriptBtn = Instance.new("TextButton")
RunScriptBtn.Parent = Script1Tab
RunScriptBtn.Size = UDim2.new(0, 200, 0, 40)
RunScriptBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
RunScriptBtn.Text = "CHẠY SCRIPT"
RunScriptBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 50)
RunScriptBtn.TextColor3 = Color3.new(1, 1, 1)

RunScriptBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Phucmax/main/autofruit.lua"))()"))()
end)

-- Tab Cài Đặt
SettingTab.Name = "SettingTab"
SettingTab.Parent = MainFrame
SettingTab.Position = UDim2.new(0, 0, 0, 50)
SettingTab.Size = UDim2.new(1, 0, 1, -50)
SettingTab.BackgroundTransparency = 1
SettingTab.Visible = false

-- Speed, JumpPower, Fly...
local plr = game.Players.LocalPlayer
local hum = plr.Character:WaitForChild("Humanoid")

-- Speed slider (dạng nút đơn giản vì không dùng UI library nâng cao)
local SpeedLabel = Instance.new("TextButton")
SpeedLabel.Parent = SettingTab
SpeedLabel.Text = "Speed: 16"
SpeedLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
SpeedLabel.Size = UDim2.new(0, 200, 0, 30)
SpeedLabel.MouseButton1Click:Connect(function()
	hum.WalkSpeed = hum.WalkSpeed + 5
	SpeedLabel.Text = "Speed: " .. hum.WalkSpeed
end)

local JumpLabel = Instance.new("TextButton")
JumpLabel.Parent = SettingTab
JumpLabel.Text = "JumpPower: 50"
JumpLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
JumpLabel.Size = UDim2.new(0, 200, 0, 30)
JumpLabel.MouseButton1Click:Connect(function()
	hum.JumpPower = hum.JumpPower + 10
	JumpLabel.Text = "JumpPower: " .. hum.JumpPower
end)

-- Fly Toggle
local flying = false
local flybtn = Instance.new("TextButton")
flybtn.Parent = SettingTab
flybtn.Text = "Fly: OFF"
flybtn.Position = UDim2.new(0.1, 0, 0.3, 0)
flybtn.Size = UDim2.new(0, 200, 0, 30)
flybtn.MouseButton1Click:Connect(function()
	flying = not flying
	flybtn.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

-- Fly tốc độ
local FlySpeed = 2
local flySpeedBtn = Instance.new("TextButton")
flySpeedBtn.Parent = SettingTab
flySpeedBtn.Text = "Fly Speed: 2"
flySpeedBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
flySpeedBtn.Size = UDim2.new(0, 200, 0, 30)
flySpeedBtn.MouseButton1Click:Connect(function()
	FlySpeed = FlySpeed + 1
	flySpeedBtn.Text = "Fly Speed: " .. FlySpeed
end)

-- NoClip
local noclip = false
local noclipBtn = Instance.new("TextButton")
noclipBtn.Parent = SettingTab
noclipBtn.Text = "NoClip: OFF"
noclipBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
noclipBtn.Size = UDim2.new(0, 200, 0, 30)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: " .. (noclip and "ON" or "OFF")
end)

-- Fly loop
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local chr = plr.Character
		if chr then
			chr:TranslateBy(workspace.CurrentCamera.CFrame.LookVector * FlySpeed / 5)
			if noclip then
				for _, v in pairs(chr:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end
	end
end)
