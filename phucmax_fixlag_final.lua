
-- phucmax fixlag UI + chức năng mạnh
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
menu.Size = UDim2.new(0, 400, 0, 350)
menu.Position = UDim2.new(0.5, -200, 0.5, -175)
menu.CanvasSize = UDim2.new(0, 0, 0, 800)
menu.ScrollBarThickness = 6
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Logo mở menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
createRainbowBorder(toggleButton)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)

-- Nút đóng
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- Thông báo xác nhận
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

-- Chức năng Fixlag nút
local function createFixButton(name, position, callback)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, -20, 0, 50)
	btn.Position = UDim2.new(0, 10, 0, position)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.TextWrapped = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
end

-- Định nghĩa từng cấp độ fixlag (sẽ cập nhật mạnh hơn sau)
createFixButton("X1 - Giảm 40%", 50, function()
	-- giảm ánh sáng, độ phân giải vật thể
	workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
	workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
	game.Lighting.GlobalShadows = false
end)

createFixButton("X2 - Xóa hiệu ứng", 110, function()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v:Destroy()
		end
	end
end)

createFixButton("X3 - Xóa cây", 170, function()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find("tree") then
			v:Destroy()
		end
	end
end)

createFixButton("X4 - Tăng hiệu lực", 230, function()
	-- kết hợp X1+X2+X3
	game.Lighting.GlobalShadows = false
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or (v:IsA("Model") and v.Name:lower():find("tree")) then
			v:Destroy()
		end
	end
end)

createFixButton("X5 - Tàng hình vật thể", 290, function()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
			v.Transparency = 1
			v.CanCollide = true
		end
	end
end)
