-- Mobile-optimized version of your draggable GUI
-- Core logic remains, but all sizes/positions are now scaled for better visibility

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleableDraggableGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main UI Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.6, 0, 0.55, 0)  -- Responsive
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "✖"
closeButton.Size = UDim2.new(0.07, 0, 0.1, 0)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -10, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tabs Container
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, -20, 0.1, 0)
tabsContainer.Position = UDim2.new(0, 10, 0.12, 0)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0.02, 0)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabsContainer

-- Create tabs
local tabButtons = {}
local tabFrames = {}
local tabNames = {"Main", "Merchants", "Event"}

local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = name
    btn.Parent = tabsContainer
    return btn
end

for _, tabName in ipairs(tabNames) do
    local btn = createTabButton(tabName)
    tabButtons[tabName] = btn

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0.65, 0)
    frame.Position = UDim2.new(0, 10, 0.25, 0)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = mainFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    tabFrames[tabName] = frame
end

-- Tab switching
local function selectTab(name)
    for tabName, frame in pairs(tabFrames) do
        frame.Visible = (tabName == name)
        tabButtons[tabName].BackgroundColor3 = (tabName == name) and Color3.fromRGB(100,149,237) or Color3.fromRGB(60,60,60)
    end
end

selectTab("Main")
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

-- Lock UI
local lockUIButton = Instance.new("TextButton")
lockUIButton.Size = UDim2.new(0.5, 0, 0.08, 0)
lockUIButton.Position = UDim2.new(0.25, 0, 0.95, 0)
lockUIButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
lockUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockUIButton.Font = Enum.Font.SourceSansBold
lockUIButton.TextScaled = true
lockUIButton.Text = "Lock UI"
lockUIButton.Parent = mainFrame

-- Show/Hide button
local showHideButton = Instance.new("TextButton")
showHideButton.Size = UDim2.new(0.2, 0, 0.06, 0)
showHideButton.Position = UDim2.new(0.5, 0, mainFrame.Position.Y.Scale - 0.07, 0)
showHideButton.AnchorPoint = Vector2.new(0.5, 0)
showHideButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
showHideButton.TextColor3 = Color3.fromRGB(255,255,255)
showHideButton.Font = Enum.Font.SourceSansBold
showHideButton.TextScaled = true
showHideButton.Text = "Hide"
showHideButton.Parent = screenGui

-- Drag Logic
local dragging = false
local dragInput, dragStart, startPos
local locked = false

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    showHideButton.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale - 0.07, mainFrame.Position.Y.Offset)
end

mainFrame.InputBegan:Connect(function(input)
    if locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Show/Hide
showHideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    showHideButton.Text = mainFrame.Visible and "Hide" or "Show"
end)

-- Lock
lockUIButton.MouseButton1Click:Connect(function()
    locked = not locked
    lockUIButton.Text = locked and "Unlock UI" or "Lock UI"
    mainFrame.BackgroundColor3 = locked and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(30, 30, 30)
end)

-- Position show/hide initially
showHideButton.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale - 0.07, mainFrame.Position.Y.Offset)

-- You can now continue adding your features inside `tabFrames["Main"]`, etc. with mobile-friendly proportions.
