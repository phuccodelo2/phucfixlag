-- ✅ Thông báo khởi động
game.StarterGui:SetCore("SendNotification", {
    Title = "phucmaxnhattrai",
    Text = "Đã khởi động thành công!",
    Duration = 5
})

-- 🖼️ Tạo UI logo
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PhucMaxFruitAuto"
gui.ResetOnSpawn = false

local logo = Instance.new("Frame", gui)
logo.Size = UDim2.new(0, 250, 0, 50)
logo.Position = UDim2.new(0.5, -125, 0, 30)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logo.BorderSizePixel = 0
local corner = Instance.new("UICorner", logo)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", logo)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(245, 223, 179)}
local index = 1
coroutine.wrap(function()
	while true do
		stroke.Color = colors[index]
		index = index % #colors + 1
		wait(0.3)
	end
end)()

local label = Instance.new("TextLabel", logo)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "PhucMax Auto Nhặt Trái"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.TextScaled = true

-- 🚀 Bay & Noclip giữ độ cao
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity = Vector3.new(0, 0, 0)
BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * math.huge

local function enableFly()
	local hrp = player.Character:WaitForChild("HumanoidRootPart")
	BodyVelocity.Parent = hrp
	while BodyVelocity and hrp do
		BodyVelocity.Velocity = Vector3.new(0, 0, 0)
		hrp.Velocity = Vector3.new(0, 0, 0)
		hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.1, 0)
		wait()
	end
end

coroutine.wrap(enableFly)()

-- 🚪 Noclip
game:GetService("RunService").Stepped:Connect(function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- 🍎 Auto nhặt trái
function getFruits()
	local fruits = {}
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Tool") and string.find(v.Name:lower(), "fruit") then
			table.insert(fruits, v)
		end
	end
	return fruits
end

function teleportToFruit(fruit)
	local hrp = player.Character:WaitForChild("HumanoidRootPart")
	hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0, 2, 0)
end

function storeFruit()
	local Backpack = player:WaitForChild("Backpack")
	for _,v in pairs(Backpack:GetChildren()) do
		if v:IsA("Tool") and string.find(v.Name:lower(), "fruit") then
			v.Parent = player:WaitForChild("StarterGear")
		end
	end
end

function espFruit(fruit)
	local billboard = Instance.new("BillboardGui", fruit)
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.Adornee = fruit.Handle
	billboard.AlwaysOnTop = true

	local text = Instance.new("TextLabel", billboard)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.Text = fruit.Name .. " - " .. math.floor((player.Character.HumanoidRootPart.Position - fruit.Position).Magnitude) .. "m"
	text.TextColor3 = Color3.new(1,1,0)
	text.BackgroundTransparency = 1
	text.TextScaled = true
end

function hopServer()
	local Http = game:GetService("HttpService")
	local tp = game:GetService("TeleportService")
	local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
	for _,v in pairs(servers.data) do
		if v.id ~= game.JobId then
			tp:TeleportToPlaceInstance(game.PlaceId, v.id, player)
			break
		end
	end
end

-- 🧠 Auto logic
while wait(3) do
	local fruits = getFruits()
	if #fruits > 0 then
		for _, fruit in pairs(fruits) do
			espFruit(fruit)
			teleportToFruit(fruit)
			wait(1)
			storeFruit()
			wait(2)
		end
	else
		hopServer()
	end
end
