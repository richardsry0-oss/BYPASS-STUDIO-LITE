-- Zyo UI Builder & Component Generator
-- Generates clean, responsive UI templates (Frames, Buttons, Inputs) inside PlayerGui.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("ZyoUIBuilder")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZyoUIBuilder"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Container Window
local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(300, 360)
window.Position = UDim2.fromScale(0.3, 0.5)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
window.BorderSizePixel = 0
window.Parent = screenGui

Instance.new("UICorner", window).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.Thickness = 1.5
stroke.Parent = window

-- Top Bar Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.fromOffset(0, 0)
title.BackgroundTransparency = 1
title.Text = "ZYO UI COMPONENT BUILDER"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = window

-- Scrolling Panel for Template Buttons
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 1, -60)
scrolling.Position = UDim2.fromOffset(10, 45)
scrolling.BackgroundTransparency = 1
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.ScrollBarThickness = 4
scrolling.Parent = window

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrolling

local function createTemplateButton(name, desc, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = scrolling
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.fromOffset(6, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. "\n" .. desc
    lbl.TextColor3 = Color3.fromRGB(210, 210, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.TextWrapped = true
    lbl.Parent = btn
    
    btn.Activated:Connect(callback)
end

-- 1. Create Notification Toast Template
createTemplateButton("Notification Toast", "Generates a popup notification banner", function()
    local toast = Instance.new("Frame")
    toast.Size = UDim2.fromOffset(240, 45)
    toast.Position = UDim2.new(0.5, -120, 0.1, 0)
    toast.BackgroundColor3 = Color3.fromRGB(35, 180, 100)
    toast.BorderSizePixel = 0
    toast.Parent = screenGui
    
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
    
    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, 0, 1, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = "Action Executed Successfully!"
    tLbl.TextColor3 = Color3.new(1, 1, 1)
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 11
    tLbl.Parent = toast
    
    task.delay(2.5, function()
        if toast then toast:Destroy() end
    end)
end)

-- 2. Create Floating Action Button (FAB)
createTemplateButton("Floating Button", "Creates a draggable circular action trigger", function()
    local fab = Instance.new("TextButton")
    fab.Size = UDim2.fromOffset(50, 50)
    fab.Position = UDim2.new(0.8, 0, 0.7, 0)
    fab.BackgroundColor3 = Color3.fromRGB(45, 120, 220)
    fab.Text = "+"
    fab.TextColor3 = Color3.new(1, 1, 1)
    fab.Font = Enum.Font.GothamBold
    fab.TextSize = 20
    fab.Parent = screenGui
    
    Instance.new("UICorner", fab).CornerRadius = UDim.new(1, 0)
end)

-- 3. Create Toggle Switch Card
createTemplateButton("Card Container", "Generates a styled panel container card", function()
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(220, 140)
    card.Position = UDim2.fromScale(0.6, 0.4)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    card.BorderSizePixel = 0
    card.Parent = screenGui
    
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local cTitle = Instance.new("TextLabel")
    cTitle.Size = UDim2.new(1, -20, 0, 30)
    cTitle.Position = UDim2.fromOffset(10, 10)
    cTitle.BackgroundTransparency = 1
    cTitle.Text = "Sample Panel Card"
    cTitle.TextColor3 = Color3.new(1, 1, 1)
    cTitle.Font = Enum.Font.GothamBold
    cTitle.TextSize = 12
    cTitle.TextXAlignment = Enum.TextXAlignment.Left
    cTitle.Parent = card
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

print("[Zyo UI Builder] Loaded successfully.")
