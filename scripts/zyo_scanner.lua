-- Zyo Script Scanner
-- Scans the client-visible game hierarchy for Script, LocalScript,
-- and ModuleScript instances matching the entered name.

local Players = game:GetService("Players")

local player = Players.LocalPlayer
if not player then
    warn("[Zyo Scanner] LocalPlayer not available.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

-- Prevent duplicates when reloading
local oldGui = playerGui:FindFirstChild("ZyoScriptScanner")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoScriptScanner"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main window
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330, 190)
main.Position = UDim2.new(0.5, -165, 0.5, -95)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 35)
title.Position = UDim2.fromOffset(15, 8)
title.BackgroundTransparency = 1
title.Text = "ZYO SCRIPT SCANNER"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Name box
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -30, 0, 40)
nameBox.Position = UDim2.fromOffset(15, 50)
nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
nameBox.BorderSizePixel = 0
nameBox.PlaceholderText = "Script name (example: MyScript)"
nameBox.Text = ""
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 145)
nameBox.TextSize = 13
nameBox.Font = Enum.Font.Gotham
nameBox.ClearTextOnFocus = false
nameBox.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 7)
boxCorner.Parent = nameBox

-- Check button
local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(1, -30, 0, 40)
checkButton.Position = UDim2.fromOffset(15, 100)
checkButton.BackgroundColor3 = Color3.fromRGB(45, 120, 210)
checkButton.BorderSizePixel = 0
checkButton.Text = "CHECK FOR ALL SCRIPTS"
checkButton.TextColor3 = Color3.new(1, 1, 1)
checkButton.TextSize = 13
checkButton.Font = Enum.Font.GothamBold
checkButton.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 7)
buttonCorner.Parent = checkButton

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 25)
status.Position = UDim2.fromOffset(15, 150)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(160, 160, 180)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

-- Results window
local resultsFrame = Instance.new("Frame")
resultsFrame.Size = UDim2.fromOffset(380, 330)
resultsFrame.Position = UDim2.new(0.5, -190, 0.5, -165)
resultsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
resultsFrame.BorderSizePixel = 0
resultsFrame.Visible = false
resultsFrame.Parent = gui

local resultsCorner = Instance.new("UICorner")
resultsCorner.CornerRadius = UDim.new(0, 10)
resultsCorner.Parent = resultsFrame

-- Results title
local resultsTitle = Instance.new("TextLabel")
resultsTitle.Size = UDim2.new(1, -60, 0, 40)
resultsTitle.Position = UDim2.fromOffset(15, 5)
resultsTitle.BackgroundTransparency = 1
resultsTitle.Text = "SCRIPT RESULTS"
resultsTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
resultsTitle.TextSize = 14
resultsTitle.Font = Enum.Font.GothamBold
resultsTitle.TextXAlignment = Enum.TextXAlignment.Left
resultsTitle.Parent = resultsFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(35, 35)
closeButton.Position = UDim2.new(1, -43, 0, 7)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 55)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = resultsFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeButton

closeButton.Activated:Connect(function()
    resultsFrame.Visible = false
end)

-- Scrolling results
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -30, 1, -60)
scrolling.Position = UDim2.fromOffset(15, 50)
scrolling.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 5
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.Parent = resultsFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 7)
scrollCorner.Parent = scrolling

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scrolling

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = scrolling

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
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function addResult(instance)
    local scriptType = getScriptType(instance)

    if not scriptType then
        return
    end

    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -5, 0, 55)
    item.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    item.BorderSizePixel = 0
    item.Text = instance.Name
        .. " [" .. scriptType .. "]\n"
        .. getPath(instance)
    item.TextColor3 = Color3.fromRGB(225, 225, 240)
    item.TextSize = 11
    item.Font = Enum.Font.Code
    item.TextWrapped = true
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Center
    item.Parent = scrolling

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = item
end

list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrolling.CanvasSize = UDim2.fromOffset(
        0,
        list.AbsoluteContentSize.Y + 16
    )
end)

-- Scan
checkButton.Activated:Connect(function()
    local searchName = nameBox.Text:gsub("^%s*(.-)%s*$", "%1")

    if searchName == "" then
        status.Text = "Enter a script name first."
        status.TextColor3 = Color3.fromRGB(240, 90, 90)
        return
    end

    clearResults()

    local found = 0

    for _, instance in ipairs(game:GetDescendants()) do
        local scriptType = getScriptType(instance)

        if scriptType and instance.Name == searchName then
            addResult(instance)
            found += 1
        end
    end

    resultsTitle.Text = "SCRIPT RESULTS (" .. found .. ")"
    resultsFrame.Visible = true

    if found > 0 then
        status.Text = "Found " .. found .. " matching script(s)."
        status.TextColor3 = Color3.fromRGB(80, 240, 140)
    else
        status.Text = "No matching scripts found."
        status.TextColor3 = Color3.fromRGB(240, 180, 80)
    end
end)

print("[Zyo Scanner] Loaded successfully.")
