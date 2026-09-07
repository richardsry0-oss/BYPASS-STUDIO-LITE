-- Zyo Control Hub & Universal Backpack Tool Script Converter
-- Scans tools in backpack, extracts source code, and converts server scripts to local scripts.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 310)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 70)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
topBar.BorderSizePixel = 0
topBar.Parent = main

Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local fixCover = Instance.new("Frame")
fixCover.Size = UDim2.new(1, 0, 0, 10)
fixCover.Position = UDim2.new(0, 0, 1, -10)
fixCover.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
fixCover.BorderSizePixel = 0
fixCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "ZYO CONTROL HUB"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Convert Tools Button
local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(1, -30, 0, 42)
convertBtn.Position = UDim2.fromOffset(15, 55)
convertBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 40)
convertBtn.BorderSizePixel = 0
convertBtn.Text = "CONVERT BACKPACK TOOLS"
convertBtn.TextColor3 = Color3.new(1, 1, 1)
convertBtn.TextSize = 12
convertBtn.Font = Enum.Font.GothamBold
convertBtn.Parent = main

Instance.new("UICorner", convertBtn).CornerRadius = UDim.new(0, 8)

-- Launch UI Builder Shortcut Button
local uiBuilderBtn = Instance.new("TextButton")
uiBuilderBtn.Size = UDim2.new(1, -30, 0, 40)
uiBuilderBtn.Position = UDim2.fromOffset(15, 105)
uiBuilderBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
uiBuilderBtn.BorderSizePixel = 0
uiBuilderBtn.Text = "OPEN UI COMPONENT BUILDER"
uiBuilderBtn.TextColor3 = Color3.new(1, 1, 1)
uiBuilderBtn.TextSize = 12
uiBuilderBtn.Font = Enum.Font.GothamBold
uiBuilderBtn.Parent = main

Instance.new("UICorner", uiBuilderBtn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 30)
status.Position = UDim2.fromOffset(15, 155)
status.BackgroundTransparency = 1
status.Text = "Ready to scan backpack tools."
status.TextColor3 = Color3.fromRGB(160, 160, 180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextWrapped = true
status.Parent = main

uiBuilderBtn.Activated:Connect(function()
    local successBuilder = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zyoriofficial/BYPASS-STUDIO-LITE/main/scripts/ui_builder.lua"))()
    end)
    if successBuilder then
        status.Text = "UI Builder loaded successfully."
        status.TextColor3 = Color3.fromRGB(80, 240, 140)
    else
        status.Text = "Failed to load UI Builder."
        status.TextColor3 = Color3.fromRGB(240, 80, 80)
    end
end)

convertBtn.Activated:Connect(function()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then
        status.Text = "Backpack not found!"
        status.TextColor3 = Color3.fromRGB(240, 80, 80)
        return
    end

    local convertedCount = 0

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            for _, child in ipairs(item:GetChildren()) do
                if child:IsA("Script") then
                    local sourceCode = ""
                    
                    if getscriptsource then
                        local ok, res = pcall(getscriptsource, child)
                        if ok and res then sourceCode = res end
                    end
                    
                    if (not sourceCode or sourceCode == "") and decompile then
                        local ok, res = pcall(decompile, child)
                        if ok and res then sourceCode = res end
                    end

                    if sourceCode ~= "" then
                        local localScript = Instance.new("LocalScript")
                        localScript.Name = child.Name .. "_Local"
                        
                        if setscriptsource then
                            pcall(setscriptsource, localScript, sourceCode)
                        end
                        
                        localScript.Parent = item
                        child:Destroy()
                        convertedCount += 1
                    end
                end
            end
        end
    end

    if convertedCount > 0 then
        status.Text = "Converted " .. convertedCount .. " script(s) in tools!"
        status.TextColor3 = Color3.fromRGB(80, 240, 140)
    else
        status.Text = "No script found in tools or failed to extract."
        status.TextColor3 = Color3.fromRGB(240, 180, 80)
    end
end)

-- Draggable implementation for Main Hub window
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
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
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[Zyo Control Hub] Loaded successfully.")
