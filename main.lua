-- Script fix lag by phucfixlag
-- Logo: Việt Nam 30/4

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Explosion") then
        v:Destroy()
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and v:IsA("MeshPart") == false then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
    end
end

game.Lighting:ClearAllChildren()
game.Lighting.GlobalShadows = false
game.Lighting.FogEnd = math.huge
settings().Rendering.QualityLevel = "Level01"

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Terrain") then
        v.WaterWaveSize = 0
        v.WaterWaveSpeed = 0
        v.WaterReflectance = 0
        v.WaterTransparency = 0
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Decal") then
        v:Destroy()
    end
end
