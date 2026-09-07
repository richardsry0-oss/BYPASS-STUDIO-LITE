-- Zyo Control Hub & Advanced Script Explorer / Decompiler
-- Features: Global service scanning (excluding CorePackages), script source preview, resizing, and conversion tools.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
if not player then return end

local success, container = pcall(function()
    return (RunService:IsStudio() and player:WaitForChild("PlayerGui")) or CoreGui
end)
local targetParent = success and container or player:WaitForChild("PlayerGui")

local oldGui = targetParent:FindFirstChild("ZyoMainHub")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoMainHub"
gui.ResetOnSpawn = false
gui.Parent = targetParent

-- Main Window (Resizable & Draggable)
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 400)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 85)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
topBar.BorderSizePixel = 0
topBar.Parent = main

Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local fixCover = Instance.new("Frame")
fixCover.Size = UDim2.new(1, 0, 0, 10)
fixCover.Position = UDim2.new(0, 0, 1, -10)
fixCover.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
fixCover.BorderSizePixel = 0
fixCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -130, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "ZYO CONTROL HUB - SYSTEM ENGINE"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- UI Builder Shortcut
local uiBuilderBtn = Instance.new("TextButton")
uiBuilderBtn.Size = UDim2.fromOffset(110, 28)
uiBuilderBtn.Position = UDim2.new(1, -120, 0.5, -14)
uiBuilderBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 200)
uiBuilderBtn.BorderSizePixel = 0
uiBuilderBtn.Text = "UI BUILDER"
uiBuilderBtn.TextColor3 = Color3.new(1, 1, 1)
uiBuilderBtn.TextSize = 10
uiBuilderBtn.Font = Enum.Font.GothamBold
uiBuilderBtn.Parent = topBar

Instance.new("UICorner", uiBuilderBtn).CornerRadius = UDim.new(0, 6)

-- Left Panel: Controls & Scan Options
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 200, 1, -52)
leftPanel.Position = UDim2.fromOffset(10, 48)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = main

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, 0, 0, 38)
scanBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
scanBtn.BorderSizePixel = 0
scanBtn.Text = "SCAN ALL SERVICES"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.TextSize = 11
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = leftPanel

Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 8)

local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(1, 0, 0, 38)
convertBtn.Position = UDim2.fromOffset(0, 44)
convertBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 40)
convertBtn.BorderSizePixel = 0
convertBtn.Text = "CONVERT SELECTED"
convertBtn.TextColor3 = Color3.new(1, 1, 1)
convertBtn.TextSize = 11
convertBtn.Font = Enum.Font.GothamBold
convertBtn.Parent = leftPanel

Instance.new("UICorner", convertBtn).CornerRadius = UDim.new(0, 8)

-- Script Scrolling List
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, 0, 1, -92)
listFrame.Position = UDim2.fromOffset(0, 88)
listFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 4
listFrame.Parent = leftPanel

Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = listFrame

-- Right Panel: Script Preview / Source Code View
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -220, 1, -52)
rightPanel.Position = UDim2.fromOffset(210, 48)
rightPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = main

Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 8)

local previewBox = Instance.new("TextBox")
previewBox.Size = UDim2.new(1, -10, 1, -10)
previewBox.Position = UDim2.fromOffset(5, 5)
previewBox.BackgroundTransparency = 1
previewBox.MultiLine = true
previewBox.ClearTextOnFocus = false
previewBox.TextEditable = true
previewBox.Text = "-- Select a script from the deep scan list to preview source code..."
previewBox.TextColor3 = Color3.fromRGB(200, 200, 220)
previewBox.TextSize = 11
previewBox.Font = Enum.Font.Code
previewBox.TextXAlignment = Enum.TextXAlignment.Left
previewBox.TextYAlignment = Enum.TextYAlignment.Top
previewBox.Parent = rightPanel

-- Status Bar
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, -22)
status.BackgroundTransparency = 1
status.Text = "System initialized. Ready."
status.TextColor3 = Color3.fromRGB(150, 150, 170)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = leftPanel

-- Resize Handle
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.fromOffset(16, 16)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
resizeHandle.BorderSizePixel = 0
resizeHandle.Text = ""
resizeHandle.Parent = main

Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

local selectedScript = nil

-- Deep Scan Function (Excluding CorePackages / CoreGui)
local function deepScan()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local scannedCount = 0
    local servicesToScan = {Workspace, ReplicatedStorage, ServerStorage, StarterGui, StarterPlayer, Lighting}
    
    local function inspectInstance(inst)
        pcall(function()
            for _, descendant in ipairs(inst:GetChildren()) do
                if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    scannedCount += 1
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -4, 0, 32)
                    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
                    btn.BorderSizePixel = 0
                    btn.Text = " [" .. descendant.ClassName .. "] " .. descendant.Name
                    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
                    btn.TextSize = 10
                    btn.Font = Enum.Font.Gotham
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = listFrame
                    
                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                    
                    btn.Activated:Connect(function()
                        selectedScript = descendant
                        status.Text = "Loaded: " .. descendant.Name
                        
                        local code = ""
                        if getscriptsource then
                            local ok, res = pcall(getscriptsource, descendant)
                            if ok and res then code = res end
                        end
                        if (not code or code == "") and decompile then
                            local ok, res = pcall(decompile, descendant)
                            if ok and res then code = res end
                        end
                        
                        previewBox.Text = code ~= "" and code or "-- [!] Decompilation or source retrieval failed."
                    end)
                end
                
                if descendant ~= CoreGui and descendant.Name ~= "CorePackages" then
                    inspectInstance(descendant)
                end
            end
        end)
    end
    
    for _, service in ipairs(servicesToScan) do
        inspectInstance(service)
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    status.Text = "Scan completed: " .. scannedCount .. " scripts found."
end

scanBtn.Activated:Connect(deepScan)

convertBtn.Activated:Connect(function()
    if not selectedScript then
        status.Text = "Error: No target script selected."
        return
    end
    
    local sourceCode = previewBox.Text
    if sourceCode == "" or sourceCode:sub(1, 4) == "-- [" then
        status.Text = "Error: Invalid source code buffer."
        return
    end
    
    local newLocal = Instance.new("LocalScript")
    newLocal.Name = selectedScript.Name .. "_Client"
    
    if setscriptsource then
        pcall(setscriptsource, newLocal, sourceCode)
    end
    
    newLocal.Parent = selectedScript.Parent or player:WaitForChild("Backpack")
    status.Text = "Converted script injected successfully!"
end)

uiBuilderBtn.Activated:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zyoriofficial/BYPASS-STUDIO-LITE/main/scripts/ui_builder.lua"))()
    end)
end)

-- Draggable & Resizable Window Logic
local dragging, resizing, dragInput, dragStart, startPos, startSize
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        dragStart = input.Position
        startSize = main.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragInput then
        local delta = dragInput.Position - dragStart
        if dragging then
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif resizing then
            local newW = math.clamp(startSize.X.Offset + delta.X, 400, 900)
            local newH = math.clamp(startSize.Y.Offset + delta.Y, 300, 700)
            main.Size = UDim2.fromOffset(newW, newH)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        resizing = false
    end
end)

print("[Zyo Control Hub] Main System Engine loaded successfully.")
