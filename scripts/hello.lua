-- Zyo Script Scanner Pro+ (Mode Selector & Instant Tool Inspector)
-- Switch between searching by name or instantly inspecting all Tool scripts across services.

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

local oldGui = targetParent:FindFirstChild("ZyoScriptScannerProPlus")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoScriptScannerProPlus"
gui.ResetOnSpawn = false
gui.Parent = targetParent

-- Main Window Frame
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(340, 255)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

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

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

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
title.Text = "ZYO SCRIPT INSPECTOR"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Mode Select Button (Toggle between Search Name & Instant Tools)
local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(1, -30, 0, 38)
modeButton.Position = UDim2.fromOffset(15, 52)
modeButton.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
modeButton.BorderSizePixel = 0
modeButton.Text = "Mode: SEARCH BY NAME"
modeButton.TextColor3 = Color3.fromRGB(0, 220, 160)
modeButton.TextSize = 13
modeButton.Font = Enum.Font.GothamBold
modeButton.Parent = main

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 8)
modeCorner.Parent = modeButton

-- Input Name Box (Used in Name Search mode)
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -30, 0, 40)
nameBox.Position = UDim2.fromOffset(15, 98)
nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
nameBox.BorderSizePixel = 0
nameBox.PlaceholderText = "Enter script name..."
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
nameBox.TextSize = 13
nameBox.Font = Enum.Font.Gotham
nameBox.ClearTextOnFocus = false
nameBox.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = nameBox

-- Action Button (Scan / Instant Load)
local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(1, -30, 0, 42)
checkButton.Position = UDim2.fromOffset(15, 146)
checkButton.BackgroundColor3 = Color3.fromRGB(45, 120, 220)
checkButton.BorderSizePixel = 0
checkButton.Text = "CHECK FOR ALL SCRIPTS"
checkButton.TextColor3 = Color3.new(1, 1, 1)
checkButton.TextSize = 13
checkButton.Font = Enum.Font.GothamBold
checkButton.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = checkButton

-- Status Label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 25)
status.Position = UDim2.fromOffset(15, 198)
status.BackgroundTransparency = 1
status.Text = "Ready. Tap Mode to switch to Instant Tools."
status.TextColor3 = Color3.fromRGB(160, 160, 180)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

---------------------------------------------------------
-- RESULTS WINDOW (LIST OF FOUND SCRIPTS)
---------------------------------------------------------
local resultsFrame = Instance.new("Frame")
resultsFrame.Size = UDim2.fromOffset(400, 360)
resultsFrame.Position = UDim2.fromScale(0.5, 0.5)
resultsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
resultsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
resultsFrame.BorderSizePixel = 0
resultsFrame.Visible = false
resultsFrame.Parent = gui

local resultsCorner = Instance.new("UICorner")
resultsCorner.CornerRadius = UDim.new(0, 12)
resultsCorner.Parent = resultsFrame

local resultsStroke = Instance.new("UIStroke")
resultsStroke.Color = Color3.fromRGB(50, 50, 70)
resultsStroke.Thickness = 1.5
resultsStroke.Parent = resultsFrame

local resultsTopBar = Instance.new("Frame")
resultsTopBar.Size = UDim2.new(1, 0, 0, 42)
resultsTopBar.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
resultsTopBar.BorderSizePixel = 0
resultsTopBar.Parent = resultsFrame

local resultsTopCorner = Instance.new("UICorner")
resultsTopCorner.CornerRadius = UDim.new(0, 12)
resultsTopCorner.Parent = resultsTopBar

local resultsFix = Instance.new("Frame")
resultsFix.Size = UDim2.new(1, 0, 0, 10)
resultsFix.Position = UDim2.new(0, 0, 1, -10)
resultsFix.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
resultsFix.BorderSizePixel = 0
resultsFix.Parent = resultsTopBar

local resultsTitle = Instance.new("TextLabel")
resultsTitle.Size = UDim2.new(1, -60, 1, 0)
resultsTitle.Position = UDim2.fromOffset(15, 0)
resultsTitle.BackgroundTransparency = 1
resultsTitle.Text = "SCRIPT RESULTS (0)"
resultsTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
resultsTitle.TextSize = 14
resultsTitle.Font = Enum.Font.GothamBold
resultsTitle.TextXAlignment = Enum.TextXAlignment.Left
resultsTitle.Parent = resultsTopBar

local closeResultsBtn = Instance.new("TextButton")
closeResultsBtn.Size = UDim2.fromOffset(32, 32)
closeResultsBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeResultsBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeResultsBtn.Text = "X"
closeResultsBtn.TextColor3 = Color3.new(1, 1, 1)
closeResultsBtn.TextSize = 13
closeResultsBtn.Font = Enum.Font.GothamBold
closeResultsBtn.Parent = resultsTopBar

local closeResCorner = Instance.new("UICorner")
closeResCorner.CornerRadius = UDim.new(0, 8)
closeResCorner.Parent = closeResultsBtn

closeResultsBtn.Activated:Connect(function()
    resultsFrame.Visible = false
end)

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -30, 1, -60)
scrolling.Position = UDim2.fromOffset(15, 50)
scrolling.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 5
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.Parent = resultsFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrolling

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrolling

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 8)
scrollPadding.PaddingBottom = UDim.new(0, 8)
scrollPadding.PaddingLeft = UDim.new(0, 8)
scrollPadding.PaddingRight = UDim.new(0, 8)
scrollPadding.Parent = scrolling

---------------------------------------------------------
-- CODE VIEWER WINDOW (PREVIEW & COPY)
---------------------------------------------------------
local codeFrame = Instance.new("Frame")
codeFrame.Size = UDim2.fromOffset(420, 380)
codeFrame.Position = UDim2.fromScale(0.5, 0.5)
codeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
codeFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
codeFrame.BorderSizePixel = 0
codeFrame.Visible = false
codeFrame.Parent = gui

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 12)
codeCorner.Parent = codeFrame

local codeStroke = Instance.new("UIStroke")
codeStroke.Color = Color3.fromRGB(50, 50, 70)
codeStroke.Thickness = 1.5
codeStroke.Parent = codeFrame

local codeTopBar = Instance.new("Frame")
codeTopBar.Size = UDim2.new(1, 0, 0, 42)
codeTopBar.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
codeTopBar.BorderSizePixel = 0
codeTopBar.Parent = codeFrame

local codeTopCorner = Instance.new("UICorner")
codeTopCorner.CornerRadius = UDim.new(0, 12)
codeTopCorner.Parent = codeTopBar

local codeFix = Instance.new("Frame")
codeFix.Size = UDim2.new(1, 0, 0, 10)
codeFix.Position = UDim2.new(0, 0, 1, -10)
codeFix.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
codeFix.BorderSizePixel = 0
codeFix.Parent = codeTopBar

local codeTitle = Instance.new("TextLabel")
codeTitle.Size = UDim2.new(1, -60, 1, 0)
codeTitle.Position = UDim2.fromOffset(15, 0)
codeTitle.BackgroundTransparency = 1
codeTitle.Text = "CODE PREVIEW"
codeTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
codeTitle.TextSize = 14
codeTitle.Font = Enum.Font.GothamBold
codeTitle.TextXAlignment = Enum.TextXAlignment.Left
codeTitle.Parent = codeTopBar

local closeCodeBtn = Instance.new("TextButton")
closeCodeBtn.Size = UDim2.fromOffset(32, 32)
closeCodeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeCodeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeCodeBtn.Text = "X"
closeCodeBtn.TextColor3 = Color3.new(1, 1, 1)
closeCodeBtn.TextSize = 13
closeCodeBtn.Font = Enum.Font.GothamBold
closeCodeBtn.Parent = codeTopBar

local closeCodeCorner = Instance.new("UICorner")
closeCodeCorner.CornerRadius = UDim.new(0, 8)
closeCodeCorner.Parent = closeCodeBtn

closeCodeBtn.Activated:Connect(function()
    codeFrame.Visible = false
end)

local codeScrolling = Instance.new("ScrollingFrame")
codeScrolling.Size = UDim2.new(1, -30, 1, -105)
codeScrolling.Position = UDim2.fromOffset(15, 50)
codeScrolling.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
codeScrolling.BorderSizePixel = 0
codeScrolling.ScrollBarThickness = 5
codeScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
codeScrolling.Parent = codeFrame

local codeScrollCorner = Instance.new("UICorner")
codeScrollCorner.CornerRadius = UDim.new(0, 8)
codeScrollCorner.Parent = codeScrolling

local codeText = Instance.new("TextBox")
codeText.Size = UDim2.new(1, -16, 1, -16)
codeText.Position = UDim2.fromOffset(8, 8)
codeText.BackgroundTransparency = 1
codeText.MultiLine = true
codeText.ClearTextOnFocus = false
codeText.TextEditable = false
codeText.Text = "-- Select a script to preview source code..."
codeText.TextColor3 = Color3.fromRGB(210, 210, 230)
codeText.TextSize = 11
codeText.Font = Enum.Font.Code
codeText.TextXAlignment = Enum.TextXAlignment.Left
codeText.TextYAlignment = Enum.TextYAlignment.Top
codeText.Parent = codeScrolling

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -30, 0, 40)
copyButton.Position = UDim2.new(0, 15, 1, -48)
copyButton.BackgroundColor3 = Color3.fromRGB(45, 180, 100)
copyButton.BorderSizePixel = 0
copyButton.Text = "COPY CODE TO CLIPBOARD"
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.TextSize = 13
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = codeFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyButton

local currentSourceCode = ""
copyButton.Activated:Connect(function()
    if setclipboard then
        setclipboard(currentSourceCode)
        copyButton.Text = "COPIED SUCCESSFULLY!"
        task.wait(1.5)
        copyButton.Text = "COPY CODE TO CLIPBOARD"
    else
        copyButton.Text = "Error: setclipboard not supported"
        task.wait(1.5)
        copyButton.Text = "COPY CODE TO CLIPBOARD"
    end
end)

---------------------------------------------------------
-- SCANNING MODES LOGIC
---------------------------------------------------------
local currentMode = "Search" -- "Search" or "Tools"

modeButton.Activated:Connect(function()
    if currentMode == "Search" then
        currentMode = "Tools"
        modeButton.Text = "Mode: INSTANT TOOL SCRIPTS"
        modeButton.TextColor3 = Color3.fromRGB(255, 170, 50)
        nameBox.Visible = false
        checkButton.Text = "LOAD ALL TOOL SCRIPTS"
        status.Text = "Mode: Click to instantly list scripts inside Tools."
    else
        currentMode = "Search"
        modeButton.Text = "Mode: SEARCH BY NAME"
        modeButton.TextColor3 = Color3.fromRGB(0, 220, 160)
        nameBox.Visible = true
        checkButton.Text = "CHECK FOR ALL SCRIPTS"
        status.Text = "Mode: Enter script name and scan."
    end
end)

local function getScriptType(instance)
    if instance:IsA("ModuleScript") then
        return "ModuleScript"
    elseif instance:IsA("LocalScript") then
        return "LocalScript"
    elseif instance:IsA("Script") then
        return "Script"
    end
    return nil
end

local function getPath(instance)
    local parts = {}
    local current = instance
    while current and current ~= game do
        table.insert(parts, 1, current.Name)
        current = current.Parent
    end
    return table.concat(parts, ".")
end

local function clearResults()
    for _, child in ipairs(scrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function addResult(scriptInstance, scriptType)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -5, 0, 52)
    item.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    item.BorderSizePixel = 0
    item.Text = ""
    item.AutoButtonColor = true
    item.Parent = scrolling

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 6)
    itemCorner.Parent = item

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Text = scriptInstance.Name .. " [" .. scriptType .. "]\n" .. getPath(scriptInstance)
    label.TextColor3 = Color3.fromRGB(225, 225, 240)
    label.TextSize = 11
    label.Font = Enum.Font.Code
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = item

    item.Activated:Connect(function()
        codeTitle.Text = "PREVIEW: " .. scriptInstance.Name
        
        local successSource, sourceContent = pcall(function()
            if getscriptsource then
                return getscriptsource(scriptInstance)
            elseif decompile then
                return decompile(scriptInstance)
            else
                return "--[[\nExecutor does not support direct script source retrieval.\n]]--"
            end
        end)
        
        if successSource and sourceContent and sourceContent ~= "" then
            currentSourceCode = sourceContent
        else
            currentSourceCode = "--[[\nUnable to retrieve source code for this script instance.\n]]--"
        end
        
        codeText.Text = currentSourceCode
        codeFrame.Visible = true
    end)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
end)

codeText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    codeScrolling.CanvasSize = UDim2.new(0, 0, 0, codeText.TextBounds.Y + 20)
end)

-- Execute Action Button
checkButton.Activated:Connect(function()
    clearResults()
    local found = 0

    if currentMode == "Search" then
        local searchName = nameBox.Text:gsub("^%s*(.-)%s*$", "%1"):lower()
        for _, instance in ipairs(game:GetDescendants()) do
            local scriptType = getScriptType(instance)
            if scriptType then
                if searchName == "" or instance.Name:lower():find(searchName, 1, true) then
                    addResult(instance, scriptType)
                    found += 1
                end
            end
        end
    elseif currentMode == "Tools" then
        -- Instantly scan specifically inside Tool instances across the game
        for _, instance in ipairs(game:GetDescendants()) do
            if instance:IsA("Tool") then
                for _, child in ipairs(instance:GetDescendants()) do
                    local scriptType = getScriptType(child)
                    if scriptType then
                        addResult(child, scriptType)
                        found += 1
                    end
                end
            end
        end
    end

    resultsTitle.Text = "RESULTS (" .. found .. ")"
    resultsFrame.Visible = true

    if found > 0 then
        status.Text = "Found " .. found .. " script(s)."
        status.TextColor3 = Color3.fromRGB(80, 240, 140)
    else
        status.Text = "No scripts found for this selection."
        status.TextColor3 = Color3.fromRGB(240, 180, 80)
    end
end)

---------------------------------------------------------
-- TOUCH DRAGGING FOR MAIN WINDOW
---------------------------------------------------------
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
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[Zyo Inspector] Loaded successfully.")
