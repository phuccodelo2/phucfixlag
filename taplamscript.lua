-- ⬇️ Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- ⬇️ Tạo cửa sổ Fluent
local Window = Fluent:CreateWindow({
    Title = "PHUCMAX HUB",
    SubTitle = "Script Tổng Hợp",
    TabWidth = 150,
    Size = UDim2.fromOffset(560, 360),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.End
})

-- ⬇️ Nút bật/tắt menu (có thể kéo)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGUI"
screenGui.Parent = game.CoreGui

local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Image = "rbxassetid://123394707028201"
toggleButton.BackgroundTransparency = 1
toggleButton.Parent = screenGui

local isFluentVisible = true

-- ⬇️ Kéo nút
local dragging, dragInput, dragStart, startPos
local UserInputService = game:GetService("UserInputService")
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ⬇️ Bấm nút để ẩn/hiện UI
toggleButton.MouseButton1Click:Connect(function()
    isFluentVisible = not isFluentVisible
    Window:Minimize(not isFluentVisible)
end)

-- ⬇️ Khởi tạo tab chính
local MainTab = Window:AddTab({
    Title = "main",
    Icon = "home"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ✅ Nút: Ascend to Floor 1
MainTab:AddButton({
    Title = "Ascend to Floor 1",
    Description = "Chạy script Floor 1 từ GitHub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/tungtung.txt"))()
    end
})

-- ✅ Nút: Ascend to Floor 2
MainTab:AddButton({
    Title = "Ascend to Floor 2",
    Description = "Chạy script Floor 2 từ GitHub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/phuccodelo2/Bot_discord-/refs/heads/main/phucmax_ui.lua"))()
    end
})

-- ✅ Nút: Fall Down
MainTab:AddButton({
    Title = "Fall Down",
    Description = "Dịch chuyển nhân vật xuống 100 đơn vị",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 100, 0) end
    end
})

-- ✅ Nút: Teleport Sky
MainTab:AddButton({
    Title = "Teleport Sky",
    Description = "Dịch chuyển nhân vật lên 200 đơn vị",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0) end
    end
})

-- ✅ Toggle: Godmode
local godConn
MainTab:AddToggle({
    Title = "Godmode",
    Description = "Giữ máu luôn ở mức 100",
    Default = false,
    Callback = function(state)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        if state then
            if godConn then godConn:Disconnect() end
            godConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health < 100 then hum.Health = 100 end
            end)
        else
            if godConn then godConn:Disconnect() godConn = nil end
        end
    end
})

-- ✅ Toggle: Anti-Hit
local dodgeFly = false
MainTab:AddToggle({
    Title = "Anti-Hit",
    Description = "Tự động né lên trên khi có người lại gần",
    Default = false,
    Callback = function(state)
        dodgeFly = state
    end
})

getgenv()._espLock = false

MainTab:AddToggle({
    Title = "ESP Lock (Ẩn)",
    Description = "Kích hoạt ESP nội bộ không hiển thị",
    Default = false,
    Callback = function(state)
        getgenv()._espLock = state
    end
})

MainTab:AddButton({
    Title = "Fly to Locked ESP",
    Description = "Bay đến vị trí đã ESP Lock (ẩn)",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        if not getgenv()._espLock or not getgenv()._espTargetPosition then
            warn("ESP Lock chưa bật hoặc chưa có vị trí lock")
            return
        end

        -- Tele lên cao tránh vướng
        hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 50, 0))

        -- Bắt đầu bay đến mục tiêu
        local speed = 30
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function(dt)
            if not getgenv()._espLock or not getgenv()._espTargetPosition then
                connection:Disconnect()
                return
            end

            local pos = hrp.Position
            local target = getgenv()._espTargetPosition
            local direction = (target - pos).Unit
            local distance = (target - pos).Magnitude

            -- Dừng nếu tới gần mục tiêu
            if distance < 5 then
                connection:Disconnect()
                return
            end

            hrp.Velocity = direction * speed
        end)
    end
})

task.spawn(function()
    while task.wait(0.02) do
        if dodgeFly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LocalPlayer.Character.HumanoidRootPart
            for _, other in pairs(Players:GetPlayers()) do
                if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    local theirHRP = other.Character.HumanoidRootPart
                    if (myHRP.Position - theirHRP.Position).Magnitude < 7 then
                        myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 10, 0)
                        break
                    end
                end
            end
        end
    end
end)

-- ✅ Toggle: Infinite Jump
local jumpConn
MainTab:AddToggle({
    Title = "Infinite Jump",
    Description = "Cho phép nhảy liên tục trên không",
    Default = false,
    Callback = function(state)
        if state then
            if jumpConn then jumpConn:Disconnect() end
            jumpConn = UIS.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char:FindFirstChild("Humanoid"):ChangeState("Jumping")
                end
            end)
        else
            if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        end
    end
})