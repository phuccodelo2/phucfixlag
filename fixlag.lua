local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernFixLagUI"
gui.ResetOnSpawn = false

-- 🌀 Viền hiệu ứng 3 màu
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

-- 📦 Menu chính
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 400, 0, 300)
menu.Position = UDim2.new(0.5, -200, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
createRainbowBorder(menu)

-- 🔰 Tên script
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -10, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Phucmax FixLag"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.BackgroundTransparency = 1

-- 🔄 Scrolling Frame chứa nút
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

-- 📦 Tạo nút FixLag
local function createFixButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 45)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- ⚙️ Chức năng từng cấp độ
local function X1()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	workspace:FindFirstChildOfClass("Lighting").Brightness = 0
end

local function X2()
	X1()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
	end
end

local function X3()
	X2()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
		if v.Name:lower():find("tree") or v:IsA("MeshPart") then v:Destroy() end
	end
end

local function X4()
	X3()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("UnionOperation") or v:IsA("Part") then v.Material = Enum.Material.SmoothPlastic end
	end
end

local function X5()
	X4()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
			v.Transparency = 1
		end
	end
end

-- 🧠 Gắn nút
createFixButton(scroll, "Fix Lag X1", X1)
createFixButton(scroll, "Fix Lag X2", X2)
createFixButton(scroll, "Fix Lag X3", X3)
createFixButton(scroll, "Fix Lag X4", X4)
createFixButton(scroll, "Fix Lag X5", X5)

-- 🪟 Nút bật/tắt menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
createRainbowBorder(toggleButton)

-- ❌ Nút đóng menu + xác nhận
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

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

-- 📌 Sự kiện nút
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