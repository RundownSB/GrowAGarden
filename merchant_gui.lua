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

-- Label 1: Pets Go Event
local Label1 = Instance.new("TextLabel")
Label1.Size = UDim2.new(0, 528, 0, 32)
Label1.Position = UDim2.new(0, 0, 0, 0)
Label1.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Label1.Text = "Pets Go Event"
Label1.TextColor3 = Color3.new(1, 1, 1)
Label1.Font = Enum.Font.SourceSansBold
Label1.TextSize = 24
Label1.Parent = MainFrame

-- Label 2: Auto Buy Aura Egg
local Label2 = Instance.new("TextLabel")
Label2.Size = UDim2.new(0, 282, 0, 50)
Label2.Position = UDim2.new(0, 0, 0, 70)
Label2.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
Label2.Text = "Auto Buy Aura Egg"
Label2.TextColor3 = Color3.new(1, 1, 1)
Label2.Font = Enum.Font.SourceSans
Label2.TextSize = 20
Label2.Parent = MainFrame

-- Label 3: Auto Buy Aura Shards
local Label3 = Instance.new("TextLabel")
Label3.Size = UDim2.new(0, 281, 0, 50)
Label3.Position = UDim2.new(0, 0, 0, 140)
Label3.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
Label3.Text = "Auto Buy Aura Shards"
Label3.TextColor3 = Color3.new(1, 1, 1)
Label3.Font = Enum.Font.SourceSans
Label3.TextSize = 20
Label3.Parent = MainFrame

-- Toggle Button 1: For Aura Egg
local Button2 = Instance.new("TextButton")
Button2.Size = UDim2.new(0, 109, 0, 50)
Button2.Position = UDim2.new(0, 290, 0, 70)
Button2.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Button2.Text = "Off"
Button2.TextColor3 = Color3.new(1, 1, 1)
Button2.Font = Enum.Font.SourceSansBold
Button2.TextSize = 20
Button2.Parent = MainFrame

-- Toggle Button 2: For Aura Shards
local Button3 = Instance.new("TextButton")
Button3.Size = UDim2.new(0, 109, 0, 50)
Button3.Position = UDim2.new(0, 290, 0, 140)
Button3.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Button3.Text = "Off"
Button3.TextColor3 = Color3.new(1, 1, 1)
Button3.Font = Enum.Font.SourceSansBold
Button3.TextSize = 20
Button3.Parent = MainFrame

-- Hide Button (on top-right under green bar)
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 137, 0, 32)
HideButton.Position = UDim2.new(1, -145, 0, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(87, 77, 76)
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 20
HideButton.Parent = MainFrame

-- Show Button (appears in top-left corner when GUI hidden)
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

-- Variables for toggles
local toggle1 = false
local toggle2 = false

-- Auto Buy functions
local function autoBuyAuraEgg()
	while toggle1 do
		for i = 1, 5 do
    local args = { "AuraEggMerchant", i }
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Network")
            :WaitForChild("CustomMerchants_Purchase")
            :InvokeServer(unpack(args))
    end)
    if not success then
        warn("Aura Egg AutoBuy error: ", err)
    end
end
wait(1) -- or whatever delay you want after all 5 purchases

	end
end

local function autoBuyAuraShards()
	while toggle2 do
		for i = 1, 10 do
			local args = { i }
			local success, err = pcall(function()
				ReplicatedStorage:WaitForChild("Network")
					:WaitForChild("AuraMerchant_Purchase")
					:InvokeServer(unpack(args))
			end)
			if not success then
				warn("Aura Shards AutoBuy error: ", err)
			end
			wait(0.5)
		end
		wait(3)
	end
end

-- Toggle logic: Aura Egg
Button2.MouseButton1Click:Connect(function()
	toggle1 = not toggle1
	Button2.Text = toggle1 and "On" or "Off"
	Button2.BackgroundColor3 = toggle1 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
	if toggle1 then
		spawn(autoBuyAuraEgg)
	end
end)

-- Toggle logic: Aura Shards
Button3.MouseButton1Click:Connect(function()
	toggle2 = not toggle2
	Button3.Text = toggle2 and "On" or "Off"
	Button3.BackgroundColor3 = toggle2 and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
	if toggle2 then
		spawn(autoBuyAuraShards)
	end
end)

-- Hide/Show logic
HideButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	ShowButton.Visible = false
end)

-- Make ShowButton draggable on PC + Mobile
local dragging = false
local dragInput, dragStart, startPos

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
