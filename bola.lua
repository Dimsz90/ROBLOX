-- FISH DEX EXPLORER - General Version
-- Tanpa event monitoring untuk fokus pada data ikan saja

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishDexExplorer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 150)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🐠 FISH DEX EXPLORER"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 24
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Complete Fish Database & Analysis"
SubTitle.TextColor3 = Color3.fromRGB(180, 220, 255)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Parent = MainFrame

-- Tab System
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -20, 0, 40)
TabsFrame.Position = UDim2.new(0, 10, 0, 80)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local Tabs = {
    "Fish Database",
    "Controller Info", 
    "Catch Logger",
    "Settings"
}

local currentTab = "Fish Database"
local tabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(1/#Tabs, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = tabName == "Fish Database" and Color3.fromRGB(0, 120, 180) or Color3.fromRGB(40, 40, 60)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Parent = TabsFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -170)
ContentFrame.Position = UDim2.new(0, 10, 0, 125)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- ScrollFrame untuk konten
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 150)
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -70)
StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
StatusBar.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 5, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- Control Buttons
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 30)
ControlFrame.Position = UDim2.new(0, 10, 1, -30)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.24, -5, 1, 0)
ScanBtn.Position = UDim2.new(0, 0, 0, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ScanBtn.Text = "🔍 Scan"
ScanBtn.TextColor3 = Color3.new(1, 1, 1)
ScanBtn.TextSize = 13
ScanBtn.Font = Enum.Font.SourceSansBold
ScanBtn.Parent = ControlFrame

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.24, -5, 1, 0)
ClearBtn.Position = UDim2.new(0.25, 5, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ClearBtn.Text = "🗑️ Clear"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.TextSize = 13
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.Parent = ControlFrame

local ExportBtn = Instance.new("TextButton")
ExportBtn.Size = UDim2.new(0.24, -5, 1, 0)
ExportBtn.Position = UDim2.new(0.5, 5, 0, 0)
ExportBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
ExportBtn.Text = "💾 Export"
ExportBtn.TextColor3 = Color3.new(1, 1, 1)
ExportBtn.TextSize = 13
ExportBtn.Font = Enum.Font.SourceSansBold
ExportBtn.Parent = ControlFrame

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(0.24, -5, 1, 0)
DestroyBtn.Position = UDim2.new(0.75, 5, 0, 0)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.Text = "❌ Destroy"
DestroyBtn.TextColor3 = Color3.new(1, 1, 1)
DestroyBtn.TextSize = 13
DestroyBtn.Font = Enum.Font.SourceSansBold
DestroyBtn.Parent = ControlFrame

-- Button corners
for _, btn in pairs({ScanBtn, ClearBtn, ExportBtn, DestroyBtn}) do
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
end

-- Data storage
local fishDatabase = {}
local fishingController = nil
local originalFishCaught = nil
local rarityMap = {}
local caughtHistory = {}

-- Initialize rarity map
for i = 1, 7 do
    local name = "Unknown"
    local color = Color3.fromRGB(150, 150, 150)
    
    if i == 1 then name = "Common"; color = Color3.fromRGB(150, 150, 150)
    elseif i == 2 then name = "Uncommon"; color = Color3.fromRGB(100, 200, 100)
    elseif i == 3 then name = "Rare"; color = Color3.fromRGB(100, 150, 255)
    elseif i == 4 then name = "Epic"; color = Color3.fromRGB(200, 100, 255)
    elseif i == 5 then name = "Legendary"; color = Color3.fromRGB(255, 215, 0)
    elseif i == 6 then name = "Mythic"; color = Color3.fromRGB(255, 100, 100)
    elseif i == 7 then name = "SECRET"; color = Color3.fromRGB(255, 50, 255)
    end
    
    rarityMap[i] = {Name = name, Color = color}
end

-- Fungsi untuk menambahkan log
local function addLog(text, color, icon)
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, 0, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Entry.Parent = ScrollFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Entry
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.Parent = Entry
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1
    Content.Text = (icon or "") .. " " .. text
    Content.TextColor3 = color or Color3.new(1, 1, 1)
    Content.TextSize = 13
    Content.Font = Enum.Font.SourceSans
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.TextWrapped = true
    Content.Parent = Entry
    
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.CanvasSize.Y.Offset)
end

-- Fungsi clear content
local function clearContent()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- TAB 1: FISH DATABASE
local function showFishDatabase()
    clearContent()
    StatusLabel.Text = "Loading fish database..."
    
    addLog("=== FISH DATABASE ===", Color3.fromRGB(0, 255, 200), "🐠")
    
    if next(fishDatabase) == nil then
        addLog("📂 Database is empty. Click 'Scan' to find fish data.", Color3.fromRGB(255, 200, 100))
        return
    end
    
    local totalFish = 0
    local fishByRarity = {}
    
    -- Group fish by rarity
    for _, fish in pairs(fishDatabase) do
        totalFish = totalFish + 1
        local rarity = fish.Rarity or 1
        
        if not fishByRarity[rarity] then
            fishByRarity[rarity] = {}
        end
        table.insert(fishByRarity[rarity], fish)
    end
    
    addLog("📊 Total Fish: " .. totalFish, Color3.fromRGB(0, 255, 150))
    
    -- Display by rarity (1 to 7)
    for rarity = 1, 7 do
        if fishByRarity[rarity] then
            local rarityInfo = rarityMap[rarity]
            local fishList = fishByRarity[rarity]
            
            addLog("⭐ " .. rarityInfo.Name .. " (" .. #fishList .. ")", rarityInfo.Color)
            
            -- Sort fish by name
            table.sort(fishList, function(a, b)
                return a.Name < b.Name
            end)
            
            for _, fish in ipairs(fishList) do
                local info = "   🐟 " .. fish.Name
                
                if fish.Weight then
                    info = info .. " | Weight: " .. tostring(fish.Weight)
                end
                
                if fish.Mutation and fish.Mutation ~= "None" then
                    info = info .. " | Mutation: " .. tostring(fish.Mutation)
                end
                
                addLog(info, rarityInfo.Color)
            end
        end
    end
    
    -- Show statistics
    addLog("=== DATABASE STATISTICS ===", Color3.fromRGB(255, 255, 0), "📈")
    
    for rarity = 1, 7 do
        if fishByRarity[rarity] then
            local rarityInfo = rarityMap[rarity]
            local count = #fishByRarity[rarity]
            local percentage = math.floor((count / totalFish) * 100)
            
            addLog(rarityInfo.Name .. ": " .. count .. " fish (" .. percentage .. "%)", rarityInfo.Color)
        end
    end
    
    StatusLabel.Text = "Loaded " .. totalFish .. " fish"
end

-- Fungsi scan untuk fish data
local function scanForFishData()
    clearContent()
    StatusLabel.Text = "Scanning for fish data..."
    
    addLog("=== SCANNING FISH DATA ===", Color3.fromRGB(0, 255, 200), "🔍")
    
    -- Reset database
    fishDatabase = {}
    
    -- Scan ReplicatedStorage untuk fish modules
    local modulesScanned = 0
    local fishFound = 0
    
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") then
            modulesScanned = modulesScanned + 1
            
            -- Try to load module
            local success, data = pcall(function()
                return require(item)
            end)
            
            if success and type(data) == "table" then
                -- Check for fish data
                for key, value in pairs(data) do
                    if type(value) == "table" then
                        local fishName = value.Name or value.FishName or tostring(key)
                        local rarityNum = value.Rarity or value.Tier
                        
                        -- Valid fish data check
                        if fishName and rarityNum and type(rarityNum) == "number" then
                            fishFound = fishFound + 1
                            
                            local fishInfo = {
                                Name = fishName,
                                Rarity = rarityNum,
                                RarityName = rarityMap[rarityNum] and rarityMap[rarityNum].Name or "Unknown",
                                Weight = value.Weight or value.Size,
                                Mutation = value.Mutation or value.Shiny or value.Variant or "None",
                                Value = value.Value or value.Price,
                                Source = item.Name
                            }
                            
                            fishDatabase[fishName] = fishInfo
                        end
                    end
                end
            end
        end
    end
    
    addLog("✅ Scan Complete!", Color3.fromRGB(0, 255, 150))
    addLog("📦 Modules scanned: " .. modulesScanned, Color3.fromRGB(200, 200, 255))
    addLog("🐟 Fish found: " .. fishFound, Color3.fromRGB(100, 255, 200))
    
    if fishFound > 0 then
        -- Show sample of found fish
        addLog("=== SAMPLE OF FOUND FISH ===", Color3.fromRGB(255, 255, 0), "🎣")
        
        local sampleCount = 0
        for _, fish in pairs(fishDatabase) do
            if sampleCount < 5 then
                local rarityInfo = rarityMap[fish.Rarity]
                local color = rarityInfo and rarityInfo.Color or Color3.fromRGB(200, 200, 200)
                
                addLog(fish.Name .. " (" .. (fish.RarityName or "?") .. ")", color)
                sampleCount = sampleCount + 1
            else
                addLog("... and " .. (fishFound - 5) .. " more", Color3.fromRGB(150, 150, 150))
                break
            end
        end
    else
        addLog("❌ No fish data found!", Color3.fromRGB(255, 100, 100))
        addLog("💡 Check if fish data is stored in ModuleScripts", Color3.fromRGB(255, 200, 100))
    end
    
    StatusLabel.Text = "Found " .. fishFound .. " fish"
    
    -- Auto-show database setelah scan
    if currentTab == "Fish Database" then
        showFishDatabase()
    end
end

-- TAB 2: CONTROLLER INFO
local function showControllerInfo()
    clearContent()
    StatusLabel.Text = "Loading controller info..."
    
    addLog("=== FISHING CONTROLLER INFO ===", Color3.fromRGB(0, 255, 200), "🎮")
    
    -- Cari controller
    local controllerPath = "Controllers.ClassicGroupFishingController"
    local current = ReplicatedStorage
    
    for part in controllerPath:gmatch("[^.]+") do
        current = current:FindFirstChild(part)
        if not current then break end
    end
    
    if not current or not current:IsA("ModuleScript") then
        addLog("❌ Controller not found at: " .. controllerPath, Color3.fromRGB(255, 50, 50))
        
        -- Coba cari di tempat lain
        addLog("--- Searching for fishing controller ---", Color3.fromRGB(255, 200, 100))
        
        local found = false
        for _, item in pairs(ReplicatedStorage:GetDescendants()) do
            if item:IsA("ModuleScript") then
                local name = item.Name:lower()
                if name:find("fish") and (name:find("controller") or name:find("control")) then
                    addLog("📦 Found: " .. item:GetFullName(), Color3.fromRGB(150, 200, 255))
                    current = item
                    found = true
                    break
                end
            end
        end
        
        if not found then
            addLog("❌ No fishing controller found", Color3.fromRGB(255, 100, 100))
            return
        end
    end
    
    addLog("✅ Controller: " .. current:GetFullName(), Color3.fromRGB(0, 255, 150))
    
    -- Load controller
    local success, data = pcall(function()
        return require(current)
    end)
    
    if not success then
        addLog("❌ Failed to load controller: " .. tostring(data), Color3.fromRGB(255, 50, 50))
        return
    end
    
    fishingController = data
    addLog("📦 Controller loaded successfully", Color3.fromRGB(0, 255, 0))
    
    -- Show key functions
    addLog("=== KEY FUNCTIONS ===", Color3.fromRGB(255, 255, 0), "🔑")
    
    local keyFunctions = {
        "FishCaught", "GetCurrentGUID", "RequestFishingMinigameClick",
        "SendFishingRequestToServer", "FishingRodStarted", "Start",
        "RequestChargeFishingRod", "FishingStopped", "Init"
    }
    
    local foundFunctions = 0
    for _, funcName in ipairs(keyFunctions) do
        if data[funcName] then
            local funcType = type(data[funcName])
            local color = funcType == "function" and Color3.fromRGB(100, 255, 200) or Color3.fromRGB(255, 200, 100)
            
            addLog(funcName .. " (" .. funcType .. ")", color)
            foundFunctions = foundFunctions + 1
        else
            addLog("❌ " .. funcName .. " (not found)", Color3.fromRGB(150, 150, 150))
        end
    end
    
    addLog("📊 Found " .. foundFunctions .. " key functions", Color3.fromRGB(0, 255, 150))
    
    -- Test GetCurrentGUID jika ada
    if data.GetCurrentGUID and type(data.GetCurrentGUID) == "function" then
        addLog("=== CURRENT FISHING INFO ===", Color3.fromRGB(200, 200, 255), "🎣")
        
        local success, guid = pcall(data.GetCurrentGUID)
        if success then
            addLog("🔑 Current GUID: " .. tostring(guid), Color3.fromRGB(100, 255, 200))
        end
        
        -- Check cooldown
        if data.OnCooldown ~= nil then
            addLog("⏱️ On Cooldown: " .. tostring(data.OnCooldown), 
                   data.OnCooldown and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100))
        end
    end
    
    StatusLabel.Text = "Controller info loaded"
end

-- TAB 3: CATCH LOGGER
local function setupCatchLogger()
    clearContent()
    StatusLabel.Text = "Setting up catch logger..."
    
    addLog("=== CATCH LOGGER ===", Color3.fromRGB(0, 255, 200), "🎣")
    
    if not fishingController then
        addLog("⚠️ Please load controller info first!", Color3.fromRGB(255, 150, 50))
        
        -- Coba load otomatis
        local controllerPath = "Controllers.ClassicGroupFishingController"
        local current = ReplicatedStorage
        
        for part in controllerPath:gmatch("[^.]+") do
            current = current:FindFirstChild(part)
            if not current then break end
        end
        
        if current and current:IsA("ModuleScript") then
            local success, data = pcall(require, current)
            if success then
                fishingController = data
                addLog("✅ Auto-loaded controller", Color3.fromRGB(0, 255, 150))
            end
        end
    end
    
    if not fishingController then
        addLog("❌ Cannot setup logger without controller", Color3.fromRGB(255, 50, 50))
        return
    end
    
    -- Setup hook untuk FishCaught
    if fishingController.FishCaught and type(fishingController.FishCaught) == "function" then
        addLog("🎯 Found FishCaught function!", Color3.fromRGB(255, 215, 0))
        
        -- Simpan fungsi asli
        originalFishCaught = fishingController.FishCaught
        
        -- Hook function
        fishingController.FishCaught = function(...)
            local args = {...}
            local timestamp = os.date("%H:%M:%S")
            
            -- Log catch
            addLog("🎣 FISH CAUGHT at " .. timestamp, Color3.fromRGB(255, 215, 0))
            
            -- Analyze fish data
            for i, arg in ipairs(args) do
                if type(arg) == "table" then
                    local fishName = arg.Name or arg.FishName
                    local rarityNum = arg.Rarity or arg.Tier
                    local weight = arg.Weight or arg.Size
                    local mutation = arg.Mutation or arg.Shiny or arg.Variant
                    
                    if fishName then
                        -- Get rarity info
                        local rarityInfo = rarityMap[tonumber(rarityNum)] or {Name = "Unknown", Color = Color3.fromRGB(200, 200, 200)}
                        
                        addLog("   🐟 " .. fishName, rarityInfo.Color)
                        addLog("   ⭐ Rarity: " .. rarityInfo.Name .. " (" .. tostring(rarityNum or "?") .. ")", rarityInfo.Color)
                        
                        if weight then
                            addLog("   ⚖️ Weight: " .. tostring(weight), rarityInfo.Color)
                        end
                        
                        if mutation then
                            addLog("   ✨ Mutation: " .. tostring(mutation), rarityInfo.Color)
                        end
                        
                        -- Simpan ke history
                        table.insert(caughtHistory, {
                            Time = timestamp,
                            Name = fishName,
                            Rarity = rarityNum,
                            Weight = weight,
                            Mutation = mutation
                        })
                        
                        -- Update status
                        StatusLabel.Text = "Last caught: " .. fishName
                        
                        -- Print ke console juga
                        print("=== FISH CAUGHT ===")
                        print("Time:", timestamp)
                        print("Name:", fishName)
                        print("Rarity:", rarityInfo.Name, "(" .. tostring(rarityNum or "?") .. ")")
                        if weight then print("Weight:", weight) end
                        if mutation then print("Mutation:", mutation) end
                        print("================")
                    end
                end
            end
            
            -- Panggil fungsi asli
            return originalFishCaught(...)
        end
        
        addLog("✅ Successfully hooked to FishCaught!", Color3.fromRGB(0, 255, 0))
        addLog("📌 Now go fishing! All catches will be logged here.", Color3.fromRGB(200, 200, 255))
        
    else
        addLog("❌ FishCaught function not found", Color3.fromRGB(255, 100, 100))
        
        -- Coba cari fungsi lain
        addLog("--- Searching for catch-related functions ---", Color3.fromRGB(255, 200, 100))
        
        local found = false
        for key, value in pairs(fishingController) do
            if type(value) == "function" then
                local keyLower = key:lower()
                if keyLower:find("catch") or keyLower:find("fish") then
                    addLog("🎯 Found: " .. key, Color3.fromRGB(255, 215, 0))
                    found = true
                end
            end
        end
        
        if not found then
            addLog("❌ No catch functions found", Color3.fromRGB(255, 50, 50))
        end
    end
    
    -- Show recent catches jika ada
    if #caughtHistory > 0 then
        addLog("=== RECENT CATCHES ===", Color3.fromRGB(255, 255, 0), "📋")
        
        local showCount = math.min(5, #caughtHistory)
        for i = #caughtHistory, #caughtHistory - showCount + 1, -1 do
            local catch = caughtHistory[i]
            if catch then
                local rarityInfo = rarityMap[tonumber(catch.Rarity)] or {Name = "Unknown", Color = Color3.fromRGB(200, 200, 200)}
                
                local info = catch.Time .. " - " .. catch.Name
                if catch.Weight then
                    info = info .. " (" .. catch.Weight .. ")"
                end
                
                addLog(info, rarityInfo.Color)
            end
        end
    end
    
    StatusLabel.Text = "Catch logger ready"
end

-- TAB 4: SETTINGS
local function showSettings()
    clearContent()
    StatusLabel.Text = "Settings"
    
    addLog("=== SETTINGS ===", Color3.fromRGB(0, 255, 200), "⚙️")
    
    -- Auto-scan setting
    local AutoScanFrame = Instance.new("Frame")
    AutoScanFrame.Size = UDim2.new(0.9, 0, 0, 40)
    AutoScanFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    AutoScanFrame.Parent = ScrollFrame
    
    local AutoScanCorner = Instance.new("UICorner")
    AutoScanCorner.CornerRadius = UDim.new(0, 6)
    AutoScanCorner.Parent = AutoScanFrame
    
    local AutoScanLabel = Instance.new("TextLabel")
    AutoScanLabel.Size = UDim2.new(0.7, 0, 1, 0)
    AutoScanLabel.Position = UDim2.new(0, 10, 0, 0)
    AutoScanLabel.BackgroundTransparency = 1
    AutoScanLabel.Text = "🔍 Auto-scan on startup"
    AutoScanLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    AutoScanLabel.TextSize = 14
    AutoScanLabel.Font = Enum.Font.SourceSans
    AutoScanLabel.TextXAlignment = Enum.TextXAlignment.Left
    AutoScanLabel.Parent = AutoScanFrame
    
    local AutoScanToggle = Instance.new("TextButton")
    AutoScanToggle.Size = UDim2.new(0.2, 0, 0.6, 0)
    AutoScanToggle.Position = UDim2.new(0.75, 0, 0.2, 0)
    AutoScanToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    AutoScanToggle.Text = "ON"
    AutoScanToggle.TextColor3 = Color3.new(1, 1, 1)
    AutoScanToggle.TextSize = 12
    AutoScanToggle.Font = Enum.Font.SourceSansBold
    AutoScanToggle.Parent = AutoScanFrame
    
    AutoScanToggle.MouseButton1Click:Connect(function()
        if AutoScanToggle.Text == "ON" then
            AutoScanToggle.Text = "OFF"
            AutoScanToggle.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        else
            AutoScanToggle.Text = "ON"
            AutoScanToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        end
    end)
    
    -- Info section
    addLog("=== INFO ===", Color3.fromRGB(200, 200, 255), "📊")
    
    addLog("🐟 Fish in database: " .. (next(fishDatabase) and table.count(fishDatabase) or 0), Color3.fromRGB(200, 200, 200))
    addLog("🎣 Caught history: " .. #caughtHistory, Color3.fromRGB(200, 200, 200))
    addLog("🎮 Controller: " .. (fishingController and "Loaded" or "Not loaded"), Color3.fromRGB(200, 200, 200))
    
    -- Reset buttons
    local ResetDataBtn = Instance.new("TextButton")
    ResetDataBtn.Size = UDim2.new(0.8, 0, 0, 35)
    ResetDataBtn.Position = UDim2.new(0.1, 0, 0, 250)
    ResetDataBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    ResetDataBtn.Text = "🔄 Reset All Data"
    ResetDataBtn.TextColor3 = Color3.new(1, 1, 1)
    ResetDataBtn.TextSize = 14
    ResetDataBtn.Font = Enum.Font.SourceSansBold
    ResetDataBtn.Parent = ScrollFrame
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 8)
    ResetCorner.Parent = ResetDataBtn
    
    ResetDataBtn.MouseButton1Click:Connect(function()
        fishDatabase = {}
        caughtHistory = {}
        addLog("✅ All data reset", Color3.fromRGB(0, 255, 150))
        StatusLabel.Text = "Data reset"
        
        -- Refresh fish database tab
        if currentTab == "Fish Database" then
            showFishDatabase()
        end
    end)
    
    -- Help info
    addLog("=== HOW TO USE ===", Color3.fromRGB(150, 255, 200), "❓")
    
    addLog("1. Go to 'Fish Database' tab", Color3.fromRGB(200, 200, 200))
    addLog("2. Click 'Scan' to find fish data", Color3.fromRGB(200, 200, 200))
    addLog("3. Go to 'Catch Logger' tab", Color3.fromRGB(200, 200, 200))
    addLog("4. Start fishing - catches auto-log", Color3.fromRGB(200, 200, 200))
    
    StatusLabel.Text = "Settings loaded"
end

-- Tab switching
local function switchTab(tabName)
    currentTab = tabName
    
    -- Update tab buttons
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and Color3.fromRGB(0, 120, 180) or Color3.fromRGB(40, 40, 60)
    end
    
    -- Load tab content
    if tabName == "Fish Database" then
        showFishDatabase()
    elseif tabName == "Controller Info" then
        showControllerInfo()
    elseif tabName == "Catch Logger" then
        setupCatchLogger()
    elseif tabName == "Settings" then
        showSettings()
    end
end

-- Button connections
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Control buttons
ScanBtn.MouseButton1Click:Connect(function()
    scanForFishData()
end)

ClearBtn.MouseButton1Click:Connect(function()
    clearContent()
    addLog("🗑️ Log cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Log cleared"
end)

ExportBtn.MouseButton1Click:Connect(function()
    addLog("💾 Exporting data...", Color3.fromRGB(100, 255, 100))
    
    print("=== FISH DEX EXPORT ===")
    print("Total fish in database:", next(fishDatabase) and table.count(fishDatabase) or 0)
    print("Total catches logged:", #caughtHistory)
    print("Controller loaded:", fishingController and "Yes" or "No")
    print("======================")
    
    -- Export fish database
    if next(fishDatabase) then
        print("\n=== FISH DATABASE ===")
        for name, fish in pairs(fishDatabase) do
            print(string.format("%s | Rarity: %s (%d) | Weight: %s | Mutation: %s",
                name, fish.RarityName or "?", fish.Rarity or 0, tostring(fish.Weight or "?"), tostring(fish.Mutation or "None")))
        end
    end
    
    -- Export catch history
    if #caughtHistory > 0 then
        print("\n=== CATCH HISTORY ===")
        for i, catch in ipairs(caughtHistory) do
            print(string.format("%s - %s (Rarity: %d, Weight: %s)",
                catch.Time, catch.Name, catch.Rarity or 0, tostring(catch.Weight or "?")))
        end
    end
    
    StatusLabel.Text = "Data exported to console"
end)

DestroyBtn.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying script in 3 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: DESTROYING..."
    
    -- Countdown
    for i = 3, 1, -1 do
        DestroyBtn.Text = "Destroying in " .. i .. "..."
        task.wait(1)
    end
    
    -- Restore original function
    if originalFishCaught and fishingController then
        pcall(function()
            fishingController.FishCaught = originalFishCaught
        end)
    end
    
    -- Destroy GUI
    ScreenGui:Destroy()
    
    print("Fish Dex Explorer destroyed!")
end)

-- Auto-start
addLog("✅ Fish Dex Explorer Loaded!", Color3.fromRGB(0, 255, 200))
addLog("📌 Click 'Scan' to find fish data", Color3.fromRGB(200, 200, 255))
addLog("🎣 Go to 'Catch Logger' to log fish catches", Color3.fromRGB(200, 200, 255))

-- Start dengan Fish Database tab
switchTab("Fish Database")

-- Auto-scan jika tidak ada data
task.spawn(function()
    task.wait(2)
    if next(fishDatabase) == nil then
        addLog("🔍 No fish data found. Auto-scanning...", Color3.fromRGB(255, 200, 100))
        scanForFishData()
    end
end)

print("Fish Dex Explorer - General Version Loaded!")
print("No event monitoring - Focus on fish data only")
