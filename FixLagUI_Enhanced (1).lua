local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernFixLagUI"
gui.ResetOnSpawn = false

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

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 400, 0, 350)
menu.Position = UDim2.new(0.5, -200, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.Parent = scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
end

-- FixLag Levels
local function clearEffects()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
			obj.Enabled = false
		elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
			obj.Enabled = false
		end
	end
end

local function fixLag(level)
	clearEffects()
	-- Reduce quality (FUTURE EXPAND: tune Materials etc.)
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	-- Reduce Lighting
	game.Lighting.Brightness = 1
	game.Lighting.GlobalShadows = false
	game.Lighting.FogEnd = 100000

	-- Level-based tuning
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			if level == 5 then
				if not obj:IsA("Terrain") and not obj:FindFirstAncestorWhichIsA("Model") then
					obj.Transparency = 1
				end
			elseif level == 6 then
				if not obj:FindFirstChildOfClass("Humanoid") and not obj:IsA("Terrain") then
					obj.Transparency = 1
				end
			end
		end
	end
end

-- Buttons
createButton("FixLag X1", function() fixLag(1) end)
createButton("FixLag X2", function() fixLag(2) end)
createButton("FixLag X3", function() fixLag(3) end)
createButton("FixLag X4", function() fixLag(4) end)
createButton("FixLag X5", function() fixLag(5) end)
createButton("FixLag X6", function() fixLag(6) end)

-- Toggle Menu Button
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
createRainbowBorder(toggleButton)

toggleButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Close Button with Confirmation
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

closeButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = true
end)

yesButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

noButton.MouseButton1Click:Connect(function()
	confirmFrame.Visible = false
end)
