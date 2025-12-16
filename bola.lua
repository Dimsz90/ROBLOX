-- FISH DEX EXPLORER - With Event Filtering
-- Enhanced version dengan filter untuk mengurangi spam

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
MainFrame.Size = UDim2.new(0, 600, 0, 600) -- Tambah tinggi
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
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
Title.Text = "🐠 FISH DEX EXPLORER v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Complete Fishing Analysis with Event Filtering"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.SourceSans
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
    "Event Filter",
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
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Parent = TabsFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -200)
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
StatusBar.Position = UDim2.new(0, 10, 1, -80)
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
ControlFrame.Position = UDim2.new(0, 10, 1, -45)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.19, -5, 1, 0)
RefreshBtn.Position = UDim2.new(0, 0, 0, 0)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
RefreshBtn.Text = "🔄 Refresh"
RefreshBtn.TextColor3 = Color3.new(1, 1, 1)
RefreshBtn.TextSize = 12
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.Parent = ControlFrame

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.19, -5, 1, 0)
ClearBtn.Position = UDim2.new(0.2, 5, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ClearBtn.Text = "🗑️ Clear"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.TextSize = 12
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.Parent = ControlFrame

local ExportBtn = Instance.new("TextButton")
ExportBtn.Size = UDim2.new(0.19, -5, 1, 0)
ExportBtn.Position = UDim2.new(0.4, 5, 0, 0)
ExportBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
ExportBtn.Text = "💾 Export"
ExportBtn.TextColor3 = Color3.new(1, 1, 1)
ExportBtn.TextSize = 12
ExportBtn.Font = Enum.Font.SourceSansBold
ExportBtn.Parent = ControlFrame

local FilterBtn = Instance.new("TextButton")
FilterBtn.Size = UDim2.new(0.19, -5, 1, 0)
FilterBtn.Position = UDim2.new(0.6, 5, 0, 0)
FilterBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
FilterBtn.Text = "⚡ Filter"
FilterBtn.TextColor3 = Color3.new(1, 1, 1)
FilterBtn.TextSize = 12
FilterBtn.Font = Enum.Font.SourceSansBold
FilterBtn.Parent = ControlFrame

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(0.19, -5, 1, 0)
DestroyBtn.Position = UDim2.new(0.8, 5, 0, 0)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.Text = "❌ Destroy"
DestroyBtn.TextColor3 = Color3.new(1, 1, 1)
DestroyBtn.TextSize = 12
DestroyBtn.Font = Enum.Font.SourceSansBold
DestroyBtn.Parent = ControlFrame

-- Button corners
for _, btn in pairs({RefreshBtn, ClearBtn, ExportBtn, FilterBtn, DestroyBtn}) do
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

-- EVENT FILTER SYSTEM
local eventFilter = {
    enabled = false,
    filters = {
        -- Events yang akan di-block atau limit
        blockedEvents = {
            "PlayFishingEffect",
            "UpdateChargeFrame",
            "UpdateChargeState"
        },
        
        -- Events yang akan tetap ditampilkan
        allowedEvents = {
            "FishCaught",
            "FishingRodStarted", 
            "FishingStopped",
            "FishingMinigameClick",
            "FishingMinigameChanged"
        },
        
        -- Rate limiting untuk events tertentu (events per detik)
        rateLimits = {
            PlayFishingEffect = 1,  -- Max 1 event per second
            UpdateChargeFrame = 2   -- Max 2 events per second
        }
    },
    
    -- Tracking untuk rate limiting
    lastEventTime = {},
    eventCounters = {}
}

-- Fungsi untuk menambahkan log dengan filter check
local function addLog(text, color, icon, bypassFilter)
    if eventFilter.enabled and not bypassFilter then
        -- Cek jika text mengandung event yang di-block
        for _, blockedEvent in ipairs(eventFilter.filters.blockedEvents) do
            if text:find(blockedEvent) then
                return -- Skip log ini
            end
        end
        
        -- Rate limiting check
        for eventName, maxRate in pairs(eventFilter.filters.rateLimits) do
            if text:find(eventName) then
                local currentTime = tick()
                local lastTime = eventFilter.lastEventTime[eventName] or 0
                
                -- Cek rate limit
                if currentTime - lastTime < (1 / maxRate) then
                    return -- Skip, terlalu cepat
                end
                
                -- Update last event time
                eventFilter.lastEventTime[eventName] = currentTime
                break
            end
        end
    end
    
    -- Jika lolos filter, tampilkan log
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

-- TAB 1: CONTROLLER ANALYSIS (sama seperti sebelumnya)
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
        return
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
    end
    
    -- Events - Highlight important ones
    addLog("⚡ EVENTS (" .. #events .. "):", Color3.fromRGB(255, 100, 100), "⚡")
    for _, event in ipairs(events) do
        local isImportant = event.Name:lower():find("fish") or event.Name:lower():find("catch")
        local color = isImportant and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 150, 100)
        local icon = isImportant and "🎣" or "📡"
        
        addLog(icon .. " " .. event.Name, color)
        
        -- Note untuk filter
        if event.Name == "PlayFishingEffect" then
            addLog("   ⚠️ This event may spam - will be filtered", Color3.fromRGB(255, 150, 50))
        end
    end
    
    analysisResults.Controller = {
        Path = current:GetFullName(),
        Functions = functions,
        Events = events,
        Tables = tables,
        Values = values
    }
    
    StatusLabel.Text = "Controller analyzed: " .. #functions .. " functions, " .. #events .. " events"
end

-- TAB 2: FISH DATA EXPLORER (sama seperti sebelumnya)
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
    
    -- Load fish data
    local totalFishFound = 0
    
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") and item.Name:match("^%u%l+") then
            local success, data = pcall(require, item)
            if success and type(data) == "table" then
                for key, value in pairs(data) do
                    if type(value) == "table" then
                        local fishName = value.Name or value.FishName or tostring(key)
                        local rarityNum = value.Rarity or value.Tier
                        
                        if fishName and rarityNum then
                            local fishInfo = {
                                Name = fishName,
                                Rarity = tonumber(rarityNum),
                                RarityName = rarityMap[tonumber(rarityNum)] and rarityMap[tonumber(rarityNum)].Name or "Unknown",
                                Weight = value.Weight or value.Size,
                                Mutation = value.Mutation or value.Shiny or value.Variant,
                                Value = value.Value or value.Price,
                                Source = item.Name
                            }
                            
                            fishDatabase[fishName] = fishInfo
                            totalFishFound = totalFishFound + 1
                        end
                    end
                end
            end
        end
    end
    
    if totalFishFound == 0 then
        addLog("❌ No fish data found!", Color3.fromRGB(255, 50, 50))
    else
        addLog("✅ Found " .. totalFishFound .. " fish in database", Color3.fromRGB(0, 255, 150))
        
        -- Group by rarity
        local fishByRarity = {}
        for _, fish in pairs(fishDatabase) do
            if not fishByRarity[fish.Rarity] then
                fishByRarity[fish.Rarity] = {}
            end
            table.insert(fishByRarity[fish.Rarity], fish)
        end
        
        -- Display by rarity
        for rarity = 1, 7 do
            if fishByRarity[rarity] then
                local rarityInfo = rarityMap[rarity] or {Name = "Rarity " .. rarity, Color = Color3.fromRGB(200, 200, 200)}
                addLog("⭐ " .. rarityInfo.Name .. " (" .. #fishByRarity[rarity] .. ")", rarityInfo.Color)
                
                for _, fish in ipairs(fishByRarity[rarity]) do
                    addLog("   🐟 " .. fish.Name, rarityInfo.Color)
                end
            end
        end
    end
    
    analysisResults.FishData = {
        TotalFish = totalFishFound,
        Database = fishDatabase
    }
    
    StatusLabel.Text = "Found " .. totalFishFound .. " fish"
end

-- TAB 3: EVENTS MONITOR WITH FILTERING
local function monitorEvents()
    clearContent()
    StatusLabel.Text = "Setting up event monitoring..."
    
    addLog("=== EVENT MONITORING SYSTEM ===", Color3.fromRGB(0, 255, 255), "⚡")
    addLog("Filter status: " .. (eventFilter.enabled and "ENABLED 🟢" or "DISABLED 🔴"), 
           eventFilter.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100))
    
    if not fishingController then
        addLog("⚠️ Please analyze Controller first!", Color3.fromRGB(255, 150, 50))
        return
    end
    
    -- Clear previous connections
    for _, conn in pairs(eventConnections) do
        pcall(function() conn:Disconnect() end)
    end
    eventConnections = {}
    
    -- Setup event monitoring dengan filter
    local importantEvents = 0
    local filteredEvents = 0
    
    for key, value in pairs(fishingController) do
        if typeof(value) == "RBXScriptSignal" then
            local isBlocked = false
            
            -- Cek jika event ini di-block
            for _, blockedEvent in ipairs(eventFilter.filters.blockedEvents) do
                if key == blockedEvent then
                    isBlocked = true
                    filteredEvents = filteredEvents + 1
                    break
                end
            end
            
            if not isBlocked or not eventFilter.enabled then
                importantEvents = importantEvents + 1
                
                local conn = value:Connect(function(...)
                    local args = {...}
                    local timestamp = os.date("%H:%M:%S")
                    
                    -- Gunakan filter check di addLog
                    addLog("⚡ " .. key .. " at " .. timestamp, Color3.fromRGB(255, 215, 0))
                    
                    -- Check for fish data (bypass filter untuk data penting)
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.Name or arg.FishName then
                                addLog("   🎣 FISH DATA DETECTED!", Color3.fromRGB(0, 255, 150), nil, true) -- bypass filter
                                
                                for k, v in pairs(arg) do
                                    if type(v) == "string" or type(v) == "number" then
                                        addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(100, 255, 200), nil, true)
                                    end
                                end
                            end
                        end
                    end
                end)
                
                table.insert(eventConnections, conn)
                
                local color = eventFilter.enabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
                addLog("✅ Monitoring: " .. key, color)
            else
                addLog("🚫 Filtered: " .. key .. " (blocked)", Color3.fromRGB(150, 150, 150))
            end
        end
    end
    
    -- Monitor important RemoteEvents
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("RemoteEvent") and item.Name:lower():find("fish") then
            local conn = item.OnClientEvent:Connect(function(...)
                local timestamp = os.date("%H:%M:%S")
                addLog("📡 " .. item.Name .. " at " .. timestamp, Color3.fromRGB(255, 150, 100))
            end)
            
            table.insert(eventConnections, conn)
            importantEvents = importantEvents + 1
            addLog("✅ Monitoring RemoteEvent: " .. item.Name, Color3.fromRGB(0, 255, 200))
        end
    end
    
    addLog("📊 Important events: " .. importantEvents, Color3.fromRGB(0, 255, 0))
    if eventFilter.enabled then
        addLog("🚫 Filtered events: " .. filteredEvents, Color3.fromRGB(255, 150, 50))
    end
    
    StatusLabel.Text = "Monitoring " .. importantEvents .. " events" .. 
                      (eventFilter.enabled and " (filter active)" or "")
end

-- TAB 4: EVENT FILTER CONFIGURATION (NEW TAB)
local function eventFilterConfig()
    clearContent()
    StatusLabel.Text = "Event Filter Configuration"
    
    addLog("=== EVENT FILTER CONFIGURATION ===", Color3.fromRGB(0, 255, 255), "⚡")
    
    -- Filter status
    addLog("Current status: " .. (eventFilter.enabled and "ENABLED 🟢" or "DISABLED 🔴"), 
           eventFilter.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100))
    
    -- Toggle button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0, 50)
    ToggleBtn.BackgroundColor3 = eventFilter.enabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
    ToggleBtn.Text = eventFilter.enabled and "🟢 DISABLE Filter" or "🔴 ENABLE Filter"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.TextSize = 14
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.Parent = ScrollFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        eventFilter.enabled = not eventFilter.enabled
        ToggleBtn.BackgroundColor3 = eventFilter.enabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
        ToggleBtn.Text = eventFilter.enabled and "🟢 DISABLE Filter" or "🔴 ENABLE Filter"
        
        addLog("Filter " .. (eventFilter.enabled and "ENABLED" or "DISABLED"), 
               eventFilter.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100))
        StatusLabel.Text = "Filter " .. (eventFilter.enabled and "enabled" or "disabled")
    end)
    
    -- Blocked events list
    addLog("--- BLOCKED EVENTS ---", Color3.fromRGB(255, 100, 100), "🚫")
    
    for _, eventName in ipairs(eventFilter.filters.blockedEvents) do
        local EventFrame = Instance.new("Frame")
        EventFrame.Size = UDim2.new(0.9, 0, 0, 30)
        EventFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        EventFrame.Parent = ScrollFrame
        
        local EventCorner = Instance.new("UICorner")
        EventCorner.CornerRadius = UDim.new(0, 6)
        EventCorner.Parent = EventFrame
        
        local EventLabel = Instance.new("TextLabel")
        EventLabel.Size = UDim2.new(0.7, 0, 1, 0)
        EventLabel.Position = UDim2.new(0, 10, 0, 0)
        EventLabel.BackgroundTransparency = 1
        EventLabel.Text = "🚫 " .. eventName
        EventLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        EventLabel.TextSize = 13
        EventLabel.Font = Enum.Font.SourceSans
        EventLabel.TextXAlignment = Enum.TextXAlignment.Left
        EventLabel.Parent = EventFrame
        
        local RemoveBtn = Instance.new("TextButton")
        RemoveBtn.Size = UDim2.new(0.2, 0, 0.6, 0)
        RemoveBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
        RemoveBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
        RemoveBtn.Text = "Remove"
        RemoveBtn.TextColor3 = Color3.new(1, 1, 1)
        RemoveBtn.TextSize = 11
        RemoveBtn.Font = Enum.Font.SourceSans
        RemoveBtn.Parent = EventFrame
        
        RemoveBtn.MouseButton1Click:Connect(function()
            -- Remove dari blocked list
            for i, name in ipairs(eventFilter.filters.blockedEvents) do
                if name == eventName then
                    table.remove(eventFilter.filters.blockedEvents, i)
                    break
                end
            end
            EventFrame:Destroy()
            addLog("Removed " .. eventName .. " from blocked list", Color3.fromRGB(255, 200, 100))
        end)
    end
    
    -- Add new event to block
    addLog("--- ADD NEW EVENT TO BLOCK ---", Color3.fromRGB(255, 200, 100), "➕")
    
    local AddFrame = Instance.new("Frame")
    AddFrame.Size = UDim2.new(0.9, 0, 0, 60)
    AddFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    AddFrame.Parent = ScrollFrame
    
    local AddCorner = Instance.new("UICorner")
    AddCorner.CornerRadius = UDim.new(0, 6)
    AddCorner.Parent = AddFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.7, -10, 0.4, 0)
    TextBox.Position = UDim2.new(0.05, 0, 0.1, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.PlaceholderText = "Enter event name to block"
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TextBox.Text = ""
    TextBox.TextSize = 13
    TextBox.Parent = AddFrame
    
    local AddBtn = Instance.new("TextButton")
    AddBtn.Size = UDim2.new(0.2, 0, 0.4, 0)
    AddBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
    AddBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    AddBtn.Text = "Add"
    AddBtn.TextColor3 = Color3.new(1, 1, 1)
    AddBtn.TextSize = 13
    AddBtn.Font = Enum.Font.SourceSansBold
    AddBtn.Parent = AddFrame
    
    AddBtn.MouseButton1Click:Connect(function()
        local eventName = TextBox.Text
        if eventName and eventName ~= "" then
            table.insert(eventFilter.filters.blockedEvents, eventName)
            TextBox.Text = ""
            addLog("Added " .. eventName .. " to blocked list", Color3.fromRGB(100, 255, 100))
            
            -- Refresh tab untuk update list
            switchTab("Event Filter")
        end
    end)
    
    -- Rate limiting configuration
    addLog("--- RATE LIMITING ---", Color3.fromRGB(150, 200, 255), "⏱️")
    
    for eventName, maxRate in pairs(eventFilter.filters.rateLimits) do
        addLog("⏱️ " .. eventName .. ": max " .. maxRate .. "/sec", Color3.fromRGB(200, 200, 200))
    end
    
    -- Reset counters button
    local ResetBtn = Instance.new("TextButton")
    ResetBtn.Size = UDim2.new(0.8, 0, 0, 30)
    ResetBtn.Position = UDim2.new(0.1, 0, 0, 450)
    ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    ResetBtn.Text = "🔄 Reset All Filters"
    ResetBtn.TextColor3 = Color3.new(1, 1, 1)
    ResetBtn.TextSize = 13
    ResetBtn.Font = Enum.Font.SourceSansBold
    ResetBtn.Parent = ScrollFrame
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 6)
    ResetCorner.Parent = ResetBtn
    
    ResetBtn.MouseButton1Click:Connect(function()
        eventFilter.lastEventTime = {}
        eventFilter.eventCounters = {}
        addLog("✅ All filter counters reset", Color3.fromRGB(0, 255, 150))
    end)
end

-- TAB 5: HOOKS SETUP (sama seperti sebelumnya)
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
        "FishCaught", "SendFishingRequestToServer", "RequestFishingMinigameClick"
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
                
                -- Log call (bypass filter untuk hook penting)
                addLog("⚡ " .. funcName .. " called at " .. timestamp, Color3.fromRGB(255, 100, 100), nil, true)
                
                -- Special handling untuk FishCaught
                if funcName == "FishCaught" then
                    addLog("🎣🎣🎣 FISH CAUGHT EVENT! 🎣🎣🎣", Color3.fromRGB(255, 215, 0), nil, true)
                    
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.Name or arg.FishName then
                                local fishName = arg.Name or arg.FishName
                                local rarityNum = arg.Rarity or arg.Tier
                                
                                -- Rarity colors
                                local rarityColors = {
                                    [1] = Color3.fromRGB(150, 150, 150),
                                    [2] = Color3.fromRGB(100, 200, 100),
                                    [3] = Color3.fromRGB(100, 150, 255),
                                    [4] = Color3.fromRGB(200, 100, 255),
                                    [5] = Color3.fromRGB(255, 215, 0),
                                    [6] = Color3.fromRGB(255, 100, 100),
                                    [7] = Color3.fromRGB(255, 50, 255)
                                }
                                
                                local rarityColor = rarityColors[tonumber(rarityNum)] or Color3.fromRGB(200, 200, 200)
                                
                                addLog("   🐟 FISH DETAILS:", rarityColor, nil, true)
                                addLog("     Name: " .. fishName, rarityColor, nil, true)
                                addLog("     Rarity: " .. tostring(rarityNum or "?"), rarityColor, nil, true)
                                
                                if arg.Weight then
                                    addLog("     Weight: " .. tostring(arg.Weight), rarityColor, nil, true)
                                end
                                
                                if arg.Mutation then
                                    addLog("     Mutation: " .. tostring(arg.Mutation), rarityColor, nil, true)
                                end
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
            addLog("❌ " .. funcName .. " not found", Color3.fromRGB(255, 100, 100))
        end
    end
    
    addLog("📊 Total functions hooked: " .. hookedCount, Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Hooked to " .. hookedCount .. " functions"
end

-- TAB 6: DEBUG TOOLS (sama seperti sebelumnya)
local function debugTools()
    clearContent()
    StatusLabel.Text = "Debug tools..."
    
    addLog("=== DEBUG TOOLS ===", Color3.fromRGB(0, 255, 255), "🐛")
    
    -- Test GetCurrentGUID
    if fishingController and fishingController.GetCurrentGUID then
        local success, guid = pcall(fishingController.GetCurrentGUID)
        if success then
            addLog("✅ Current GUID: " .. tostring(guid), Color3.fromRGB(0, 255, 150))
        end
    end
    
    -- Filter status
    addLog("🔧 Filter status: " .. (eventFilter.enabled and "ENABLED" or "DISABLED"), 
           eventFilter.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100))
    
    addLog("🚫 Blocked events: " .. #eventFilter.filters.blockedEvents, Color3.fromRGB(200, 200, 200))
    addLog("🔌 Active connections: " .. #eventConnections, Color3.fromRGB(200, 200, 200))
    addLog("🎣 Hooked functions: " .. #hookedFunctions, Color3.fromRGB(200, 200, 200))
    
    StatusLabel.Text = "Debug info loaded"
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
    elseif tabName == "Event Filter" then
        eventFilterConfig()
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
    addLog("💾 Exporting data...", Color3.fromRGB(100, 255, 100))
    
    print("=== FISH DEX EXPORT ===")
    print("Filter enabled:", eventFilter.enabled)
    print("Blocked events:", #eventFilter.filters.blockedEvents)
    
    -- Export blocked events
    print("\n=== BLOCKED EVENTS ===")
    for _, event in ipairs(eventFilter.filters.blockedEvents) do
        print("🚫 " .. event)
    end
    
    StatusLabel.Text = "Data exported to console"
end)

FilterBtn.MouseButton1Click:Connect(function()
    -- Toggle filter langsung
    eventFilter.enabled = not eventFilter.enabled
    
    local status = eventFilter.enabled and "ENABLED 🟢" or "DISABLED 🔴"
    local color = eventFilter.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    
    addLog("⚡ Filter " .. status, color)
    FilterBtn.Text = eventFilter.enabled and "⚡ Filter ON" or "⚡ Filter OFF"
    StatusLabel.Text = "Filter " .. (eventFilter.enabled and "enabled" or "disabled")
    
    -- Refresh events tab jika sedang aktif
    if currentTab == "Events" then
        switchTab("Events")
    end
end)

DestroyBtn.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying script in 3 seconds...", Color3.fromRGB(255, 50, 50), nil, true)
    StatusLabel.Text = "Status: DESTROYING..."
    
    for i = 3, 1, -1 do
        DestroyBtn.Text = "Destroying in " .. i .. "..."
        task.wait(1)
    end
    
    -- Restore semua hooked functions
    for funcName, originalFunc in pairs(hookedFunctions) do
        if fishingController then
            pcall(function()
                fishingController[funcName] = originalFunc
            end)
        end
    end
    
    -- Disconnect semua events
    for _, conn in pairs(eventConnections) do
        pcall(function() conn:Disconnect() end)
    end
    
    ScreenGui:Destroy()
    print("Fish Dex Explorer destroyed!")
end)

-- Start dengan Controller tab
switchTab("Controller")

-- Initial message
addLog("✅ Fish Dex Explorer v2.1 Loaded!", Color3.fromRGB(0, 255, 150), nil, true)
addLog("⚡ Event filtering available - Go to 'Event Filter' tab", Color3.fromRGB(200, 200, 255))
addLog("🎣 PlayFishingEffect events will be filtered by default", Color3.fromRGB(255, 200, 100))

print("Fish Dex Explorer v2.1 - With Event Filtering")
print("Default blocked: PlayFishingEffect, UpdateChargeFrame, UpdateChargeState")
