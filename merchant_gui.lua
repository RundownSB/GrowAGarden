local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleableDraggableGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main frame (holds all content except Show/Hide)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35, 0, 0.45, 0)  -- increased height for tabs + content
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.15, 0) -- top-center-ish
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 12)
cornerMain.Parent = mainFrame

-- Close button top-right of mainFrame
local closeButton = Instance.new("TextButton")
closeButton.Text = "✖"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -10, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end)

-- Container for tab buttons (top, below close button)
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, -20, 0, 40)
tabsContainer.Position = UDim2.new(0, 10, 0, 50)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

local tabButtonsLayout = Instance.new("UIListLayout")
tabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
tabButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabButtonsLayout.Padding = UDim.new(0, 10)
tabButtonsLayout.Parent = tabsContainer

-- Helper to create tab buttons
local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = name
    btn.AutoButtonColor = true
    btn.Parent = tabsContainer
    return btn
end

local tabNames = {"Main", "Merchants", "Event"}
local tabButtons = {}
local tabFrames = {}

-- Create tab buttons and corresponding content frames
for i, tabName in ipairs(tabNames) do
    local btn = createTabButton(tabName)
    tabButtons[tabName] = btn

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 1, -100) -- fill below tabsContainer, leave space for buttons below
    frame.Position = UDim2.new(0, 10, 0, 90)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    tabFrames[tabName] = frame
end

-- Select tab helper function
local function selectTab(name)
    for tabName, frame in pairs(tabFrames) do
        frame.Visible = (tabName == name)
        tabButtons[tabName].BackgroundColor3 = (tabName == name) and Color3.fromRGB(100, 149, 237) or Color3.fromRGB(60, 60, 60) -- Highlight selected tab
    end
end

-- Initially select "Main"
selectTab("Main")

-- Connect tab buttons to switch tabs
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(tabName)
    end)
end

-- Lock UI button (below the tab content)
local lockUIButton = Instance.new("TextButton")
lockUIButton.Size = UDim2.new(0.5, 0, 0, 40)
lockUIButton.Position = UDim2.new(0.25, 0, 1, -50)
lockUIButton.AnchorPoint = Vector2.new(0, 1)
lockUIButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
lockUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockUIButton.Font = Enum.Font.SourceSansBold
lockUIButton.TextScaled = true
lockUIButton.Text = "Lock UI"
lockUIButton.Parent = mainFrame

-- Show/Hide Button (always visible)
local showHideButton = Instance.new("TextButton")
showHideButton.Size = UDim2.new(0.15, 0, 0, 40)
showHideButton.Position = UDim2.new(0.5, 0, 0.05, 0)
showHideButton.AnchorPoint = Vector2.new(0.5, 0)
showHideButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
showHideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
showHideButton.Font = Enum.Font.SourceSansBold
showHideButton.TextScaled = true
showHideButton.Text = "Hide"
showHideButton.Parent = screenGui

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos

local locked = false -- lock state

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    -- Keep showHideButton positioned relative to mainFrame top center
    showHideButton.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale - 0.06, mainFrame.Position.Y.Offset)
end

mainFrame.InputBegan:Connect(function(input)
    if locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Show/Hide toggle functionality
showHideButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        mainFrame.Visible = false
        showHideButton.Text = "Show"
    else
        mainFrame.Visible = true
        showHideButton.Text = "Hide"
    end
end)

-- Lock UI button: toggles drag lock
lockUIButton.MouseButton1Click:Connect(function()
    locked = not locked
    if locked then
        lockUIButton.Text = "Unlock UI"
        mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        lockUIButton.Text = "Lock UI"
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- Position showHideButton initially relative to mainFrame
showHideButton.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale - 0.06, mainFrame.Position.Y.Offset)

-- =========================
-- Add Auto Buy in Event Tab
-- =========================

local eventFrame = tabFrames["Event"]

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.Text = "Auto Buy From Merchant"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = eventFrame

local autoBuyToggle = Instance.new("TextButton")
autoBuyToggle.Size = UDim2.new(0, 150, 0, 40)
autoBuyToggle.Position = UDim2.new(0, 10, 0, 50)
autoBuyToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
autoBuyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyToggle.Font = Enum.Font.SourceSansBold
autoBuyToggle.TextScaled = true
autoBuyToggle.Text = "Auto Buy: OFF"
autoBuyToggle.Parent = eventFrame

local autoBuyEnabled = false

local function autoBuyFunction()
    while autoBuyEnabled do
        for i = 1, 4 do
            local args = {
                "AuraEggMerchant",
                i
            }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Network")
                    :WaitForChild("CustomMerchants_Purchase")
                    :InvokeServer(unpack(args))
            end)
            if not success then
                warn("AutoBuy error: ", err)
            end
            wait(0.5)
        end
        wait(3)
    end
end

autoBuyToggle.MouseButton1Click:Connect(function()
    autoBuyEnabled = not autoBuyEnabled
    if autoBuyEnabled then
        autoBuyToggle.Text = "Auto Buy: ON"
        spawn(autoBuyFunction)
    else
        autoBuyToggle.Text = "Auto Buy: OFF"
    end
end)
