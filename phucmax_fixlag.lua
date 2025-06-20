
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernFixLagUI"
gui.ResetOnSpawn = false

-- Viền hiệu ứng 3 màu
local function createRainbowBorder(frame)
	local uiStroke = Instance.new("UIStroke", frame)
	uiStroke.Thickness = 2
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.LineJoinMode = Enum.LineJoinMode.Round
	local colors = {Color3.fromRGB(0,255,255), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,0)}
	local index = 1
	coroutine.wrap(function()
		while true do
			uiStroke.Color = colors[index]
			index = index % #colors + 1
			wait(0.3)
		end
	end)()
end

-- Menu chính
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 400, 0, 300)
menu.Position = UDim2.new(0.5, -200, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Nút bật/tắt menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
createRainbowBorder(toggleButton)

-- Nút đóng menu
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- Frame xác nhận
local confirmFrame = Instance.new("Frame", gui)
confirmFrame.Size = UDim2.new(0, 250, 0, 120)
confirmFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
confirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
confirmFrame.Visible = false
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0, 10)
createRainbowBorder(confirmFrame)

local confirmText = Instance.new("TextLabel", confirmFrame)
confirmText.Size = UDim2.new(1, -20, 0, 60)
confirmText.Position = UDim2.new(0, 10, 0, 10)
confirmText.Text = "Bạn có chắc muốn tắt script không?"
confirmText.TextColor3 = Color3.new(1, 1, 1)
confirmText.BackgroundTransparency = 1
confirmText.TextWrapped = true
confirmText.TextScaled = true

local yesButton = Instance.new("TextButton", confirmFrame)
yesButton.Size = UDim2.new(0.4, 0, 0, 30)
yesButton.Position = UDim2.new(0.1, 0, 1, -40)
yesButton.Text = "Có"
yesButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
yesButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", yesButton).CornerRadius = UDim.new(0, 6)

local noButton = Instance.new("TextButton", confirmFrame)
noButton.Size = UDim2.new(0.4, 0, 0, 30)
noButton.Position = UDim2.new(0.5, 10, 1, -40)
noButton.Text = "Không"
noButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
noButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", noButton).CornerRadius = UDim.new(0, 6)

-- Tiêu đề
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Phucmax FixLag"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Scroll buttons
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 5)

-- Fix lag logic
local function FixLag(level)
	local Lighting = game:GetService("Lighting")
	local function removeEffect(v)
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v:Destroy() end
	end

	for _, v in pairs(workspace:GetDescendants()) do
		if level >= 2 then removeEffect(v) end
		if level >= 3 and (v:IsA("Decal") or v:IsA("Texture")) then v:Destroy() end
		if level >= 3 and v.Name:lower():find("tree") then v:Destroy() end
		if level >= 4 and v:IsA("BasePart") then
			pcall(function()
				v.Material = Enum.Material.Plastic
				v.Transparency = 0.5
			end)
		end
		if level >= 5 and v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
			pcall(function()
				v.Transparency = 1
				v.CanCollide = true
			end)
		end
	end

	if Lighting and level >= 1 then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1000000
		Lighting.Brightness = 0
		Lighting.ClockTime = 14
	end
end

local function createFixButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- Tạo nút Fix Lag X1–X5
createFixButton(scroll, "Fix Lag X1", function() FixLag(1) end)
createFixButton(scroll, "Fix Lag X2", function() FixLag(2) end)
createFixButton(scroll, "Fix Lag X3", function() FixLag(3) end)
createFixButton(scroll, "Fix Lag X4", function() FixLag(4) end)
createFixButton(scroll, "Fix Lag X5", function() FixLag(5) end)

-- Logic nút
toggleButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

closeButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = true
end)

yesButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

noButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = false
end)
