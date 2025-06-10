-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 528, 0, 327)
MainFrame.Position = UDim2.new(0.247, 0, 0.139, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Labels
local function createLabel(text, positionY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 281, 0, 50)
    label.Position = UDim2.new(0, 0, 0, positionY)
    label.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.Parent = MainFrame
    return label
end

local Label1 = Instance.new("TextLabel")
Label1.Size = UDim2.new(0, 528, 0, 32)
Label1.Position = UDim2.new(0, 0, 0, 0)
Label1.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Label1.Text = "Pets Go Event"
Label1.TextColor3 = Color3.new(1, 1, 1)
Label1.Font = Enum.Font.SourceSansBold
Label1.TextSize = 24
Label1.Parent = MainFrame

createLabel("Auto Buy Aura Egg", 70)
createLabel("Auto Buy Aura Shards", 140)
createLabel("Auto Teleport Mining Cave", 210)

-- Toggle Buttons
local function createToggleButton(positionY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 109, 0, 50)
    button.Position = UDim2.new(0, 290, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    button.Text = "Off"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Parent = MainFrame
    return button
end

local Button2 = createToggleButton(70)
local Button3 = createToggleButton(140)
local TPButton = createToggleButton(210)

-- Hide/Show Buttons
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 137, 0, 32)
HideButton.Position = UDim2.new(1, -145, 0, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 20
HideButton.Parent = MainFrame

local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 100, 0, 40)
ShowButton.Position = UDim2.new(0, 10, 0, 10)
ShowButton.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
ShowButton.Text = "Show"
ShowButton.TextColor3 = Color3.new(1, 1, 1)
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.TextSize = 20
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

-- Toggle Variables
local toggle1 = false
local toggle2 = false
local teleporting = false

-- Auto Buy Logic
local function autoBuyAuraEgg()
    while toggle1 do
        for i = 1, 4 do
            local args = { "AuraEggMerchant", i }
            local success, err = pcall(function()
                ReplicatedStorage.Network.CustomMerchants_Purchase:InvokeServer(unpack(args))
            end)
            if not success then warn("Aura Egg error:", err) end
        end
        task.wait(1)
    end
end

local function autoBuyAuraShards()
    while toggle2 do
        for i = 1, 10 do
            local args = { i }
            local success, err = pcall(function()
                ReplicatedStorage.Network.AuraMerchant_Purchase:InvokeServer(unpack(args))
            end)
            if not success then warn("Aura Shards error:", err) end
        end
        task.wait(1)
    end
end

local function teleportLoop()
    while teleporting do
        local character = player.Character or player.CharacterAdded:Wait()
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

-- Button Logic
Button2.MouseButton1Click:Connect(function()
    toggle1 = not toggle1
    Button2.Text = toggle1 and "On" or "Off"
    Button2.BackgroundColor3 = toggle1 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    if toggle1 then task.spawn(autoBuyAuraEgg) end
end)

Button3.MouseButton1Click:Connect(function()
    toggle2 = not toggle2
    Button3.Text = toggle2 and "On" or "Off"
    Button3.BackgroundColor3 = toggle2 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    if toggle2 then task.spawn(autoBuyAuraShards) end
end)

TPButton.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    TPButton.Text = teleporting and "On" or "Off"
    TPButton.BackgroundColor3 = teleporting and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    if teleporting then task.spawn(teleportLoop) end
end)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- Drag GUI Button
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    if dragging and input.Position and dragStart then
        local delta = input.Position - dragStart
        ShowButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

ShowButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ShowButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ShowButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateDrag(input)
    end
end)
