-- FISCH GAME - Advanced Fish Explorer & Logger
-- Untuk explore ReplicatedStorage dan auto-detect fish data

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishExplorer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 550)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🐟 FISCH - Advanced Fish Explorer"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.ZIndex = 11
Title.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 11
StatusLabel.Parent = MainFrame

-- ScrollFrame untuk list
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -170)
ScrollFrame.Position = UDim2.new(0, 10, 0, 65)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.Parent = MainFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 8)
ScrollCorner.Parent = ScrollFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Button Container
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 0, 90)
ButtonFrame.Position = UDim2.new(0, 10, 1, -95)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

-- Scan ReplicatedStorage Button
local ScanRSButton = Instance.new("TextButton")
ScanRSButton.Size = UDim2.new(0.48, 0, 0, 35)
ScanRSButton.Position = UDim2.new(0, 0, 0, 0)
ScanRSButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ScanRSButton.Text = "📦 Explore ReplicatedStorage"
ScanRSButton.TextColor3 = Color3.new(1, 1, 1)
ScanRSButton.TextSize = 14
ScanRSButton.Font = Enum.Font.SourceSansBold
ScanRSButton.Parent = ButtonFrame

local ScanRSCorner = Instance.new("UICorner")
ScanRSCorner.CornerRadius = UDim.new(0, 6)
ScanRSCorner.Parent = ScanRSButton

-- Scan Fish Data Button
local ScanFishButton = Instance.new("TextButton")
ScanFishButton.Size = UDim2.new(0.48, 0, 0, 35)
ScanFishButton.Position = UDim2.new(0.52, 0, 0, 0)
ScanFishButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ScanFishButton.Text = "🔍 Scan Fish Database"
ScanFishButton.TextColor3 = Color3.new(1, 1, 1)
ScanFishButton.TextSize = 14
ScanFishButton.Font = Enum.Font.SourceSansBold
ScanFishButton.Parent = ButtonFrame

local ScanFishCorner = Instance.new("UICorner")
ScanFishCorner.CornerRadius = UDim.new(0, 6)
ScanFishCorner.Parent = ScanFishButton

-- Clear Button
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, 0, 0, 35)
ClearButton.Position = UDim2.new(0, 0, 0, 45)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
ClearButton.Text = "🗑️ Clear Log"
ClearButton.TextColor3 = Color3.new(1, 1, 1)
ClearButton.TextSize = 14
ClearButton.Font = Enum.Font.SourceSansBold
ClearButton.Parent = ButtonFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

-- Destroy Script Button
local DestroyButton = Instance.new("TextButton")
DestroyButton.Size = UDim2.new(0.48, 0, 0, 35)
DestroyButton.Position = UDim2.new(0.52, 0, 0, 45)
DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyButton.Text = "❌ Delete Script"
DestroyButton.TextColor3 = Color3.new(1, 1, 1)
DestroyButton.TextSize = 14
DestroyButton.Font = Enum.Font.SourceSansBold
DestroyButton.Parent = ButtonFrame

local DestroyCorner = Instance.new("UICorner")
DestroyCorner.CornerRadius = UDim.new(0, 6)
DestroyCorner.Parent = DestroyButton

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Fungsi tambah log
local function addLog(text, color)
    local Entry = Instance.new("TextLabel")
    Entry.Size = UDim2.new(1, -10, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Entry.Text = "  " .. text
    Entry.TextColor3 = color or Color3.new(1, 1, 1)
    Entry.TextSize = 13
    Entry.Font = Enum.Font.SourceSans
    Entry.TextXAlignment = Enum.TextXAlignment.Left
    Entry.TextYAlignment = Enum.TextYAlignment.Top
    Entry.TextWrapped = true
    Entry.Parent = ScrollFrame
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 5)
    Padding.PaddingBottom = UDim.new(0, 5)
    Padding.Parent = Entry
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 4)
    EntryCorner.Parent = Entry
    
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.CanvasSize.Y.Offset)
end

-- Fungsi explore ReplicatedStorage secara detail
local function exploreReplicatedStorage()
    addLog("=== EXPLORING REPLICATED STORAGE ===", Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Status: Scanning ReplicatedStorage..."
    
    local totalItems = 0
    local modules = 0
    
    local function exploreFolder(folder, indent)
        indent = indent or ""
        for _, item in pairs(folder:GetChildren()) do
            totalItems = totalItems + 1
            local itemType = item.ClassName
            local itemName = item.Name
            
            if item:IsA("ModuleScript") then
                modules = modules + 1
                addLog(indent .. "📜 ModuleScript: " .. itemName, Color3.fromRGB(150, 150, 255))
                
                -- Try to require dan lihat isinya
                local success, data = pcall(function()
                    return require(item)
                end)
                
                if success and type(data) == "table" then
                    local keys = {}
                    for k, _ in pairs(data) do
                        table.insert(keys, tostring(k))
                    end
                    if #keys > 0 then
                        addLog(indent .. "  └─ Keys: " .. table.concat(keys, ", "), Color3.fromRGB(100, 200, 100))
                    end
                end
            elseif item:IsA("Folder") then
                addLog(indent .. "📁 Folder: " .. itemName, Color3.fromRGB(200, 200, 100))
                exploreFolder(item, indent .. "  ")
            else
                addLog(indent .. "📄 " .. itemType .. ": " .. itemName, Color3.fromRGB(150, 150, 150))
            end
        end
    end
    
    exploreFolder(ReplicatedStorage)
    
    addLog(string.format("✅ Total items: %d | ModuleScripts: %d", totalItems, modules), Color3.fromRGB(0, 255, 0))
    StatusLabel.Text = string.format("Status: Found %d items, %d modules", totalItems, modules)
end

-- Fungsi scan fish database
local function scanFishDatabase()
    addLog("=== SCANNING FISH DATABASE ===", Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Status: Scanning for fish data..."
    
    local fishFound = 0
    
    -- Cari di ReplicatedStorage
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") then
            local name = item.Name:lower()
            if name:find("fish") or name:find("bestiary") or name:find("catch") or name:find("dex") then
                addLog("🎯 Possible fish module: " .. item.Name, Color3.fromRGB(255, 200, 0))
                
                local success, data = pcall(function()
                    return require(item)
                end)
                
                if success and type(data) == "table" then
                    -- Coba parse fish data
                    for key, value in pairs(data) do
                        if type(value) == "table" then
                            local fishName = value.Name or value.FishName or tostring(key)
                            local rarity = value.Rarity or value.Tier or "?"
                            local weight = value.Weight or value.MinWeight or value.MaxWeight or "?"
                            local mutation = value.Mutation or value.Shiny or value.Variant or "None"
                            
                            fishFound = fishFound + 1
                            local info = string.format("🐟 %s | Rarity: %s | Weight: %s | Mutation: %s",
                                fishName, tostring(rarity), tostring(weight), tostring(mutation))
                            addLog(info, Color3.fromRGB(100, 255, 200))
                        end
                    end
                end
            end
        end
    end
    
    addLog(string.format("✅ Fish scan complete! Found %d entries", fishFound), Color3.fromRGB(0, 255, 0))
    StatusLabel.Text = string.format("Status: Found %d fish", fishFound)
end

-- Hook catch events - IMPROVED
local connections = {}

local function setupCatchDetection()
    -- Monitor player's PlayerGui untuk catch notifications
    local gui = player:WaitForChild("PlayerGui")
    
    -- Method 1: Monitor DescendantAdded untuk catch UI
    connections[#connections + 1] = gui.DescendantAdded:Connect(function(obj)
        task.wait(0.05)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = obj.Text
            if text:lower():find("caught") or text:lower():find("you got") then
                -- Extract fish name dari text
                local fishName = text:match("You got: (.+)") or text:match("Caught (.+)") or text:match("(%a+%s?%a*)$")
                if fishName then
                    addLog("🎣 CAUGHT! " .. fishName .. " | Time: " .. os.date("%H:%M:%S"), Color3.fromRGB(255, 215, 0))
                end
            end
        end
    end)
    
    -- Method 2: Monitor Workspace
    connections[#connections + 1] = Workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if obj:IsA("Model") and obj.Name ~= player.Name then
            -- Cek apakah ini fish model
            local hasAttributes = false
            for _, attr in pairs(obj:GetAttributes()) do
                hasAttributes = true
                break
            end
            
            if hasAttributes or obj:FindFirstChild("Weight") or obj:FindFirstChild("Rarity") then
                local weight = obj:GetAttribute("Weight") or (obj:FindFirstChild("Weight") and obj.Weight.Value) or "?"
                local rarity = obj:GetAttribute("Rarity") or (obj:FindFirstChild("Rarity") and obj.Rarity.Value) or "?"
                local mutation = obj:GetAttribute("Mutation") or obj:GetAttribute("Shiny") or "None"
                
                local info = string.format("🎣 CAUGHT! %s | Weight: %s | Rarity: %s | Mutation: %s | Time: %s",
                    obj.Name, tostring(weight), tostring(rarity), tostring(mutation), os.date("%H:%M:%S"))
                addLog(info, Color3.fromRGB(255, 215, 0))
            end
        end
    end)
end

-- Button Actions
ScanRSButton.MouseButton1Click:Connect(function()
    exploreReplicatedStorage()
end)

ScanFishButton.MouseButton1Click:Connect(function()
    scanFishDatabase()
end)

ClearButton.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    addLog("🗑️ Log cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Status: Log cleared"
end)

DestroyButton.MouseButton1Click:Connect(function()
    addLog("❌ Destroying script in 2 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: Destroying..."
    task.wait(2)
    
    -- Disconnect semua connections
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    
    -- Destroy GUI
    ScreenGui:Destroy()
    
    print("Fish Explorer destroyed!")
end)

-- Initialize
addLog("✅ Fish Explorer loaded!", Color3.fromRGB(0, 255, 150))
addLog("📌 Click 'Explore ReplicatedStorage' to see all modules", Color3.fromRGB(200, 200, 200))
addLog("📌 Click 'Scan Fish Database' to find fish data", Color3.fromRGB(200, 200, 200))
addLog("📌 Auto-logging fish catches...", Color3.fromRGB(200, 200, 200))

setupCatchDetection()

print("Fish Explorer Active!")
