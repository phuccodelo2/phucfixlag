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
local menu = Instance.new("ScrollingFrame", gui)
menu.Size = UDim2.new(0, 400, 0, 300)
menu.Position = UDim2.new(0.5, -200, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.ScrollBarThickness = 4
menu.CanvasSize = UDim2.new(0, 0, 0, 600)
menu.Active = true
menu.Draggable = true
menu.Visible = false

createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Logo nút bật menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
createRainbowBorder(toggleButton)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)

-- Nút X
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- Xác nhận tắt
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

-- 🧠 Logic menu
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

-- ⚙️ Chức năng fixlag
local function clearEffects()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") or v:IsA("Explosion") then
			v:Destroy()
		end
	end
end

local function removeTreesAndProps()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and (v.Name:lower():find("tree") or v.Name:lower():find("bush")) then
			v:Destroy()
		end
	end
end

local function makeInvisibleExceptGround()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(game.Players) then
			v.Transparency = 1
			v.CanCollide = true
		end
	end
end

local function applyFixLevel(level)
	if level >= 1 then
		-- Giảm ánh sáng
		workspace.DescendantAdded:Connect(function(desc)
			if desc:IsA("ParticleEmitter") or desc:IsA("Smoke") then
				desc:Destroy()
			end
		end)
		workspace.FallenPartsDestroyHeight = -5000
		game:GetService("Lighting").FogEnd = 100
		game:GetService("Lighting").Brightness = 1
	end
	if level >= 2 then
		clearEffects()
	end
	if level >= 3 then
		removeTreesAndProps()
	end
	if level >= 5 then
		makeInvisibleExceptGround()
	end
end

-- ⚡ Tạo nút fixlag
local function createFixButton(name, posY, level)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		applyFixLevel(level)
	end)
end

-- Giao diện nút
createFixButton("FIXLAG X1", 50, 1)
createFixButton("FIXLAG X2", 100, 2)
createFixButton("FIXLAG X3", 150, 3)
createFixButton("FIXLAG X4", 200, 4)
createFixButton("FIXLAG X5", 250, 5)
