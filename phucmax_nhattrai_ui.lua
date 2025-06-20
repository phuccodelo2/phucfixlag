
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ModernFixLagUI"
gui.ResetOnSpawn = false

-- ⏹️ Viền hiệu ứng 3 màu
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

-- ⬛ Menu chính (có thể kéo)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 400, 0, 300)
menu.Position = UDim2.new(0.5, -200, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false
createRainbowBorder(menu)
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- 🔤 Tiêu đề
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Phucmax FixLag"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- 📜 ScrollingFrame chứa nút
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

-- 🛠️ Danh sách nút fixlag
local functions = {
	{label = "Tắt bóng đổ", func = function() game:GetService("Lighting").GlobalShadows = false end},
	{label = "Tắt Particle", func = function()
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
				v.Enabled = false
			end
		end
	end},
	{label = "Ẩn Decal", func = function()
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("Decal") then
				v.Transparency = 1
			end
		end
	end},
	{label = "Xoá Accessory", func = function()
		for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
			if v:IsA("Accessory") or v:IsA("Hat") then
				v:Destroy()
			end
		end
	end},
	{label = "Tắt ánh sáng", func = function()
		for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
			if v:IsA("PostEffect") or v:IsA("BlurEffect") then
				v.Enabled = false
			end
		end
	end},
	{label = "Giảm chất lượng", func = function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end}
}

-- 🖲️ Tạo các nút
for i, info in pairs(functions) do
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, (i - 1) * 45)
	btn.Text = info.label
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSansBold
	btn.MouseButton1Click:Connect(info.func)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

-- 🔘 Nút bật/tắt menu
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003"
toggleButton.Draggable = true
toggleButton.Active = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
createRainbowBorder(toggleButton)

-- ❌ Nút đóng menu
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- 🪧 Xác nhận
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

-- Nút Có
local yesButton = Instance.new("TextButton", confirmFrame)
yesButton.Size = UDim2.new(0.4, 0, 0, 30)
yesButton.Position = UDim2.new(0.1, 0, 1, -40)
yesButton.Text = "Có"
yesButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
yesButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", yesButton).CornerRadius = UDim.new(0, 6)

-- Nút Không
local noButton = Instance.new("TextButton", confirmFrame)
noButton.Size = UDim2.new(0.4, 0, 0, 30)
noButton.Position = UDim2.new(0.5, 10, 1, -40)
noButton.Text = "Không"
noButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
noButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", noButton).CornerRadius = UDim.new(0, 6)

-- 🧠 Logic nút
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


-- Thiết lập tốc độ bay và giữ độ cao
local flying = false
local height = 60
local speed = 300

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.cframe = player.Character.HumanoidRootPart.CFrame

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.velocity = Vector3.new(0,0.1,0)
bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

function startFlying()
    flying = true
    bodyGyro.Parent = player.Character.HumanoidRootPart
    bodyVelocity.Parent = player.Character.HumanoidRootPart

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local camCF = workspace.CurrentCamera.CFrame
            local moveVec = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
            moveVec = moveVec.Unit * speed
            bodyVelocity.Velocity = Vector3.new(moveVec.X, 0, moveVec.Z)
            player.Character:FindFirstChild("HumanoidRootPart").Position = Vector3.new(player.Character.HumanoidRootPart.Position.X, height, player.Character.HumanoidRootPart.Position.Z)
        end
    end)
end

startFlying()
