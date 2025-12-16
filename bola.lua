-- FISH DEX EXPLORER - Complete Fishing Analysis
-- Advanced tool untuk explore semua fishing-related modules

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
MainFrame.Size = UDim2.new(0, 600, 0, 550)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🐠 FISH DEX EXPLORER v2.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Complete Fishing Module Analysis"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextSize = 14
Title.Font = Enum.Font.SourceSans
SubTitle.Parent = MainFrame

-- Tab System
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -20, 0, 35)
TabsFrame.Position = UDim2.new(0, 10, 0, 70)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local Tabs = {
    "Controller",
    "Fish Data",
    "Events",
    "Hooks",
    "Debug"
}

local currentTab = "Controller"
local tabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(1/#Tabs, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = tabName == "Controller" and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 60)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Parent = TabsFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -180)
ContentFrame.Position = UDim2.new(0, 10, 0, 110)
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
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -60)
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
ControlFrame.Size = UDim2.new(1, -20, 0, 25)
ControlFrame.Position = UDim2.new(0, 10, 1, -25)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.24, -5, 1, 0)
RefreshBtn.Position = UDim2.new(0, 0, 0, 0)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
RefreshBtn.Text = "🔄 Refresh"
RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
RefreshBtn.TextSize = 13
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.Parent = ControlFrame

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
for _, btn in pairs({RefreshBtn, ClearBtn, ExportBtn, DestroyBtn}) do
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
end

-- Data storage
local fishingController = nil
local fishDatabase = {}
local eventConnections = {}
local hookedFunctions = {}
local analysisResults = {}

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

-- TAB 1: CONTROLLER ANALYSIS
local function analyzeController()
    clearContent()
    StatusLabel.Text = "Analyzing Fishing Controller..."
    
    addLog("=== FISHING CONTROLLER ANALYSIS ===", Color3.fromRGB(0, 255, 255), "🔍")
    
    -- Cari controller
    local controllerPath = "Controllers.ClassicGroupFishingController"
    local current = ReplicatedStorage
    
    for part in controllerPath:gmatch("[^.]+") do
        current = current:FindFirstChild(part)
        if not current then break end
    end
    
    if not current or not current:IsA("ModuleScript") then
        addLog("❌ Controller not found at: " .. controllerPath, Color3.fromRGB(255, 50, 50), "⚠️")
        
        -- Coba cari di tempat lain
        addLog("--- Searching in all ReplicatedStorage ---", Color3.fromRGB(255, 200, 0), "🔎")
        
        local foundControllers = {}
        for _, item in pairs(ReplicatedStorage:GetDescendants()) do
            if item:IsA("ModuleScript") then
                local nameLower = item.Name:lower()
                if nameLower:find("fish") and (nameLower:find("controller") or nameLower:find("control")) then
                    table.insert(foundControllers, item)
                    addLog("📦 Found: " .. item:GetFullName(), Color3.fromRGB(150, 200, 255))
                end
            end
        end
        
        if #foundControllers == 0 then
            addLog("❌ No fishing controllers found!", Color3.fromRGB(255, 50, 50))
            return
        end
        
        current = foundControllers[1]
        addLog("✅ Using: " .. current:GetFullName(), Color3.fromRGB(0, 255, 0))
    end
    
    -- Load controller
    local success, data = pcall(function()
        return require(current)
    end)
    
    if not success then
        addLog("❌ Failed to load controller: " .. tostring(data), Color3.fromRGB(255, 50, 50))
        return
    end
    
    fishingController = data
    addLog("✅ Controller loaded successfully!", Color3.fromRGB(0, 255, 150), "✅")
    
    -- Analyze structure
    addLog("--- MODULE STRUCTURE ---", Color3.fromRGB(200, 200, 255), "📊")
    
    local functions = {}
    local events = {}
    local tables = {}
    local values = {}
    
    for key, value in pairs(data) do
        local valueType = type(value)
        
        if valueType == "function" then
            table.insert(functions, {Name = key, Value = value})
        elseif typeof(value) == "RBXScriptSignal" then
            table.insert(events, {Name = key, Value = value})
        elseif valueType == "table" then
            table.insert(tables, {Name = key, Value = value})
        else
            table.insert(values, {Name = key, Value = value})
        end
    end
    
    -- Fungsi
    addLog("🔧 FUNCTIONS (" .. #functions .. "):", Color3.fromRGB(100, 200, 255), "🔧")
    for _, func in ipairs(functions) do
        local isCatchRelated = func.Name:lower():find("catch") or func.Name:lower():find("fish")
        local color = isCatchRelated and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
        local icon = isCatchRelated and "🎣" or "🔧"
        
        addLog(icon .. " " .. func.Name, color)
        
        if isCatchRelated then
            -- Dapatkan info function
            local info = debug.getinfo(func.Value)
            if info then
                addLog("   ├─ Source: " .. (info.source or "?"), Color3.fromRGB(100, 100, 100))
                addLog("   └─ Line: " .. (info.linedefined or "?"), Color3.fromRGB(100, 100, 100))
            end
        end
    end
    
    -- Events
    addLog("⚡ EVENTS (" .. #events .. "):", Color3.fromRGB(255, 100, 100), "⚡")
    for _, event in ipairs(events) do
        addLog("📡 " .. event.Name, Color3.fromRGB(255, 150, 100))
    end
    
    -- Tables
    addLog("📦 TABLES (" .. #tables .. "):", Color3.fromRGB(255, 200, 100), "📦")
    for _, tbl in ipairs(tables) do
        local size = #tbl.Value
        local hasData = false
        
        -- Cek jika table berisi data ikan
        for k, v in pairs(tbl.Value) do
            if type(v) == "table" and (v.Name or v.FishName) then
                hasData = true
                break
            end
        end
        
        local icon = hasData and "🐟" or "📦"
        local color = hasData and Color3.fromRGB(100, 255, 200) or Color3.fromRGB(200, 200, 200)
        
        addLog(icon .. " " .. tbl.Name .. " (size: " .. size .. ")", color)
    end
    
    -- Values
    addLog("📄 VALUES (" .. #values .. "):", Color3.fromRGB(150, 150, 150), "📄")
    for _, val in ipairs(values) do
        addLog("📌 " .. val.Name .. " = " .. tostring(val.Value), Color3.fromRGB(150, 150, 150))
    end
    
    -- Special analysis untuk fungsi yang penting
    addLog("--- KEY FUNCTIONS ANALYSIS ---", Color3.fromRGB(255, 255, 0), "🔑")
    
    local keyFunctions = {
        "FishCaught", "GetCurrentGUID", "RequestFishingMinigameClick",
        "FishingRodStarted", "SendFishingRequestToServer", "Start"
    }
    
    for _, funcName in ipairs(keyFunctions) do
        if data[funcName] then
            local funcType = type(data[funcName])
            local color = funcType == "function" and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 150, 50)
            
            addLog("🎯 " .. funcName .. " (" .. funcType .. ")", color)
            
            if funcType == "function" then
                -- Try to get function info
                local info = debug.getinfo(data[funcName])
                if info then
                    addLog("   ├─ Source: " .. (info.source or "?"), Color3.fromRGB(100, 100, 100))
                    addLog("   └─ Lines: " .. (info.linedefined or "?") .. "-" .. (info.lastlinedefined or "?"), Color3.fromRGB(100, 100, 100))
                end
                
                -- Test panggil fungsi yang aman
                if funcName == "GetCurrentGUID" then
                    local success, result = pcall(data[funcName])
                    if success then
                        addLog("   📍 Current GUID: " .. tostring(result), Color3.fromRGB(100, 255, 200))
                    end
                end
            end
        else
            addLog("❌ " .. funcName .. " (NOT FOUND)", Color3.fromRGB(255, 100, 100))
        end
    end
    
    -- Save analysis results
    analysisResults.Controller = {
        Path = current:GetFullName(),
        Functions = functions,
        Events = events,
        Tables = tables,
        Values = values
    }
    
    StatusLabel.Text = "Controller analyzed: " .. #functions .. " functions, " .. #events .. " events"
end

-- TAB 2: FISH DATA EXPLORER
local function exploreFishData()
    clearContent()
    StatusLabel.Text = "Exploring fish data..."
    
    addLog("=== FISH DATABASE EXPLORER ===", Color3.fromRGB(0, 255, 255), "🐟")
    
    -- Rarity map
    local rarityMap = {
        [1] = {Name = "Common", Color = Color3.fromRGB(150, 150, 150)},
        [2] = {Name = "Uncommon", Color = Color3.fromRGB(100, 200, 100)},
        [3] = {Name = "Rare", Color = Color3.fromRGB(100, 150, 255)},
        [4] = {Name = "Epic", Color = Color3.fromRGB(200, 100, 255)},
        [5] = {Name = "Legendary", Color = Color3.fromRGB(255, 215, 0)},
        [6] = {Name = "Mythic", Color = Color3.fromRGB(255, 100, 100)},
        [7] = {Name = "SECRET", Color = Color3.fromRGB(255, 50, 255)}
    }
    
    -- Scan untuk fish modules
    addLog("--- Scanning ReplicatedStorage for fish data ---", Color3.fromRGB(200, 200, 255), "🔍")
    
    local fishModules = {}
    local totalFishFound = 0
    
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") then
            local name = item.Name
            -- Cek jika ini kemungkinan fish data
            if not name:match("^%u%l+%u%l+$") then -- Pattern untuk nama ikan (CamelCase)
                local success, data = pcall(function()
                    return require(item)
                end)
                
                if success and type(data) == "table" then
                    -- Cek jika berisi fish data
                    local hasFishData = false
                    local fishInModule = {}
                    
                    for key, value in pairs(data) do
                        if type(value) == "table" then
                            local fishName = value.Name or value.FishName or tostring(key)
                            local rarityNum = value.Rarity or value.Tier
                            
                            if fishName and rarityNum then
                                hasFishData = true
                                
                                local fishInfo = {
                                    Name = fishName,
                                    Rarity = tonumber(rarityNum),
                                    RarityName = rarityMap[tonumber(rarityNum)] and rarityMap[tonumber(rarityNum)].Name or "Unknown",
                                    Weight = value.Weight or value.Size,
                                    Mutation = value.Mutation or value.Shiny or value.Variant,
                                    Value = value.Value or value.Price,
                                    Source = item.Name
                                }
                                
                                table.insert(fishInModule, fishInfo)
                                totalFishFound = totalFishFound + 1
                                
                                -- Add to global database
                                fishDatabase[fishName] = fishInfo
                            end
                        end
                    end
                    
                    if hasFishData then
                        table.insert(fishModules, {
                            Module = item,
                            Fish = fishInModule
                        })
                        
                        addLog("📁 Module: " .. item.Name .. " (" .. #fishInModule .. " fish)", Color3.fromRGB(100, 200, 255))
                    end
                end
            end
        end
    end
    
    if #fishModules == 0 then
        addLog("❌ No fish data modules found!", Color3.fromRGB(255, 50, 50))
        
        -- Coba cari di folder tertentu
        addLog("--- Checking specific folders ---", Color3.fromRGB(255, 200, 0))
        
        local foldersToCheck = {"Fish", "Fishes", "Bestiary", "Database", "Data"}
        for _, folderName in ipairs(foldersToCheck) do
            local folder = ReplicatedStorage:FindFirstChild(folderName)
            if folder then
                addLog("📂 Found folder: " .. folderName, Color3.fromRGB(150, 200, 255))
                
                for _, item in pairs(folder:GetDescendants()) do
                    if item:IsA("ModuleScript") then
                        local success, data = pcall(require, item)
                        if success and type(data) == "table" then
                            addLog("   📦 " .. item.Name, Color3.fromRGB(200, 200, 200))
                        end
                    end
                end
            end
        end
    else
        addLog("✅ Found " .. #fishModules .. " fish modules with " .. totalFishFound .. " total fish", 
               Color3.fromRGB(0, 255, 150), "📊")
        
        -- Tampilkan semua ikan dengan grouping by rarity
        addLog("--- ALL FISH BY RARITY ---", Color3.fromRGB(255, 255, 0), "⭐")
        
        local fishByRarity = {}
        for _, fish in pairs(fishDatabase) do
            if not fishByRarity[fish.Rarity] then
                fishByRarity[fish.Rarity] = {}
            end
            table.insert(fishByRarity[fish.Rarity], fish)
        end
        
        -- Sort by rarity
        local sortedRarities = {}
        for rarity in pairs(fishByRarity) do
            table.insert(sortedRarities, rarity)
        end
        table.sort(sortedRarities)
        
        for _, rarityNum in ipairs(sortedRarities) do
            local rarityInfo = rarityMap[rarityNum] or {Name = "Rarity " .. rarityNum, Color = Color3.fromRGB(200, 200, 200)}
            local fishList = fishByRarity[rarityNum]
            
            addLog("⭐ " .. rarityInfo.Name .. " (" .. #fishList .. " fish)", rarityInfo.Color)
            
            for _, fish in ipairs(fishList) do
                local info = string.format("   🐟 %s", fish.Name)
                if fish.Weight then
                    info = info .. " | Weight: " .. tostring(fish.Weight)
                end
                if fish.Mutation then
                    info = info .. " | Mutation: " .. tostring(fish.Mutation)
                end
                
                addLog(info, rarityInfo.Color)
            end
        end
        
        -- Tampilkan beberapa contoh detail
        addLog("--- SAMPLE FISH DETAILS ---", Color3.fromRGB(200, 255, 200), "🔎")
        
        local sampleCount = 0
        for name, fish in pairs(fishDatabase) do
            if sampleCount < 5 then
                local rarityInfo = rarityMap[fish.Rarity] or {Name = "Unknown", Color = Color3.fromRGB(200, 200, 200)}
                
                addLog("🔍 " .. name, rarityInfo.Color)
                addLog("   ├─ Rarity: " .. fish.RarityName .. " (" .. fish.Rarity .. ")", rarityInfo.Color)
                if fish.Weight then
                    addLog("   ├─ Weight: " .. tostring(fish.Weight), rarityInfo.Color)
                end
                if fish.Mutation then
                    addLog("   ├─ Mutation: " .. tostring(fish.Mutation), rarityInfo.Color)
                end
                if fish.Value then
                    addLog("   ├─ Value: " .. tostring(fish.Value), rarityInfo.Color)
                end
                addLog("   └─ Source: " .. fish.Source, rarityInfo.Color)
                
                sampleCount = sampleCount + 1
            else
                addLog("... and " .. (totalFishFound - 5) .. " more fish", Color3.fromRGB(150, 150, 150))
                break
            end
        end
    end
    
    -- Check jika ada Bestiary module
    addLog("--- BESTIARY CHECK ---", Color3.fromRGB(150, 200, 255), "📖")
    
    local bestiary = ReplicatedStorage:FindFirstChild("Bestiary")
    if bestiary then
        addLog("✅ Bestiary found!", Color3.fromRGB(0, 255, 0))
        
        local success, data = pcall(require, bestiary)
        if success then
            if type(data) == "table" then
                if data.GetBestiary and type(data.GetBestiary) == "function" then
                    addLog("🔧 GetBestiary function available", Color3.fromRGB(100, 255, 200))
                    
                    -- Try to get bestiary data
                    local success2, bestiaryData = pcall(data.GetBestiary)
                    if success2 and type(bestiaryData) == "table" then
                        local count = 0
                        for _, fish in pairs(bestiaryData) do
                            if type(fish) == "table" and fish.Name then
                                count = count + 1
                            end
                        end
                        addLog("📊 Bestiary contains " .. count .. " fish", Color3.fromRGB(0, 255, 150))
                    end
                end
            end
        end
    else
        addLog("ℹ️ No Bestiary module found", Color3.fromRGB(150, 150, 150))
    end
    
    analysisResults.FishData = {
        TotalFish = totalFishFound,
        Database = fishDatabase
    }
    
    StatusLabel.Text = "Found " .. totalFishFound .. " fish in database"
end

-- TAB 3: EVENTS MONITOR
local function monitorEvents()
    clearContent()
    StatusLabel.Text = "Setting up event monitoring..."
    
    addLog("=== EVENT MONITORING SYSTEM ===", Color3.fromRGB(0, 255, 255), "⚡")
    
    if not fishingController then
        addLog("⚠️ Please analyze Controller first!", Color3.fromRGB(255, 150, 50))
        return
    end
    
    -- Clear previous connections
    for _, conn in pairs(eventConnections) do
        pcall(function() conn:Disconnect() end)
    end
    eventConnections = {}
    
    -- Monitor events in controller
    addLog("--- CONTROLLER EVENTS ---", Color3.fromRGB(200, 150, 255), "🔌")
    
    local eventCount = 0
    for key, value in pairs(fishingController) do
        if typeof(value) == "RBXScriptSignal" then
            eventCount = eventCount + 1
            
            local conn = value:Connect(function(...)
                local args = {...}
                local timestamp = os.date("%H:%M:%S")
                
                addLog("⚡ " .. key .. " fired at " .. timestamp, Color3.fromRGB(255, 215, 0))
                
                -- Log arguments
                for i, arg in ipairs(args) do
                    if type(arg) == "table" then
                        addLog("   📦 Arg " .. i .. ": [TABLE]", Color3.fromRGB(200, 200, 200))
                        
                        -- Check for fish data
                        if arg.Name or arg.FishName then
                            addLog("   🎣 FISH DATA DETECTED!", Color3.fromRGB(0, 255, 150))
                            for k, v in pairs(arg) do
                                if type(v) == "string" or type(v) == "number" then
                                    addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(100, 255, 200))
                                end
                            end
                        end
                    else
                        addLog("   📄 Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")", 
                               Color3.fromRGB(200, 200, 200))
                    end
                end
            end)
            
            table.insert(eventConnections, conn)
            addLog("✅ Monitoring: " .. key, Color3.fromRGB(0, 255, 0))
        end
    end
    
    if eventCount == 0 then
        addLog("ℹ️ No events found in controller", Color3.fromRGB(150, 150, 150))
    end
    
    -- Monitor RemoteEvents
    addLog("--- REMOTEEVENTS IN REPLICATEDSTORAGE ---", Color3.fromRGB(150, 200, 255), "📡")
    
    local remoteCount = 0
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("RemoteEvent") then
            local nameLower = item.Name:lower()
            if nameLower:find("fish") or nameLower:find("catch") or nameLower:find("rod") then
                remoteCount = remoteCount + 1
                
                local conn = item.OnClientEvent:Connect(function(...)
                    local args = {...}
                    local timestamp = os.date("%H:%M:%S")
                    
                    addLog("📡 " .. item.Name .. " at " .. timestamp, Color3.fromRGB(255, 150, 100))
                    
                    -- Check for fish data
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.Name or arg.FishName then
                                addLog("   🎣 REMOTE FISH DATA!", Color3.fromRGB(0, 255, 150))
                                
                                for k, v in pairs(arg) do
                                    if type(v) == "string" or type(v) == "number" then
                                        addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(100, 255, 200))
                                    end
                                end
                            end
                        end
                    end
                end)
                
                table.insert(eventConnections, conn)
                addLog("✅ Monitoring RemoteEvent: " .. item.Name, Color3.fromRGB(0, 255, 150))
            end
        end
    end
    
    addLog("📊 Total events being monitored: " .. (eventCount + remoteCount), Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Monitoring " .. (eventCount + remoteCount) .. " events"
end

-- TAB 4: HOOKS SETUP
local function setupHooks()
    clearContent()
    StatusLabel.Text = "Setting up function hooks..."
    
    addLog("=== FUNCTION HOOKS SETUP ===", Color3.fromRGB(0, 255, 255), "🎣")
    
    if not fishingController then
        addLog("⚠️ Please analyze Controller first!", Color3.fromRGB(255, 150, 50))
        return
    end
    
    -- Hook ke fungsi penting
    local functionsToHook = {
        "FishCaught", "SendFishingRequestToServer", "RequestFishingMinigameClick",
        "FishingRodStarted", "FishingStopped"
    }
    
    local hookedCount = 0
    
    for _, funcName in ipairs(functionsToHook) do
        if fishingController[funcName] and type(fishingController[funcName]) == "function" then
            addLog("🎯 Found: " .. funcName, Color3.fromRGB(255, 215, 0))
            
            -- Save original function
            hookedFunctions[funcName] = fishingController[funcName]
            
            -- Create hook
            fishingController[funcName] = function(...)
                local args = {...}
                local timestamp = os.date("%H:%M:%S")
                
                -- Log call
                addLog("⚡ " .. funcName .. " called at " .. timestamp, Color3.fromRGB(255, 100, 100))
                
                -- Special handling for FishCaught
                if funcName == "FishCaught" then
                    addLog("🎣🎣🎣 FISH CAUGHT EVENT! 🎣🎣🎣", Color3.fromRGB(255, 215, 0))
                    
                    -- Analyze arguments for fish data
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            addLog("   📦 Argument " .. i .. " is a table:", Color3.fromRGB(200, 200, 200))
                            
                            -- Extract all data
                            for k, v in pairs(arg) do
                                if type(v) == "string" or type(v) == "number" then
                                    addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(100, 255, 200))
                                end
                            end
                            
                            -- Check if this is fish data
                            if arg.Name or arg.FishName then
                                local fishName = arg.Name or arg.FishName
                                local rarityNum = arg.Rarity or arg.Tier
                                local weight = arg.Weight or arg.Size
                                local mutation = arg.Mutation or arg.Shiny
                                
                                -- Get rarity info
                                local rarityMap = {
                                    [1] = {Name = "Common", Color = Color3.fromRGB(150, 150, 150)},
                                    [2] = {Name = "Uncommon", Color = Color3.fromRGB(100, 200, 100)},
                                    [3] = {Name = "Rare", Color = Color3.fromRGB(100, 150, 255)},
                                    [4] = {Name = "Epic", Color = Color3.fromRGB(200, 100, 255)},
                                    [5] = {Name = "Legendary", Color = Color3.fromRGB(255, 215, 0)},
                                    [6] = {Name = "Mythic", Color = Color3.fromRGB(255, 100, 100)},
                                    [7] = {Name = "SECRET", Color = Color3.fromRGB(255, 50, 255)}
                                }
                                
                                local rarityInfo = rarityMap[tonumber(rarityNum)] or {Name = "Unknown", Color = Color3.fromRGB(200, 200, 200)}
                                
                                addLog("   🐟 FISH DETAILS:", rarityInfo.Color)
                                addLog("     Name: " .. fishName, rarityInfo.Color)
                                addLog("     Rarity: " .. rarityInfo.Name .. " (" .. tostring(rarityNum or "?") .. ")", rarityInfo.Color)
                                
                                if weight then
                                    addLog("     Weight: " .. tostring(weight), rarityInfo.Color)
                                end
                                
                                if mutation then
                                    addLog("     Mutation: " .. tostring(mutation), rarityInfo.Color)
                                end
                                
                                -- Print to console juga
                                print("=== FISH CAUGHT (HOOKED) ===")
                                print("Name:", fishName)
                                print("Rarity:", rarityInfo.Name, "(" .. tostring(rarityNum or "?") .. ")")
                                if weight then print("Weight:", weight) end
                                if mutation then print("Mutation:", mutation) end
                                print("Time:", timestamp)
                                print("==================")
                            end
                        end
                    end
                end
                
                -- Call original function
                return hookedFunctions[funcName](...)
            end
            
            hookedCount = hookedCount + 1
            addLog("✅ Hooked to " .. funcName, Color3.fromRGB(0, 255, 0))
        else
            addLog("❌ " .. funcName .. " not found or not a function", Color3.fromRGB(255, 100, 100))
        end
    end
    
    if hookedCount == 0 then
        addLog("⚠️ No functions were hooked!", Color3.fromRGB(255, 150, 50))
        
        -- Try to find any catch-related function
        addLog("--- Searching for any catch-related functions ---", Color3.fromRGB(255, 200, 0))
        
        for key, value in pairs(fishingController) do
            if type(value) == "function" then
                local keyLower = key:lower()
                if keyLower:find("catch") or keyLower:find("fish") then
                    addLog("🎯 Will hook to: " .. key, Color3.fromRGB(255, 215, 0))
                    
                    -- Hook this function
                    hookedFunctions[key] = value
                    
                    fishingController[key] = function(...)
                        addLog("⚡ " .. key .. " called!", Color3.fromRGB(255, 150, 100))
                        return hookedFunctions[key](...)
                    end
                    
                    addLog("✅ Hooked to " .. key, Color3.fromRGB(0, 255, 0))
                    hookedCount = hookedCount + 1
                end
            end
        end
    end
    
    addLog("📊 Total functions hooked: " .. hookedCount, Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Hooked to " .. hookedCount .. " functions"
end

-- TAB 5: DEBUG TOOLS
local function debugTools()
    clearContent()
    StatusLabel.Text = "Debug tools..."
    
    addLog("=== DEBUG TOOLS ===", Color3.fromRGB(0, 255, 255), "🐛")
    
    -- Test GetCurrentGUID
    addLog("--- GetCurrentGUID Test ---", Color3.fromRGB(200, 200, 255), "🔑")
    
    if fishingController and fishingController.GetCurrentGUID and type(fishingController.GetCurrentGUID) == "function" then
        local success, guid = pcall(fishingController.GetCurrentGUID)
        if success then
            addLog("✅ Current GUID: " .. tostring(guid), Color3.fromRGB(0, 255, 150))
        else
            addLog("❌ Failed: " .. tostring(guid), Color3.fromRGB(255, 50, 50))
        end
    else
        addLog("❌ GetCurrentGUID not available", Color3.fromRGB(255, 100, 100))
    end
    
    -- Test fishing status
    addLog("--- Fishing Status ---", Color3.fromRGB(150, 255, 200), "📊")
    
    if fishingController then
        if fishingController.OnCooldown ~= nil then
            addLog("⏱️ OnCooldown: " .. tostring(fishingController.OnCooldown), 
                   fishingController.OnCooldown and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100))
        end
        
        -- Check other status properties
        local statusProps = {"_getPower", "UpdateChargeState", "BaitSpawned"}
        for _, prop in ipairs(statusProps) do
            if fishingController[prop] ~= nil then
                addLog("📌 " .. prop .. ": " .. tostring(fishingController[prop]), Color3.fromRGB(200, 200, 200))
            end
        end
    end
    
    -- Memory info
    addLog("--- Memory Info ---", Color3.fromRGB(255, 200, 100), "💾")
    
    addLog("📊 Fish in database: " .. #fishDatabase, Color3.fromRGB(200, 200, 200))
    addLog("🔌 Active event connections: " .. #eventConnections, Color3.fromRGB(200, 200, 200))
    addLog("🎣 Hooked functions: " .. #hookedFunctions, Color3.fromRGB(200, 200, 200))
    
    -- Test fishing simulation
    addLog("--- Simulation Tests ---", Color3.fromRGB(255, 150, 100), "🎮")
    
    local TestButton = Instance.new("TextButton")
    TestButton.Size = UDim2.new(0.8, 0, 0, 30)
    TestButton.Position = UDim2.new(0.1, 0, 0, 200)
    TestButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    TestButton.Text = "🎣 Simulate Fish Catch"
    TestButton.TextColor3 = Color3.new(1, 1, 1)
    TestButton.TextSize = 14
    TestButton.Font = Enum.Font.SourceSansBold
    TestButton.Parent = ScrollFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TestButton
    
    TestButton.MouseButton1Click:Connect(function()
        addLog("🎣 SIMULATING FISH CAUGHT...", Color3.fromRGB(255, 215, 0))
        
        -- Create fake fish data
        local fakeFish = {
            Name = "Test Fish",
            Rarity = 3,
            Weight = 15.5,
            Mutation = "Shiny",
            Value = 100
        }
        
        -- Trigger FishCaught jika ada hook
        if fishingController and fishingController.FishCaught then
            if hookedFunctions["FishCaught"] then
                -- Call melalui hook
                fishingController.FishCaught(fakeFish)
                addLog("✅ Simulated FishCaught called", Color3.fromRGB(0, 255, 0))
            else
                addLog("⚠️ FishCaught not hooked", Color3.fromRGB(255, 150, 50))
            end
        else
            addLog("❌ FishCaught not available", Color3.fromRGB(255, 50, 50))
        end
    end)
    
    StatusLabel.Text = "Debug tools ready"
end

-- Tab switching
local function switchTab(tabName)
    currentTab = tabName
    
    -- Update tab buttons
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 60)
    end
    
    -- Load tab content
    if tabName == "Controller" then
        analyzeController()
    elseif tabName == "Fish Data" then
        exploreFishData()
    elseif tabName == "Events" then
        monitorEvents()
    elseif tabName == "Hooks" then
        setupHooks()
    elseif tabName == "Debug" then
        debugTools()
    end
end

-- Button connections
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Control buttons
RefreshBtn.MouseButton1Click:Connect(function()
    addLog("🔄 Refreshing current tab...", Color3.fromRGB(255, 255, 0))
    switchTab(currentTab)
end)

ClearBtn.MouseButton1Click:Connect(function()
    clearContent()
    addLog("🗑️ Log cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Log cleared"
end)

ExportBtn.MouseButton1Click:Connect(function()
    addLog("💾 Exporting data to console...", Color3.fromRGB(100, 255, 100))
    
    print("=== FISH DEX EXPORT ===")
    print("Controller analyzed:", analysisResults.Controller and "Yes" or "No")
    print("Fish in database:", analysisResults.FishData and analysisResults.FishData.TotalFish or 0)
    print("Hooked functions:", #hookedFunctions)
    print("Event connections:", #eventConnections)
    print("===================")
    
    -- Export fish database
    if fishDatabase and next(fishDatabase) then
        print("\n=== FISH DATABASE ===")
        for name, fish in pairs(fishDatabase) do
            print(string.format("%s | Rarity: %s (%d) | Weight: %s | Mutation: %s",
                name, fish.RarityName, fish.Rarity or 0, tostring(fish.Weight or "?"), tostring(fish.Mutation or "None")))
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
    
    -- Restore all hooked functions
    for funcName, originalFunc in pairs(hookedFunctions) do
        if fishingController then
            pcall(function()
                fishingController[funcName] = originalFunc
            end)
        end
    end
    
    -- Disconnect all events
    for _, conn in pairs(eventConnections) do
        pcall(function() conn:Disconnect() end)
    end
    
    -- Destroy GUI
    ScreenGui:Destroy()
    
    print("Fish Dex Explorer destroyed!")
end)

-- Auto-start dengan Controller tab
switchTab("Controller")

-- Initial message
addLog("✅ Fish Dex Explorer v2.0 Loaded!", Color3.fromRGB(0, 255, 150))
addLog("📌 Use tabs to explore different aspects of the fishing system", Color3.fromRGB(200, 200, 255))
addLog("🔧 Go to 'Hooks' tab to setup fish catch detection", Color3.fromRGB(200, 200, 255))

print("Fish Dex Explorer Active!")
print("Path: ReplicatedStorage.Controllers.ClassicGroupFishingController")
