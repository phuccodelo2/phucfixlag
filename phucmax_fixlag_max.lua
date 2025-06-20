
-- Phucmax Ultimate FixLag Script (Max Level)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FixLagUltimate"
gui.ResetOnSpawn = false

-- Menu chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Phucmax MAX FixLag"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -40, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 50)
btn.Text = "BẬT FIXLAG MẠNH NHẤT"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBlack
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
	-- Tắt hiệu ứng ánh sáng
	local Lighting = game:GetService("Lighting")
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1000000
	Lighting.Brightness = 0
	Lighting.OutdoorAmbient = Color3.new(1, 1, 1)

	-- Tắt chi tiết địa hình
	local Terrain = workspace.Terrain
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterTransparency = 1
	Terrain.WaterReflectance = 0
	Terrain.WaterColor = Color3.new()

	-- Giảm chất lượng render
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

	-- Xóa/ẩn tất cả hiệu ứng, cây, vật thể phụ
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Beam") then
			obj.Enabled = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
			obj:Destroy()
		elseif obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing") then
			obj:Destroy()
		elseif obj:IsA("MeshPart") or obj:IsA("Part") then
			if obj.Name:lower():find("tree") or obj.Name:lower():find("bush") or obj.Name:lower():find("grass") or obj.Name:lower():find("leaf") then
				obj:Destroy()
			end
		end
	end

	-- Ẩn toàn bộ BasePart phụ (không ảnh hưởng map chính)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
			obj.Material = Enum.Material.SmoothPlastic
			obj.Transparency = 0.5
			obj.CastShadow = false
		end
	end

	btn.Text = "✅ Đã bật FixLag mạnh nhất"
	btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
end)
