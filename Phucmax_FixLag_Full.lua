
-- Phucmax FixLag Menu
-- Tối ưu hiệu năng game mạnh mẽ theo từng cấp độ X1 → X5

local function FixLag(level)
    local player = game.Players.LocalPlayer
    local lighting = game:GetService("Lighting")
    local debris = game:GetService("Debris")

    -- Ánh sáng cơ bản
    lighting.GlobalShadows = false
    lighting.FogEnd = 100000
    lighting.Brightness = 0
    lighting.ClockTime = 12

    -- Hạ chất lượng render
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- Tắt hiệu ứng cơ bản
    if level >= 1 then
        for _, desc in pairs(workspace:GetDescendants()) do
            if desc:IsA("Texture") or desc:IsA("Decal") or desc:IsA("Beam") then
                desc.Transparency = 1
            elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") then
                desc:Destroy()
            elseif desc:IsA("SurfaceAppearance") or desc:IsA("ForceField") then
                desc:Destroy()
            elseif desc:IsA("SpotLight") or desc:IsA("PointLight") or desc:IsA("SurfaceLight") then
                desc:Destroy()
            end
        end
    end

    -- X2: Xóa hiệu ứng particle mạnh hơn
    if level >= 2 then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v:Destroy()
            end
        end
    end

    -- X3: Xóa cây, giảm chi tiết
    if level >= 3 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.match(obj.Name:lower(), "tree") then
                obj:Destroy()
            elseif obj:IsA("MeshPart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
        end
    end

    -- X4: Tối ưu toàn bộ map, đổi vật liệu
    if level >= 4 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
        end
    end

    -- X5: Làm tàng hình gần hết map (trừ cây) để tối ưu tối đa
    if level >= 5 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not string.match(obj.Name:lower(), "tree") then
                obj.Transparency = 1
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
                obj.CanCollide = true
                for _, d in pairs(obj:GetChildren()) do
                    if d:IsA("Decal") then
                        d:Destroy()
                    end
                end
            end
        end
    end
end

-- Ví dụ: Gán nút kích hoạt từng cấp
-- Gọi FixLag(1) cho X1, FixLag(2) cho X2, ...
-- FixLag(5) cho X5 max giảm lag
