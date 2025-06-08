--// Create GUI Elements
local Player = game:GetService("Players").LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MerchantGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 170)
Frame.Position = UDim2.new(0, 40, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local BuyButton = Instance.new("TextButton")
BuyButton.Size = UDim2.new(0, 200, 0, 40)
BuyButton.Position = UDim2.new(0, 10, 0, 30)
BuyButton.Text = "Buy Items 1–4"
BuyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyButton.Font = Enum.Font.SourceSansBold
BuyButton.TextSize = 18
BuyButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 200, 0, 60)
StatusLabel.Position = UDim2.new(0, 10, 0, 80)
StatusLabel.Text = "Click to purchase..."
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

--// Function: Purchases items 1 to 4
local running = true
local function purchaseItems()
    if not running then return end
    StatusLabel.Text = "Purchasing..."

    for i = 1, 4 do
        if not running then break end

        local args = { "AuraEggMerchant", i }
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage")
                .Network
                .CustomMerchants_Purchase
                :InvokeServer(unpack(args))
        end)

        if success then
            StatusLabel.Text = "Purchased item " .. i .. " ✅"
        else
            StatusLabel.Text = "Failed on item " .. i .. " ❌"
            break
        end

        wait(0.3)
    end

    if running then
        wait(1)
        StatusLabel.Text = "Done ✅"
    end
end

--// Events
local BuyConnection = BuyButton.MouseButton1Click:Connect(purchaseItems)

local CloseConnection = CloseButton.MouseButton1Click:Connect(function()
    running = false -- kill switch logic
    BuyConnection:Disconnect()
    CloseConnection:Disconnect()
    ScreenGui:Destroy()
end)
