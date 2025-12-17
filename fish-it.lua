-- baru

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

-- Content Area (Dikembalikan ke ukuran default)
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

-- FUNGSI CSV
local function tableToCSV(data, columns)
    local csvString = ""
    
    -- Header
    csvString = table.concat(columns, ",") .. "\n"
    
    -- Rows
    for _, row in ipairs(data) do
        local rowData = {}
        for _, col in ipairs(columns) do
            local value = row[col]
            local formattedValue = tostring(value or "")
            
            -- Hapus line breaks/newlines
            formattedValue = formattedValue:gsub("[\n\r]", " ")
            
            -- Escape double quotes dan bungkus dengan double quotes jika mengandung koma atau quote
            formattedValue = formattedValue:gsub("\"", "\"\"")
            if formattedValue:find(",") or formattedValue:find("\"") then
                formattedValue = "\"" .. formattedValue .. "\""
            end
            table.insert(rowData, formattedValue)
        end
        csvString = csvString .. table.concat(rowData, ",") .. "\n"
    end
    
    return csvString
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
                local info = "    🐟 " .. fish.Name
                
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
                        
                        addLog("    🐟 " .. fishName, rarityInfo.Color)
                        addLog("    ⭐ Rarity: " .. rarityInfo.Name .. " (" .. tostring(rarityNum or "?") .. ")", rarityInfo.Color)
                        
                        if weight then
                            addLog("    ⚖️ Weight: " .. tostring(weight), rarityInfo.Color)
                        end
                        
                        if mutation then
                            addLog("    ✨ Mutation: " .. tostring(mutation), rarityInfo.Color)
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
    addLog("3. Click 'Export' untuk salin data dari Console (F9)", Color3.fromRGB(200, 200, 200))
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

-- FUNGSI EKSPOR MENGGUNAKAN FUNGSI setclipboard() (JIKA TERSEDIA)
ExportBtn.MouseButton1Click:Connect(function()
    clearContent() 
    addLog("💾 Menyiapkan data untuk clipboard...", Color3.fromRGB(100, 255, 100))
    
    -- Hitung total ikan di database
    local totalFish = 0
    for _ in pairs(fishDatabase) do
        totalFish = totalFish + 1
    end
    
    local fullCSV = ""
    local hasData = false
    
    -- 1. EKSPOR FISH DATABASE (PRIORITAS UTAMA)
    if totalFish > 0 then
        addLog("📊 Mengumpulkan data Fish Database...", Color3.fromRGB(100, 200, 255))
        
        -- Konversi fishDatabase ke array untuk tableToCSV
        local fishList = {}
        for _, fishData in pairs(fishDatabase) do
            table.insert(fishList, fishData)
        end
        
        -- Pastikan kolom sesuai dengan struktur data yang ada
        local fishColumns = {"Name", "Rarity", "RarityName", "Weight", "Mutation", "Value", "Source"}
        local fishCSV = ""
        
        -- Buat header CSV
        for i, column in ipairs(fishColumns) do
            fishCSV = fishCSV .. column
            if i < #fishColumns then
                fishCSV = fishCSV .. ","
            end
        end
        fishCSV = fishCSV .. "\n"
        
        -- Buat baris data
        for _, fishData in ipairs(fishList) do
            for i, column in ipairs(fishColumns) do
                local value = fishData[column] or ""
                -- Handle nilai khusus
                if column == "Mutation" then
                    value = fishData.Mutation or "Normal"
                elseif column == "Source" then
                    value = fishData.Source or "Unknown"
                end
                
                -- Escape koma dan quote
                if tostring(value):find(",") or tostring(value):find('"') then
                    value = '"' .. tostring(value):gsub('"', '""') .. '"'
                end
                
                fishCSV = fishCSV .. tostring(value)
                if i < #fishColumns then
                    fishCSV = fishCSV .. ","
                end
            end
            fishCSV = fishCSV .. "\n"
        end
        
        fullCSV = fullCSV .. "### FISH DATABASE ###\n"
        fullCSV = fullCSV .. fishCSV .. "\n"
        hasData = true
        addLog("✅ Fish Database siap ("..totalFish.." ikan)", Color3.fromRGB(0, 255, 150))
    else
        addLog("⚠️ Fish Database kosong", Color3.fromRGB(255, 150, 50))
    end
    
    -- 2. EKSPOR CATCH HISTORY (OPSIONAL)
    if caughtHistory and #caughtHistory > 0 then
        addLog("📈 Mengumpulkan Catch History...", Color3.fromRGB(200, 150, 255))
        
        local historyColumns = {"Time", "Name", "Rarity", "Weight", "Mutation"}
        local historyCSV = ""
        
        -- Buat header
        for i, column in ipairs(historyColumns) do
            historyCSV = historyCSV .. column
            if i < #historyColumns then
                historyCSV = historyCSV .. ","
            end
        end
        historyCSV = historyCSV .. "\n"
        
        -- Buat baris data
        for _, historyData in ipairs(caughtHistory) do
            for i, column in ipairs(historyColumns) do
                local value = historyData[column] or ""
                
                -- Format waktu jika ada
                if column == "Time" and value then
                    if typeof(value) == "DateTime" then
                        value = value:FormatLocalTime("HH:mm:ss", "en-us")
                    end
                end
                
                -- Escape koma dan quote
                if tostring(value):find(",") or tostring(value):find('"') then
                    value = '"' .. tostring(value):gsub('"', '""') .. '"'
                end
                
                historyCSV = historyCSV .. tostring(value)
                if i < #historyColumns then
                    historyCSV = historyCSV .. ","
                end
            end
            historyCSV = historyCSV .. "\n"
        end
        
        fullCSV = fullCSV .. "### CATCH HISTORY ###\n"
        fullCSV = fullCSV .. historyCSV .. "\n"
        hasData = true
        addLog("✅ Catch History siap ("..#caughtHistory.." tangkapan)", Color3.fromRGB(0, 255, 150))
    else
        addLog("⚠️ Catch History kosong", Color3.fromRGB(255, 150, 50))
    end
    
    -- 3. PROSES COPY KE CLIPBOARD
    if hasData then
        -- Coba berbagai metode clipboard
        local copySuccess = false
        
        -- METODE 1: setclipboard() (Synapse, Krnl, dll)
        if type(setclipboard) == "function" then
            pcall(function()
                setclipboard(fullCSV)
                copySuccess = true
                addLog("📋 Data disalin dengan setclipboard()", Color3.fromRGB(100, 255, 100))
            end)
        end
        
        -- METODE 2: writeclipboard() (beberapa executor)
        if not copySuccess and type(writeclipboard) == "function" then
            pcall(function()
                writeclipboard(fullCSV)
                copySuccess = true
                addLog("📋 Data disalin dengan writeclipboard()", Color3.fromRGB(100, 255, 100))
            end)
        end
        
        -- METODE 3: Clipboard service (Roblox native)
        if not copySuccess then
            pcall(function()
                local ClipboardService = game:GetService("ClipboardService")
                if ClipboardService then
                    ClipboardService:SetString(fullCSV)
                    copySuccess = true
                    addLog("📋 Data disalin dengan ClipboardService", Color3.fromRGB(100, 255, 100))
                end
            end)
        end
        
        -- METODE 4: GUI TextBox untuk copy manual
        if not copySuccess then
            addLog("❌ Fungsi clipboard tidak ditemukan", Color3.fromRGB(255, 50, 50))
            addLog("🔄 Membuat TextBox untuk copy manual...", Color3.fromRGB(255, 200, 100))
            
            -- Hapus frame copy sebelumnya jika ada
            if script.Parent:FindFirstChild("CopyFrame") then
                script.Parent:FindFirstChild("CopyFrame"):Destroy()
            end
            
            -- Buat frame untuk textbox
            local CopyFrame = Instance.new("Frame")
            CopyFrame.Name = "CopyFrame"
            CopyFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
            CopyFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
            CopyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            CopyFrame.BackgroundTransparency = 0.1
            CopyFrame.BorderSizePixel = 2
            CopyFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
            CopyFrame.ZIndex = 100
            
            -- UIStroke untuk efek glow
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 150, 255)
            stroke.Thickness = 3
            stroke.Parent = CopyFrame
            
            -- Corner
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = CopyFrame
            
            -- Title
            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Text = "📋 COPY DATA MANUAL (Select All → Ctrl+C)"
            title.Size = UDim2.new(1, 0, 0.08, 0)
            title.Position = UDim2.new(0, 0, 0, 0)
            title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            title.BackgroundTransparency = 0.2
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Font = Enum.Font.GothamBold
            title.TextSize = 18
            title.TextXAlignment = Enum.TextXAlignment.Center
            
            local titleCorner = Instance.new("UICorner")
            titleCorner.CornerRadius = UDim.new(0, 8)
            titleCorner.Parent = title
            
            local titleStroke = Instance.new("UIStroke")
            titleStroke.Color = Color3.fromRGB(0, 200, 255)
            titleStroke.Thickness = 2
            titleStroke.Parent = title
            
            title.Parent = CopyFrame
            
            -- Close button
            local closeBtn = Instance.new("TextButton")
            closeBtn.Name = "CloseBtn"
            closeBtn.Text = "✕"
            closeBtn.Size = UDim2.new(0.08, 0, 0.08, 0)
            closeBtn.Position = UDim2.new(0.92, 0, 0, 0)
            closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            closeBtn.TextColor3 = Color3.white
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.TextSize = 16
            
            closeBtn.MouseButton1Click:Connect(function()
                CopyFrame:Destroy()
                addLog("📦 TextBox ditutup", Color3.fromRGB(200, 200, 200))
            end)
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 8)
            closeCorner.Parent = closeBtn
            
            closeBtn.Parent = CopyFrame
            
            -- TextBox untuk data
            local textBox = Instance.new("TextBox")
            textBox.Name = "DataTextBox"
            textBox.Text = fullCSV
            textBox.Size = UDim2.new(0.96, 0, 0.84, 0)
            textBox.Position = UDim2.new(0.02, 0, 0.1, 0)
            textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            textBox.TextColor3 = Color3.fromRGB(200, 255, 200)
            textBox.Font = Enum.Font.Code
            textBox.TextSize = 14
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.TextYAlignment = Enum.TextYAlignment.Top
            textBox.TextWrapped = false
            textBox.ClearTextOnFocus = false
            textBox.MultiLine = true
            textBox.ScrollingEnabled = true
            
            -- Auto-select all text ketika focus
            textBox.Focused:Connect(function()
                wait(0.1)
                textBox:CaptureFocus()
                textBox.SelectionStart = 1
                textBox.CursorPosition = #textBox.Text + 1
            end)
            
            local textBoxCorner = Instance.new("UICorner")
            textBoxCorner.CornerRadius = UDim.new(0, 6)
            textBoxCorner.Parent = textBox
            
            local textBoxStroke = Instance.new("UIStroke")
            textBoxStroke.Color = Color3.fromRGB(100, 100, 150)
            textBoxStroke.Thickness = 1
            textBoxStroke.Parent = textBox
            
            textBox.Parent = CopyFrame
            
            -- Select All Button
            local selectAllBtn = Instance.new("TextButton")
            selectAllBtn.Name = "SelectAllBtn"
            selectAllBtn.Text = "📄 SELECT ALL"
            selectAllBtn.Size = UDim2.new(0.4, 0, 0.06, 0)
            selectAllBtn.Position = UDim2.new(0.05, 0, 0.95, 0)
            selectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            selectAllBtn.TextColor3 = Color3.white
            selectAllBtn.Font = Enum.Font.GothamBold
            selectAllBtn.TextSize = 14
            
            selectAllBtn.MouseButton1Click:Connect(function()
                textBox:CaptureFocus()
                textBox.SelectionStart = 1
                textBox.CursorPosition = #textBox.Text + 1
                addLog("📄 Semua teks dipilih (Ctrl+C untuk copy)", Color3.fromRGB(100, 255, 200))
            end)
            
            local selectCorner = Instance.new("UICorner")
            selectCorner.CornerRadius = UDim.new(0, 6)
            selectCorner.Parent = selectAllBtn
            
            selectAllBtn.Parent = CopyFrame
            
            -- Copy Button
            local copyBtn = Instance.new("TextButton")
            copyBtn.Name = "CopyBtn"
            copyBtn.Text = "📋 COPY TO CLIPBOARD"
            copyBtn.Size = UDim2.new(0.4, 0, 0.06, 0)
            copyBtn.Position = UDim2.new(0.55, 0, 0.95, 0)
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            copyBtn.TextColor3 = Color3.white
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.TextSize = 14
            
            copyBtn.MouseButton1Click:Connect(function()
                -- Coba copy dengan berbagai metode lagi
                local copied = false
                
                if type(setclipboard) == "function" then
                    pcall(function() setclipboard(textBox.Text) copied = true end)
                elseif type(writeclipboard) == "function" then
                    pcall(function() writeclipboard(textBox.Text) copied = true end)
                end
                
                if copied then
                    addLog("✅ Berhasil copy dari TextBox", Color3.fromRGB(0, 255, 150))
                    copyBtn.Text = "✅ COPIED!"
                    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                    wait(1)
                    copyBtn.Text = "📋 COPY TO CLIPBOARD"
                    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                else
                    addLog("❌ Gagal copy dari TextBox", Color3.fromRGB(255, 50, 50))
                    copyBtn.Text = "❌ FAILED"
                    copyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                    wait(1)
                    copyBtn.Text = "📋 COPY TO CLIPBOARD"
                    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                end
            end)
            
            local copyCorner = Instance.new("UICorner")
            copyCorner.CornerRadius = UDim.new(0, 6)
            copyCorner.Parent = copyBtn
            
            copyBtn.Parent = CopyFrame
            
            CopyFrame.Parent = script.Parent
            
            addLog("📝 Gunakan TextBox di atas untuk copy manual", Color3.fromRGB(255, 255, 150))
            StatusLabel.Text = "Gunakan TextBox untuk copy"
            
        else
            -- Berhasil copy ke clipboard
            addLog("🎉 DATA BERHASIL DISALIN KE CLIPBOARD!", Color3.fromRGB(0, 255, 0))
            addLog("📋 Buka Excel/Google Sheets → Paste (Ctrl+V)", Color3.fromRGB(200, 255, 200))
            
            -- Tampilkan preview
            addLog("📊 Preview data yang disalin:", Color3.fromRGB(200, 200, 255))
            
            -- Ambil beberapa baris untuk preview
            local lines = {}
            for line in fullCSV:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end
            
            -- Tampilkan 3-5 baris pertama
            for i = 1, math.min(5, #lines) do
                if i == 1 or string.find(lines[i], "###") or i <= 3 then
                    addLog("   " .. lines[i], Color3.fromRGB(200, 255, 200))
                end
            end
            
            if #lines > 5 then
                addLog("   ... dan " .. (#lines - 5) .. " baris lainnya", Color3.fromRGB(150, 150, 150))
            end
            
            StatusLabel.Text = "✅ Data tersalin ke clipboard!"
            
            -- Auto-clear status setelah beberapa detik
            wait(3)
            StatusLabel.Text = "Ready"
        end
        
    else
        addLog("❌ Tidak ada data untuk diekspor", Color3.fromRGB(255, 50, 50))
        StatusLabel.Text = "Tidak ada data untuk diekspor"
    end
end)

-- Fungsi helper untuk menampilkan pesan
function addLog(message, color)
    -- Asumsikan ada fungsi atau UI element untuk log
    if LogLabel then
        LogLabel.Text = LogLabel.Text .. "\n" .. message
        LogLabel.TextColor3 = color
    end
    print("[EXPORT] " .. message)
end

-- Fungsi untuk clear content
function clearContent()
    if LogLabel then
        LogLabel.Text = ""
    end
end

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
addLog("📌 Click 'Scan' untuk mendapatkan data ikan", Color3.fromRGB(200, 200, 255))
addLog("💡 Gunakan tombol Export untuk salin mentah dari Console (F9)!", Color3.fromRGB(200, 200, 255))

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

print("Fish Dex Explorer - Console Export Version Loaded!")
