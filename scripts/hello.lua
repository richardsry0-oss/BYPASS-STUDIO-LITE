-- Zyo Control Hub & Core Engine Launcher
-- Keeps the core engine lean and modular, loading the UI Builder dynamically.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
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
main.Size = UDim2.fromOffset(540, 420)
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
title.Text = "ZYO CONTROL HUB - CORE ENGINE"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- UI Builder Shortcut (Loads external ui_builder.lua script)
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
leftPanel.Size = UDim2.new(0, 210, 1, -52)
leftPanel.Position = UDim2.fromOffset(10, 48)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = main

-- Mode Selector
local modes = {"SEARCH", "TOOLS", "SERVERSTORAGE", "SERVERSCRIPTSERVICE"}
local modeIdx = 1

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, 0, 0, 34)
modeBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
modeBtn.BorderSizePixel = 0
modeBtn.Text = "Mode: " .. modes[modeIdx]
modeBtn.TextColor3 = Color3.fromRGB(0, 220, 160)
modeBtn.TextSize = 11
modeBtn.Font = Enum.Font.GothamBold
modeBtn.Parent = leftPanel

Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)

-- Name Filter Box (Only active for SEARCH mode)
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, 0, 0, 32)
nameBox.Position = UDim2.fromOffset(0, 38)
nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
nameBox.BorderSizePixel = 0
nameBox.PlaceholderText = "Search script name..."
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
nameBox.TextSize = 11
nameBox.Font = Enum.Font.Gotham
nameBox.Parent = leftPanel

Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, 0, 0, 36)
scanBtn.Position = UDim2.fromOffset(0, 74)
scanBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
scanBtn.BorderSizePixel = 0
scanBtn.Text = "SCAN ALL SERVICES"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.TextSize = 11
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = leftPanel

Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 6)

local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(1, 0, 0, 36)
convertBtn.Position = UDim2.fromOffset(0, 114)
convertBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 40)
convertBtn.BorderSizePixel = 0
convertBtn.Text = "CONVERT SELECTED"
convertBtn.TextColor3 = Color3.new(1, 1, 1)
convertBtn.TextSize = 11
convertBtn.Font = Enum.Font.GothamBold
convertBtn.Parent = leftPanel

Instance.new("UICorner", convertBtn).CornerRadius = UDim.new(0, 6)

-- Script Scrolling List
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, 0, 1, -180)
listFrame.Position = UDim2.fromOffset(0, 156)
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
rightPanel.Size = UDim2.new(1, -230, 1, -52)
rightPanel.Position = UDim2.fromOffset(220, 48)
rightPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = main

Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 8)

local previewBox = Instance.new("TextBox")
previewBox.Size = UDim2.new(1, -10, 1, -45)
previewBox.Position = UDim2.fromOffset(5, 5)
previewBox.BackgroundTransparency = 1
previewBox.MultiLine = true
previewBox.ClearTextOnFocus = false
previewBox.TextEditable = true
previewBox.Text = "-- Select a script from the scan list to preview source code..."
previewBox.TextColor3 = Color3.fromRGB(200, 200, 220)
previewBox.TextSize = 11
previewBox.Font = Enum.Font.Code
previewBox.TextXAlignment = Enum.TextXAlignment.Left
previewBox.TextYAlignment = Enum.TextYAlignment.Top
previewBox.Parent = rightPanel

-- Copy Source Code Button Inside Right Panel
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -10, 0, 32)
copyBtn.Position = UDim2.new(0, 5, 1, -37)
copyBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 220)
copyBtn.BorderSizePixel = 0
copyBtn.Text = "COPY SOURCE CODE"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 11
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = rightPanel

Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

-- Status Bar at Bottom of Left Panel
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, -22)
status.BackgroundTransparency = 1
status.Text = "Core Engine active. Ready."
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

local function isCore(obj)
    local cur = obj
    while cur and cur ~= game do
        if cur.Name == "CorePackages" or cur.Name == "CoreGui" or cur.ClassName == "CoreGui" then return true end
        cur = cur.Parent
    end
    return false
end

modeBtn.Activated:Connect(function()
    modeIdx = modeIdx % #modes + 1
    modeBtn.Text = "Mode: " .. modes[modeIdx]
    nameBox.Visible = (modes[modeIdx] == "SEARCH")
end)

local function executeScan()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local scannedCount = 0
    local mode = modes[modeIdx]
    
    local function addScriptButton(descendant)
        scannedCount += 1
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 36)
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
            local sourceFound = false
            
            if not sourceFound and getscriptsource then
                local ok, res = pcall(getscriptsource, descendant)
                if ok and res and type(res) == "string" and res ~= "" then
                    code = res
                    sourceFound = true
                end
            end
            
            if not sourceFound and decompile then
                local ok, res = pcall(decompile, descendant)
                if ok and res and type(res) == "string" and res ~= "" then
                    code = res
                    sourceFound = true
                end
            end
            
            if not sourceFound then
                local altFuncs = {"get_script_source", "GetScriptSource", "dump_bytecode", "getscriptbytecode"}
                for _, funcName in ipairs(altFuncs) do
                    if _G[funcName] then
                        local ok, res = pcall(_G[funcName], descendant)
                        if ok and res and type(res) == "string" and res ~= "" then
                            code = "-- [Extracted via " .. funcName .. "]\n" .. res
                            sourceFound = true
                            break
                        end
                    end
                end
            end
            
            previewBox.Text = sourceFound and code or "-- [!] Decompilation or source retrieval failed (Protected/Server-side)."
        end)
    end
    
    if mode == "SEARCH" then
        local query = nameBox.Text:lower()
        local servicesToScan = {Workspace, ReplicatedStorage, ServerStorage, ServerScriptService, StarterGui, StarterPlayer, Lighting}
        for _, service in ipairs(servicesToScan) do
            pcall(function()
                for _, descendant in ipairs(service:GetDescendants()) do
                    if not isCore(descendant) and (descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript")) then
                        if query == "" or descendant.Name:lower():find(query, 1, true) then
                            addScriptButton(descendant)
                        end
                    end
                end
            end)
        end
    elseif mode == "TOOLS" then
        pcall(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Tool") then
                    for _, c in ipairs(v:GetDescendants()) do
                        if c:IsA("Script") or c:IsA("LocalScript") or c:IsA("ModuleScript") then
                            addScriptButton(c)
                        end
                    end
                end
            end
        end)
    elseif mode == "SERVERSTORAGE" then
        pcall(function()
            for _, v in ipairs(ServerStorage:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    addScriptButton(v)
                end
            end
        end)
    elseif mode == "SERVERSCRIPTSERVICE" then
        pcall(function()
            for _, v in ipairs(ServerScriptService:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    addScriptButton(v)
                end
            end
        end)
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    status.Text = "Scanned " .. scannedCount .. " scripts."
end

scanBtn.Activated:Connect(executeScan)

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
    newLocal.Name = selectedScript.Name .. "_Converted"
    
    if setscriptsource then
        pcall(setscriptsource, newLocal, sourceCode)
    end
    
    newLocal.Parent = selectedScript.Parent or player:WaitForChild("Backpack")
    status.Text = "Converted script injected successfully!"
end)

copyBtn.Activated:Connect(function()
    if setclipboard then
        setclipboard(previewBox.Text)
        copyBtn.Text = "COPIED TO CLIPBOARD!"
        task.wait(1.5)
        copyBtn.Text = "COPY SOURCE CODE"
    end
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
            local newW = math.clamp(startSize.X.Offset + delta.X, 440, 950)
            local newH = math.clamp(startSize.Y.Offset + delta.Y, 320, 750)
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

print("[Zyo Control Hub] Core Engine loaded successfully.")
