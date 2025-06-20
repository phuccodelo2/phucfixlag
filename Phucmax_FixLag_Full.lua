local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernFixLagUI"
gui.ResetOnSpawn = false

-- Tạo viền hiệu ứng
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
menu.Size = UDim2.new(0, 400, 0, 320)
menu.Position = UDim2.new(0.5, -200, 0.5, -160)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Nút bật menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
createRainbowBorder(toggleButton)

-- Nút đóng
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

-- Tên tiêu đề
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Phucmax FixLag"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

-- Vùng cuộn các nút
local scrolling = Instance.new("ScrollingFrame", menu)
scrolling.Size = UDim2.new(1, -20, 1, -50)
scrolling.Position = UDim2.new(0, 10, 0, 40)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 500)
scrolling.ScrollBarThickness = 5
scrolling.BackgroundTransparency = 1

-- Các nút X1 → X5
local fixFunctions = {}

-- Hàm reset
local function resetFix()
	workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("Decal") or obj:IsA("ParticleEmitter") or obj:IsA("Accessory") then
			obj:Destroy()
		end
	end)
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Accessory") then
			v:Destroy()
		end
	end
end

fixFunctions["X1"] = function()
	resetFix()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	workspace.Terrain.WaterWaveSize = 0
	workspace.Terrain.WaterTransparency = 1
	workspace.Terrain.WaterReflectance = 0
	workspace.Terrain.WaterWaveSpeed = 0
	workspace.Terrain.WaterColor = Color3.new()
	game:GetService("Lighting").GlobalShadows = false
end

fixFunctions["X2"] = function()
	fixFunctions["X1"]()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
			v.Enabled = false
		end
	end
end

fixFunctions["X3"] = function()
	fixFunctions["X2"]()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("MeshPart") or v:IsA("Part") then
			if v.Name:lower():find("tree") or v.Name:lower():find("bush") then
				v:Destroy()
			end
		end
	end
end

fixFunctions["X4"] = function()
	fixFunctions["X3"]()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Texture") or v:IsA("SurfaceAppearance") then
			v:Destroy()
		end
	end
end

fixFunctions["X5"] = function()
	fixFunctions["X4"]()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
			v.CanCollide = true
		end
	end
end

-- Tạo các nút
local y = 0
for i = 1, 5 do
	local name = "X" .. i
	local btn = Instance.new("TextButton", scrolling)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.Text = "Fixlag " .. name
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	y = y + 45

	btn.MouseButton1Click:Connect(function()
		if fixFunctions[name] then
			fixFunctions[name]()
		end
	end)
end

-- Nút bật/tắt menu
toggleButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Nút đóng
closeButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = true
end)

yesButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

noButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = false
end)