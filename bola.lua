-- FISH DEX EXPLORER - Advanced Fishing Controller Analysis
-- Focus: ReplicatedStorage > Fishing > FishingController

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishDexExplorer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 1000
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 500)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🔍 FISH DEX EXPLORER"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.ZIndex = 11
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Focus: FishingController Analysis"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.SourceSans
SubTitle.ZIndex = 11
SubTitle.Parent = MainFrame

-- Tab System
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -20, 0, 30)
TabsFrame.Position = UDim2.new(0, 10, 0, 65)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local ControllerTab = Instance.new("TextButton")
ControllerTab.Name = "ControllerTab"
ControllerTab.Size = UDim2.new(0.33, -2, 1, 0)
ControllerTab.Position = UDim2.new(0, 0, 0, 0)
ControllerTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ControllerTab.Text = "Controller"
ControllerTab.TextColor3 = Color3.new(1, 1, 1)
ControllerTab.TextSize = 14
ControllerTab.Font = Enum.Font.SourceSansBold
ControllerTab.Parent = TabsFrame

local EventsTab = Instance.new("TextButton")
EventsTab.Name = "EventsTab"
EventsTab.Size = UDim2.new(0.33, -2, 1, 0)
EventsTab.Position = UDim2.new(0.33, 2, 0, 0)
EventsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
EventsTab.Text = "Events"
EventsTab.TextColor3 = Color3.new(1, 1, 1)
EventsTab.TextSize = 14
EventsTab.Font = Enum.Font.SourceSansBold
EventsTab.Parent = TabsFrame

local DataTab = Instance.new("TextButton")
DataTab.Name = "DataTab"
DataTab.Size = UDim2.new(0.34, -2, 1, 0)
DataTab.Position = UDim2.new(0.66, 2, 0, 0)
DataTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
DataTab.Text = "Fish Data"
DataTab.TextColor3 = Color3.new(1, 1, 1)
DataTab.TextSize = 14
DataTab.Font = Enum.Font.SourceSansBold
DataTab.Parent = TabsFrame

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- ScrollFrame untuk konten
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 25)
StatusBar.Position = UDim2.new(0, 10, 1, -30)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusBar.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 5, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- Fungsi untuk menambahkan log
local function addLog(text, color, icon)
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, 0, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Entry.Parent = ScrollFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Entry
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -10, 0, 0)
    Content.Position = UDim2.new(0, 5, 0, 5)
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
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 5)
    Padding.Parent = Entry
    
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.CanvasSize.Y.Offset)
end

-- Fungsi untuk clear content
local function clearContent()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- Variabel untuk menyimpan data
local fishingController = nil
local controllerData = {}
local fishDatabase = {}

-- TAB 1: ANALYZE FISHING CONTROLLER
local function analyzeFishingController()
    clearContent()
    StatusLabel.Text = "Status: Analyzing FishingController..."
    
    -- Cari FishingController di ReplicatedStorage
    addLog("=== FISHING CONTROLLER ANALYSIS ===", Color3.fromRGB(255, 255, 0), "📜")
    
    local fishingFolder = ReplicatedStorage:FindFirstChild("Fishing")
    if not fishingFolder then
        addLog("❌ ERROR: 'Fishing' folder not found in ReplicatedStorage!", Color3.fromRGB(255, 50, 50), "⚠️")
        return
    end
    
    local controllerModule = fishingFolder:FindFirstChild("FishingController")
    if not controllerModule then
        addLog("❌ ERROR: 'FishingController' module not found!", Color3.fromRGB(255, 50, 50), "⚠️")
        return
    end
    
    addLog("✅ Found FishingController at: " .. controllerModule:GetFullName(), Color3.fromRGB(0, 255, 0), "📍")
    
    -- Require module
    local success, moduleData = pcall(function()
        return require(controllerModule)
    end)
    
    if not success then
        addLog("❌ Failed to require FishingController: " .. tostring(moduleData), Color3.fromRGB(255, 50, 50), "⚠️")
        return
    end
    
    fishingController = moduleData
    addLog("✅ Successfully required FishingController!", Color3.fromRGB(0, 255, 150), "✅")
    
    -- Analyze module structure
    addLog("--- MODULE STRUCTURE ---", Color3.fromRGB(200, 200, 255), "📊")
    
    local functionCount = 0
    local eventCount = 0
    local tableCount = 0
    local otherCount = 0
    
    for key, value in pairs(moduleData) do
        local keyType = type(value)
        
        if keyType == "function" then
            functionCount = functionCount + 1
            addLog("🔧 Function: " .. key, Color3.fromRGB(100, 200, 255), "🔧")
            
            -- Coba dapatkan informasi tentang function
            local funcInfo = debug.getinfo(value)
            if funcInfo then
                addLog("   ├─ Source: " .. (funcInfo.source or "?"), Color3.fromRGB(150, 150, 150))
                addLog("   └─ Line: " .. (funcInfo.linedefined or "?"), Color3.fromRGB(150, 150, 150))
            end
            
        elseif keyType == "table" then
            tableCount = tableCount + 1
            addLog("📦 Table: " .. key .. " (size: " .. tostring(#value) .. ")", Color3.fromRGB(255, 200, 100), "📦")
            
            -- Cek jika ini adalah event (BindableEvent atau RemoteEvent)
            if typeof(value) == "RBXScriptSignal" then
                eventCount = eventCount + 1
                addLog("   ├─ Type: RBXScriptSignal (Event)", Color3.fromRGB(150, 200, 100))
            else
                -- Coba inspect isi table (maksimal 5 item)
                local itemCount = 0
                for k, v in pairs(value) do
                    itemCount = itemCount + 1
                    if itemCount <= 5 then
                        addLog("   ├─ " .. tostring(k) .. ": " .. tostring(type(v)), Color3.fromRGB(150, 150, 150))
                    end
                end
                if itemCount > 5 then
                    addLog("   └─ ... and " .. (itemCount - 5) .. " more items", Color3.fromRGB(150, 150, 150))
                end
            end
            
        elseif key:sub(1, 2) == "On" or key:find("Event") or key:find("Signal") then
            eventCount = eventCount + 1
            addLog("⚡ Event/Signal: " .. key, Color3.fromRGB(255, 100, 100), "⚡")
            
        else
            otherCount = otherCount + 1
            addLog("📄 " .. keyType:sub(1,1):upper() .. keyType:sub(2) .. ": " .. key .. " = " .. tostring(value), 
                   Color3.fromRGB(150, 150, 150), "📄")
        end
    end
    
    addLog("--- SUMMARY ---", Color3.fromRGB(255, 255, 0), "📊")
    addLog("Total items: " .. tostring(functionCount + eventCount + tableCount + otherCount), Color3.fromRGB(200, 200, 200))
    addLog("Functions: " .. functionCount, Color3.fromRGB(100, 200, 255))
    addLog("Events/Signals: " .. eventCount, Color3.fromRGB(255, 100, 100))
    addLog("Tables: " .. tableCount, Color3.fromRGB(255, 200, 100))
    addLog("Other: " .. otherCount, Color3.fromRGB(150, 150, 150))
    
    -- Simpan data penting
    controllerData = {
        Module = controllerModule,
        Data = moduleData,
        Functions = {},
        Events = {},
        Tables = {}
    }
    
    -- Cari khusus FishCaught dan fungsi terkait
    addLog("--- FISH CATCH RELATED ---", Color3.fromRGB(0, 255, 150), "🎣")
    
    local foundCatch = false
    for key, value in pairs(moduleData) do
        local keyLower = key:lower()
        if keyLower:find("catch") or keyLower:find("fish") or keyLower:find("caught") then
            foundCatch = true
            local valueType = type(value)
            addLog("🎯 " .. key .. " (" .. valueType .. ")", Color3.fromRGB(255, 215, 0))
            
            if valueType == "function" then
                -- Simpan fungsi untuk hooking
                controllerData.Functions[key] = value
                addLog("   └─ Can be hooked for logging", Color3.fromRGB(150, 255, 150))
            elseif valueType == "table" then
                controllerData.Tables[key] = value
            end
        end
    end
    
    if not foundCatch then
        addLog("⚠️ No obvious fish catch functions found!", Color3.fromRGB(255, 150, 50))
    end
    
    StatusLabel.Text = "Status: Controller analysis complete!"
end

-- TAB 2: EVENT EXPLORER
local function exploreEvents()
    clearContent()
    StatusLabel.Text = "Status: Exploring events..."
    
    addLog("=== EVENT EXPLORER ===", Color3.fromRGB(255, 255, 0), "⚡")
    
    if not fishingController then
        addLog("⚠️ Please analyze Controller first!", Color3.fromRGB(255, 150, 50))
        return
    end
    
    -- Cari semua event di FishingController
    addLog("--- FISHINGCONTROLLER EVENTS ---", Color3.fromRGB(200, 150, 255), "🔍")
    
    local eventList = {}
    for key, value in pairs(fishingController) do
        local keyLower = key:lower()
        if typeof(value) == "RBXScriptSignal" then
            table.insert(eventList, {Name = key, Value = value})
        elseif key:sub(1, 2) == "On" or keyLower:find("event") or keyLower:find("signal") then
            table.insert(eventList, {Name = key, Value = value, Type = type(value)})
        end
    end
    
    if #eventList == 0 then
        addLog("❌ No events found in FishingController!", Color3.fromRGB(255, 50, 50))
    else
        for _, event in ipairs(eventList) do
            addLog("📡 Event: " .. event.Name, Color3.fromRGB(100, 200, 255))
            addLog("   ├─ Type: " .. tostring(event.Type or typeof(event.Value)), Color3.fromRGB(150, 150, 150))
            
            -- Coba connect untuk monitoring
            if typeof(event.Value) == "RBXScriptSignal" then
                event.Value:Connect(function(...)
                    local args = {...}
                    addLog("   ⚡ TRIGGERED: " .. event.Name .. " with " .. #args .. " args", 
                           Color3.fromRGB(255, 215, 0))
                    
                    -- Log args
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            addLog("     Arg " .. i .. ": [TABLE] ", Color3.fromRGB(200, 200, 200))
                            for k, v in pairs(arg) do
                                if type(v) == "string" or type(v) == "number" then
                                    addLog("       " .. k .. " = " .. tostring(v), Color3.fromRGB(150, 150, 150))
                                end
                            end
                        else
                            addLog("     Arg " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")", 
                                   Color3.fromRGB(200, 200, 200))
                        end
                    end
                end)
                addLog("   └─ ✅ Connected for monitoring", Color3.fromRGB(0, 255, 0))
            end
        end
    end
    
    -- Cari RemoteEvents di folder Fishing
    addLog("--- REMOTEEVENTS IN FISHING FOLDER ---", Color3.fromRGB(150, 200, 255), "🔌")
    
    local fishingFolder = ReplicatedStorage:FindFirstChild("Fishing")
    if fishingFolder then
        local remoteCount = 0
        for _, item in pairs(fishingFolder:GetChildren()) do
            if item:IsA("RemoteEvent") then
                remoteCount = remoteCount + 1
                addLog("📡 RemoteEvent: " .. item.Name, Color3.fromRGB(255, 150, 100))
                
                -- Connect untuk monitoring
                item.OnClientEvent:Connect(function(...)
                    local args = {...}
                    addLog("   ⚡ REMOTE EVENT: " .. item.Name .. " received!", Color3.fromRGB(255, 215, 0))
                    
                    -- Coba extract fish data
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.Name or arg.FishName then
                                addLog("   🎣 FISH DATA DETECTED!", Color3.fromRGB(0, 255, 150))
                                for k, v in pairs(arg) do
                                    if type(v) == "string" or type(v) == "number" then
                                        addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(100, 255, 200))
                                    end
                                end
                            end
                        end
                    end
                end)
                addLog("   └─ ✅ Connected to remote event", Color3.fromRGB(0, 255, 0))
            end
        end
        
        if remoteCount == 0 then
            addLog("ℹ️ No RemoteEvents found in Fishing folder", Color3.fromRGB(150, 150, 150))
        end
    end
    
    StatusLabel.Text = "Status: Event exploration complete!"
end

-- TAB 3: FISH DATA EXPLORER
local function exploreFishData()
    clearContent()
    StatusLabel.Text = "Status: Exploring fish data..."
    
    addLog("=== FISH DATA EXPLORER ===", Color3.fromRGB(255, 255, 0), "🐟")
    
    -- 1. Cari Bestiary atau database ikan
    addLog("--- SEARCHING FOR FISH DATABASES ---", Color3.fromRGB(100, 200, 255), "🔍")
    
    local databases = {}
    
    -- Cari di seluruh ReplicatedStorage
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") then
            local name = item.Name:lower()
            if name:find("fish") or name:find("bestiary") or name:find("dex") or 
               name:find("catch") or name:find("database") or name:find("data") then
                
                table.insert(databases, item)
                addLog("📦 Found: " .. item:GetFullName(), Color3.fromRGB(200, 200, 100))
            end
        end
    end
    
    if #databases == 0 then
        addLog("❌ No fish databases found!", Color3.fromRGB(255, 50, 50))
    else
        -- Explore setiap database
        for _, db in ipairs(databases) do
            addLog("--- EXPLORING: " .. db.Name .. " ---", Color3.fromRGB(255, 200, 100), "📖")
            
            local success, data = pcall(function()
                return require(db)
            end)
            
            if success and type(data) == "table" then
                addLog("✅ Successfully loaded database", Color3.fromRGB(0, 255, 0))
                
                -- Cari fish data
                local fishCount = 0
                local function exploreTable(tbl, depth, prefix)
                    depth = depth or 0
                    prefix = prefix or ""
                    
                    if depth > 3 then return end -- Limit recursion
                    
                    for key, value in pairs(tbl) do
                        if type(value) == "table" then
                            -- Cek jika ini data ikan
                            local isFish = false
                            local fishInfo = {}
                            
                            -- Cari atribut ikan
                            for k, v in pairs(value) do
                                if type(v) == "string" or type(v) == "number" then
                                    if k:lower():find("name") and type(v) == "string" then
                                        isFish = true
                                        fishInfo.Name = v
                                    elseif k:lower():find("rarity") or k:lower():find("tier") then
                                        fishInfo.Rarity = v
                                    elseif k:lower():find("weight") or k:lower():find("size") then
                                        fishInfo.Weight = v
                                    elseif k:lower():find("mutation") or k:lower():find("shiny") or k:lower():find("variant") then
                                        fishInfo.Mutation = v
                                    elseif k:lower():find("value") or k:lower():find("price") then
                                        fishInfo.Value = v
                                    end
                                end
                            end
                            
                            if isFish and fishInfo.Name then
                                fishCount = fishCount + 1
                                local logText = string.format("🐟 %s | Rarity: %s | Weight: %s | Mutation: %s",
                                    fishInfo.Name or "Unknown",
                                    fishInfo.Rarity or "?",
                                    tostring(fishInfo.Weight or "?"),
                                    fishInfo.Mutation or "None")
                                
                                addLog(logText, Color3.fromRGB(100, 255, 200))
                                
                                -- Simpan ke database
                                if not fishDatabase[fishInfo.Name] then
                                    fishDatabase[fishInfo.Name] = {
                                        Name = fishInfo.Name,
                                        Rarity = fishInfo.Rarity,
                                        Weight = fishInfo.Weight,
                                        Mutation = fishInfo.Mutation,
                                        Value = fishInfo.Value,
                                        Source = db.Name
                                    }
                                end
                            else
                                -- Explore nested tables
                                exploreTable(value, depth + 1, prefix .. key .. ".")
                            end
                        end
                    end
                end
                
                exploreTable(data)
                
                addLog("📊 Found " .. fishCount .. " fish entries", Color3.fromRGB(0, 255, 150))
                
            else
                addLog("❌ Failed to load database: " .. tostring(data), Color3.fromRGB(255, 50, 50))
            end
        end
    end
    
    -- 2. Cari di FishingController untuk fish data
    addLog("--- SEARCHING IN FISHINGCONTROLLER ---", Color3.fromRGB(150, 255, 150), "🎣")
    
    if fishingController then
        local foundFishData = false
        
        -- Cari table yang mungkin berisi data ikan
        for key, value in pairs(fishingController) do
            if type(value) == "table" and key:lower():find("fish") then
                addLog("📦 Found fish table: " .. key, Color3.fromRGB(255, 200, 100))
                
                for fishKey, fishData in pairs(value) do
                    if type(fishData) == "table" then
                        local fishName = fishData.Name or fishData.FishName or tostring(fishKey)
                        local rarity = fishData.Rarity or fishData.Tier
                        local weight = fishData.Weight or fishData.Size
                        
                        if fishName and (rarity or weight) then
                            foundFishData = true
                            addLog(string.format("   🐟 %s | Rarity: %s | Weight: %s", 
                                fishName, tostring(rarity or "?"), tostring(weight or "?")), 
                                Color3.fromRGB(150, 255, 200))
                        end
                    end
                end
            end
        end
        
        if not foundFishData then
            addLog("ℹ️ No fish data tables found in FishingController", Color3.fromRGB(150, 150, 150))
        end
    end
    
    -- 3. Cari di Workspace atau Player untuk current fish
    addLog("--- CURRENT FISH TRACKING ---", Color3.fromRGB(255, 150, 100), "📍")
    
    -- Monitor player attributes
    player:GetAttributeChangedSignal("CaughtFish"):Connect(function()
        local fish = player:GetAttribute("CaughtFish")
        if fish then
            addLog("🎣 Player attribute changed - CaughtFish: " .. tostring(fish), Color3.fromRGB(255, 215, 0))
        end
    end)
    
    player:GetAttributeChangedSignal("LastFish"):Connect(function()
        local fish = player:GetAttribute("LastFish")
        if fish then
            addLog("🎣 Player attribute changed - LastFish: " .. tostring(fish), Color3.fromRGB(255, 215, 0))
        end
    end)
    
    addLog("✅ Monitoring player attributes for fish data", Color3.fromRGB(0, 255, 0))
    
    -- Summary
    addLog("--- FISH DATABASE SUMMARY ---", Color3.fromRGB(255, 255, 0), "📊")
    
    local totalFish = 0
    for _ in pairs(fishDatabase) do
        totalFish = totalFish + 1
    end
    
    if totalFish > 0 then
        addLog("✅ Loaded " .. totalFish .. " unique fish into database", Color3.fromRGB(0, 255, 150))
        
        -- Tampilkan beberapa contoh
        local count = 0
        for name, data in pairs(fishDatabase) do
            if count < 5 then
                addLog("📝 " .. name .. " (" .. (data.Rarity or "Common") .. ")", Color3.fromRGB(200, 200, 200))
                count = count + 1
            else
                addLog("... and " .. (totalFish - 5) .. " more fish", Color3.fromRGB(150, 150, 150))
                break
            end
        end
    else
        addLog("❌ No fish data found in databases", Color3.fromRGB(255, 100, 100))
    end
    
    StatusLabel.Text = "Status: Fish data exploration complete!"
end

-- Tab switching
local function switchTab(tabName)
    ControllerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    EventsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    DataTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    
    if tabName == "Controller" then
        ControllerTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        analyzeFishingController()
    elseif tabName == "Events" then
        EventsTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        exploreEvents()
    elseif tabName == "Data" then
        DataTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        exploreFishData()
    end
end

-- Button connections
ControllerTab.MouseButton1Click:Connect(function()
    switchTab("Controller")
end)

EventsTab.MouseButton1Click:Connect(function()
    switchTab("Events")
end)

DataTab.MouseButton1Click:Connect(function()
    switchTab("Data")
end)

-- Auto-hook untuk fish catch detection
local function setupAutoHook()
    -- Tunggu beberapa detik lalu analisis controller
    task.wait(2)
    analyzeFishingController()
    
    -- Setup hook untuk fish catch
    task.wait(3)
    
    if fishingController then
        -- Cari fungsi FishCaught
        for key, value in pairs(fishingController) do
            local keyLower = key:lower()
            if (keyLower:find("fishcaught") or keyLower:find("caught") or keyLower:find("catch")) and type(value) == "function" then
                addLog("🎯 HOOKING TO: " .. key, Color3.fromRGB(255, 215, 0), "🎣")
                
                -- Simpan fungsi asli
                local originalFunction = value
                
                -- Override fungsi
                fishingController[key] = function(...)
                    local args = {...}
                    
                    -- Log panggilan fungsi
                    addLog("⚡ " .. key .. " TRIGGERED!", Color3.fromRGB(255, 100, 100), "⚡")
                    
                    -- Coba extract fish data dari args
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            addLog("   📦 Argument " .. i .. " is a table", Color3.fromRGB(200, 200, 200))
                            
                            -- Cek untuk fish data
                            for k, v in pairs(arg) do
                                if type(v) == "string" or type(v) == "number" then
                                    addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(150, 255, 150))
                                end
                            end
                            
                            -- Jika ada Name atau FishName, ini mungkin fish data
                            if arg.Name or arg.FishName then
                                local fishName = arg.Name or arg.FishName
                                local rarity = arg.Rarity or arg.Tier
                                local weight = arg.Weight or arg.Size
                                local mutation = arg.Mutation or arg.Shiny or arg.Variant
                                
                                addLog("🎣 FISH CAUGHT! " .. fishName, Color3.fromRGB(0, 255, 150), "🎉")
                                addLog("   ├─ Rarity: " .. tostring(rarity or "?"), Color3.fromRGB(200, 200, 200))
                                addLog("   ├─ Weight: " .. tostring(weight or "?"), Color3.fromRGB(200, 200, 200))
                                addLog("   └─ Mutation: " .. tostring(mutation or "None"), Color3.fromRGB(200, 200, 200))
                                
                                -- Update status
                                StatusLabel.Text = "Caught: " .. fishName .. " (" .. (rarity or "Common") .. ")"
                            end
                        else
                            addLog("   📄 Argument " .. i .. ": " .. tostring(arg) .. " (" .. type(arg) .. ")", 
                                   Color3.fromRGB(200, 200, 200))
                        end
                    end
                    
                    -- Panggil fungsi asli
                    return originalFunction(...)
                end
                
                addLog("✅ Successfully hooked to " .. key, Color3.fromRGB(0, 255, 0), "✅")
                break
            end
        end
    end
end

-- Start dengan Controller tab
switchTab("Controller")

-- Setup auto-hook setelah GUI siap
task.spawn(function()
    task.wait(1)
    setupAutoHook()
end)

-- Export untuk debugging
print("Fish Dex Explorer Loaded!")
print("Use the GUI to explore FishingController and fish data.")

-- Return untuk akses dari luar
return {
    GetController = function() return fishingController end,
    GetFishDatabase = function() return fishDatabase end,
    AddLog = addLog
}
