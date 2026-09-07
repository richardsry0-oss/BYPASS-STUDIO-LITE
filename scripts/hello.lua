-- ZyoDevUI v2.1 (Mobile Optimized) - Advanced Delta Exploitation Toolset
-- Integrated Touch-Friendly Dragging, Resizing, Fly Toggle, and Floating Open/Close Icon

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then return end

local success, container = pcall(function()
    return (RunService:IsStudio() and player:WaitForChild("PlayerGui")) or CoreGui
end)
local targetParent = success and container or player:WaitForChild("PlayerGui")

local oldGui = targetParent:FindFirstChild("ZyoDevUI")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoDevUI"
gui.ResetOnSpawn = false
gui.Parent = targetParent

-- Main Window Frame (Sized well for mobile screens)
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(320, 240)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.Thickness = 1.5
stroke.Parent = frame

-- Top Bar (Draggable Header optimized for touch)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local fixCover = Instance.new("Frame")
fixCover.Size = UDim2.new(1, 0, 0, 10)
fixCover.Position = UDim2.new(0, 0, 1, -10)
fixCover.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
fixCover.BorderSizePixel = 0
fixCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "ZYORI MOBILE UI"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(36, 36)
closeBtn.Position = UDim2.new(1, -42, 0.5, -18)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -45)
contentContainer.Position = UDim2.fromOffset(0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.fromOffset(15, 12)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Systems Nominal"
statusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentContainer

-- Fly Toggle Button (Larger touch target for mobile)
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -30, 0, 52)
flyBtn.Position = UDim2.fromOffset(15, 52)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
flyBtn.Text = "Toggle Fly [ OFF ]"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextSize = 15
flyBtn.Font = Enum.Font.GothamBold
flyBtn.Parent = contentContainer

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 10)
flyCorner.Parent = flyBtn

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(70, 70, 95)
flyStroke.Thickness = 1
flyStroke.Parent = flyBtn

-- Floating Open Button (When UI is closed)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(50, 50)
openBtn.Position = UDim2.new(0, 20, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
openBtn.Text = "ZY"
openBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
openBtn.TextSize = 16
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(0, 255, 150)
openStroke.Thickness = 2
openStroke.Parent = openBtn

-- Resize Handle (Larger touch zone for mobile corner dragging)
local resizeBtn = Instance.new("TextButton")
resizeBtn.Size = UDim2.fromOffset(30, 30)
resizeBtn.Position = UDim2.new(1, -30, 1, -30)
resizeBtn.BackgroundTransparency = 1
resizeBtn.Text = "◢"
resizeBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
resizeBtn.TextSize = 16
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.Parent = frame

---------------------------------------------------------
-- MOBILE TOUCH DRAGGING SYSTEM
---------------------------------------------------------
local dragging, dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

---------------------------------------------------------
-- MOBILE TOUCH RESIZING SYSTEM
---------------------------------------------------------
local resizing, resizeStart, startSize

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        startSize = frame.AbsoluteSize
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

RunService.RenderStepped:Connect(function()
    if resizing and resizeStart then
        local mousePos = UserInputService:GetMouseLocation()
        local newWidth = math.clamp(startSize.X + (mousePos.X - resizeStart.X), 280, 600)
        local newHeight = math.clamp(startSize.Y + (mousePos.Y - resizeStart.Y), 200, 500)
        frame.Size = UDim2.fromOffset(newWidth, newHeight)
    end
end)

---------------------------------------------------------
-- CLOSE & OPEN TOGGLE
---------------------------------------------------------
closeBtn.Activated:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

openBtn.Activated:Connect(function()
    openBtn.Visible = false
    frame.Visible = true
end)

---------------------------------------------------------
-- MOBILE FLIGHT ENGINE (Touch-Compatible Hover)
---------------------------------------------------------
local flying = false
local flySpeed = 50
local bg, bv, renderConnection

local function getRoot()
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end
    return nil
end

local function toggleFly(state)
    flying = state
    local root = getRoot()
    
    if flying then
        flyBtn.Text = "Toggle Fly [ ON ]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
        statusLabel.Text = "Status: Flight Active"
        
        if not root then return end
        
        bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        bg.Parent = root
        
        bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.zero
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        
        renderConnection = RunService.RenderStepped:Connect(function()
            local currRoot = getRoot()
            local camera = workspace.CurrentCamera
            if not flying or not currRoot or not currRoot.Parent then
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                if renderConnection then renderConnection:Disconnect() end
                return
            end
            
            -- On mobile without standard keyboard controls, fly forward based on Camera look vector when active
            local moveDir = camera.CFrame.LookVector
            bv.velocity = moveDir * flySpeed
            bg.cframe = camera.CFrame
        end)
    else
        flyBtn.Text = "Toggle Fly [ OFF ]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        statusLabel.Text = "Status: Flight Disabled"
        
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if renderConnection then renderConnection:Disconnect() end
    end
end

flyBtn.Activated:Connect(function()
    toggleFly(not flying)
end)

print("[ZyoUI Mobile] Loaded successfully.")
