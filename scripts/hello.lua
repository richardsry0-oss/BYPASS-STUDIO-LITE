local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player then
    warn("[ZyoUI] LocalPlayer not available")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("ZyoDevUI")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoDevUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(360, 200)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 10)
title.BackgroundTransparency = 1
title.Text = "Zyo Dev Tool"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = frame

local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -20, 0, 45)
message.Position = UDim2.fromOffset(10, 65)
message.BackgroundTransparency = 1
message.Text = "Hello, Travis!"
message.TextColor3 = Color3.fromRGB(210, 210, 210)
message.TextSize = 18
message.Font = Enum.Font.Gotham
message.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -40, 0, 45)
button.Position = UDim2.fromOffset(20, 125)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.Text = "Click Me"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

button.Activated:Connect(function()
    message.Text = "Button clicked!"
end)

print("[ZyoUI] Loaded successfully")
