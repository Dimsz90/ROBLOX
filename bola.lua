-- FISCH GAME - FISH EXPLORER & CATCH LOGGER
-- Script untuk mencari semua data ikan: nama, rarity, weight, mutation

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishExplorer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🐟 FISCH - Fish Explorer & Logger"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- ScrollFrame untuk list ikan
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
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
ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
ButtonFrame.Position = UDim2.new(0, 10, 1, -45)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

-- Scan Button
local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.48, 0, 1, 0)
ScanButton.Position = UDim2.new(0, 0, 0, 0)
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ScanButton.Text = "🔍 Scan Fish Data"
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.TextSize = 16
ScanButton.Font = Enum.Font.SourceSansBold
ScanButton.Parent = ButtonFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

-- Clear Button
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, 0, 1, 0)
ClearButton.Position = UDim2.new(0.52, 0, 0, 0)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClearButton.Text = "🗑️ Clear Log"
ClearButton.TextColor3 = Color3.new(1, 1, 1)
ClearButton.TextSize = 16
ClearButton.Font = Enum.Font.SourceSansBold
ClearButton.Parent = ButtonFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Data Storage
local fishDatabase = {}
local catchLog = {}

-- Fungsi untuk menambah entry ke log
local function addLogEntry(text, color)
    local Entry = Instance.new("TextLabel")
    Entry.Size = UDim2.new(1, -10, 0, 25)
    Entry.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Entry.Text = text
    Entry.TextColor3 = color or Color3.new(1, 1, 1)
    Entry.TextSize = 14
    Entry.Font = Enum.Font.SourceSans
    Entry.TextXAlignment = Enum.TextXAlignment.Left
    Entry.TextWrapped = true
    Entry.Parent = ScrollFrame
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 4)
    EntryCorner.Parent = Entry
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    return Entry
end

-- Fungsi untuk scan fish data dari berbagai lokasi
local function scanFishData()
    addLogEntry("=== SCANNING FISH DATA ===", Color3.fromRGB(255, 255, 0))
    
    local found = 0
    
    -- Scan ReplicatedStorage
    pcall(function()
        for _, module in pairs(ReplicatedStorage:GetDescendants()) do
            if module:IsA("ModuleScript") then
                local success, data = pcall(function()
                    return require(module)
                end)
                
                if success and type(data) == "table" then
                    -- Cari data ikan
                    for k, v in pairs(data) do
                        if type(v) == "table" and (v.Name or v.FishName or v.Rarity or v.Weight) then
                            local fishName = v.Name or v.FishName or tostring(k)
                            if not fishDatabase[fishName] then
                                fishDatabase[fishName] = v
                                found = found + 1
                                
                                local info = string.format("🐟 %s | Rarity: %s | Weight: %s", 
                                    fishName,
                                    tostring(v.Rarity or "?"),
                                    tostring(v.Weight or v.MinWeight or "?")
                                )
                                addLogEntry(info, Color3.fromRGB(100, 200, 255))
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Scan Workspace untuk caught fish
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                local name = obj.Name
                if name:lower():find("fish") or obj:FindFirstChild("FishData") then
                    if not fishDatabase[name] then
                        fishDatabase[name] = {Name = name, Source = "Workspace"}
                        found = found + 1
                        addLogEntry("🎣 Found: " .. name, Color3.fromRGB(150, 255, 150))
                    end
                end
            end
        end
    end)
    
    -- Scan PlayerGui inventory
    pcall(function()
        local gui = player.PlayerGui
        for _, obj in pairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text = obj.Text
                if text and #text > 2 and text:match("%a") then
                    -- Cari pattern nama ikan
                    if not fishDatabase[text] and (obj.Parent.Name:lower():find("fish") or obj.Parent.Name:lower():find("inventory")) then
                        fishDatabase[text] = {Name = text, Source = "GUI"}
                        found = found + 1
                        addLogEntry("📋 From GUI: " .. text, Color3.fromRGB(200, 200, 100))
                    end
                end
            end
        end
    end)
    
    addLogEntry(string.format("✅ Scan complete! Found %d fish entries", found), Color3.fromRGB(0, 255, 0))
end

-- Hook untuk mendeteksi catch event
local function hookCatchEvents()
    -- Monitor Workspace untuk new fish
    Workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Model") or obj:IsA("Part") then
            pcall(function()
                local fishData = obj:FindFirstChild("FishData")
                if fishData or obj.Name:lower():find("fish") then
                    local info = {
                        Name = obj.Name,
                        Time = os.date("%H:%M:%S"),
                        Weight = "Unknown",
                        Rarity = "Unknown",
                        Mutation = "None"
                    }
                    
                    -- Coba extract data
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") then
                            if child.Name:lower():find("weight") then
                                info.Weight = tostring(child.Value)
                            elseif child.Name:lower():find("rarity") then
                                info.Rarity = tostring(child.Value)
                            elseif child.Name:lower():find("mutation") or child.Name:lower():find("shiny") then
                                info.Mutation = tostring(child.Value)
                            end
                        end
                    end
                    
                    table.insert(catchLog, info)
                    
                    local logText = string.format("🎣 CAUGHT! %s | Weight: %s | Rarity: %s | Mutation: %s | Time: %s",
                        info.Name, info.Weight, info.Rarity, info.Mutation, info.Time)
                    addLogEntry(logText, Color3.fromRGB(255, 215, 0))
                end
            end)
        end
    end)
end

-- Button actions
ScanButton.MouseButton1Click:Connect(function()
    scanFishData()
end)

ClearButton.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    addLogEntry("🗑️ Log cleared!", Color3.fromRGB(255, 100, 100))
end)

-- Auto start
addLogEntry(" Fish Explorer loaded!", Color3.fromRGB(0, 255, 150))
addLogEntry(" Click 'Scan Fish Data' to search for fish", Color3.fromRGB(200, 200, 200))
addLogEntry(" Script will auto-log all fish you catch", Color3.fromRGB(200, 200, 200))

hookCatchEvents()

print("Fish Explorer Active!")
print("Commands: Press 'Scan Fish Data' button to start")
