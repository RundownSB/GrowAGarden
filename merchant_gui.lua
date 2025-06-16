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
MainGuiFrame.Size = UDim2.new(0, 560, 0, 525) -- was 431 x 404 (increased ~1.3x)
MainGuiFrame.ClipsDescendants = true
MainGuiFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainGuiFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 7)
TitleLabel.Size = UDim2.new(1, 0, 0, 34) -- was 26 height
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 30 -- increased from 22
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "Grow A Garden | SB |"
TitleLabel.TextStrokeTransparency = 0.7
TitleLabel.TextScaled = false
TitleLabel.TextWrapped = false
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = MainGuiFrame
mainStroke.Thickness = 1.5 -- slight thicker stroke
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Transparency = 0

local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Parent = MainGuiFrame
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Position = UDim2.new(0, 8, 0, 53) -- was 5,40
TabButtonsFrame.Size = UDim2.new(0, 550, 0, 40) -- was 420,32

local function createTabButton(name, posX)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = TabButtonsFrame
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, posX, 0, 0)
    button.Size = UDim2.new(0, 260, 0, 40) -- was 200 x 32
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 26 -- was 20
    button.TextColor3 = Color3.fromRGB(190, 190, 190)
    button.Text = name:gsub("Button", "")
    button.AutoButtonColor = false
    return button
end

local MainButton = createTabButton("MainButton", 0)
local MerchantsButton = createTabButton("MerchantsButton", 280) -- was 210

local function createTabFrame(name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Parent = MainGuiFrame
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 8, 0, 110) -- was 5,75
    frame.Size = UDim2.new(0, 550, 0, 420) -- was 420,320
    frame.Visible = false
    return frame
end

local MainTabFrame = createTabFrame("MainTabFrame")
local MerchantsTabFrame = createTabFrame("MerchantsTabFrame")
MainTabFrame.Visible = true

local toggleStrokes = {}

local function createToggleSquare(parent, position)
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Parent = parent
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Size = UDim2.new(0, 28, 0, 28) -- was 20 x 20
    toggle.Position = position
    toggle.AutoButtonColor = false
    toggle.Text = ""
    toggle.ZIndex = 2

    local stroke = Instance.new("UIStroke")
    stroke.Parent = toggle
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1.2 -- slightly thicker stroke
    table.insert(toggleStrokes, stroke)

    local light = Instance.new("Frame")
    light.Name = "Light"
    light.Parent = toggle
    light.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    light.BorderSizePixel = 0
    light.Size = UDim2.new(1, -6, 1, -6) -- adjusted to stay inside bigger toggle
    light.Position = UDim2.new(0, 3, 0, 3)
    light.Visible = false
    light.ZIndex = 3

    return toggle, light
end

local function createToggleButton(parent, text, yPos)
    local container = Instance.new("Frame")
    container.Name = text .. "Container"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -15, 0, 40) -- was 30 height and -10 width
    container.Position = UDim2.new(0, 5, 0, yPos)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -40, 1, 0) -- extra space for bigger toggle
    label.Font = Enum.Font.SourceSans
    label.TextSize = 22 -- was 18
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle, light = createToggleSquare(container, UDim2.new(1, -35, 0, 6)) -- adjusted position for bigger toggle

    return {container, toggle, light, false}
end

local autoSell = createToggleButton(MainTabFrame, "Auto Sell", 5)
local autoFastCollect = createToggleButton(MainTabFrame, "Auto Fast Collect", 55) -- was 35
local autoBuySeedsToggle = createToggleButton(MerchantsTabFrame, "Auto Buy Seeds", 5)

-- The seed list  (used by both buy seed functions)
local seedList = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn",
    "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut",
    "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper",
    "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple"
}

-- Tab buttons mapping
local tabButtons = {
    MainButton = MainTabFrame,
    MerchantsButton = MerchantsTabFrame,
}

local function updateTabButtons(selectedButton)
    for _, button in pairs({MainButton, MerchantsButton}) do
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

-- Logic Variables
local selling = false
local autoBuySeeds = false
local fastCollectEnabled = false


-- Require CollectController module (for fast collect)
local CollectController = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CollectController"))
CollectController.Start(CollectController)

-- Auto Sell Logic
autoSell[2].MouseButton1Click:Connect(function()
    if not selling then
        selling = true
        autoSell[3].Visible = true
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local originalPos = hrp.CFrame
        hrp.CFrame = CFrame.new(85.94, 3, 0.32)
        task.wait(1)
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        hrp.CFrame = originalPos
        selling = false
        autoSell[3].Visible = false
    else
        selling = false
        autoSell[3].Visible = false
    end
end)

-- Auto Fast Collect Logic
local function fastCollectLoop()
    while fastCollectEnabled do
        pcall(function()
            CollectController:Collect()
        end)
        task.wait(0.15)
    end
end

autoFastCollect[2].MouseButton1Click:Connect(function()
    fastCollectEnabled = not fastCollectEnabled
    autoFastCollect[3].Visible = fastCollectEnabled
    if fastCollectEnabled then
        task.spawn(fastCollectLoop)
    end
end)

-- Auto Buy Seeds Logic (Original one, unchanged)
local function autoBuySeedsLoop()
    while autoBuySeeds do
        for _, seedName in ipairs(seedList) do
            pcall(function()
                ReplicatedStorage.GameEvents.BuySeedStock:FireServer(seedName)
            end)
            task.wait(0.3)
        end
        task.wait(1)
    end
end

autoBuySeedsToggle[2].MouseButton1Click:Connect(function()
    autoBuySeeds = not autoBuySeeds
    autoBuySeedsToggle[3].Visible = autoBuySeeds
    if autoBuySeeds then
        task.spawn(autoBuySeedsLoop)
    end
end)

-- === Buy Selected Seeds with collapsible list ===

local buySelectedSeedsToggle = createToggleButton(MerchantsTabFrame, "Buy Selected Seeds", 45)

-- Add expand/collapse button next to label
local expandCollapseBtn = Instance.new("TextButton")
expandCollapseBtn.Name = "ExpandCollapseBtn"
expandCollapseBtn.Parent = buySelectedSeedsToggle[1]
expandCollapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
expandCollapseBtn.BorderSizePixel = 0
expandCollapseBtn.Size = UDim2.new(0, 32, 0, 28) -- was 25 x 20
expandCollapseBtn.Position = UDim2.new(1, -75, 0, 6) -- adjusted for bigger toggle & spacing
expandCollapseBtn.Font = Enum.Font.SourceSansBold
expandCollapseBtn.TextSize = 26 -- was 18
expandCollapseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
expandCollapseBtn.Text = "▶"
expandCollapseBtn.AutoButtonColor = false

local seedListVisible = false

local SeedSelectionFrame = Instance.new("ScrollingFrame")
SeedSelectionFrame.Name = "SeedSelectionFrame"
SeedSelectionFrame.Parent = MerchantsTabFrame
SeedSelectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SeedSelectionFrame.Position = UDim2.new(0, 8, 0, 100) -- was 100
SeedSelectionFrame.Size = UDim2.new(0, 540, 0, 330) -- was 410 x 215
SeedSelectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
SeedSelectionFrame.ScrollBarThickness = 8 -- slightly thicker scrollbar
SeedSelectionFrame.Visible = false  -- Start hidden

local seedToggles = {}

local function createSeedToggle(seedName, yPos)
    local container = Instance.new("Frame")
    container.Name = seedName .. "Container"
    container.Parent = SeedSelectionFrame
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -15, 0, 38) -- was 30 height and -10 width
    container.Position = UDim2.new(0, 5, 0, yPos)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -40, 1, 0) -- extra space for bigger toggle
    label.Font = Enum.Font.SourceSans
    label.TextSize = 22 -- was 18
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = seedName
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle, light = createToggleSquare(container, UDim2.new(1, -35, 0, 6)) -- adjusted pos

    toggle.MouseButton1Click:Connect(function()
        light.Visible = not light.Visible
        seedToggles[seedName] = light.Visible
    end)

    seedToggles[seedName] = false
end

for i, seedName in ipairs(seedList) do
    createSeedToggle(seedName, (i - 1) * 40) -- was 32 spacing
end

SeedSelectionFrame.CanvasSize = UDim2.new(0, 0, 0, #seedList * 40) -- adjusted for new toggle height

expandCollapseBtn.MouseButton1Click:Connect(function()
    seedListVisible = not seedListVisible
    SeedSelectionFrame.Visible = seedListVisible
    expandCollapseBtn.Text = seedListVisible and "▼" or "▶"
end)

local buySelectedSeeds = false
buySelectedSeedsToggle[2].MouseButton1Click:Connect(function()
    buySelectedSeeds = not buySelectedSeeds
    buySelectedSeedsToggle[3].Visible = buySelectedSeeds
    if buySelectedSeeds then
        task.spawn(function()
            while buySelectedSeeds do
                for seedName, enabled in pairs(seedToggles) do
                    if enabled then
                        pcall(function()
                            ReplicatedStorage.GameEvents.BuySeedStock:FireServer(seedName)
                        end)
                        task.wait(0.3)
                    end
                end
                task.wait(1)
            end
        end)
    end
end)


-- === Buy Selected Gear with collapsible list ===

local gearList = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Cleaning Spray",
    "Favorite Tool", "Harvest Tool", "Friendship Pot"
}

local buySelectedGearToggle = createToggleButton(MerchantsTabFrame, "Buy Selected Gear", 95)

local expandGearBtn = Instance.new("TextButton")
expandGearBtn.Name = "ExpandGearBtn"
expandGearBtn.Parent = buySelectedGearToggle[1]
expandGearBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
expandGearBtn.BorderSizePixel = 0
expandGearBtn.Size = UDim2.new(0, 32, 0, 28)
expandGearBtn.Position = UDim2.new(1, -75, 0, 6)
expandGearBtn.Font = Enum.Font.SourceSansBold
expandGearBtn.TextSize = 26
expandGearBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
expandGearBtn.Text = "▶"
expandGearBtn.AutoButtonColor = false

local gearListVisible = false

local GearSelectionFrame = Instance.new("ScrollingFrame")
GearSelectionFrame.Name = "GearSelectionFrame"
GearSelectionFrame.Parent = MerchantsTabFrame
GearSelectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GearSelectionFrame.Position = UDim2.new(0, 8, 0, 150)
GearSelectionFrame.Size = UDim2.new(0, 540, 0, 250)
GearSelectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
GearSelectionFrame.ScrollBarThickness = 8
GearSelectionFrame.Visible = false

local gearToggles = {}

local function createGearToggle(gearName, yPos)
    local container = Instance.new("Frame")
    container.Name = gearName .. "Container"
    container.Parent = GearSelectionFrame
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -15, 0, 38)
    container.Position = UDim2.new(0, 5, 0, yPos)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 22
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = gearName
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle, light = createToggleSquare(container, UDim2.new(1, -35, 0, 6))

    toggle.MouseButton1Click:Connect(function()
        light.Visible = not light.Visible
        gearToggles[gearName] = light.Visible
    end)

    gearToggles[gearName] = false
end

for i, gearName in ipairs(gearList) do
    createGearToggle(gearName, (i - 1) * 40)
end

GearSelectionFrame.CanvasSize = UDim2.new(0, 0, 0, #gearList * 40)

expandGearBtn.MouseButton1Click:Connect(function()
    gearListVisible = not gearListVisible
    GearSelectionFrame.Visible = gearListVisible
    expandGearBtn.Text = gearListVisible and "▼" or "▶"
end)

local buySelectedGear = false
buySelectedGearToggle[2].MouseButton1Click:Connect(function()
    buySelectedGear = not buySelectedGear
    buySelectedGearToggle[3].Visible = buySelectedGear
    if buySelectedGear then
        task.spawn(function()
            while buySelectedGear do
                for gearName, enabled in pairs(gearToggles) do
                    if enabled then
                        pcall(function()
                            ReplicatedStorage.GameEvents.BuyGearStock:FireServer(unpack({ gearName }))
                        end)
                        task.wait(0.3)
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local autoPlantToggle = createToggleButton(MerchantsTabFrame, "Auto Plant", 130) -- adjust Y pos if needed
local autoPlantEnabled = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plantLocationsFolder = workspace.Farm.Farm.Important:WaitForChild("Plant_Locations")
local canPlantValue = plantLocationsFolder:WaitForChild("Can_Plant")
local plantRemote = ReplicatedStorage.GameEvents:WaitForChild("Plant_RE")

local seedIndex = 1 -- Used to cycle through seeds

-- Toggle button functionality
local autoPlantEnabled = false

autoPlantToggle[2].MouseButton1Click:Connect(function()
    autoPlantEnabled = not autoPlantEnabled
    autoPlantToggle[3].Visible = autoPlantEnabled -- show the light
end)


-- Check if a plant location is empty (no child named "Plant")
local function isEmpty(location)
	return not location:FindFirstChild("Plant")
end

-- Auto-plant loop
task.spawn(function()
	while true do
		if autoPlantEnabled then
			for _, location in pairs(plantLocationsFolder:GetChildren()) do
				if location:IsA("BasePart") and isEmpty(location) then
					local pos = location.Position
					local seedName = seedList[seedIndex]

					plantRemote:FireServer(Vector3.new(pos.X, pos.Y, pos.Z), seedName)

					-- Cycle to next seed
					seedIndex += 1
					if seedIndex > #seedList then
						seedIndex = 1
					end
				end
			end
		end
		task.wait(3)
	end
end)

-- Toggle GUI Button
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Name = "ToggleGuiButton"
toggleGuiButton.Text = "☰"
toggleGuiButton.TextColor3 = Color3.new(1, 1, 1)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
toggleGuiButton.Size = UDim2.new(0, 38, 0, 38) -- was 30 x 30
toggleGuiButton.Position = UDim2.new(0, 8, 0, 8) -- was 5,5
toggleGuiButton.ZIndex = 10
toggleGuiButton.Font = Enum.Font.SourceSansBold
toggleGuiButton.TextSize = 30 -- was 24
toggleGuiButton.Parent = screenGui

local guiVisible = true
toggleGuiButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainGuiFrame.Visible = guiVisible
end)
