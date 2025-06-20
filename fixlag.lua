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
menu.Position = UDim2.new(0.5, -200, 0.5, -150) -- căn giữa đúng
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Active = true
menu.Draggable = true
menu.Visible = false

createRainbowBorder(menu)

local corner = Instance.new("UICorner", menu)
corner.CornerRadius = UDim.new(0, 12)

-- 🔘 Nút bật/tắt menu (di chuyển được)
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 135, 0, 25)
toggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleButton.Image = "rbxassetid://139344694264003" -- logo
toggleButton.Draggable = true
toggleButton.Active = true

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0, 10)

createRainbowBorder(toggleButton)

-- ❌ Nút đóng menu (góc trên phải)
local closeButton = Instance.new("TextButton", menu)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
closeButton.TextColor3 = Color3.new(1, 0, 0)

Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- 🪧 Thông báo xác nhận
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

-- 🔳 Nút Có
local yesButton = Instance.new("TextButton", confirmFrame)
yesButton.Size = UDim2.new(0.4, 0, 0, 30)
yesButton.Position = UDim2.new(0.1, 0, 1, -40)
yesButton.Text = "Có"
yesButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
yesButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", yesButton).CornerRadius = UDim.new(0, 6)

-- 🔲 Nút Không
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
-- FIX LAG MẠNH | TỐI ƯU FULL MAP
pcall(function()
    -- Tắt bóng đổ
    game:GetService("Lighting").GlobalShadows = false

    -- Tắt các hiệu ứng không cần thiết
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
        if v:IsA("Explosion") then
            v.Visible = false
        end
    end

    -- Tắt decal mặt đất và hiệu ứng không cần thiết
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Tắt vật trang trí và phụ kiện nhỏ
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Accessory") or v:IsA("Hat") or v.Name == "Effect" or v.Name == "Particles" then
            v:Destroy()
        end
    end

    -- Tối ưu terrain
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 0

    -- Tắt hiệu ứng ánh sáng
    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end

    -- Giảm chi tiết render
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    print("[✅] Đã fix lag hoàn tất!")
end)