-- Zyo Main Control Hub & Studio Toolkit
-- Combines Script Inspector and UI Component Builder into an unified control panel.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

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

-- Main Hub Panel
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 290)
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

-- Top Bar (Draggable)
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

-- Module Selector Modes
local modes = {"SEARCH", "TOOLS", "SERVERSTORAGE", "SERVERSCRIPTSERVICE"}
local modeIdx = 1

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, -30, 0, 38)
modeBtn.Position = UDim2.fromOffset(15, 52)
modeBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
modeBtn.BorderSizePixel = 0
modeBtn.Text = "Inspector Mode: " .. modes[modeIdx]
modeBtn.TextColor3 = Color3.fromRGB(0, 220, 160)
modeBtn.TextSize = 12
modeBtn.Font = Enum.Font.GothamBold
modeBtn.Parent = main

Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -30, 0, 38)
nameBox.Position = UDim2.fromOffset(15, 98)
nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
nameBox.BorderSizePixel = 0
nameBox.PlaceholderText = "Enter script name query..."
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
nameBox.TextSize = 12
nameBox.Font = Enum.Font.Gotham
nameBox.Parent = main

Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -30, 0, 42)
scanBtn.Position = UDim2.fromOffset(15, 144)
scanBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 220)
scanBtn.BorderSizePixel = 0
scanBtn.Text = "RUN SCRIPT INSPECTOR"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.TextSize = 12
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = main

Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 8)

-- Launch UI Builder Shortcut Button
local uiBuilderBtn = Instance.new("TextButton")
uiBuilderBtn.Size = UDim2.new(1, -30, 0, 40)
uiBuilderBtn.Position = UDim2.fromOffset(15, 194)
uiBuilderBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
uiBuilderBtn.BorderSizePixel = 0
uiBuilderBtn.Text = "OPEN UI COMPONENT BUILDER"
uiBuilderBtn.TextColor3 = Color3.new(1, 1, 1)
uiBuilderBtn.TextSize = 12
uiBuilderBtn.Font = Enum.Font.GothamBold
uiBuilderBtn.Parent = main

Instance.new("UICorner", uiBuilderBtn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 24)
status.Position = UDim2.fromOffset(15, 246)
status.BackgroundTransparency = 1
status.Text = "Hub Active. Ready."
status.TextColor3 = Color3.fromRGB(160, 160, 180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

modeBtn.Activated:Connect(function()
    modeIdx = modeIdx % #modes + 1
    modeBtn.Text = "Inspector Mode: " .. modes[modeIdx]
    nameBox.Visible = (modeIdx == 1)
end)

uiBuilderBtn.Activated:Connect(function()
    -- Load UI Builder script dynamically
    local successBuilder, err = pcall(function()
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

---------------------------------------------------------
-- RESULTS WINDOW
---------------------------------------------------------
local resultsFrame = Instance.new("Frame")
resultsFrame.Size = UDim2.fromOffset(380, 340)
resultsFrame.Position = UDim2.fromScale(0.5, 0.5)
resultsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
resultsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
resultsFrame.BorderSizePixel = 0
resultsFrame.Visible = false
resultsFrame.Parent = gui

Instance.new("UICorner", resultsFrame).CornerRadius = UDim.new(0, 12)

local resTop = Instance.new("Frame")
resTop.Size = UDim2.new(1, 0, 0, 40)
resTop.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
resTop.BorderSizePixel = 0
resTop.Parent = resultsFrame

Instance.new("UICorner", resTop).CornerRadius = UDim.new(0, 12)

local resTitle = Instance.new("TextLabel")
resTitle.Size = UDim2.new(1, -50, 1, 0)
resTitle.Position = UDim2.fromOffset(12, 0)
resTitle.BackgroundTransparency = 1
resTitle.Text = "SCRIPT RESULTS"
resTitle.TextColor3 = Color3.new(1, 1, 1)
resTitle.Font = Enum.Font.GothamBold
resTitle.TextSize = 12
resTitle.TextXAlignment = Enum.TextXAlignment.Left
resTitle.Parent = resTop

local closeRes = Instance.new("TextButton")
closeRes.Size = UDim2.fromOffset(28, 28)
closeRes.Position = UDim2.new(1, -34, 0.5, -14)
closeRes.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeRes.Text = "X"
closeRes.TextColor3 = Color3.new(1, 1, 1)
closeRes.Font = Enum.Font.GothamBold
closeRes.TextSize = 11
closeRes.Parent = resTop

Instance.new("UICorner", closeRes).CornerRadius = UDim.new(0, 6)
closeRes.Activated:Connect(function() resultsFrame.Visible = false end)

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 1, -55)
scrolling.Position = UDim2.fromOffset(10, 48)
scrolling.BackgroundTransparency = 1
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.ScrollBarThickness = 4
scrolling.Parent = resultsFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrolling

---------------------------------------------------------
-- CODE VIEWER WINDOW
---------------------------------------------------------
local codeFrame = Instance.new("Frame")
codeFrame.Size = UDim2.fromOffset(400, 360)
codeFrame.Position = UDim2.fromScale(0.5, 0.5)
codeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
codeFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
codeFrame.BorderSizePixel = 0
codeFrame.Visible = false
codeFrame.Parent = gui

Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 12)

local codeTop = Instance.new("Frame")
codeTop.Size = UDim2.new(1, 0, 0, 40)
codeTop.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
codeTop.BorderSizePixel = 0
codeTop.Parent = codeFrame

Instance.new("UICorner", codeTop).CornerRadius = UDim.new(0, 12)

local codeTitle = Instance.new("TextLabel")
codeTitle.Size = UDim2.new(1, -50, 1, 0)
codeTitle.Position = UDim2.fromOffset(12, 0)
codeTitle.BackgroundTransparency = 1
codeTitle.Text = "CODE PREVIEW"
codeTitle.TextColor3 = Color3.new(1, 1, 1)
codeTitle.Font = Enum.Font.GothamBold
codeTitle.TextSize = 12
codeTitle.TextXAlignment = Enum.TextXAlignment.Left
codeTitle.Parent = codeTop

local closeCode = Instance.new("TextButton")
closeCode.Size = UDim2.fromOffset(28, 28)
closeCode.Position = UDim2.new(1, -34, 0.5, -14)
closeCode.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeCode.Text = "X"
closeCode.TextColor3 = Color3.new(1, 1, 1)
closeCode.Font = Enum.Font.GothamBold
closeCode.TextSize = 11
closeCode.Parent = codeTop

Instance.new("UICorner", closeCode).CornerRadius = UDim.new(0, 6)
closeCode.Activated:Connect(function() codeFrame.Visible = false end)

local codeScroll = Instance.new("ScrollingFrame")
codeScroll.Size = UDim2.new(1, -20, 1, -100)
codeScroll.Position = UDim2.fromOffset(10, 48)
codeScroll.BackgroundTransparency = 1
codeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
codeScroll.ScrollBarThickness = 4
codeScroll.Parent = codeFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, 0, 1, 0)
codeBox.BackgroundTransparency = 1
codeBox.MultiLine = true
codeBox.TextEditable = false
codeBox.Text = "-- Select a script..."
codeBox.TextColor3 = Color3.fromRGB(210, 210, 230)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 11
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Parent = codeScroll

local currentSrc = ""
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -20, 0, 38)
copyBtn.Position = UDim2.new(0, 10, 1, -45)
copyBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
copyBtn.Text = "COPY SOURCE CODE"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = codeFrame

Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

copyBtn.Activated:Connect(function()
    if setclipboard then
        setclipboard(currentSrc)
        copyBtn.Text = "COPIED SUCCESSFULLY!"
        task.wait(1.5)
        copyBtn.Text = "COPY SOURCE CODE"
    end
end)

local function isCore(obj)
    local cur = obj
    while cur and cur ~= game do
        if cur.Name == "CorePackages" or cur.Name == "CoreGui" or cur.ClassName == "CoreGui" then return true end
        cur = cur.Parent
    end
    return false
end

local function getPath(obj)
    local t = {} local cur = obj
    while cur and cur ~= game do table.insert(t, 1, cur.Name) cur = cur.Parent end
    return table.concat(t, ".")
end

scanBtn.Activated:Connect(function()
    for _, v in ipairs(scrolling:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local count = 0
    local mode = modes[modeIdx]

    local function addItem(inst)
        count += 1
        local item = Instance.new("TextButton", scrolling)
        item.Size = UDim2.new(1, -4, 0, 48)
        item.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
        item.Text = ""
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", item)
        lbl.Size = UDim2.new(1, -12, 1, 0)
        lbl.Position = UDim2.fromOffset(6, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = inst.Name .. " [" .. inst.ClassName .. "]\n" .. getPath(inst)
        lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.TextWrapped = true

        item.Activated:Connect(function()
            codeTitle.Text = "PREVIEW: " .. inst.Name
            local ok, res = pcall(function()
                if getscriptsource then local s = getscriptsource(inst) if s and s ~= "" then return s end end
                if decompile then local d = decompile(inst) if d and d ~= "" then return d end end
                return "--[[\nBytecode protection or source unavailable.\n]]--"
            end)
            currentSrc = (ok and res) or "--[[\nExtraction error.\n]]--"
            codeBox.Text = currentSrc
            codeFrame.Visible = true
        end)
    end

    if mode == "SEARCH" then
        local query = nameBox.Text:lower()
        for _, v in ipairs(game:GetDescendants()) do
            if not isCore(v) and (v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript")) then
                if query == "" or v.Name:lower():find(query, 1, true) then addItem(v) end
            end
        end
    elseif mode == "TOOLS" then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Tool") then
                for _, c in ipairs(v:GetDescendants()) do
                    if c:IsA("Script") or c:IsA("LocalScript") or c:IsA("ModuleScript") then addItem(c) end
                end
            end
        end
    elseif mode == "SERVERSTORAGE" then
        for _, v in ipairs(ServerStorage:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then addItem(v) end
        end
    elseif mode == "SERVERSCRIPTSERVICE" then
        for _, v in ipairs(ServerScriptService:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then addItem(v) end
        end
    end

    scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    resTitle.Text = "RESULTS (" .. count .. ")"
    resultsFrame.Visible = true
    status.Text = "Found " .. count .. " script(s)."
    status.TextColor3 = Color3.fromRGB(80, 240, 140)
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
