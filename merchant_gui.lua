-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local oldGui = PlayerGui:FindFirstChild("MainGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local MainGuiFrame = Instance.new("Frame")
MainGuiFrame.Name = "MainGuiFrame"
MainGuiFrame.Parent = screenGui
MainGuiFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainGuiFrame.BorderSizePixel = 0
MainGuiFrame.Position = UDim2.new(0.519, 0, 0.507, 0)
MainGuiFrame.Size = UDim2.new(0, 431, 0, 404)
MainGuiFrame.ClipsDescendants = true
MainGuiFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainGuiFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 26)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 22
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "Pets Go | SB |"
TitleLabel.TextStrokeTransparency = 0.7
TitleLabel.TextScaled = false
TitleLabel.TextWrapped = false
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = MainGuiFrame
mainStroke.Thickness = 1
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Transparency = 0

local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Parent = MainGuiFrame
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Position = UDim2.new(0, 5, 0, 40)
TabButtonsFrame.Size = UDim2.new(0, 420, 0, 32)

local function createTabButton(name, posX)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = TabButtonsFrame
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, posX, 0, 0)
    button.Size = UDim2.new(0, 135, 0, 32)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.TextColor3 = Color3.fromRGB(190, 190, 190)
    button.Text = name:gsub("Button", "")
    button.AutoButtonColor = false
    return button
end

local MainButton = createTabButton("MainButton", 0)
local MerchantsButton = createTabButton("MerchantsButton", 140)
local EventButton = createTabButton("EventButton", 280)

local function createTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Parent = MainGuiFrame
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 5, 0, 75)
    frame.Size = UDim2.new(0, 420, 0, 320)
    frame.Visible = false
    return frame
end

local MainTabFrame = createTabFrame("MainTabFrame")
local MerchantsTabFrame = createTabFrame("MerchantsTabFrame")
local EventTabFrame = createTabFrame("EventTabFrame")
MainTabFrame.Visible = true

local toggleStrokes = {}

-- Updated function: createToggleSquare now returns a TextButton toggle for mobile & desktop input support
local function createToggleSquare(parent, position)
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Parent = parent
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Size = UDim2.new(0, 20, 0, 20)
    toggle.Position = position
    toggle.AutoButtonColor = false
    toggle.Text = ""
    toggle.ZIndex = 2

    local stroke = Instance.new("UIStroke")
    stroke.Parent = toggle
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    table.insert(toggleStrokes, stroke)

    local light = Instance.new("Frame")
    light.Name = "Light"
    light.Parent = toggle
    light.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    light.BorderSizePixel = 0
    light.Size = UDim2.new(1, -4, 1, -4)
    light.Position = UDim2.new(0, 2, 0, 2)
    light.Visible = false
    light.ZIndex = 3

    return toggle, light
end

local function createToggleButton(parent, text, yPos)
    local container = Instance.new("Frame")
    container.Name = text .. "Container"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 30)
    container.Position = UDim2.new(0, 5, 0, yPos)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle, light = createToggleSquare(container, UDim2.new(1, -25, 0, 5))

    return {container, toggle, light, false} -- toggled state false initially
end

local autoTpMiningCave = createToggleButton(MainTabFrame, "Auto tp to Mining cave", 5)
local autoBuyAuraEggs = createToggleButton(EventTabFrame, "Auto Buy Aura Eggs", 5)
local autoBuyAuraShards = createToggleButton(EventTabFrame, "Auto Buy Aura Shards", 40)

local tabButtons = {
    MainButton = MainTabFrame,
    MerchantsButton = MerchantsTabFrame,
    EventButton = EventTabFrame,
}

local function updateTabButtons(selectedButton)
    for _, button in pairs({MainButton, MerchantsButton, EventButton}) do
        if button == selectedButton then
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            button.TextColor3 = Color3.new(1, 1, 1)
        else
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            button.TextColor3 = Color3.fromRGB(190, 190, 190)
        end
    end
end

for buttonName, frame in pairs(tabButtons) do
    local button = TabButtonsFrame:WaitForChild(buttonName)
    button.MouseButton1Click:Connect(function()
        for _, f in pairs(tabButtons) do
            f.Visible = false
        end
        frame.Visible = true
        updateTabButtons(button)
    end)
end

updateTabButtons(MainButton)

local hue = 0
local speed = 0.5

RunService.RenderStepped:Connect(function(delta)
    hue = (hue + delta * speed) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    if mainStroke then
        mainStroke.Color = color
    end
    for _, stroke in ipairs(toggleStrokes) do
        local toggle = stroke.Parent
        if toggle and toggle:FindFirstChild("Light") and toggle.Light.Visible then
            stroke.Color = color
        else
            stroke.Color = Color3.fromRGB(100, 100, 100)
        end
    end
end)

-- Auto TP to Mining Cave logic
local teleporting = false

local function teleportLoop()
    while teleporting do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local enterPortal = workspace.MAP.INTERACT.CaveTeleports.Enter
        firetouchinterest(hrp, enterPortal, 0)
        task.wait(0.1)
        firetouchinterest(hrp, enterPortal, 1)

        task.wait(3)
        hrp.CFrame = CFrame.new(-11.4716215, -259.332214, 762.846130)
        task.wait(180)

        local leavePart = workspace.MAP.INTERACT.CaveTeleports:FindFirstChild("LeavePart")
        if leavePart then
            hrp.CFrame = CFrame.new(leavePart:GetPivot().Position + Vector3.new(0, 5, 0))
        end

        task.wait(120)
    end
end

-- Use .Activated so toggles work on both mobile taps and mouse clicks
autoTpMiningCave[2].Activated:Connect(function()
    teleporting = not teleporting
    autoTpMiningCave[3].Visible = teleporting
    if teleporting then
        task.spawn(teleportLoop)
    end
end)

-- Example for other toggles: add your logic as needed
local auraEggsEnabled = false
autoBuyAuraEggs[2].Activated:Connect(function()
    auraEggsEnabled = not auraEggsEnabled
    autoBuyAuraEggs[3].Visible = auraEggsEnabled
    -- Add your auto buy aura eggs logic here
end)

local auraShardsEnabled = false
autoBuyAuraShards[2].Activated:Connect(function()
    auraShardsEnabled = not auraShardsEnabled
    autoBuyAuraShards[3].Visible = auraShardsEnabled
    -- Add your auto buy aura shards logic here
end)

local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Name = "ToggleGuiButton"
toggleGuiButton.Text = "☰"
toggleGuiButton.TextColor3 = Color3.new(1, 1, 1)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
toggleGuiButton.Size = UDim2.new(0, 30, 0, 30)
toggleGuiButton.Position = UDim2.new(0, 5, 0, 5)
toggleGuiButton.ZIndex = 10
toggleGuiButton.Font = Enum.Font.SourceSansBold
toggleGuiButton.TextSize = 24
toggleGuiButton.Parent = screenGui

local guiVisible = true

toggleGuiButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainGuiFrame.Visible = guiVisible
end)

-- (Rest of script remains unchanged: Hide/Show GUI + drag logic...)
