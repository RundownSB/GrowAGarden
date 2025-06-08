--// Setup GUI
local Player = game:GetService("Players").LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MerchantGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 210)
Frame.Position = UDim2.new(0, 40, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local BuyButton = Instance.new("TextButton")
BuyButton.Size = UDim2.new(0, 220, 0, 40)
BuyButton.Position = UDim2.new(0, 10, 0, 30)
BuyButton.Text = "Buy Items 1–4"
BuyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyButton.Font = Enum.Font.SourceSansBold
BuyButton.TextSize = 18
BuyButton.Parent = Frame

local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(0, 220, 0, 40)
AutoButton.Position = UDim2.new(0, 10, 0, 80)
AutoButton.Text = "Auto Buy: OFF"
AutoButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.Font = Enum.Font.SourceSansBold
AutoButton.TextSize = 18
AutoButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 220, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.Text = "Ready."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextWrapped = true
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "✖"
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = Frame

--// Script Logic
local running = true
local autoBuying = false

local function purchaseItems()
    if not running then return end
    StatusLabel.Text = "Buying..."

    for i = 1, 4 do
        if not running then break end

        local args = { "AuraEggMerchant", i }
        local success = pcall(function()
            game:GetService("ReplicatedStorage")
                .Network
                .CustomMerchants_Purchase
                :InvokeServer(unpack(args))
        end)

        if success then
            StatusLabel.Text = "Bought item " .. i
        else
            StatusLabel.Text = "Failed item " .. i
            break
        end

        wait(0.3)
    end

    StatusLabel.Text = "Done"
end

--// Event Connections
local BuyConnection = BuyButton.MouseButton1Click:Connect(purchaseItems)

local AutoConnection = AutoButton.MouseButton1Click:Connect(function()
    autoBuying = not autoBuying
    AutoButton.Text = "Auto Buy: " .. (autoBuying and "ON" or "OFF")

    if autoBuying then
        task.spawn(function()
            while autoBuying and running do
                purchaseItems()
                wait(2) -- wait between loops
            end
        end)
    end
end)

local CloseConnection

CloseConnection = CloseButton.MouseButton1Click:Connect(function()
    -- Destroy GUI immediately
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end

    -- Stop all activity and disconnect events
    running = false
    autoBuying = false
    
    if BuyConnection then BuyConnection:Disconnect() end
    if AutoConnection then AutoConnection:Disconnect() end
    if CloseConnection then CloseConnection:Disconnect() end
end)
